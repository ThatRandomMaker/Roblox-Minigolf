local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage.remoteEvents:WaitForChild("shopOpen")
local shopFeedback = replicatedStorage.remoteEvents:WaitForChild("shopFeedback")
local golfBallConfig = require(replicatedStorage.moduleScripts:WaitForChild("golfBallConfig"))

remote.OnServerEvent:Connect(function(player, itemName)
	local itemData = golfBallConfig.Items[itemName] or golfBallConfig.Trails[itemName] or golfBallConfig.Effects[itemName] or golfBallConfig.golfSticks[itemName]
	if not itemData then return end
	
	local slotValueName = nil
	if golfBallConfig.Items[itemName] then
		slotValueName = "ballChosen"
	elseif golfBallConfig.Trails[itemName] then
		slotValueName = "trailChosen"
	elseif golfBallConfig.Effects[itemName] then
		slotValueName = "effectChosen"
	elseif golfBallConfig.golfSticks[itemName] then
		slotValueName = "stickChosen"
	end
	
	if not slotValueName then return end
	
	local data = player:FindFirstChild("PlayerData")
	local cash = player.leaderstats.Cash
	local ownedString = data.ownedItemsList.Value
	local ownedTable = string.split(ownedString, ",")
	data.Name = "PlayerData"
	
	if table.find(ownedTable, itemName) then
		data[slotValueName].Value = itemName
		-- print("equipped" .. itemName .. slotValueName)
		shopFeedback:FireClient(player, "Equip")
		return
	end
	
	local cost = itemData.Price
	if cash.Value >= cost then
		cash.Value -= cost
		
		table.insert(ownedTable, itemName)
		data.ownedItemsList.Value = table.concat(ownedTable, ",")
		data[slotValueName].Value = itemName
		-- print("got" .. itemName)
		shopFeedback:FireClient(player, "Purchase")
	else 
	-- print("not enough money or something failed i think")
	shopFeedback:FireClient(player, "Error")
	end
end)