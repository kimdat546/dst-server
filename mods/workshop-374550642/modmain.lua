if not GLOBAL.TUNING then
    return
end
local TUNING = GLOBAL.TUNING

local OLD_STACK_VALUES =
{
    TUNING.STACK_SIZE_LARGEITEM,
    TUNING.STACK_SIZE_MEDITEM,
    TUNING.STACK_SIZE_SMALLITEM,
    TUNING.STACK_SIZE_TINYITEM,
    TUNING.STACK_SIZE_PELLET,
}

TUNING.STACK_SIZE_LARGEITEM = GetModConfigData("STACK_SIZE_LARGEITEM") or TUNING.STACK_SIZE_LARGEITEM
TUNING.STACK_SIZE_MEDITEM  = GetModConfigData("STACK_SIZE_MEDITEM")  or TUNING.STACK_SIZE_MEDITEM
TUNING.STACK_SIZE_SMALLITEM = GetModConfigData("STACK_SIZE_SMALLITEM") or TUNING.STACK_SIZE_SMALLITEM
TUNING.STACK_SIZE_TINYITEM = GetModConfigData("STACK_SIZE_TINYITEM") or TUNING.STACK_SIZE_TINYITEM
TUNING.STACK_SIZE_PELLET   = GetModConfigData("STACK_SIZE_PELLET") or TUNING.STACK_SIZE_PELLET

local NEW_STACK_VALUES =
{
    TUNING.STACK_SIZE_LARGEITEM,
    TUNING.STACK_SIZE_MEDITEM,
    TUNING.STACK_SIZE_SMALLITEM,
    TUNING.STACK_SIZE_TINYITEM,
    TUNING.STACK_SIZE_PELLET,
}

local function IsDurabilityItem(inst)
    return inst.components.finiteuses ~= nil
        or inst.components.armor ~= nil
        or inst.components.fueled ~= nil
        or inst.components.weapon ~= nil
end

local function UsesAnyTuningStackValue(size)
    for _,v in ipairs(NEW_STACK_VALUES) do
        if size == v then
            return true
        end
    end
    return false
end

local function getNewStackSize(size)
    for i,v in ipairs(OLD_STACK_VALUES) do
        if size == v then
            return NEW_STACK_VALUES[i]
        end
    end
    for _,v in ipairs(NEW_STACK_VALUES) do
        if size < v then
            return v
        end
    end
    return size
end

AddPrefabPostInitAny(function(inst)

    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    
    if inst.components.inventoryitem == nil then
        return
    end

    if inst.components.stackable == nil then
        return
    end

    if IsDurabilityItem(inst) then
        return
    end

    local current_size = inst.components.stackable.maxsize
    if current_size == 1 then
        return
    end
    
    if not UsesAnyTuningStackValue(current_size) then
        inst.components.stackable.maxsize = getNewStackSize(current_size)
    end

end)


