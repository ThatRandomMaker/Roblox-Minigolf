local physicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local golfBallFolder = workspace:WaitForChild("GolfBalls")

local function ballTransparency(ball)
	
	while not ball:GetAttribute("Owner") do
		task.wait(0.1)
	end
	
	local ownerName = ball:GetAttribute("Owner")
	
	if ownerName ~= localPlayer.Name then
		ball.Transparency = 0.5
		ball.Color = Color3.fromRGB(163, 162, 165)
	end
end

golfBallFolder.ChildAdded:Connect(ballTransparency)

for _, ball in pairs(golfBallFolder:GetChildren()) do
	ballTransparency(ball)
end