--because there is no C00LCLAN V3, so I made my own hehe :).I hope you like it 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local Character       = Player.Character or Player.CharacterAdded:Wait()
local Humanoid        = Character:WaitForChild("Humanoid")
local HRP             = Character:WaitForChild("HumanoidRootPart")
local Mouse           = Player:GetMouse()
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local player = Player

local PlaceId = game.PlaceId
local JobId = game.JobId
--settings
local infjump = false
local invisRunning = false
local noclipOn = false
local noclipConn
local hoverHeight
local bindFrame, bindConn, waitingBindFunction
local customBinds = {}
local infJumpEnabled = false
local infJumpConnection = nil
local espOn = false
local spinOn = false
local spinBAV, lockBP
local savedCFrame
local invisRunning = false
local InvisibleCharacter = nil
local OriginalCharacter = nil
local voidConn = nil
local flyingEnabled = false
local invisRunning = false
local flyBG, flyBV, flyConn
local ray = workspace.CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
local hit, pos = workspace:FindPartOnRay(ray, Character)
--GUI settings
local GUI_WIDTH     = 400
local GUI_HEIGHT    = 320
local TITLE_HEIGHT  = 30
local NAV_HEIGHT    = 30
local FOOTER_HEIGHT = 30
local GRID_PADDING  = 4
local GRID_COLUMNS  = 4

math.randomseed(os.time())
local character_set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

local string_sub = string.sub
local math_random = math.random
local table_concat = table.concat
local character_set_amount = #character_set
local number_one = 1
local default_length = 10



local function generate_string(length)
	local random_string = {}

	for int = number_one, length or default_length do
		local random_number = math_random(number_one, character_set_amount)
		local character = string_sub(character_set, random_number, random_number)

		random_string[#random_string + number_one] = character
	end

	return table_concat(random_string)
end
-- Function manager with descriptions
local FunctionManager = {
	CategorizedFunctions = { All = {} },
	Categories          = { "All" },
	CurrentCategoryIndex= 1,
	Descriptions        = {},
	ISFE = {},
	OnFunctionAdded     = Instance.new("BindableEvent"),
}

function UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local fn = customBinds[input.KeyCode]
		if fn and type(fn) == "function" then
			pcall(fn)
		end
	end
end)
local function toggleInvisibility()
	if invisRunning then return end
	invisRunning = true

	local player = Players.LocalPlayer
	repeat task.wait(0.1) until player.Character
	local originalChar = player.Character
	originalChar.Archivable = true

	local invisibleChar = originalChar:Clone()
	invisibleChar.Name   = ""
	invisibleChar.Parent = Lighting

	-- clone transparency
	for _, part in ipairs(invisibleChar:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0.5
		end
	end

	-- we’ll need these in nested functions:
	local isInvis = false
	local voidConn, deathConn, steppedConn

	-- Respawn helper (puts you back to originalChar)
	local function Respawn()
		invisRunning = false
		if steppedConn then steppedConn:Disconnect() end
		if deathConn   then deathConn:Disconnect()   end

		player.Character = originalChar
		originalChar.Parent = workspace
		-- destroy the extra humanoid
		local clonedHum = originalChar:FindFirstChildWhichIsA("Humanoid")
		if clonedHum then clonedHum:Destroy() end

		invisibleChar.Parent = nil
	end

	-- fix for falling through the void
	local voidY = workspace.FallenPartsDestroyHeight
	steppedConn = RunService.Stepped:Connect(function()
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local y = hrp.Position.Y
		if (voidY < 0 and y <= voidY) or (voidY >= 0 and y >= voidY) then
			Respawn()
		end
	end)

	-- if cloned character dies
	local clonedHum = invisibleChar:FindFirstChildWhichIsA("Humanoid")
	deathConn = clonedHum.Died:Connect(Respawn)

	-- now swap them
	local camCF = workspace.CurrentCamera.CFrame
	local hrpCF = originalChar.HumanoidRootPart.CFrame

	originalChar:MoveTo(Vector3.new(0, math.pi*1e6, 0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	task.wait(0.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

	invisibleChar.Parent = workspace
	invisibleChar.HumanoidRootPart.CFrame = hrpCF
	player.Character = invisibleChar

	-- re‑enable animations
	for _, a in ipairs(player.Character:GetDescendants()) do
		if a.Name == "Animate" and a:IsA("Model") then
			a.Disabled = true; a.Disabled = false
		end
	end
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until player.Character ~= nil
	workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildWhichIsA('Humanoid')
	workspace.CurrentCamera.CameraType = "Custom"
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = 400
	player.CameraMode = "Classic"
	player.Character.Head.Anchored = false
	player.Character.Animate.Enabled = false
	player.Character.Animate.Enabled = true
	Notify("You are now invisible!", "System", 3)
end

--init
updateGrid()
