local Lighting = game:GetService("Lighting")
local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local setLighting = replicatedStorage.bindableEvents:WaitForChild("setLighting")
local updNTL = replicatedStorage.bindableEvents:WaitForChild("updateNightTimeLighting")
local player = game.Players.LocalPlayer
local daytimeProgressionValue = player:WaitForChild("PlayerData"):WaitForChild("DaytimeProgression")
local nightStatus = player:WaitForChild("PlayerData"):WaitForChild("NightTime")

local isNight = false
local transitionConnection = nil
local currentAlpha = 0

local lamps = {}

local function initprolamp(lampModel)
	if not lampModel:FindFirstChild("lampPart") then return end
	local lampData = {
		Part = lampModel:FindFirstChild("lampPart"),
		Lights = {}
	}
	
	for _, descendant in pairs(lampModel:GetDescendants()) do
		if descendant:IsA("Light") then
			table.insert(lampData.Lights, descendant)
		end
	end
	table.insert(lamps, lampData)
end

for _, lamp in pairs(collectionService:GetTagged("streetLamp")) do
		initprolamp(lamp)
end

collectionService:GetInstanceAddedSignal("streetLamp"):Connect(initprolamp)

local function updateLights(alpha)
	currentAlpha = alpha
	for _, lampData in pairs(lamps) do
			for _, light in pairs(lampData.Lights) do
				light.Brightness = (alpha^2) * 3
				light.Enabled = (alpha > 0.05)
			end
		if lampData.Part and lampData.Part:IsA("BasePart") then
			lampData.Part.Color = Color3.fromRGB(0,0,0):Lerp(Color3.fromRGB(158, 153, 112), alpha)
		end
	end
end

local function startTransition(targetAlpha, animationDuration)
	if transitionConnection then 
		transitionConnection:Disconnect()
		transitionConnection = nil
	end
	
	local startAlpha = currentAlpha
	local elapsed = 0
	transitionConnection = runService.Heartbeat:Connect(function(dt)
		elapsed += dt
		local alpha = math.clamp(elapsed / animationDuration, 0, 1)
		local finalAlpha = startAlpha + (targetAlpha - startAlpha) * alpha
		updateLights(finalAlpha)
		if alpha >= 1 then
			transitionConnection:Disconnect()
			transitionConnection = nil
		end
	end)
end


nightStatus.Changed:Connect(function(status)
if status == true then
	startTransition(1, 0)
else
	startTransition(0, 0)
	end
end)

task.spawn(function()
	while true do
		if daytimeProgressionValue.Value then
			local t = Lighting.ClockTime
			if t >= 17 and t < 17.7 and not isNight then
				isNight = true
				startTransition(1, 5)
				-- print("helloes it is sunset.." .. t)
			elseif (t >= 6.3 and t < 7) and isNight then
				isNight = false
				startTransition(0, 5)
				-- print("helloes it is sunrise.." .. t)
			end
		end
		task.wait(10)
	end
end)

if nightStatus.Value then
	startTransition(1,0)
end