local badgeService = game:GetService("BadgeService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local badgeMilestones = require(replicatedStorage:WaitForChild("progressionBadgeMilestones"))
local Players = game:GetService("Players")


local function onPlayerAdded(player)
	local leaderstats = player:WaitForChild("leaderstats")
	local stagesWon = leaderstats:WaitForChild("Stages Won")
	
	local badgesWon = {}
	
	local function checkBadgeMilestone(newValue)
		for milestone, badgeId in pairs(badgeMilestones) do
			if not badgesWon[badgeId] and newValue >= milestone then
				local success, hasBadge = pcall(function()
					return badgeService:UserHasBadgeAsync(player.UserId, badgeId)
				end)
				
				if success then
					if hasBadge then
						badgesWon[badgeId] = true
					else
						badgeService:AwardBadgeAsync(player.UserId, badgeId)
						badgesWon[badgeId] = true
					end
				end
				
			end
		end
	end
	checkBadgeMilestone(stagesWon.Value)
	stagesWon.Changed:Connect(checkBadgeMilestone)
end

Players.PlayerAdded:Connect(onPlayerAdded)
