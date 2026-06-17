local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")
local sound = soundService:WaitForChild("golfHoleHit")
local playSoundEvent = replicatedStorage:WaitForChild("playGolfHoleSound")

playSoundEvent.OnClientEvent:Connect(function()
	sound:Play()
end)

