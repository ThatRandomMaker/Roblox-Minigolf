local replicatedStorage = game:GetService("ReplicatedStorage")
local updateSettings = replicatedStorage.remoteEvents:WaitForChild("updateSettings")

updateSettings.OnServerEvent:Connect(function(player, settingName, newValue)
	local setting = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild(settingName)
	if setting then
		setting.Value = newValue
	end
end)