local teleportService = game:GetService("TeleportService")
local arrivingGui = teleportService:GetArrivingTeleportGui()

if arrivingGui then
	teleportService:SetTeleportGui(nil)
	arrivingGui.Parent = game.Players.LocalPlayer.PlayerGui
end