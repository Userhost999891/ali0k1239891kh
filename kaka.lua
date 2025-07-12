-- Pełny LUA skrypt GUI Roblox z Jump, Speed, TP, Fly, NoClip, Reset i przesuwalnym GUI

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("Frame")
gui.Name = "MainGui"
gui.BackgroundColor3 = Color3.fromRGB(30,30,30)
gui.Size = UDim2.new(0, 350, 0, 400)
gui.Position = UDim2.new(0.5, -175, 0.5, -200)
gui.AnchorPoint = Vector2.new(0.5, 0.5)
gui.Parent = player:WaitForChild("PlayerGui")

-- Dragging
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
							 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
	                 input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

-- Title Bar
local titleBar = Instance.new("Frame", gui)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,45)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Text = "Panel Sterowania"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.Gotham
titleLabel.TextSize = 18

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- JumpPower input
local jumpLabel = Instance.new("TextLabel", gui)
jumpLabel.Text = "JumpPower:"
jumpLabel.Size = UDim2.new(0, 100, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 50)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 16
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jumpInput = Instance.new("TextBox", gui)
jumpInput.Size = UDim2.new(0, 100, 0, 30)
jumpInput.Position = UDim2.new(0, 120, 0, 50)
jumpInput.ClearTextOnFocus = false
jumpInput.Text = tostring(humanoid.JumpPower)
jumpInput.TextColor3 = Color3.new(0,0,0)
jumpInput.BackgroundColor3 = Color3.new(1,1,1)
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 16

-- WalkSpeed input
local speedLabel = Instance.new("TextLabel", gui)
speedLabel.Text = "WalkSpeed:"
speedLabel.Size = UDim2.new(0, 100, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", gui)
speedInput.Size = UDim2.new(0, 100, 0, 30)
speedInput.Position = UDim2.new(0, 120, 0, 90)
speedInput.ClearTextOnFocus = false
speedInput.Text = tostring(humanoid.WalkSpeed)
speedInput.TextColor3 = Color3.new(0,0,0)
speedInput.BackgroundColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 16

-- Save Button (green with checkmark)
local saveBtn = Instance.new("TextButton", gui)
saveBtn.Text = "✔ Zapisz"
saveBtn.Size = UDim2.new(0, 100, 0, 35)
saveBtn.Position = UDim2.new(0, 10, 0, 135)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 18
saveBtn.AutoButtonColor = true

saveBtn.MouseButton1Click:Connect(function()
	local j = tonumber(jumpInput.Text)
	local s = tonumber(speedInput.Text)
	if j and j >= 0 and j <= 500 then
		humanoid.JumpPower = j
	end
	if s and s >= 0 and s <= 500 then
		humanoid.WalkSpeed = s
	end
end)

-- TP Section Frame
local tpFrame = Instance.new("Frame", gui)
tpFrame.Size = UDim2.new(1, -20, 0, 100)
tpFrame.Position = UDim2.new(0, 10, 0, 190)
tpFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tpFrame.BorderSizePixel = 0
tpFrame.AnchorPoint = Vector2.new(0, 0)

local tpTitle = Instance.new("TextLabel", tpFrame)
tpTitle.Text = "TP (Teleport)"
tpTitle.Size = UDim2.new(1, 0, 0, 25)
tpTitle.BackgroundTransparency = 1
tpTitle.TextColor3 = Color3.new(1,1,1)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 18

-- Coordinate inputs X, Y, Z
local coords = {}

for i, axis in pairs({"X", "Y", "Z"}) do
	local label = Instance.new("TextLabel", tpFrame)
	label.Text = axis .. ":"
	label.Size = UDim2.new(0, 20, 0, 30)
	label.Position = UDim2.new(0, 10 + (i-1)*90, 0, 30)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left

	local input = Instance.new("TextBox", tpFrame)
	input.Size = UDim2.new(0, 70, 0, 30)
	input.Position = UDim2.new(0, 35 + (i-1)*90, 0, 30)
	input.ClearTextOnFocus = false
	input.Text = "0"
	input.TextColor3 = Color3.new(0,0,0)
	input.BackgroundColor3 = Color3.new(1,1,1)
	input.Font = Enum.Font.Gotham
	input.TextSize = 16
	coords[axis] = input
end

-- Set Button
local setBtn = Instance.new("TextButton", tpFrame)
setBtn.Text = "Set"
setBtn.Size = UDim2.new(0, 60, 0, 35)
setBtn.Position = UDim2.new(0, 10, 0, 70)
setBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
setBtn.TextColor3 = Color3.new(1,1,1)
setBtn.Font = Enum.Font.GothamBold
setBtn.TextSize = 16

local setCoords = Vector3.new(0,0,0)

setBtn.MouseButton1Click:Connect(function()
	local x = tonumber(coords["X"].Text)
	local y = tonumber(coords["Y"].Text)
	local z = tonumber(coords["Z"].Text)
	if x and y and z then
		setCoords = Vector3.new(x,y,z)
	end
end)

-- TP Button
local tpBtn = Instance.new("TextButton", tpFrame)
tpBtn.Text = "TP"
tpBtn.Size = UDim2.new(0, 60, 0, 35)
tpBtn.Position = UDim2.new(0, 80, 0, 70)
tpBtn.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16

tpBtn.MouseButton1Click:Connect(function()
	if setCoords then
		hrp.CFrame = CFrame.new(setCoords)
	end
end)

-- Additional Fun Functions

-- Fly Toggle Button
local flyBtn = Instance.new("TextButton", gui)
flyBtn.Text = "Fly: OFF"
flyBtn.Size = UDim2.new(0, 100, 0, 35)
flyBtn.Position = UDim2.new(0, 200, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16

local flying = false
local bodyVelocity

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly: ON"
		bodyVelocity = Instance.new("BodyVelocity", hrp)
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Velocity = Vector3.new(0,0,0)
	else
		flyBtn.Text = "Fly: OFF"
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
	end
end)

-- NoClip Toggle Button
local noclipBtn = Instance.new("TextButton", gui)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.Size = UDim2.new(0, 100, 0, 35)
noclipBtn.Position = UDim2.new(0, 200, 0, 90)
noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 16

local noclipOn = false

noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	if noclipOn then
		noclipBtn.Text = "NoClip: ON"
		for _, part in pairs(char:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		noclipBtn.Text = "NoClip: OFF"
		for _, part in pairs(char:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

-- Reset Button
local resetBtn = Instance.new("TextButton", gui)
resetBtn.Text = "Reset Stats"
resetBtn.Size = UDim2.new(0, 100, 0, 35)
resetBtn.Position = UDim2.new(0, 200, 0, 135)
resetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 16

resetBtn.MouseButton1Click:Connect(function()
	humanoid.JumpPower = 50
	humanoid.WalkSpeed = 16
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	noclipOn = false
	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
	flyBtn.Text = "Fly: OFF"
	noclipBtn.Text = "NoClip: OFF"
	jumpInput.Text = "50"
	speedInput.Text = "16"
end)