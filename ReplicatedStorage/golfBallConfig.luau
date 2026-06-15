local golfBallConfig = {}

golfBallConfig.Items = {
	["Default"] = {Color = Color3.fromRGB(163, 162, 165), Price = 0},
	["RedTestBall"] = {Color = Color3.fromRGB(255, 0, 0), Price = 50},
	["BlueTestBall"] = {Color = Color3.fromRGB(0, 0, 255), Price = 100}
}

golfBallConfig.Trails = {
	["None"] = {Price = 0, Color = nil},
	["RainbowTrail"] = {
			Price = 100,
			Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
		})
	},
	["FireTrail"] = {
		Price = 300,
		Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
	}
}

golfBallConfig.Effects = {
	["None"] = {Price = 0},
	["Sparkles"] = {
		Price = 100,
		Template = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("Sparkles")
	},
	["Lighting"] = {
		Price = 100,
		Template = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("Lighting")
	},
	["Plasma"] = {
		Price = 100,
		Template = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("Plasma")
	},
	["Void"] = {
		Price = 100,
		Template = game.ReplicatedStorage:WaitForChild("Particles"):WaitForChild("Void")
	}
}

return golfBallConfig