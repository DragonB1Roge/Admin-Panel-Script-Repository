local Commands = require("AdminPanel/Commands/Size")
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

function Commands.Size(player, adminName, targetPlayerName, scale)
	if not Commands:CanUseCommand(player, "Size") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

	if targetPlayer then
		-- Change target player's size
		targetPlayer.Character.HumanRootoidPart.Size = Vector3.new(scale, scale, scale)
	else
		player.Chatted:AllFireClients("No se encontró un jugador con ese nombre.")
	end
end

return Commands
