local Assets = { 
	Asset("ANIM"  ,"anim/ret_slurperbag.zip"),
	Asset("SOUND" ,"sound/slurper.fsb"),
}

local max = math.max

--------------------------------------------------------------------------------------------

local function UpdatePercent(inst, data)
	if not data then return end

	local inv_owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	inv_owner.SoundEmitter:PlaySound("dontstarve/creatures/slurper/attach")
	
	local  bundle = inv_owner.components.minecraftbundle
	if bundle then bundle:UpdateItemStackUnits(inst, data.oldstacksize, data.stacksize) end
end

local function OnItemGet(inst, data)
    if not data then return end
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/attach")

	local  bundle = inst.components.minecraftbundle
	if bundle then bundle:GetItemUnits(data.item) end

	if not data.item.components.stackable then return end
    data.item:ListenForEvent("stacksizechange", inst.UpdatePercent)
end

local function OnItemLose(inst, data)
    if not data then return end
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/dettach")

	local  bundle = inst.components.minecraftbundle
	if bundle then bundle:LoseItemUnits(data.prev_item, data.slot) end

	if not data.prev_item.components.stackable then return end
    data.prev_item:RemoveEventCallback("stacksizechange", inst.UpdatePercent)
end

--////////////////////////////////////////////////////////////////////////////////////////--

local function fn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("ret_slurperbag")
	inst.AnimState:SetBuild("ret_slurperbag")
	inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("nowidget")
	inst:AddTag("quicksnatch")
	inst:AddTag("portablestorage")

    MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end --///////////////////////////////////--

	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

	inst:AddComponent("finiteuses") -- Using as a display for how full the container contents are.
    inst.components.finiteuses:SetUses(0)
    inst.components.finiteuses:SetDoesNotStartFull(true)

	inst:AddComponent("container")
	inst.components.container:SetNumSlots(1)
	inst.components.container:EnableInfiniteStackSize(true)
	--inst.components.container.itemtestfn = ItemTestFn

	inst:AddComponent("minecraftbundle")
	inst.components.minecraftbundle:SetDynamicSlots()
	inst.components.minecraftbundle:SetMaxSize(TUNING.RET_SLURPERBAG.CAPACITY)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.RET_SLURPERBAG.SPOILRATE)

	----------------------------------------------------------------------------------------
	inst.UpdatePercent = UpdatePercent

	inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)

	MakeHauntableLaunch(inst)
    return inst
end

return  Prefab("ret_slurperbag", fn, Assets)