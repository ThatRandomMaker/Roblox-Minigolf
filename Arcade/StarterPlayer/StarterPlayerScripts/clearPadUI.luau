local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage.remoteEvents:WaitForChild("updateClearPad")

remote.OnClientEvent:Connect(function(actionType, clearBallPad)
	if not clearBallPad then return end
	
	local Gui = clearBallPad:WaitForChild("BillboardGui")
	local Label = Gui:WaitForChild("TextLabel")
	
	local function resetPad()
		Label.Text = ""
		Label.TextColor3 = Color3.fromRGB(255, 0, 0)
		clearBallPad.Color = Color3.fromRGB(152, 53, 53)
	end
	
	if actionType == "Cleared" then
		Label.Text = "Cleared!"
		Label.TextColor3 = Color3.fromRGB(0, 0, 0)
		clearBallPad.Color = Color3.fromRGB(158, 158, 161)
		task.delay(2, resetPad)
	elseif actionType == "noBall" then
		Label.Text = "You don't have a ball!"
		clearBallPad.Color = Color3.fromRGB(218, 133, 65)
		Label.TextColor3 = Color3.fromRGB(218, 133, 65)
		task.delay(2, resetPad)
	end
end)







