local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local autosaveIndicator = replicatedStorage.remoteEvents:WaitForChild("autosaveIndicator")
local DataModule = require(ServerScriptService:WaitForChild("datastoreModule"))

local memoryStoreService = game:GetService("MemoryStoreService")
local sessionMap = memoryStoreService:GetHashMap("PlayerSessionData")

local function plrDataToSave(player)
	local function getTable(str)
		if str == "" or str == nil then return {} end
		return string.split(str, ",")
	end
	return {
		["StagesWon"] = player.leaderstats["Stages Won"].Value,
		["Cash"] = player.leaderstats.Cash.Value,
		["ballChosen"] = player.PlayerData.ballChosen.Value,
		["trailChosen"] = player.PlayerData.trailChosen.Value,
		["effectChosen"] = player.PlayerData.effectChosen.Value,
		["stickChosen"] = player.PlayerData.stickChosen.Value,
		["OwnedItems"] = string.split(player.PlayerData.ownedItemsList.Value, ","),
		["CompletedStages"] = getTable(player.PlayerData.CompletedStages.Value),
		["Shadows"] = player.PlayerData.Shadows.Value,
		["DaytimeProgression"] = player.PlayerData.DaytimeProgression.Value,
		["NightTime"] = player.PlayerData.NightTime.Value,
		["TutorialComplete"] = player.PlayerData.TutorialComplete.Value,
		["currentHotkey"] = player.PlayerData.currentHotkey.Value,
		["cameraMode"] = player.PlayerData.cameraMode.Value,
		["isLightMode"] = player.PlayerData.isLightMode.Value
	}
end

game.Players.PlayerAdded:Connect(function(player)
	local userIdString = tostring(player.UserId)
	
	local recentData = nil
	pcall(function()
		recentData = sessionMap:GetAsync(userIdString)
	end)
	
	local data = recentData or DataModule.Load(player.UserId) or {}
	
	local playerData = Instance.new("Folder")
	playerData.Name = "PlayerData"
	playerData.Parent = player
	
	local ballChosen = Instance.new("StringValue", playerData)
	ballChosen.Name = "ballChosen"
	ballChosen.Value = data.ballChosen or "DefaultBall"
	
	local trailChosen = Instance.new("StringValue", playerData)
	trailChosen.Name = "trailChosen"
	trailChosen.Value = data.trailChosen or "DefaultTrail"
	
	local effectChosen = Instance.new("StringValue", playerData)
	effectChosen.Name = "effectChosen"
	effectChosen.Value = data.effectChosen or "DefaultEffect"
	
	local stickChosen = Instance.new("StringValue", playerData)
	stickChosen.Name = "stickChosen"
	stickChosen.Value = data.stickChosen or "DefaultStick"
	
	local ownedItems = Instance.new("StringValue", playerData)
	ownedItems.Name = "ownedItemsList"
	ownedItems.Value = table.concat(data.OwnedItems or {}, ",")
	
	local completedStages = Instance.new("StringValue", playerData)
	completedStages.Name = "CompletedStages"
	completedStages.Value = table.concat(data.CompletedStages or {}, ",")
	
	local shadows = Instance.new("BoolValue", playerData)
	shadows.Name = "Shadows"
	shadows.Value = if data.Shadows ~= nil then data.Shadows else true
	
	local daytimeProgression = Instance.new("BoolValue", playerData)
	daytimeProgression.Name = "DaytimeProgression"
	daytimeProgression.Value = if data.DaytimeProgression ~= nil then data.DaytimeProgression else true
	
	local nightTime = Instance.new("BoolValue", playerData)
	nightTime.Name = "NightTime"
	nightTime.Value = if data.NightTime ~= nil then data.NightTime else false
	
	local isLightMode = Instance.new("BoolValue", playerData)
	isLightMode.Name = "isLightMode"
	isLightMode.Value = if data.isLightMode ~= nil then data.isLightMode else false
	
	local cameraMode = Instance.new("BoolValue", playerData)
	cameraMode.Name = "cameraMode"
	cameraMode.Value = if data.cameraMode ~= nil then data.cameraMode else false
	
	local currentHotkey = Instance.new("StringValue", playerData)
	currentHotkey.Name = "currentHotkey"
	currentHotkey.Value = if data.currentHotkey ~= nil then tostring(data.currentHotkey) else ""
	
	local tutorialComplete = Instance.new("BoolValue", playerData)
	tutorialComplete.Name = "TutorialComplete"
	tutorialComplete.Value = if data.TutorialComplete ~= nil then data.TutorialComplete else false
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local StagesWon = Instance.new("NumberValue")
	StagesWon.Name = "Stages Won"
	StagesWon.Parent = leaderstats
	StagesWon.Value = data.StagesWon or 0

	local Cash = Instance.new("NumberValue")
	Cash.Name = "Cash"
	Cash.Parent = leaderstats
	Cash.Value = data.Cash or 0
	
end)

-- got autosave working
-- task.wait is how long it takes between every autosave (sec)

task.spawn(function()
	while true do
		task.wait(60)
		autosaveIndicator:FireAllClients(true)
		
		for _, player in pairs(Players:GetPlayers()) do
			if player:FindFirstChild("PlayerData") and player:FindFirstChild("leaderstats") then 
				DataModule.Save(player.UserId, plrDataToSave(player))
			end
		end
		task.wait(2)
		autosaveIndicator:FireAllClients(false)
	end
end)

local serverClosing = false

local savedPlayers = {}

local function savePlayerData(player)
	if savedPlayers[player.UserId] then return end
	savedPlayers[player.UserId] = true
	
	if player:FindFirstChild("PlayerData") and player:FindFirstChild("leaderstats") then
		local saveData = plrDataToSave(player)
		local userIdString = tostring(player.UserId)
		
		pcall(function()
			sessionMap:SetAsync(userIdString, saveData, 60)
		end)
		
		DataModule.Save(player.UserId, saveData)
	end
end

Players.PlayerRemoving:Connect(function(player)
		savePlayerData(player)
		savedPlayers[player.UserId] = nil
end)

game:BindToClose(function()
	local threads = {}
	for _, player in pairs(Players:GetPlayers()) do
		local thread = task.spawn(function()
			savePlayerData(player)
		end)
		table.insert(threads, thread)
	end
	
	for _, thread in ipairs(threads) do
		repeat task.wait() until coroutine.status(thread) == "dead"
	end
end)