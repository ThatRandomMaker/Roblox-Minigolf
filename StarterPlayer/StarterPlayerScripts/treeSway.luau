local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local playerGui = player.PlayerGui
local screenGui = playerGui:WaitForChild("ScreenGui")
local textLabel = screenGui:WaitForChild("TextLabel")

textLabel.Text = "init"
textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
task.wait(5)
textLabel.TextColor3 = Color3.fromRGB(0,0,0)
textLabel.Text = "init done!"

local swaySpeed = 0.5
local swayIntensity = 0.05
local tagName = "treeSway"
local maxRenderDistance = 150
local viewFieldThreshold = 0.2

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
	
	local nearbyParts = workspace:GetPartBoundsInRadius(trackingPoint, maxRenderDistance, overlapParams)
	local activeModels = {}
	
	for _, part in ipairs(nearbyParts) do
		local model = part:FindFirstAncestorOfClass("Model")
		if model and originalPivots[model] then
			activeModels[model] = true
		end
	end
	
	local totalMoving = 0
	
	for model in pairs(activeModels) do
		local originalPivot = originalPivots[model]
		if not model or not model.Parent then
			originalPivots[model] = nil
			timeOffsets[model] = nil
			lastActiveTimes[model] = nil
			continue
		end
		
		local modelPosition = originalPivot.Position
		local toTreeDirection = (modelPosition - cameraPosition).Unit
		local dotProduct = cameraLookVector:Dot(toTreeDirection)
		
		if dotProduct < viewFieldThreshold then
			continue
		end
		
		totalMoving = totalMoving + 1
		
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
	
	textLabel.Text = "Active Trees: " .. tostring(totalMoving)
end)