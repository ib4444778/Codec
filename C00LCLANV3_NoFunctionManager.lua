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
local function updateGrid()
	for _, c in ipairs(gridFrame:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local cat = FunctionManager:getCurrentCategory()
	catLabel.Text = cat

	for name, cb in pairs(FunctionManager.CategorizedFunctions[cat]) do
		local btn = Instance.new("TextButton")
		local isFE = FunctionManager.ISFE[name]
		btn.Size             = UDim2.new(1,0,0,40)
		btn.BackgroundColor3 = Color3.fromRGB(70,10,10)
		btn.BorderSizePixel  = 0
		btn.Font             = Enum.Font.SourceSansBold
		btn.TextSize         = 16
		btn.TextColor3       = Color3.new(1,1,1)
		btn.Text             = name
		btn.TextWrapped      = true
		btn.Parent           = gridFrame
		btn.Name             = generate_string(math_random(1, 10))
		if isFE == "no" then
			btn.BackgroundColor3 = Color3.fromRGB(72, 100, 87)
		end
		-- tooltip
		local desc = FunctionManager.Descriptions[name]
		
		btn.MouseMoved:Connect(function()
			if desc ~= "" and desc ~= nil then
				tooltip.Text     = desc
				tooltip.Position = UDim2.new(0,Mouse.X,0,Mouse.Y - tooltip.Size.Y.Offset - 4)
				tooltip.Visible = true
			end
		end)
		btn.MouseLeave:Connect(function() tooltip.Visible = false end)

		btn.MouseButton1Click:Connect(function()
			pcall(cb)
		end)
	end
end
local logo = Instance.new("ImageLabel")
logo.Name                 = generate_string(math_random(1, 10))
logo.BackgroundTransparency = 1
logo.Size                 = UDim2.new(1, 0, 0, 100)
logo.Position             = UDim2.new(0, -50, 0, -100)
logo.Image                = "rbxassetid://87486058304609"
logo.ScaleType            = Enum.ScaleType.Fit              
logo.Parent               = mainFrame
-- nav buttons
leftCat.MouseButton1Click:Connect(function()
	FunctionManager.CurrentCategoryIndex = (FunctionManager.CurrentCategoryIndex - 2) % #FunctionManager.Categories + 1
	updateGrid()
end)
rightCat.MouseButton1Click:Connect(function()
	FunctionManager:cycleCategory()
	updateGrid()
end)
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
FunctionManager.OnFunctionAdded.Event:Connect(updateGrid)



-- Initialize
updateGrid()

updateGrid()
