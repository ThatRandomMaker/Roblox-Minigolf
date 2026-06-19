local Lighting = game:GetService("Lighting")
local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local settingsLogic = require(replicatedStorage:WaitForChild("settingsLogic"))
local setlLightingEvent = replicatedStorage:WaitForChild("setLighting")

local maxBrightness = 3
local isNight = false
local animationDuration = 5
local transitionConnection = nil
local lastTriggered = 0

local function updateLights(alpha)
	for _, lampModel in pairs(collectionService:GetTagged("streetLamp")) do
		local lampPart = lampModel:FindFirstChild("lampPart")
		for _, descendant in pairs(lampModel:GetDescendants()) do
			if descendant:IsA("Light") then
				descendant.Brightness = (alpha^2) * 3
				descendant.Enabled = (alpha > 0.05)
			end
		end
		if lampPart and lampPart:IsA("BasePart") then
			lampPart.Color = Color3.fromRGB(0,0,0):Lerp(Color3.fromRGB(158, 153, 112), alpha)
		end
	end
end

local function startTransition(targetAlpha)
	if transitionConnection then return end
	local startAlpha = (isNight) and 0 or 1
	local elapsed = 0
	transitionConnection = runService.Heartbeat:Connect(function(dt)
		elapsed += dt
		local alpha = math.clamp(elapsed / animationDuration, 0, 1)
		local finalAlpha = (targetAlpha == 1) and alpha or (1 - alpha)
		updateLights(finalAlpha)
		if alpha >= 1 then
			transitionConnection:Disconnect()
			transitionConnection = nil
		end
	end)
end

task.spawn(function()
	while true do
		if settingsLogic.daytimeProgression then
			local t = Lighting.ClockTime
			
			if t >= 17 and t < 17.7 and not isNight then
				isNight = true
				startTransition(1)
				print("helloes is sunset.." .. t)
			elseif (t >= 6.3 and t < 7) and isNight then
				isNight = false
				startTransition(0)
				print("helloes is sunrise.." .. t)
			end
		end
		task.wait(10)
	end
end)