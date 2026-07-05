local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid")
local playerScripts = player:WaitForChild("PlayerScripts")
local playerModule = require(playerScripts:WaitForChild("PlayerModule"))
local controls = playerModule:GetControls()

local starterGui = game:GetService("StarterGui")

starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
controls:Disable()

script:Destroy()