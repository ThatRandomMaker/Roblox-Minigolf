local spawnPad = script.Parent
local cooldown = {}

spawnPad.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	
	if player then
		if cooldown[player.UserId] and (tick() - cooldown [player.UserId] < 2) then
			return
	end

	if workspace.GolfBalls:FindFirstChild(player.Name) then return end
		
	cooldown[player.UserId] = tick()
	-- debug placeholder
	print(hit.Parent.Name)
	print(player.UserId)
	-- debug placeholder
	local PlayerBall = Instance.new("Part")
	PlayerBall.Shape = Enum.PartType.Ball
	PlayerBall.Size = Vector3.new(1,1,1)
	PlayerBall.Position = script.Parent.Position + Vector3.new(0,1,0)
	PlayerBall.Name = hit.Parent.Name
	PlayerBall.Parent = workspace.GolfBalls
	PlayerBall.Material = "SmoothPlastic"
	PlayerBall:SetAttribute("Owner", hit.Parent.Name)
	PlayerBall.CollisionGroup = "Ball"
	PlayerBall.Massless = true
	print(PlayerBall.CollisionGroup)

	end
end)