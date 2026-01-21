local RunService = game:GetService("RunService") -- Get the RunService
local UserInputService = game:GetService("UserInputService") -- get the UserInputService

local sprintSystemsModule = require(game.ReplicatedStorage.Systems.sprintSystems.Data) -- Get the Module

local Running = false -- BoolValue
local StaminaLose = false -- BoolValue

local stamina = sprintSystemsModule["stamina"] -- stamina
local regeneration = sprintSystemsModule["regeneration"] -- regeneration
local slowRegeneration = stamina / sprintSystemsModule["slowRegenTime"]
local RUNTIME = sprintSystemsModule["RUNTIME"] -- Runtime
local staminaPerSecond = stamina / RUNTIME -- Stamina Per Second


local Character = game.Players.LocalPlayer.Character -- Get the Character
local Humanoid = Character:WaitForChild("Humanoid") -- Get the Humanoid

local function  Run(key) -- Check Running
	if key.KeyCode == Enum.KeyCode.LeftShift and stamina > 0 then
		Running = true
		print("Running")
	end
end

local function StopRun(key) -- Check not Running
	if key.KeyCode == Enum.KeyCode.LeftShift then
		Running = false
		print("Walking")


	end
end


UserInputService.InputBegan:Connect(Run)
UserInputService.InputEnded:Connect(StopRun)

RunService.Heartbeat:Connect(function(dt)

	local isMoving = Humanoid.MoveDirection.Magnitude > 0 

	if isMoving and Running == true and stamina > 0 then

		stamina = stamina - (staminaPerSecond * dt)
		Humanoid.WalkSpeed = sprintSystemsModule["runSpeed"]

		if stamina <= 0 then
			StaminaLose = true
		end

		if stamina < 0 then stamina = 0 end
	else
		Running = false

		if StaminaLose == true then
			Humanoid.WalkSpeed = sprintSystemsModule["slowSpeed"]
		else
			Humanoid.WalkSpeed = sprintSystemsModule["speed"]
		end

		if stamina < 100 and StaminaLose == false then
			stamina = stamina + (regeneration * dt)
			if stamina > 100 then stamina = 100 end

		elseif stamina < 100 and StaminaLose == true then
			stamina = stamina + (slowRegeneration * dt)
			if stamina > 100 then 
				stamina = 100
				StaminaLose = false
			end
		end
	end
	if sprintSystemsModule["viewOutpot"] == true then
		print("Stamina: "..stamina)
		print("Speed: "..Humanoid.WalkSpeed)
	end
end)
