local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local contentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local transitionUI = playerGui:WaitForChild("transitionUI")
local transitionFrame = transitionUI:WaitForChild("transitionFrame")

local soundTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
-- side ribbon anim
local ribbonIn = TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
local ribbonOut = TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local ribbonPositions = {
	["popOut"] = UDim2.new(0, 0, 0, 0),
	["popIn"] = UDim2.new(-0.25, 0, 0, 0)
}
local function ribbonAnimation(tpUI)
	local Ribbon = tpUI:WaitForChild("CanvasGroup"):WaitForChild("infoFrame")

	local Tween = tweenService:Create(Ribbon, ribbonIn, {Position = ribbonPositions["popIn"]})
	Tween:Play()
	Tween.Completed:Wait()
end

-- transitionui
local transitionTweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local function startTransitionReverse()
	transitionUI.Enabled = true
	transitionFrame.Position = UDim2.new(1.5, 0, 0.5, 0)
	transitionFrame.Visible = true
	local transitionTween = tweenService:Create(transitionFrame, transitionTweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
	transitionTween:Play()
	transitionTween.Completed:Wait()
end

local function endTransitionReverse()
	local transitionTween1 = tweenService:Create(transitionFrame, transitionTweenInfo, {Position = UDim2.new(-0.5, 0, 0.5, 0)})
	transitionTween1:Play()
	transitionTween1.Completed:Wait()
	transitionFrame.Visible = false
	--transitionFrame.Position = UDim2.new(-0.5, 0, 0.5, 0)
	transitionUI.Enabled = false
end


if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- need to change for each map
-- hardcoded but shouldn't be an issue (?)
local arrivingGui = playerGui:WaitForChild("Desert", 5)
if not arrivingGui then return end

local mainMenuUI = playerGui:WaitForChild("mainMenuUI")

local canvasGroup = arrivingGui:WaitForChild("CanvasGroup")
local sound = arrivingGui:WaitForChild("waitSound")

local infoFrame = canvasGroup:WaitForChild("infoFrame")
local loadingLabel = infoFrame:WaitForChild("statusLabel")
local loadingLabelShadow = infoFrame:WaitForChild("Shadow"):WaitForChild("statusLabelShadow")

sound:Play()

local dotTask = task.spawn(function()
	local Dots = {".", "..", "...", ""}
	local i = 0

	while true do
		i = (i % #Dots) + 1
		loadingLabel.Text = "Loading" .. Dots[i]
		loadingLabelShadow.Text = "Loading" .. Dots[i]
		task.wait(0.4)
	end
end)

task.spawn(function()
	local assetsToLoad = {playerGui, player.Backpack, player.PlayerScripts}
	local success, err = pcall(function()
		contentProvider:PreloadAsync(assetsToLoad)
	end)
	
	if not success then
		warn("Error preloading but eh, the game will work won't it? /j" .. tostring(err))
	end
end)	

task.cancel(dotTask)
task.wait()
loadingLabel.Text = "Complete!"
loadingLabelShadow.Text = "Complete!"
loadingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
task.wait(2)
ribbonAnimation(arrivingGui)

local soundTween = tweenService:Create(sound, soundTweenInfo, {Volume = 0})
soundTween:Play()
soundTween.Completed:Wait()

sound:Stop()

startTransitionReverse()
arrivingGui:Destroy()
task.wait(0.2)

mainMenuUI.Enabled = true
for _, child in ipairs(mainMenuUI.mainFrame:GetChildren()) do
	if child:IsA("LocalScript") and not child.Enabled then
		print(child)
		child.Enabled = true
	end
end	

endTransitionReverse()
