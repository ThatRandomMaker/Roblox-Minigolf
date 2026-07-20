local clouds = workspace.Terrain:WaitForChild("Clouds")
local cloudCover = 50
local cloudDensity = 1

while true do
	clouds.Cover = math.random(cloudCover, cloudCover + 10) / 100
	clouds.Density = math.random(cloudDensity, cloudDensity + 10) / 100
	task.wait(60)
end