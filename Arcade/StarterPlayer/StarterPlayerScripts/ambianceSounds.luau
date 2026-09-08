local Lighting = game:GetService("Lighting")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

local Player = game.Players.LocalPlayer
local playerData = Player:WaitForChild("PlayerData")
local daytimeProgressionValue = playerData:WaitForChild("DaytimeProgression")
local nightStatus = playerData:WaitForChild("NightTime")

local Ambiance = soundService:WaitForChild("Ambiance")
local daySound = Ambiance:WaitForChild("Day")
local nightSound = Ambiance:WaitForChild("Night")
local indoorSound = Ambiance:WaitForChild("Indoor")

local isIndoors = false
local updateIndoor = replicatedStorage.remoteEvents:WaitForChild("updateIndoor")
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function getAlpha(t)
	local rawAlpha = 0
	if t>= 18 and t < 20 then rawAlpha = (t - 18)/2
	elseif t >= 19 or t < 5 then rawAlpha = 1
	elseif t >= 5 and t < 7 then rawAlpha = 1 - ((t-5)/2)
	else rawAlpha = 0 end
	return rawAlpha * rawAlpha * (3-2 * rawAlpha)
end

local function Indoor()
	if nightSound.IsPlaying then
		local Tween = tweenService:Create(nightSound, tweenInfo, {Volume = 0})
		
		indoorSound.Volume = 0
		tweenService:Create(indoorSound, tweenInfo, {Volume = 0.5}):Play()
		Tween:Play()
		Tween.Completed:Wait()
		
		nightSound:Stop()
	elseif daySound.IsPlaying then
		local Tween = tweenService:Create(daySound, tweenInfo, {Volume = 0})

		indoorSound.Volume = 0
		tweenService:Create(indoorSound, tweenInfo, {Volume = 0.5}):Play()
		Tween:Play()
		Tween.Completed:Wait()
		
		daySound:Stop()
	end
	
	indoorSound:Play()
end

local function updateSound()
	if isIndoors then
		Indoor()
		return
	end
	
	local t = Lighting.ClockTime
	local alpha = getAlpha(t)
	
	if indoorSound.IsPlaying then indoorSound:Stop() end
	
	if not daytimeProgressionValue.Value then
		if nightStatus.Value then
			if not nightSound.IsPlaying then nightSound:Play() end
			nightSound.Volume = 0.5
			daySound:Stop()
		else
			if not daySound.IsPlaying then daySound:Play() end
			daySound.Volume = 1
			nightSound:Stop()
		end
		return
	end

	if alpha < 1 then
		if not daySound.IsPlaying then daySound:Play() end
		daySound.Volume = 1 * (1 - alpha)
	else 
		daySound:Stop()
	end
	
	if alpha > 0 then
		if not nightSound.IsPlaying then nightSound:Play() end
		nightSound.Volume = 0.5 * alpha
	else 
		nightSound:Stop()
	end
end

updateIndoor.OnClientEvent:Connect(function(newValue)
	if isIndoors ~= newValue then
		isIndoors = newValue
		updateSound()
	end
end)

-- changing to outdoor ambiance upon reset
local function onCharacterAdded(Character)
	local Humanoid = Character:WaitForChild("Humanoid")
	
	Humanoid.Died:Connect(function()
		print("ded")
		
		isIndoors = false
		updateSound()
	end)
end

Player.CharacterAdded:Connect(onCharacterAdded)

if Player.Character then
	onCharacterAdded(Player.Character)
end

Lighting:GetPropertyChangedSignal("ClockTime"):Connect(updateSound)
updateSound()