local dataStoreService = game:GetService("DataStoreService")
local myDataStore = dataStoreService:GetDataStore("GolfData")
local dataModule = {}

function dataModule.GetStarterData()
	return {
		["Cash"] = 0,
		["StagesWon"]= 0,
		["ballChosen"] = "DefaultBall",
		["trailChosen"] = "DefaultTrail",
		["effectChosen"] = "DefaultEffect",
		["stickChosen"] = "DefaultStick",
		["OwnedItems"] = {"DefaultBall", "DefaultTrail", "DefaultEffect", "DefaultStick"},
		["CompletedStages"] = {},
		["Shadows"] = true,
		["DaytimeProgression"] = true,
		["NightTime"] = false
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
		warn("My datastore didn't work for", userId, "and the error is", err, "Oof...")
	end
end

function dataModule.Load(userId)
	local key = "Player_" .. userId
	local success, data = pcall(function()
		return myDataStore:GetAsync(key)
	end)
	local starterData = dataModule.GetStarterData()
	
	if success and data then
		for key, value in pairs(starterData) do
			if data[key] == nil then
				data[key] = value
			end
		end
		return data
	else
		return dataModule.GetStarterData()
	end
end

return dataModule