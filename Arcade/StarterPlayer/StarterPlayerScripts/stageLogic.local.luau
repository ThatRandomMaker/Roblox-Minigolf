-- used for controlling things in stages

-- stage 9 path

local Stage_A9 = workspace:WaitForChild("Stage_A9")
local visualFolder = Stage_A9:WaitForChild("visualPart")
local visualPath = visualFolder:WaitForChild("Union")
print(visualPath)

local tweenService = game:GetService("TweenService")
local tweenInfo1 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

task.spawn(function()
	while true do
		task.wait(2.5)
		local fadeInTween = tweenService:Create(visualPath, tweenInfo1, {Transparency = 0.85})
		fadeInTween:Play()
		-- visualPath.Transparency = 0.85
		task.wait(1.25)
		local fadeOutTween = tweenService:Create(visualPath, tweenInfo1, {Transparency = 1})
		fadeOutTween:Play()
		-- visualPath.Transparency = 1
	end
end)


-- stage 8 pads

local Stage_A8 = workspace:WaitForChild("Stage_A8")
local padFolder = Stage_A8:WaitForChild("Pads")
local soundPart = Stage_A8:WaitForChild("soundPart")
local clickSound = soundPart:WaitForChild("click")
local switchSound = soundPart:WaitForChild("switch")
local partTable = {
	Green = {},
	Cyan = {}
}

for _, part in pairs(padFolder:GetChildren()) do
	if part:IsA("BasePart") then
		if part.Name == "Green" then
			table.insert(partTable.Green, part)
		elseif part.Name == "Cyan" then
			table.insert(partTable.Cyan, part)
		end
	end
end

local padTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

local function disablePads(partColor)
	local originalColor = partColor.Color

	clickSound:Play()
	partColor.Color = Color3.fromRGB(159, 159, 159)
	task.wait(0.6)
	clickSound:Play()
	partColor.Color = originalColor
	task.wait(0.55)
	clickSound:Play()
	partColor.Color = Color3.fromRGB(159, 159, 159)
	task.wait(0.5)
	local disablePadTween = tweenService:Create(partColor, padTweenInfo, {Transparency = 1})
	disablePadTween:Play()
	
	switchSound:Play()
	partColor.CanCollide = false
	partColor.Color = originalColor
end

local function enablePads(partColor)
	local enablePadTween = tweenService:Create(partColor, padTweenInfo, {Transparency = 0})
	enablePadTween:Play()
	
	partColor.CanCollide = true
end

task.spawn(function()
	while true do
		task.wait(4)
		for _, part in pairs(partTable.Cyan) do
			enablePads(part)
		end
		task.wait(1)

		for _, part in pairs(partTable.Green) do
			task.spawn(disablePads, part)
		end
		
		task.wait(4)
		for _, part in pairs(partTable.Green) do
			enablePads(part)
		end
		task.wait(1)
		
		for _, part in pairs(partTable.Cyan) do
			task.spawn(disablePads, part)
		end
	end
end)


-- stage 7 spinning parts
local runService = game:GetService("RunService")
local Stage_A7 = workspace:WaitForChild("Stage_A7")
local spinningPartsFolder = Stage_A7:WaitForChild("spinningParts")


local partData = {}
local rng = Random.new()

for _, child in ipairs(spinningPartsFolder:GetChildren()) do
	if child:IsA("BasePart") then
		-- don't mess with y or z (unless you don't want parts spinning in place)
		-- i don't use (for example) -2 to 2 here, because it can hit 0 or something really close to 0 and possibly ruin the stage.
		local randomSpeed = Vector3.new(rng:NextNumber(0.5, 2), 0, 0)

		table.insert(partData, {
			Part = child,
			Speed = randomSpeed
		})

	end
end

runService.Heartbeat:Connect(function(dt)
	for _, data in ipairs(partData) do
		data.Part.CFrame = data.Part.CFrame * CFrame.Angles(
			data.Speed.X * dt,
			data.Speed.Y * dt,
			data.Speed.Z * dt
		)
	end
end)