local replicatedStorage = game:GetService("ReplicatedStorage")
local golfHole = script.Parent
local playSoundEvent = replicatedStorage:WaitForChild("playSound")

function onBallTouched(hit)
	local ownerAttrib = hit:GetAttribute("Owner")
	
	if ownerAttrib then
		local player = game.Players:FindFirstChild(ownerAttrib)
		
	if player then
	playSoundEvent:FireClient(player)
	print(ownerAttrib)
	hit:Destroy()
	else
		print("player not found")
		end	
	else return end
end


golfHole.Touched:Connect(onBallTouched)