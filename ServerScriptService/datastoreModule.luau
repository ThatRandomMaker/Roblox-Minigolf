local dataStoreService = game:GetService("DataStoreService")
local myDataStore = dataStoreService:GetDataStore("GolfData")
local dataModule = {}

function dataModule.GetStarterData()
	return {
		["Cash"] = 0,
		["StagesWon"]= 0,
		["ballChosen"] = "Default",
		["OwnedItems"] = {"Default"}
	}
end

function dataModule.Save(userId, dataToSave)
	local key = "Player_" .. userId
	local success, err = pcall(function()
		myDataStore:UpdateAsync(key, function(oldData)
			return dataToSave
		end)
	end)
	if not success then
		warn("My datastore didn't work for", userId, "and the error is", err, "Goddammit!")
	end
end

function dataModule.Load(userId)
	local key = "Player_" .. userId
	local success, data = pcall(function()
		return myDataStore:GetAsync(key)
	end)
	if success and data then
		return data
	else
		return dataModule.GetStarterData()
	end
end

return dataModule