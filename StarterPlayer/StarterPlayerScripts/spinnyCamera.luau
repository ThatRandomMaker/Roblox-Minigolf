local tweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local mainMenuLogic = require(replicatedStorage.moduleScripts:WaitForChild("mainMenuLogic"))
local camera = Workspace.CurrentCamera
local target = Workspace.cameraFolder:WaitForChild("target")
local anchor = Workspace.cameraFolder:WaitForChild("anchor")

local angle = 90
local orbitRadius = 30
local speed = 1
local elevation = 20

mainMenuLogic.cameraConnection = runService.RenderStepped:Connect(function(dt)
	angle = angle + (speed * dt)
	local x = math.cos(angle) * orbitRadius
	local z = math.sin(angle) * orbitRadius
	
	anchor.CFrame = CFrame.new(target.Position + Vector3.new(x,elevation,z))
	camera.CFrame = CFrame.lookAt(anchor.Position, target.Position)
end)