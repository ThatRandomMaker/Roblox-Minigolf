local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local contentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local arrivingGui = playerGui:WaitForChild("loadingScreen", 5)

if not arrivingGui then return end


	local canvasGroup = arrivingGui:WaitForChild("CanvasGroup")
	local sound = arrivingGui:WaitForChild("waitSound")
	local loadingLabel = canvasGroup.loadingFrame.mainFrame:WaitForChild("loadingText")
	local funFactLabel = canvasGroup.loadingFrame.mainFrame:WaitForChild("factText")
	local uiStroke = funFactLabel:WaitForChild("UIStroke")
	local mainMenuUI = playerGui:WaitForChild("mainMenuUI")
	
	sound:Play()
	
	local isLoading = true
	
	task.spawn(function()
		local assetsToLoad = {playerGui, player.Backpack, player.PlayerScripts}
		local success, err = pcall(function()
			contentProvider:PreloadAsync(assetsToLoad)
		end)
		
		if not success then
			warn("Error preloading but eh, the game will work won't it? /j" .. tostring(err))
		end
		
		isLoading = false
	end)	

	task.spawn(function()
		local Dots = {".", "..", "...", ""}
		local i = 0

		while isLoading do
			i = (i % #Dots) + 1
			loadingLabel.Text = "Loading" .. Dots[i]
			task.wait(0.4)
		end
	end)
	
	local funFacts = require(replicatedStorage.moduleScripts:WaitForChild("funFacts"))
	
	task.spawn(function()
		
		local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
		funFactLabel.TextTransparency = 1
		local lastFact = nil
		
		local fadeIn = tweenService:Create(funFactLabel, fadeInfo, {TextTransparency = 0})
		local fadeIn2 = tweenService:Create(uiStroke, fadeInfo, {Transparency = 0})
		local fadeOut = tweenService:Create(funFactLabel, fadeInfo, {TextTransparency = 1})
		local fadeOut2 = tweenService:Create(uiStroke, fadeInfo, {Transparency = 1})
		
		while isLoading do
			local randomFact = math.random(1, #funFacts)
			
			if #funFacts > 1 then
				while randomFact == lastFact do
					randomFact = math.random(1, #funFacts)
				end
			end
			
			lastFact = randomFact
			funFactLabel.Text = funFacts[randomFact]
			print(funFactLabel.Text)
			print(funFacts[randomFact])
			

			fadeIn:Play()
			fadeIn2:Play()
			fadeIn.Completed:Wait()
			
			for _ = 1, 30 do
				if not isLoading then break end
				task.wait(0.1)
			end
			
			if not isLoading then break end
			
			
			fadeOut:Play()
			fadeOut2:Play()
			fadeOut.Completed:Wait()
		end
		
	end)
	
	if isLoading then
		repeat task.wait(0.1) until not isLoading
	end
	
	loadingLabel.Text = "Complete!"
	loadingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	task.wait(2)
	
	for i = 0.9, 0, -0.1 do
		sound.Volume = i
		task.wait(0.05)
	end
	sound:Stop()
	
	task.wait(0.25)
	
	mainMenuUI.Enabled = true
	for _, child in ipairs(mainMenuUI.mainFrame:GetChildren()) do
		if child:IsA("LocalScript") and not child.Enabled then
			print(child)
			child.Enabled = true
		end
	end	
	
	print(arrivingGui)

	local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local fadeTween = tweenService:Create(canvasGroup, fadeInfo, {GroupTransparency = 1})
	fadeTween:Play()
	fadeTween.Completed:Wait()
	arrivingGui:Destroy()
