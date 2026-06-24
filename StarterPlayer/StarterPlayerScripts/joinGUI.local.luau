local teleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local tweenService = game:GetService("TweenService")

local arrivingGui = teleportService:GetArrivingTeleportGui()

local function fadeOut(guiElement, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	for _, descendant in pairs(guiElement:GetDescendants()) do
		if descendant:IsA("ImageLabel") then
			tweenService:Create(descendant, tweenInfo, {ImageTransparancy = 1})
		elseif descendant:IsA("TextLabel") then
			tweenService:Create(descendant, tweenInfo, {TextTransparency = 1})
		elseif descendant:IsA("Frame") then
			tweenService:Create(descendant, tweenInfo, {BackgroundTransparency = 1})
		end
	end
end

if arrivingGui then
	arrivingGui.Parent = playerGui
	
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	
	fadeOut(arrivingGui, 1)
	task.wait(1)
	arrivingGui:Destroy()
else return end
