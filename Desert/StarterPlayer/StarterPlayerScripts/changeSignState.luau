local collectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local playerData = player:WaitForChild("PlayerData")
local completedStages = playerData:WaitForChild("CompletedStages")

local function updateSignState(signPart)
	--[[
	part with a surfacegui needs to be tagged with "stageSign"
	then the part needs to have an attribute with "stageName", it'll display the status on that specific stage (make it the same as the golfhole's attribute)
	for example, if you set Stage_G1 on the golfHole, then in the attrib it needs to be Grass_1 (case-sensitive)
	after that it'll update the status if the sign has a textLabel named "statusLabel"
	]]
	
	local surfaceGui = signPart:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then return end
	local textLabel = surfaceGui:FindFirstChild("statusLabel")
	local shadowTextLabel = surfaceGui:FindFirstChild("statusLabelShadow")
	local stageName = signPart:GetAttribute("stageName")
	
	local function updateSign()
		local list = string.split(completedStages.Value, ",")
		if table.find(list, stageName) then
			textLabel.Text = "Stage complete!"
			textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			
			shadowTextLabel.Text = "Stage complete!"
		else
			textLabel.Text = "Not complete!"
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			
			shadowTextLabel.Text = "Not complete!"
		end
	end
	
	completedStages.Changed:Connect(updateSign)
	updateSign()
end

for _, sign in pairs(collectionService:GetTagged("stageSign")) do
	updateSignState(sign)
end

collectionService:GetInstanceAddedSignal("stageSign"):Connect(updateSignState)