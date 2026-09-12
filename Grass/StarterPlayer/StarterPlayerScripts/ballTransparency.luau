local physicsService = game:GetService("PhysicsService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local golfBallFolder = Workspace:WaitForChild("GolfBalls")

local function hideEffect(obj)
	if obj:IsA("Trail") or obj:IsA("ParticleEmitter") or obj:IsA("Beam") then
		obj.Enabled = false
	end
end

local function ballTransparency(ball)
	
	while not ball:GetAttribute("Owner") do
		task.wait(0.1)
	end
	
	local ownerName = ball:GetAttribute("Owner")
	if ownerName ~= localPlayer.Name then
		ball.Transparency = 0.5
		ball.Color = Color3.fromRGB(163, 162, 165)
		
		for _, descendant in pairs(ball:GetDescendants()) do
			-- idk why but i can't get a print from this
			-- it works anyway though
			hideEffect(descendant)
		end
		ball.DescendantAdded:Connect(hideEffect)
	end
end

golfBallFolder.ChildAdded:Connect(ballTransparency)

for _, ball in pairs(golfBallFolder:GetChildren()) do
	task.spawn(ballTransparency, ball)
end