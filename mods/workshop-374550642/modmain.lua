local TUNING = GLOBAL.TUNING
local tonumber = GLOBAL.tonumber
local assert = GLOBAL.assert

local forceStackSizes = GetModConfigData("FORCE_STACKSIZES") or false

local function cfg(name, fallback)
    local v = GetModConfigData(name)
    v = tonumber(v)
    return v or fallback
end

local OLD_STACK_VALUES = {
    TUNING.STACK_SIZE_LARGEITEM or 10,
    TUNING.STACK_SIZE_MEDITEM or 20,
    TUNING.STACK_SIZE_SMALLITEM or 40,
    TUNING.STACK_SIZE_TINYITEM or 60,
    TUNING.STACK_SIZE_PELLET or 120,
}

local NEW_STACK_VALUES = {
    cfg("STACK_SIZE_LARGEITEM", OLD_STACK_VALUES[1]),
    cfg("STACK_SIZE_MEDITEM", OLD_STACK_VALUES[2]),
    cfg("STACK_SIZE_SMALLITEM", OLD_STACK_VALUES[3]),
    cfg("STACK_SIZE_TINYITEM", OLD_STACK_VALUES[4]),
    cfg("STACK_SIZE_PELLET", OLD_STACK_VALUES[5]),
}

for i,v in ipairs(NEW_STACK_VALUES) do
    assert(type(v) == "number", "Stack config value "..tostring(i).." is not a number")
    assert(v >= 1, "Stack config value "..tostring(i).." must be >= 1")
end

TUNING.STACK_SIZE_LARGEITEM = NEW_STACK_VALUES[1]
TUNING.STACK_SIZE_MEDITEM   = NEW_STACK_VALUES[2]
TUNING.STACK_SIZE_SMALLITEM = NEW_STACK_VALUES[3]
TUNING.STACK_SIZE_TINYITEM  = NEW_STACK_VALUES[4]
TUNING.STACK_SIZE_PELLET    = NEW_STACK_VALUES[5]

if forceStackSizes then
	local function getNewStackSize(size, currentStackValues)
		if currentStackValues == nil then
			currentStackValues = NEW_STACK_VALUES
		end
		if size == nil then
			return currentStackValues[3]
		end
		for i,v in ipairs(OLD_STACK_VALUES) do
			if size == v then
				return currentStackValues[i]
			end
		end
		for i,v in ipairs(NEW_STACK_VALUES) do
			if size == v then
				return currentStackValues[i]
			end
		end
		for i,v in ipairs(currentStackValues) do
			if size <= v then
				return v
			end
		end
		return currentStackValues[3]
	end

	AddPrefabPostInitAny(function(inst)
		if not GLOBAL.TheWorld.ismastersim then return end
		
		local s = inst.components.stackable
		if s == nil then return end
		
		local currentSize = tonumber(s.maxsize)
		
		local currentStackValues = {
			TUNING.STACK_SIZE_LARGEITEM,
			TUNING.STACK_SIZE_MEDITEM,
			TUNING.STACK_SIZE_SMALLITEM,
			TUNING.STACK_SIZE_TINYITEM,
			TUNING.STACK_SIZE_PELLET,
		}
		for i,v in ipairs(currentStackValues) do
			assert(type(v) == "number", "Stack config value "..tostring(i).." is not a number")
			assert(v >= 1, "Stack config value "..tostring(i).." must be >= 1")
		end
		
		local newSize = getNewStackSize(currentSize, currentStackValues)
		if newSize == nil or newSize == currentSize then return end
		
		print(inst.prefab,
		  "stackable:", s,
		  "current stacksize:" , currentSize,
		  "new stacksize:", newSize)

		s.maxsize = newSize
	end)
end