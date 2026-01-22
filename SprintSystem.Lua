--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)

local regenRate = sprintSystemsModule.regeneration
local slowRegenTime = sprintSystemsModule.slowRegenTime
local runtime = sprintSystemsModule.RUNTIME

local walkSpeed = sprintSystemsModule.speed
local runSpeed = sprintSystemsModule.runSpeed
local slowSpeed = sprintSystemsModule.slowSpeed

local MAX_STAMINA = 100
local stamina = MAX_STAMINA

local staminaDrain = MAX_STAMINA / runtime
local slowRegen = MAX_STAMINA / slowRegenTime

local running = false
local exhausted = false
local currentSpeed = walkSpeed

--// Input
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftShift and stamina > 0 then
		running = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		running = false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	local isMoving = humanoid.MoveDirection.Magnitude > 0

	-- Sprinting
	if running and isMoving and stamina > 0 then
		stamina -= staminaDrain * dt
		currentSpeed = runSpeed

		if stamina <= 0 then
			stamina = 0
			exhausted = true
			running = false
		end

	else
		-- Regeneration
		if stamina < MAX_STAMINA then
			stamina += (exhausted and slowRegen or regenRate) * dt

			if stamina >= MAX_STAMINA then
				stamina = MAX_STAMINA
				exhausted = false
			end
		end

		currentSpeed = exhausted and slowSpeed or walkSpeed
	end

	if humanoid.WalkSpeed ~= currentSpeed then
		humanoid.WalkSpeed = currentSpeed
	end
end)
