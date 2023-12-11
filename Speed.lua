local Commands = require("AdminPanel/Commands/Speed")
local Roles = require(script.Parent.Main.Roles)

function Commands:CanUseCommand(player, command)
	-- Verifica si el jugador tiene un rol
	local role = Roles.GetRole(player.UserId)

	if not role then
		return false
	end

	-- Comprueba si el rol tiene el permiso para el comando
	return Roles.HasPermission(role, command)
end

function Commands.Speed(player, adminName)
	if not Commands:CanUseCommand(player, "Speed") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- Cambiar la velocidad del jugador a un número grande
		humanoid.WalkSpeed = 1000
	end
end

return Commands
