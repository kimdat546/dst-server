local STRINGS = GLOBAL.STRINGS
local TUNING  = GLOBAL.TUNING

local max = math.max

local Capacity  = GetModConfigData("Bag Capacity")
local Spoilrate = GetModConfigData("Bag Spoilrate")
local SoulJar   = GetModConfigData("SoulJar")

Assets = {
    Asset("IMAGE"       ,"images/inventoryimages/ret_bundles.tex"     ),
    Asset("ATLAS"       ,"images/inventoryimages/ret_bundles.xml"     ),
    Asset("ATLAS_BUILD" ,"images/inventoryimages/ret_bundles.xml" ,256),
}

RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/ret_bundles.xml"), "ret_slurperbag.tex")

--/////////////////////////////////// CONTENT ////////////////////////////////////////--

PrefabFiles = {
    -- Slurper Bag
    "ret_slurperbag",
}

TUNING.RET_SLURPERBAG = {
    CAPACITY  = Capacity,
    SPOILRATE = Spoilrate
}

local STRINGS = GLOBAL.STRINGS
STRINGS.NAMES.RET_SLURPERBAG = "Slurper Bag"
STRINGS.RECIPE_DESC.RET_SLURPERBAG = "Devour a bit of everything."

AddRecipe2( "ret_slurperbag",
    {GLOBAL.Ingredient("slurper_pelt"  ,2) ,
     GLOBAL.Ingredient("rope"          ,1) ,
     GLOBAL.Ingredient("nightmarefuel" ,2)},
    GLOBAL.TECH.MAGIC_THREE,
    {atlas= "images/inventoryimages/ret_bundles.xml"}
)


local GENERIC      = STRINGS.CHARACTERS.GENERIC
local WILLOW       = STRINGS.CHARACTERS.WILLOW
local WOLFGANG     = STRINGS.CHARACTERS.WOLFGANG
local WENDY        = STRINGS.CHARACTERS.WENDY
local WX78         = STRINGS.CHARACTERS.WX78
local WICKERBOTTOM = STRINGS.CHARACTERS.WICKERBOTTOM
local WOODIE       = STRINGS.CHARACTERS.WOODIE
local MAXWELL      = STRINGS.CHARACTERS.WAXWELL
local WIGFRID      = STRINGS.CHARACTERS.WATHGRITHR
local WEBBER       = STRINGS.CHARACTERS.WEBBER
local WINONA       = STRINGS.CHARACTERS.WINONA
local WARLY        = STRINGS.CHARACTERS.WARLY
local WORTOX       = STRINGS.CHARACTERS.WORTOX
local WORMWOOD     = STRINGS.CHARACTERS.WORMWOOD
local WURT         = STRINGS.CHARACTERS.WURT
local WALTER       = STRINGS.CHARACTERS.WALTER
local WANDA        = STRINGS.CHARACTERS.WANDA

GENERIC.DESCRIBE.RET_SLURPERBAG      = "You're… not going to bite, right?"
WILLOW.DESCRIBE.RET_SLURPERBAG       = "My pockets deserve better."
WOLFGANG.DESCRIBE.RET_SLURPERBAG     = "Wolfgang thinks bag is tiny mouth-beast."
WENDY.DESCRIBE.RET_SLURPERBAG        = "A hollow thing."
WX78.DESCRIBE.RET_SLURPERBAG         = "HIGH COMPRESSION SELECTED"
WICKERBOTTOM.DESCRIBE.RET_SLURPERBAG = "Remarkably efficient gastric containment."
WOODIE.DESCRIBE.RET_SLURPERBAG       = "Hope this one doesn't try to eat my hair, eh?"
MAXWELL.DESCRIBE.RET_SLURPERBAG      = "An improvement upon prior inconveniences."
WIGFRID.DESCRIBE.RET_SLURPERBAG      = "A vessel for dishonorable burdens."
WEBBER.DESCRIBE.RET_SLURPERBAG       = "It keeps our snacks fresh for a bit."
WINONA.DESCRIBE.RET_SLURPERBAG       = "Looks like one o' those head-huggin' things."
WARLY.DESCRIBE.RET_SLURPERBAG        = "Ideal for storing ingredients."
WORTOX.DESCRIBE.RET_SLURPERBAG       = "Hyuyu! What a creature you were... and are!"
WORMWOOD.DESCRIBE.RET_SLURPERBAG     = "Bag-Belly friend."
WURT.DESCRIBE.RET_SLURPERBAG         = "Glurgh... bag still breathing? Florp."
WALTER.DESCRIBE.RET_SLURPERBAG       = "No Woby, it's not a pet... Probably."
WANDA.DESCRIBE.RET_SLURPERBAG        = "I don’t remember losing this. Yet."

AddRecipeToFilter("ret_slurperbag", "CONTAINERS")
AddRecipeToFilter("ret_slurperbag", "MAGIC")

----------------------------------------------------------------------------------------
-- Bag Actions

--no widget interaction
local function NoWidgetComponetAction(inst, doer, actions)
    if not inst:HasTag("nowidget") then return end 
    for i,v in ipairs(actions) do
        if v == GLOBAL.ACTIONS.RUMMAGE then
            table.remove(actions, i)
        end
    end
end

AddComponentAction("USEITEM", "inventoryitem", NoWidgetComponetAction)
AddComponentAction("INVENTORY", "container", NoWidgetComponetAction)

--store
local MC_Store = AddAction("MCBUNDLE_STORE", "Store", function(act)
    local bundle = act.invobject
    local item   = act.target

    if not bundle or not item then return false end
    
    bundle.components.minecraftbundle:Store(act.doer, item)

    return true
end) --MC_Store.instant = true

local old_store_fn = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    local target = act.target
    if target and target.components.minecraftbundle then
        return target.components.minecraftbundle:Store(act.doer, act.invobject)
    end

    return old_store_fn(act)
end

AddComponentAction("USEITEM", "minecraftbundle", function(inst, doer, target, actions, right) 
    local inventoryitem = target.replica.inventoryitem

    if right and inventoryitem and inventoryitem:IsHeld() and not inventoryitem:CanOnlyGoInPocket()
    and (not inventoryitem:CanOnlyGoInPocketOrPocketContainers() or inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:CanOnlyGoInPocket()) then
        if inst:HasTag("quicksnatch") then table.insert(actions, GLOBAL.ACTIONS.MCBUNDLE_STORE) return end
    end
    --if target ~= nil then table.insert(actions, GLOBAL.ACTIONS.MCBUNDLE_SNATCH) end
end)

AddStategraphActionHandler("wilson"        ,GLOBAL.ActionHandler(GLOBAL.ACTIONS.MCBUNDLE_STORE  ,"doshortaction"))
AddStategraphActionHandler("wilson_client" ,GLOBAL.ActionHandler(GLOBAL.ACTIONS.MCBUNDLE_STORE  ,"doshortaction"))


--snatch
local MC_Snatch = AddAction("MCBUNDLE_SNATCH", "Snatch", function(act)
    local bundle = act.invobject or act.target
    local doer = act.doer
    if bundle ~= nil and doer ~= nil then
        bundle.components.minecraftbundle:Search(doer, act.target, act.slot)
        return true 
    end

    return false
end) --MC_Snatch.instant = true

AddComponentAction("INVENTORY", "minecraftbundle", function(inst,doer,actions,right) 
    table.insert(actions, GLOBAL.ACTIONS.MCBUNDLE_SNATCH)
end)

AddComponentAction("SCENE", "minecraftbundle", function(inst,doer,actions,right) 
    table.insert(actions, GLOBAL.ACTIONS.MCBUNDLE_SNATCH)
end)

AddStategraphActionHandler("wilson"        ,GLOBAL.ActionHandler(GLOBAL.ACTIONS.MCBUNDLE_SNATCH ,"doshortaction"))
AddStategraphActionHandler("wilson_client" ,GLOBAL.ActionHandler(GLOBAL.ACTIONS.MCBUNDLE_SNATCH ,"doshortaction"))

--snatch handler
AddModRPCHandler("MCBUNDLE", "SNATCH", function(player, container, slot)
    local bundle = player.components.inventory:GetActiveItem()
    if bundle and bundle.components.minecraftbundle then
        --if bundle.components.minecraftbundle.size == 0 then return end
        local act = GLOBAL.BufferedAction(player, container, GLOBAL.ACTIONS.MCBUNDLE_SNATCH, bundle)
        act.slot = slot
        player.components.playercontroller:DoAction(act)
    end
end)

AddClassPostConstruct("widgets/itemslot", function(self)
    local old_OnMouseButton = self.OnMouseButton
    self.OnMouseButton = function(_, button, down, ...)
        if down and button == GLOBAL.MOUSEBUTTON_RIGHT and self.tile == nil then
		    local character = GLOBAL.ThePlayer
		    local inventory = character and character.replica.inventory or nil
		    local active_item = inventory and inventory:GetActiveItem() or nil
		    local container = self.container
		    local container_item = container and container:GetItemInSlot(self.num) or nil

            if active_item and active_item:HasTag("quicksnatch") and container_item == nil then
                local owner_container = container.inst or self.owner
                SendModRPCToServer(MOD_RPC.MCBUNDLE.SNATCH, owner_container, self.num) 
            end

            self._lastRightClickTime = GLOBAL.GetTime()
        end
        return old_OnMouseButton(_, button, down, ...)
    end
end)

----------------------------------------------------------------------------------------
--Soul Jar

if SoulJar == true then
    local function SoulJarCanStore(self, doer, storing_item)
        local skills = doer.components.skilltreeupdater
        if skills == nil or not skills:IsActivated("wortox_souljar_1") then
            if doer.components.talker ~= nil then
                doer.components.talker:Say(GLOBAL.GetActionFailString(doer,"STORE","NOTSOULJARHANDLER"))
            end
            return false
        end

        --Store
        if storing_item and storing_item:HasTag("soul") and doer.finishportalhoptask ~= nil then
            local souls = 0
            doer.components.inventory:ForEachItem(function(item)
                if storing_item.prefab == item.prefab then
                    souls = souls + (item.components.stackable and item.components.stackable:StackSize() or 1)
                end
            end)
            if souls > 1 then
                doer:TryToPortalHop(1, true)
            end
        end

        return true
    end

    local function SoulJarSnatchTest(self, doer, storing_item, target)
        if target and not target.components.inventory then return 0 end

        local inventory = doer.components.inventory
        if not inventory then return 0 end

        local max_count = TUNING.WORTOX_MAX_SOULS

        local skills = doer.components.skilltreeupdater
        if skills:IsActivated("wortox_souljar_2") then
            local souljars = 0
            for slot = 1, inventory:GetNumSlots() do
                local item = inventory:GetItemInSlot(slot)
                if item and item.prefab == "wortox_souljar" then
                    souljars = souljars + 1
                end
            end
            local activeitem = inventory:GetActiveItem()
            if activeitem and activeitem.prefab == "wortox_souljar" then
                souljars = souljars + 1
            end
            max_count = max_count + souljars * TUNING.SKILLS.WORTOX.FILLED_SOULJAR_SOULCAP_INCREASE_PER
        end

        local has, count = inventory:Has("wortox_soul", 0, false)
        return max(max_count - count , 0)
    end

    AddPrefabPostInit("wortox_souljar", function(inst)
        inst:AddTag("nowidget")
        inst:AddTag("quicksnatch")
        if not GLOBAL.TheWorld.ismastersim then return inst end

        inst:AddComponent("minecraftbundle")
        inst.components.minecraftbundle.canstorefrom_fn = SoulJarCanStore
        inst.components.minecraftbundle.snatchtest_fn   = SoulJarSnatchTest
    end)
end