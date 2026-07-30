local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")
local golfHoleSound = soundService:WaitForChild("golfHoleHit")
local dissapearSound = soundService:WaitForChild("ballDissapear")
local playSoundEvent = replicatedStorage.remoteEvents:WaitForChild("playSound")

playSoundEvent.OnClientEvent:Connect(function(soundType)
	if soundType == "golfHole" then
		golfHoleSound:Play()
	elseif soundType == "fadeBall" then
		dissapearSound:Play()
	end
end)

