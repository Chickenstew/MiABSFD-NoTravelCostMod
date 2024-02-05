local Utils = require("utils")

Utils.Init("Chickenstew", "No Travel Cost", "0.0.3")

FastTravelObj = nil

local function UpdateFastTravel(New_MapFastTravelLayout)
	if not New_MapFastTravelLayout:IsValid() then
		Utils.Log("MapFastTravelLayout was NOT valid")
		return
	end

	FastTravelObj = New_MapFastTravelLayout
	
	New_MapFastTravelLayout.MapChangeCost.Life = 0
	New_MapFastTravelLayout.MapChangeCost.Satiety = 0
	New_MapFastTravelLayout.MapChangeCost.bIsOK = true
end

local function HookMapFastTravelLayout(New_MapFastTravelLayout)
		UpdateFastTravel(New_MapFastTravelLayout)
end
NotifyOnNewObject("WBP_MapFastTravelLayout_C", HookMapFastTravelLayout)

local function SetMapcost()
	New_MIAChangeMapHelperComponent = FindAllOf("MIAChangeMapHelperComponent")

	for Index, MapHelperInstance in pairs(New_MIAChangeMapHelperComponent) do
		
		MapHelperInstance.MapChangeCost.Life = 0
		MapHelperInstance.MapChangeCost.Satiety = 0
		MapHelperInstance.MapChangeCost.bIsOK = true
	end
end

RegisterHook("/Script/MadeInAbyss.MIAChangeMapHelperComponent:MoveDecided", function()
	SetMapcost()
end)

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
	Utils.RegisterHookOnce("/Game/MadeInAbyss/UI/Menu/Map/WBP_MapFastTravelLayout.WBP_MapFastTravelLayout_C:Update", function(Context)
		FastTravelObj = Context:get()
		UpdateFastTravel(FastTravelObj)
	end)
	
	Utils.RegisterHookOnce("/Game/MadeInAbyss/UI/StageSelect/BP_FastTravelPlateComponent.BP_FastTravelPlateComponent_C:SetCost", function(Context)
		SetMapcost()
	end)	
end)
