local MCBundle = Class(function(self,inst)
    self.inst = inst

    self.updateslots = false

    --self.stacksize = 1200 -- units of a storted-item maxstack
    --self.maxsize  = self.stacksize 
	--self.size = 0

    --self.unit_cache = {} 

    --self.canstorefrom_fn = function(self, doer, item) {...}
    --self.snatchtest_fn   = function(self, doer, item) {...}

    self.container  = inst.components.container
end)

local ceil = math.ceil
local min  = math.min
local max  = math.max

local function GetItemUnitSize(self, item)
    local stackable = item.components.stackable
    if not stackable then return self.stacksize end
    
    local item_maxsize = stackable.originalmaxsize or stackable.maxsize
    local cached = self.unit_cache[item_maxsize]
    if cached then return cached end

    local units = self.stacksize / item_maxsize
    self.unit_cache[item_maxsize] = units
    return units
end

local function GetOverflowedValue(self, item, accept_count)
    local item_stack = item.components.stackable and item.components.stackable:StackSize() or 1
    if not self.updateslots then return accept_count and (item_stack > accept_count) and accept_count end

    local item_size  = GetItemUnitSize(self, item)

    local newsize  = self.size + item_size * item_stack
	if newsize <= self.maxsize then return nil end

    -- how many item units overflow the allowed maxsize
    local overflow_units  = (newsize - self.maxsize) / item_size
    overflow_units  = math.ceil(overflow_units) -- -1e-9 safeguard float noise

    local can_take = item_stack - overflow_units
    return can_take
end

local function GivePartial(self, item, count)
    if count < 1 --[[or self.size + count > self.maxsize]] then return end
    if not item.components.stackable then return end

    local part = item.components.stackable:Get(count)
    part.components.stackable:SetIgnoreMaxSize(false)

    self.container:GiveItem(part, nil)
end

--////////////////////////////////////////////////////////////////////////////////////////--

function MCBundle:SetDynamicSlots()
    self.updateslots = true

    self.stacksize = 1200
    self.maxsize  = self.stacksize 
	self.size = 0

    self.unit_cache = {} 
end

function MCBundle:SetMaxSize(val)
    self.maxsize = self.updateslots and max(1, val)
    --self:UpdateStackValue() --not probably needed
end

function MCBundle:GetStackPercent()
	return self.updateslots and min(self.size / self.maxsize, 1)
end

--------------------------------------------------------------------------------------------

function MCBundle:UpdateStackValue(remove_slot)
    if self.updateslots == true then 
        local container = self.container

        if remove_slot then table.remove(self.container.slots, remove_slot) end

        local targeted_slots = container:NumItems() + 1
        if container.numslots ~= targeted_slots then
           container.numslots =  targeted_slots -- surely nothing goes wrong :clueless:
        end

        if self.inst.components.finiteuses then
            self.inst.components.finiteuses:SetPercent(self:GetStackPercent())
        end
    end

    if self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner then return end

    self.inst.AnimState:PlayAnimation("store")
	self.inst.AnimState:PushAnimation("idle", true)
end

--------------------------------------------------------------------------------------------

function MCBundle:GetItemUnits(item)
    local item_stack = item.components.stackable and item.components.stackable:StackSize() or 1
    local units = GetItemUnitSize(self, item) * item_stack

    self.size = min(self.size + ceil(units), self.maxsize)

    self:UpdateStackValue()
end

function MCBundle:LoseItemUnits(item, slot)
    local item_stack = item.components.stackable and item.components.stackable:StackSize() or 1
    local units = GetItemUnitSize(self, item) * item_stack

    self.size = max(self.size - ceil(units), 0)

    self:UpdateStackValue(slot)
end

function MCBundle:UpdateItemStackUnits(item, old_count, new_count)
    local old_units = GetItemUnitSize(self, item) * old_count
    self.size = max(self.size - ceil(old_units), 0)

    local new_units = GetItemUnitSize(self, item) * new_count
    self.size = min(self.size + ceil(new_units), self.maxsize)

    self:UpdateStackValue()
end

--------------------------------------------------------------------------------------------

function MCBundle:HasFreeSpace(doer, item, accept_count)
    local inv_owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner 

    --I love mimics bloating my functions...
    local mimic = item.components.itemmimic
    if mimic then
        if  inv_owner and inv_owner.components.inventory 
        and inv_owner.components.inventory:GetActiveItem() == self.inst then 
            mimic:TurnEvil(inv_owner)
        end
        
        return false 
    end

    local  overflow = GetOverflowedValue(self, item, accept_count)
	if not overflow then return true end

    GivePartial(self, item, overflow) 

    return false
end 

--////////////////////////////////////////////////////////////////////////////////////////--

function MCBundle:Store(doer, item)
    if not item or item.components.minecraftbundle then 
        if doer.components.talker ~= nil then
            doer.components.talker:Say(GetActionFailString(doer,"STORE","NOTALLOWED"))
        end
        return true 
    end 

    if self.canstorefrom_fn and self:canstorefrom_fn(doer, item) == false then return true end

    local accept_count = self.container:CanAcceptCount(item)
    if    accept_count <= 0 then 
        if doer.components.talker ~= nil then
            doer.components.talker:Say(GetActionFailString(doer,"STORE","GENERIC"))
        end
        return true
    end

    local  free_space = self:HasFreeSpace(doer, item, accept_count)
    if not free_space then 
        if doer.components.talker ~= nil then
            doer.components.talker:Say(GetActionFailString(doer,"STORE","GENERIC"))
        end
        return true 
    end 

    local item_owner = item.components.inventoryitem.owner
    local c = item_owner.components.inventory or item_owner.components.container
    
    c:RemoveItem(item, true)
    self.container:GiveItem(item, nil) 

    return true
end

function MCBundle:Search(doer, owner_container, slot)
    if self.canstorefrom_fn and self:canstorefrom_fn(doer) == false then return true end 

    --if owner_container then searcher.components.talker:Say("empty slot spotted, so it works") return end
    --if doer then doer.components.talker:Say("searcher") end
    local c = self.container

    local  item = c.slots[1]
    if not item then return false, "NOTHING_INSIDE" end
    local  item_given = item

    local accept_count = self.snatchtest_fn and self:snatchtest_fn(doer, item, owner_container)
    if accept_count and (accept_count <= 0) then return end

    local stackable = item.components.stackable
    local max_count = stackable and (accept_count or stackable.originalmaxsize or stackable.maxsize)

    if stackable and (stackable:StackSize() > max_count) then
        item_given = stackable:Get(max_count) 
    else
        c:RemoveItemBySlot(1, true)
        --table.remove(c.slots,1) -- now cam be tracked on MCBundle:LoseItemUnits()
    end
    
    if stackable then item_given.components.stackable:SetIgnoreMaxSize(false) end

    if owner_container and slot then
        c = owner_container.components.container or owner_container.components.inventory
        c:GiveItem(item_given, slot) 
    elseif doer and doer.components.inventory then 
        doer.components.inventory:GiveActiveItem(item_given)
    else
        c:DropItem(item_given)
    end
    
end

return MCBundle