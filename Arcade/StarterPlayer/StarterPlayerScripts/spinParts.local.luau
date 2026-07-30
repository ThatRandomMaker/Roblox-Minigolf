if not game:IsLoaded() then game:IsLoaded().Wait() end

local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")

local rotationSpeed = 2

local spinningParts = {}

local function initProPart(part)
	table.insert(spinningParts, part)
end

for _, part in pairs(collectionService:GetTagged("partToSpin")) do
	initProPart(part)
end

collectionService:GetInstanceAddedSignal("partToSpin"):Connect(initProPart)
collectionService:GetInstanceRemovedSignal("partToSpin"):Connect(function(part)
	local index = table.find(spinningParts, part)
	if index then table.remove(spinningParts, index) end
end)

runService.Heartbeat:Connect(function(deltaTime)
	for _, part in pairs(spinningParts) do
		local speed = part:GetAttribute("rotationSpeed") or rotationSpeed
		
		if part:IsA("Model") then
			local currentCFrame = part:GetPivot()
			part:PivotTo(currentCFrame * CFrame.Angles(0, speed * deltaTime, 0))
		elseif part:IsA("UnionOperation") then
		part.CFrame = part.CFrame * CFrame.Angles(0, 0, speed * deltaTime)
		end
	end
end)

