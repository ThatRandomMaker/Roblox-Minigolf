local replicatedStorage = game:GetService("ReplicatedStorage")
local updateSettings = replicatedStorage.remoteEvents:WaitForChild("updateSettings")

updateSettings.OnServerEvent:Connect(function(player, settingName, newValue)
	local setting = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild(settingName)
	if setting then
		setting.Value = newValue
	end
end)

local updateTutorialState = replicatedStorage.remoteEvents:WaitForChild("updateTutorialState")

updateTutorialState.OnServerEvent:Connect(function(player, tutorialAccepted)
	local tutorialAcceptedValue = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("TutorialComplete")
	if tutorialAccepted then
		tutorialAcceptedValue.Value = true
	end
end)

