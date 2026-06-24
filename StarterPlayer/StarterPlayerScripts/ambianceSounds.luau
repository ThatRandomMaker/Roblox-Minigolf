local Lighting = game:GetService("Lighting")
local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")
local player = game.Players.LocalPlayer
local daytimeProgressionValue = player:WaitForChild("PlayerData"):WaitForChild("DaytimeProgression")
local nightStatus = player:WaitForChild("PlayerData"):WaitForChild("NightTime")

local daySound = soundService.Ambiance:WaitForChild("Day")
local nightSound = soundService.Ambiance:WaitForChild("Night")

local function getAlpha(t)
	local rawAlpha = 0
	if t>= 18 and t < 20 then rawAlpha = (t - 18)/2
	elseif t >= 19 or t < 5 then rawAlpha = 1
	elseif t >= 5 and t < 7 then rawAlpha = 1 - ((t-5)/2)
	else rawAlpha = 0 end
	return rawAlpha * rawAlpha * (3-2 * rawAlpha)
end

local function updateSound()
	
	local t = Lighting.ClockTime
	local alpha = getAlpha(t)
	
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

Lighting:GetPropertyChangedSignal("ClockTime"):Connect(updateSound)
updateSound()