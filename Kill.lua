local Commands = require("AdminPanel/Commands/Kill")
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

function Commands.Kill(player, adminName)
	if not Commands:CanUseCommand(player, "Kill") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	local humanoid = player.Character.Humanoid
	humanoid.Health = 0

	-- Deshabilita el movimiento del jugador durante 5 segundos
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	wait(5)

	-- Reactiva el movimiento del jugador
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
end

return Commands
