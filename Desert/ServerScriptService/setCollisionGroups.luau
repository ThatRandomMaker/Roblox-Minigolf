local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local activePlayers = {}

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:CollisionGroupSetCollidable("Player", "Player", false)

local function setupPlayerCollisionGroups (player)
	local bg = "Ball_".. player.Name
	local sg = "Stick_" .. player.Name
	PhysicsService:RegisterCollisionGroup(bg)
	PhysicsService:RegisterCollisionGroup(sg)
	PhysicsService:CollisionGroupSetCollidable(sg, "Default", false)
	PhysicsService:CollisionGroupSetCollidable(sg, "Player", false)
	PhysicsService:CollisionGroupSetCollidable(bg, "Player", false)
	PhysicsService:CollisionGroupSetCollidable(bg, "invisWall", true)
	PhysicsService:CollisionGroupSetCollidable(sg, "invisWall", false)
	PhysicsService:CollisionGroupSetCollidable("Player", "invisWall", false)

	PhysicsService:CollisionGroupSetCollidable(sg, bg, true)
	
	for _, otherPlayer in ipairs(activePlayers) do
		if otherPlayer ~= player then
			local otherbg = "Ball_" .. otherPlayer.Name
			local othersg = "Stick_" .. otherPlayer.Name
			
			PhysicsService:CollisionGroupSetCollidable(sg, otherbg, false)
			PhysicsService:CollisionGroupSetCollidable(sg, othersg, false)
			PhysicsService:CollisionGroupSetCollidable(othersg, bg, false)
			PhysicsService:CollisionGroupSetCollidable(bg, otherbg, false)
			PhysicsService:CollisionGroupSetCollidable(otherbg, "Player", false)
			PhysicsService:CollisionGroupSetCollidable(othersg, "Player", false)
		end
	end
	
	PhysicsService:CollisionGroupSetCollidable(sg, bg, true)

	table.insert(activePlayers, player)
end

local function removePlayerCollisionGroups(player)
	
	local golfBalls = workspace:FindFirstChild("GolfBalls")
	
	for i, p in ipairs(activePlayers) do
		if p == player then
			table.remove(activePlayers, i)
			break
		end
	end
	
	if golfBalls then
		local playerBall = golfBalls:FindFirstChild(player.Name)
		if playerBall then
			playerBall:Destroy()
		end
	end
	
end

local function onDescendantAdded(descendant)
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Player"
	end
end

local function GolfStickCollisionGroup(descendant, player) 
	if descendant:IsA("Tool") then
		local stickGroup = "Stick_" .. player.Name
		for _, part in ipairs(descendant:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("UnionOperation") then
				part.CollisionGroup = stickGroup
			end
		end
		descendant.DescendantAdded:Connect(function(child)
			if child:IsA("BasePart") or child:IsA("UnionOperation") then
				child.CollisionGroup = stickGroup
			end
		end)
	end
end

local function onCharacterAdded(character, player)
	for _, descendant in character:GetDescendants() do
		onDescendantAdded(descendant)
	end
	character.DescendantAdded:Connect(onDescendantAdded)
	character.ChildAdded:Connect(function(child)
		GolfStickCollisionGroup(child, player) 
	end)

	for _, child in character:GetChildren() do
		GolfStickCollisionGroup(child, player)
	end
end

Players.PlayerAdded:Connect(function(player)
	setupPlayerCollisionGroups(player)
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(character, player)
	end)
end)

Players.PlayerRemoving:Connect(removePlayerCollisionGroups)

for _, player in Players:GetPlayers() do
	setupPlayerCollisionGroups(player)
	if player.Character then
		onCharacterAdded(player.Character, player)
	end
end

