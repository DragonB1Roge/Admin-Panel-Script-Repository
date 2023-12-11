local Roles = {
	Creator = {
		Description = "Creador y Materializador del Juego",
		Permissions = {"Kick", "Ban", "Kill", "Size", "Speed", "Clone", "Fling"},
		Members = {"onix1124", "Usuario2"}
	},
	RoyaltyAdmin = {
		Description = "Amigos del Creador",
		Permissions = {"Kick", "Kill", "Size", "Speed", "Clone", "Fling"},
		Members = {"Usuario3", "Usuario4"}
	},
	Admin = {
		Description = "Moderador Basico",
		Permissions = {"Kick", "Ban", "Kill", "Speed", "Clone"},
		Members = {"Usuario5"}
	}
}

local UserRoles = {
	[1242293864] = "Creator",
	[5678] = "RoyaltyAdmin"
}

local Members = {
	["onix1124"] = "Creator",
	["Usuario2"] = "Creator",
	["Usuario3"] = "RoyaltyAdmin",
	["Usuario4"] = "RoyaltyAdmin",
	["Usuario5"] = "Admin"
}


function ValidatePermissions(player)
	-- Obtiene el ID de usuario y nombre del jugador
	local userId = player.UserId
	local playerName = player.Name

	-- Busca el rol del jugador en la tabla UserRoles
	local playerRole = UserRoles[userId]

	if playerRole then
		-- Verifica si el rol existe y si el jugador está incluido en la lista de miembros del rol correspondiente
		if Members[playerRole] and table.find(Members[playerRole], playerName) then
			-- El jugador tiene permisos
			print(playerName .. " tiene permisos para el rol " .. playerRole)
		else
			print(playerName .. " no tiene permisos para el rol " .. playerRole)
		end
	else
		print("El jugador " .. playerName .. " no tiene un rol definido.")
	end
end

function HasPermission(player, permission)
	-- Obtiene el rol del jugador
	local role = Roles[UserRoles[player.UserId]]

	-- Verifica si el rol existe y si el permiso está listado
	if role and role.Permissions[permission] then
		return true
	end

	return false
end

local Prefix = ";"

local Commands = {}

-- Require módulos de comandos

function Commands:Execute(player, command, ...)

	if Commands:CanUseCommand(player, command) then

		return Commands[command](player, ...)

	end

end

function Commands:CanUseCommand(player, command)

	-- Validar permisos del rol

	local role = Members[player.UserId]

	if role and Roles[role] and Roles[role].Commands[command] then
		return true
	end

	return false
end


local Players = game:GetService("Players")

function AddCommand(command, functionBody)
	-- Capture `...` in a new variable
	local wrappedFunction = function(player, ...)
		-- the Call original function without the captured arguments
		functionBody(player)
	end

	-- Add the wrapped function to the `Commands` table
	Commands[command] = wrappedFunction
end

-- Define a function to add commands from directory
function AddCommandsFromDirectory(directory)
	for _, file in pairs(directory:GetChildren()) do
		if file.Name:sub(-4) == ".lua" then
			local module = require(file.Parent .. "/" .. file.Name)
			AddCommand(module.Name, module)
		end
	end
end

AddCommandsFromDirectory(script.Parent.Commands)

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		local prefix = ";"

		if string.sub(message, 1, 1) == prefix then
			local command = string.sub(message, 2)
			local functionBody = Commands[command]

			if functionBody then
				functionBody(player)
			else
				player:Kick("Comando desconocido")
			end
		end
	end)
end)


-- Ocultar el Panel de Administrador por defecto
local AdminPanel = script.Parent.AdminPanel
AdminPanel.Visible = false

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	-- Revisar los permisos del jugador al entrar al juego
	ValidatePermissions(player)

	-- Mostrar el Panel de Administrador solo si tiene permisos
	if Commands:CanUseCommand(player, "Kick") then
		AdminPanel.Visible = true
	end
end)
