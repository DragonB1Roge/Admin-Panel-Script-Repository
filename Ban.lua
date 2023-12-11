local Commands = require("AdminPanel/Commands")
local Roles = require(script.Parent.Main.Roles)

function Commands:CanUseCommand(player, command)
	-- Check permission only once
	local hasPermission = Roles.GetRole(player.UserId) and Roles.HasPermission(role, command)

	-- Return result
	return hasPermission
end

function Commands.Ban(player)
	local hasPermission = Commands:CanUseCommand(player, "ban")

	if not hasPermission then
		player.Chatted:FireAllClients("No tienes permiso para usar este comando.")
		return
	end

	-- Import BanScreen from workspace
	local BanScreen = game.Workspace.AdminPanel.Commands.BanScreen

	-- Show BanScreen
	BanScreen.Visible = true

	-- Define variables
	local reason = BanScreen.ReasonTextBox.Text
	local time = BanScreen.SelectedTimeButton.Name

	-- Validate time selection

	-- Listen for BanButton click
	BanScreen.BanButton.MouseButton1Down:Connect(function()
		-- Destroy BanScreen
		BanScreen:Destroy()
	end)

	local BanScreen = script.Parent.BanScreen
	local TimeButtons = {
		[1] = BanScreen:FindFirstChild("5 meses Button"),
		[2] = BanScreen:FindFirstChild("1 año Button"),
		[3] = BanScreen:FindFirstChild("3 años Button"),
		[4] = BanScreen:FindFirstChild("Permanente Button"),
	}

	-- Define the banTimes table before using it
	local banTimes = {
		["5 meses"] = 12960000,
		["1 año"] = 31536000,
		["3 años"] = 94395200,
		["Permanente"] = 1000000000,
	}

	local function BanPlayer(player, time, reason)
		local validTime = banTimes[time]

		if not validTime then
			-- Show error message
			BanScreen:ShowError("Error: Tiempo de ban inválido.")
			return
		end
	end

	local ReasonTextBox = BanScreen:FindFirstChild("Reason TextBox")

	local function GetBanPlayer(player, time, reason)
		local validTime = banTimes[time]

		if not validTime then
			--			 Display user-friendly message instead of print statement
			player:Kick("Tiempo de ban inválido.")
			return
		end

		-- Ban the player
		Commands.Ban(player, reason, validTime)

		-- Send ban announcement
		local Players = game:GetService("Players")
		Players.PlayerRemoving:Connect(function(player)
			game.Players:ChatAnnounce(player, "Has sido baneado por " .. time .. " por " .. reason)
		end)
	end

	for _, button in pairs(TimeButtons) do
		button.MouseButton1Up:Connect(function()
			local time = button.Name
			local reason = ReasonTextBox.Text

			if not banTimes[time] then
				-- Show error message on the screen
				BanScreen:ShowError("Error: Tiempo de ban inválido.")
				return
			end

			-- ... existing code ...

			local confirmBanDialog = game:GetService("CoreGui"):PromptButtonDialog("Confirmar ban", "Estás a punto de banear a " .. player.Name .. " por " .. time .. ". ¿Estás seguro?")
			confirmBanDialog.Buttons[1].Text = "Confirmar"
			confirmBanDialog.Buttons[1].MouseButton1Up:Connect(function()
				BanPlayer(player, time, reason)
				BanScreen:Destroy()
			end)
		end)
	end
end
