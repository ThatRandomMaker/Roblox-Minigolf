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
local trackedParts = {}


local function initprolamp(lampModel)
	
	local lampPart
	
	if lampModel:IsA("BasePart") then
		lampPart = lampModel
	else
		lampPart = lampModel:FindFirstChild("lampPart")
	end
	
	if not lampPart then
		return warn("Object tagged streetLamp is missing a valid lampPart! " .. lampModel:GetFullName())
	end
	
	if trackedParts[lampPart] then
		return
	end
	
	trackedParts[lampPart] = true
	
	local startColor = lampModel:GetAttribute("startColor")
	local targetColor = lampModel:GetAttribute("targetColor")
	local lampBrightness = lampModel:GetAttribute("lampBrightness")
	
	if not startColor then
		startColor = Color3.fromRGB(0, 0, 0)
		warn("hello no startColor for " .. lampModel:GetFullName() .. "!")
	end
	
	if not targetColor then
		targetColor = Color3.fromRGB(158, 153, 112)
		warn("hello no targetColor for " .. lampModel:GetFullName() .. "!")
	end
		
	if not lampBrightness then
		lampBrightness = 1
		warn("hello no lampBrightness for " .. lampModel:GetFullName() .. "!")
	end
	
	local lampData = {
		Part = lampPart,
		StartColor = startColor,
		TargetColor = targetColor,
		LampBrightness = lampBrightness,
		Lights = {}
	}
	
	if lampModel:IsA("Light") then
		table.insert(lampData.Lights, lampModel)
	end
	for _, descendant in pairs(lampModel:GetDescendants()) do
		if descendant:IsA("Light") then
			table.insert(lampData.Lights, descendant)
		end
	end
	table.insert(lamps, lampData)
	
	for _, light in pairs(lampData.Lights) do
		light.Brightness = (currentAlpha^2) * lampData.LampBrightness
		light.Enabled = (currentAlpha > 0.05)
	end
	
	if lampData.Part and lampData.Part:IsA("BasePart") then
		lampData.Part.Color = lampData.StartColor:Lerp(lampData.TargetColor, currentAlpha)
	end
	
	lampModel.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("Light") then
			table.insert(lampData.Lights, descendant)
			descendant.Brightness = (currentAlpha^2) * lampData.LampBrightness
			descendant.Enabled = (currentAlpha > 0.05)
		end
	end)
end

for _, lamp in pairs(collectionService:GetTagged("streetLamp")) do
		initprolamp(lamp)
end

collectionService:GetInstanceAddedSignal("streetLamp"):Connect(initprolamp)

local function updateLights(alpha)
	currentAlpha = alpha
	for _, lampData in pairs(lamps) do
			for _, light in pairs(lampData.Lights) do
				light.Brightness = (alpha^2) * lampData.LampBrightness
				light.Enabled = (alpha > 0.05)
			end
		if lampData.Part and lampData.Part:IsA("BasePart") then
			lampData.Part.Color = lampData.StartColor:Lerp(lampData.TargetColor, alpha)
		end
	end
end

local function startTransition(targetAlpha, animationDuration)
	if transitionConnection then 
		transitionConnection:Disconnect()
		transitionConnection = nil
	end
	
	if animationDuration <= 0 then
		updateLights(targetAlpha)
		return
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

local function updateEnabledState()
	local shouldBeActive = daytimeProgressionValue.Value or nightStatus.Value
	if not shouldBeActive then
		if transitionConnection then
			transitionConnection:Disconnect()
			transitionConnection = nil
		end
		updateLights(0)
		script.Disabled = true
	end
end


nightStatus.Changed:Connect(function(status)
if status == true then
	startTransition(1, 0)
else
	if not isNight then
		startTransition(0, 0)
		end
	end
	updateEnabledState()
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

daytimeProgressionValue.Changed:Connect(function(status)
	print("changed", status, "isNight", isNight, "nightstatus", nightStatus.Value)
	if not status then
		isNight = false
		if not nightStatus.Value then
			startTransition(0, 0)
		end
	end
	updateEnabledState()
end)