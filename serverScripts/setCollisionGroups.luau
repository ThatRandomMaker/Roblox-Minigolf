local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("Ball")
PhysicsService:RegisterCollisionGroup("GolfStick")

PhysicsService:CollisionGroupSetCollidable("Player", "Ball", false)
PhysicsService:CollisionGroupSetCollidable("GolfStick", "Ball", true)
PhysicsService:CollisionGroupSetCollidable("Player", "Player", false)
PhysicsService:CollisionGroupSetCollidable("GolfStick", "Default", false)
PhysicsService:CollisionGroupSetCollidable("Player", "GolfStick", false)

local function onDescendantAdded(descendant)
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Player"
	end
end

local function GolfStickCollisionGroup(descendant) 
	if descendant:IsA("Tool") then
		for _, part in ipairs(descendant:GetDescendants()) do
			if part:IsA("UnionOperation") then
				part.CollisionGroup = "GolfStick"
				print(part.CollisionGroup)
			end
		end
		descendant.DescendantAdded:Connect(function(child)
			if child:IsA("UnionOperation") then
				child.CollisionGroup = "GolfStick"
				print(child.CollisionGroup)
			end
		end)
	end
end

local function onCharacterAdded(character)
	for _, descendant in character:GetDescendants() do
		onDescendantAdded(descendant)
	end
	character.DescendantAdded:Connect(onDescendantAdded)
	character.ChildAdded:Connect(GolfStickCollisionGroup)
	for _, child in character:GetChildren() do
		GolfStickCollisionGroup(child)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end)




