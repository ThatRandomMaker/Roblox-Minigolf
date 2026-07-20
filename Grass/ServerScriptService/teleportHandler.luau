local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage.remoteEvents:WaitForChild("teleportHandler")
local teleportService = game:GetService("TeleportService")

remote.OnServerEvent:Connect(function(player, placeID, buttonName)
	if not placeID then return end
	local maxRetry = 3
	local success = false
	local result = nil
	
	for i = 1, maxRetry do
		local statusText = ""
		if i < maxRetry then
			statusText = "Failed, attempt " .. i
		else
			statusText = "Reserving new server..."
		end
		
		if i > 1 then remote:FireClient(player, statusText, buttonName) end
		
	success, result = pcall(function()
		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ShouldReserveServer = (i == maxRetry)
		return teleportService:TeleportAsync(placeID, {player}, teleportOptions)
	end)
	if success then break end
	task.wait(1.5)
end
	if not success then
		remote:FireClient(player, "failed_Final", buttonName)
		warn("teleport failed " .. maxRetry .. " attempts " .. tostring(result))
	end
end)


