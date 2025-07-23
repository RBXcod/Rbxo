local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CheatGUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0, 30, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0

local tabButtonsFrame = Instance.new("Frame", mainFrame)
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createTabButton(name, xPosition)
	local btn = Instance.new("TextButton", tabButtonsFrame)
	btn.Text = name
	btn.Size = UDim2.new(0.5, 0, 1, 0)
	btn.Position = UDim2.new(xPosition, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	return btn
end

local mainTab = Instance.new("Frame", mainFrame)
mainTab.Size = UDim2.new(1, 0, 1, -30)
mainTab.Position = UDim2.new(0, 0, 0, 30)
mainTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainTab.Visible = true

local extraTab = Instance.new("Frame", mainFrame)
extraTab.Size = UDim2.new(1, 0, 1, -30)
extraTab.Position = UDim2.new(0, 0, 0, 30)
extraTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
extraTab.Visible = false

local btnMain = createTabButton("Главная", 0)
local btnExtra = createTabButton("Улучшения", 0.5)

btnMain.MouseButton1Click:Connect(function()
	mainTab.Visible = true
	extraTab.Visible = false
end)

btnExtra.MouseButton1Click:Connect(function()
	mainTab.Visible = false
	extraTab.Visible = true
end)

-- Aimbot
local aiming = false
local radius = 100
local circle = Drawing.new("Circle")
circle.Visible = true
circle.Transparency = 1
circle.Thickness = 1
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Radius = radius
circle.Filled = false

RunService.RenderStepped:Connect(function()
	circle.Position = UIS:GetMouseLocation()
end)

function getClosestTarget()
	local closest = nil
	local dist = radius
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") and plr.Character.Humanoid.Health > 0 then
			local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.Head.Position)
			if onScreen then
				local diff = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
				if diff < dist then
					local ray = Ray.new(Camera.CFrame.Position, (plr.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
					local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character, true, false)
					if hit and not hit:IsDescendantOf(plr.Character) then continue end
					closest = plr
					dist = diff
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if aiming then
		local target = getClosestTarget()
		if target then
			local headPos = target.Character.Head.Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
		end
	end
end)

-- Main tab buttons
local function createButton(text, parent, callback, posY)
	local btn = Instance.new("TextButton", parent)
	btn.Text = text
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
end

createButton("Aimbot вкл/выкл", mainTab, function()
	aiming = not aiming
end, 10)

createButton("Показать/Скрыть круг", mainTab, function()
	circle.Visible = not circle.Visible
end, 50)

createButton("Круг +", mainTab, function()
	radius = radius + 10
	circle.Radius = radius
end, 90)

createButton("Круг -", mainTab, function()
	radius = math.max(10, radius - 10)
	circle.Radius = radius
end, 130)

-- Extra tab functions
local walkSpeed = 16
local jumpPower = 50
local fly = false
local noclip = false

createButton("Скорость +", extraTab, function()
	walkSpeed = walkSpeed + 10
	LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
end, 10)

createButton("Скорость -", extraTab, function()
	walkSpeed = math.max(10, walkSpeed - 10)
	LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
end, 50)

createButton("Прыжок +", extraTab, function()
	jumpPower = jumpPower + 10
	LocalPlayer.Character.Humanoid.JumpPower = jumpPower
end, 90)

createButton("Прыжок -", extraTab, function()
	jumpPower = math.max(10, jumpPower - 10)
	LocalPlayer.Character.Humanoid.JumpPower = jumpPower
end, 130)

createButton("Fly", extraTab, function()
	fly = not fly
	if fly then
		local bp = Instance.new("BodyPosition", LocalPlayer.Character.HumanoidRootPart)
		bp.Name = "FlyForce"
		bp.MaxForce = Vector3.new(100000, 100000, 100000)
		RunService.RenderStepped:Connect(function()
			if bp and bp.Parent then
				bp.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
			end
		end)
	else
		if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyForce") then
			LocalPlayer.Character.HumanoidRootPart.FlyForce:Destroy()
		end
	end
end, 170)

createButton("Noclip", extraTab, function()
	noclip = not noclip
	RunService.Stepped:Connect(function()
		if noclip and LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
end, 210)
