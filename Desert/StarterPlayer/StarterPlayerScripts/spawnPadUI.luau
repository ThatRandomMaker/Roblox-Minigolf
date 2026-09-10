local replicatedStorage = game:GetService("ReplicatedStorage")
local updateSpawnPad = replicatedStorage.remoteEvents:WaitForChild("updateSpawnPad")

local activeTimers = {}

local function resetSpawnPad(spawnPad, label)
	if not spawnPad or not label then return end
	label.Visible = true
	label.Text = ""
	spawnPad.Color = Color3.fromRGB(152, 130, 51)
	activeTimers[spawnPad] = nil
end

local function clearTimer(spawnPad)
	if activeTimers[spawnPad] then
		task.cancel(activeTimers[spawnPad])
		activeTimers[spawnPad] = nil
	end
end

updateSpawnPad.OnClientEvent:Connect(function(actionType, spawnPad, extraData)
	
	if not spawnPad then return end
	
	local Gui = spawnPad:FindFirstChild("BillboardGui")
	local label = Gui:FindFirstChild("TextLabel")
	
	if not label then return end
	clearTimer(spawnPad)
	
	label.Visible = true
	
	if actionType == "Cooldown" then
		label.Text = "Cooldown..."
		label.TextColor3 = Color3.fromRGB(0,0,0)
		spawnPad.Color = Color3.fromRGB(136,136,136)
		
		local timeLeft = extraData or 1
		activeTimers[spawnPad] = task.delay(timeLeft, function()
			resetSpawnPad(spawnPad, label)
		end)
	elseif actionType == "alreadyHasBall" then
		spawnPad.Color = Color3.fromRGB(255, 89, 89)
		label.TextColor3 = Color3.fromRGB(255,0,0)
		label.Visible = true
		label.Text = "You already have a ball!"
		activeTimers[spawnPad] = task.delay(1.5, function()
			resetSpawnPad(spawnPad, label)
		end)
	elseif actionType == "Success" then
		label.Text = "Ball Spawned!"
		label.TextColor3 = Color3.fromRGB(144, 98, 49)
		spawnPad.Color = Color3.fromRGB(255, 126, 34)
		
		activeTimers[spawnPad] = task.delay(0.6, function()
			if label.Text == "Ball Spawned!" then
				label.Text = "Cooldown..."
				label.TextColor3 = Color3.fromRGB(0,0,0)
				spawnPad.Color = Color3.fromRGB(136,136,136)
				activeTimers[spawnPad] = task.delay(1.4, function()
					resetSpawnPad(spawnPad, label)
				end)
			end
		end)
	end
end)



