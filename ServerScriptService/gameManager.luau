local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataModule = require(ServerScriptService:WaitForChild("datastoreModule"))

game.Players.PlayerAdded:Connect(function(player)
	local data = DataModule.Load(player.UserId)
	
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
	
	local ownedItems = Instance.new("StringValue", playerData)
	ownedItems.Name = "ownedItemsList"
	ownedItems.Value = table.concat(data.OwnedItems or {}, ",")
	
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

Players.PlayerRemoving:Connect(function(player)
	local dataToSave = {
		["StagesWon"] = player.leaderstats["Stages Won"].Value,
		["Cash"] = player.leaderstats.Cash.Value,
		["ballChosen"] = player.PlayerData.ballChosen.Value,
		["trailChosen"] = player.PlayerData.trailChosen.Value,
		["effectChosen"] = player.PlayerData.effectChosen.Value,
		["OwnedItems"] = string.split(player.PlayerData.ownedItemsList.Value, ",")
	}
	
	DataModule.Save(player.UserId, dataToSave)
end)

game:BindToClose(function()
	for _, player in pairs(Players:GetPlayers()) do
		local dataToSave = {
			["StagesWon"] = player.leaderstats["Stages Won"].Value,
			["Cash"] = player.leaderstats.Cash.Value,
			["ballChosen"] = player.PlayerData.ballChosen.Value,
			["trailChosen"] = player.PlayerData.trailChosen.Value,
			["effectChosen"] = player.PlayerData.effectChosen.Value,
			["OwnedItems"] = string.split(player.PlayerData.ownedItemsList.Value, ",")
		}
		DataModule.Save(player.UserId, dataToSave)
	end
end)
