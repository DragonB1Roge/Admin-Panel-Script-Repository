local Roles = require(script.Parent.Main.Roles)
local Commands = require(script.Parent.Main.Commands)

function Commands:CanUseCommand(player, command)
	-- Verifica si el jugador tiene un rol
	local role = Roles.GetRole(player.UserId)

	if not role then
		return false
	end

	-- Comprueba si el rol tiene el permiso para el comando
	return Roles.HasPermission(role, command)
end

function Commands.Clone(player)
	if not Commands:CanUseCommand(player, "Clone") then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	local clone = player.Character:Clone()

	clone.Parent = workspace

	clone.CanCollide = false
	clone.HumanoidRootPart.Anchored = true

	clone.HumanoidRootPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,2,0)

	-- Eliminar clon después de 10 segundos
	wait(10)
	clone:Destroy()

end
return Commands
