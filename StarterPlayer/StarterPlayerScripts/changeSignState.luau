local collectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local playerData = player:WaitForChild("PlayerData")
local completedStages = playerData:WaitForChild("CompletedStages")

local function updateSignState(signPart)
	local surfaceGui = signPart:FindFirstChildWhichIsA("SurfaceGui")
	if not surfaceGui then return end
	local textLabel = surfaceGui:FindFirstChild("statusLabel")
	local stageName = signPart:GetAttribute("stageName")
	
	local function updateSign()
		local list = string.split(completedStages.Value, ",")
		if table.find(list, stageName) then
			textLabel.Text = "Stage complete!"
			textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		else
			textLabel.Text = "Stage hasn't been completed yet!"
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
	
	completedStages.Changed:Connect(updateSign)
	updateSign()
end

for _, sign in pairs(collectionService:GetTagged("stageSign")) do
	updateSignState(sign)
end

collectionService:GetInstanceAddedSignal("stageSign"):Connect(updateSignState)