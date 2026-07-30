local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local swaySpeed = 0.4
local swayIntensity = 0.053
local maxRenderDistance = 60
local tagName = "treeSway"
local viewFieldThreshold = 0.5

local originalPivots = {}
local timeOffsets = {}
local lastActiveTimes = {}

local overlapParams = OverlapParams.new()
overlapParams.CollisionGroup = "Default"

local function onInstanceAdded(model)
	if model:IsA("Model") then
		originalPivots[model] = model:GetPivot()
		timeOffsets[model] = 0
		lastActiveTimes[model] = os.clock()
	end
end

local function onInstanceRemoved(model)
	originalPivots[model] = nil
	timeOffsets[model] = nil
	lastActiveTimes[model] = nil
end

for _, instance in ipairs(collectionService:GetTagged(tagName)) do
	onInstanceAdded(instance)
end

collectionService:GetInstanceAddedSignal(tagName):Connect(onInstanceAdded)
collectionService:GetInstanceRemovedSignal(tagName):Connect(onInstanceRemoved)

runService.Heartbeat:Connect(function()
	local currentTime = os.clock()
	
	local cameraCFrame = Camera.CFrame
	local cameraPosition = cameraCFrame.Position
	local cameraLookVector = cameraCFrame.LookVector
	
	local trackingPoint = (player.Character and player.Character:GetPivot().Position) or Camera.CFrame.Position
	
	for model, originalPivot in pairs(originalPivots) do
		if not model or not model.Parent then
			onInstanceRemoved(model)
			continue
		end
	
	local modelPosition = originalPivot.Position
	
	local distance = (modelPosition - trackingPoint).Magnitude
	if distance > maxRenderDistance then
		continue
	end
	
	local toTreeDirection = (modelPosition - cameraPosition).Unit
	local dotProduct = cameraLookVector:Dot(toTreeDirection)
	
	if dotProduct < viewFieldThreshold then
		continue
	end
	
	local lastActive = lastActiveTimes[model] or currentTime
	local timeDeactived = currentTime - lastActive
	
	if timeDeactived > 0.05 then
		timeOffsets[model] = (timeOffsets[model] or 0) + timeDeactived
	end
	
	lastActiveTimes[model] = currentTime
	local adjustedTime = currentTime - (timeOffsets[model] or 0)

	local objectOffset = (modelPosition.X + modelPosition.Z) * 0.1
	local swayAngle = math.sin((adjustedTime * swaySpeed) + objectOffset) * swayIntensity
	
	local swayCFrame = originalPivot * CFrame.Angles(swayAngle, 0, swayAngle * 0.5)
	model:PivotTo(swayCFrame)
	end
	
end)