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

function AddCommand(command, functionBody)
	local wrappedFunction = function(player, ...)
		functionBody(player, ...)
	end
	Commands[command] = wrappedFunction
end

function Kick(player, target)
	if not Commands:CanUseCommand(player, "Kick") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	-- Realiza la acción de expulsar al jugador especificado
	player:Kick("Has sido expulsado por " .. target)
end

AddCommand("Kick", Kick) -- Agrega la función Kick con el comando "Kick"

-- Conéctate al evento PlayerAdded y maneja los mensajes de chat
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		local prefix = ";"

		if string.sub(message, 1, 1) == prefix then
			local command = string.sub(message, 2)

			local functionBody = Commands[command]

			if functionBody then
				-- Valida los permisos antes de ejecutar el comando
				if Commands:CanUseCommand(player, command) then
					functionBody(player, "target value")
				else
					player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
				end
			else
				player:Kick("Comando desconocido.")
			end
		end
	end)
end)
