local Roles = require(script.Parent.Main.Roles)
local Commands = require(script.Parent.Main.Commands)

-- Function to check if a player can use a command
function Commands:CanUseCommand(player, command)
	-- Verifica si el jugador tiene un rol
	local role = Roles.GetRole(player.UserId)

	if not role then
		return false
	end

	-- Comprueba si el rol tiene el permiso para el comando
	return Roles.HasPermission(role, command)
end

function Commands.Fling(player)
	if not Commands:CanUseCommand(player, "fling") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	local humanoid = player.Character.Humanoid
	local impulse = Vector3.new(math.random(-100, 100), 50, math.random(-100, 100))
	humanoid:ApplyImpulse(impulse)
end
