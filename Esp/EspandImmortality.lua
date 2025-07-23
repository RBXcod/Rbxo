local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"
gui.ResetOnSpawn = false

local minimized = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "My Cheat Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSans
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -50, 0, 5)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Font = Enum.Font.SourceSans
minimizeButton.TextSize = 18

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeButton.Font = Enum.Font.SourceSans
closeButton.TextSize = 18

local minimizedFrame = Instance.new("Frame", gui)
minimizedFrame.Size = UDim2.new(0, 300, 0, 30)
minimizedFrame.Position = frame.Position
minimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizedFrame.Visible = false

local miniTitle = Instance.new("TextLabel", minimizedFrame)
miniTitle.Size = UDim2.new(1, -60, 1, 0)
miniTitle.Position = UDim2.new(0, 10, 0, 0)
miniTitle.Text = "My Cheat Menu"
miniTitle.TextColor3 = Color3.new(1, 1, 1)
miniTitle.BackgroundTransparency = 1
miniTitle.Font = Enum.Font.SourceSans
miniTitle.TextSize = 20
miniTitle.TextXAlignment = Enum.TextXAlignment.Left

local expandButton = Instance.new("TextButton", minimizedFrame)
expandButton.Size = UDim2.new(0, 20, 0, 20)
expandButton.Position = UDim2.new(1, -50, 0, 5)
expandButton.Text = "+"
expandButton.TextColor3 = Color3.new(1, 1, 1)
expandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
expandButton.Font = Enum.Font.SourceSans
expandButton.TextSize = 18

local closeMiniButton = Instance.new("TextButton", minimizedFrame)
closeMiniButton.Size = UDim2.new(0, 20, 0, 20)
closeMiniButton.Position = UDim2.new(1, -25, 0, 5)
closeMiniButton.Text = "X"
closeMiniButton.TextColor3 = Color3.new(1, 1, 1)
closeMiniButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeMiniButton.Font = Enum.Font.SourceSans
closeMiniButton.TextSize = 18

minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	minimizedFrame.Visible = true
end)

expandButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	minimizedFrame.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

closeMiniButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local aiming = false
local radius = 80

local circle = Drawing.new("Circle")
circle.Position = Vector2.new(580, 300)
circle.Radius = radius
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Visible = true
circle.Thickness = 2
circle.Transparency = 1
circle.Filled = false

function getClosestTarget()
	local closest = nil
	local dist = radius
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") and plr.Character.Humanoid.Health > 0 then
			local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.Head.Position)
			if onScreen then
				local diff = (Vector2.new(pos.X, pos.Y) - circle.Position).Magnitude
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

local function createButton(text, parent, callback, posY)
	local btn = Instance.new("TextButton", parent)
	btn.Text = text
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local mainTab = Instance.new("Frame", frame)
mainTab.Size = UDim2.new(1, 0, 1, -60)
mainTab.Position = UDim2.new(0, 0, 0, 60)
mainTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local extraTab = Instance.new("Frame", frame)
extraTab.Size = UDim2.new(1, 0, 1, -60)
extraTab.Position = UDim2.new(0, 0, 0, 60)
extraTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
extraTab.Visible = false

local btnMain = createButton("Главная", frame, function()
	mainTab.Visible = true
	extraTab.Visible = false
end, 30)

local btnExtra = createButton("Улучшения", frame, function()
	mainTab.Visible = false
	extraTab.Visible = true
end, 65)

createButton("Вкл/Выкл Aimbot", mainTab, function()
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

local walkSpeed = 16
local jumpPower = 50
local fly = false
local noclip = false

createButton("Скорость +", extraTab, function()
	walkSpeed = walkSpeed + 10
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
	end
end, 10)

createButton("Скорость -", extraTab, function()
	walkSpeed = math.max(10, walkSpeed - 10)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
	end
end, 50)

createButton("Прыжок +", extraTab, function()
	jumpPower = jumpPower + 10
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = jumpPower
	end
end, 90)

createButton("Прыжок -", extraTab, function()
	jumpPower = math.max(10, jumpPower - 10)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = jumpPower
	end
end, 130)

local flyForceConnection
createButton("Fly", extraTab, function()
	fly = not fly
	if fly then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local bp = Instance.new("BodyPosition")
			bp.Name = "FlyForce"
			bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bp.Position = hrp.Position + Vector3.new(0, 5, 0)
			bp.Parent = hrp

			flyForceConnection = RunService.RenderStepped:Connect(function()
				if bp and bp.Parent then
					bp.Position = hrp.Position + Vector3.new(0, 5, 0)
				else
					if flyForceConnection then
						flyForceConnection:Disconnect()
						flyForceConnection = nil
					end
				end
			end)
		end
	else
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp and hrp:FindFirstChild("FlyForce") then
			hrp.FlyForce:Destroy()
		end
		if flyForceConnection then
			flyForceConnection:Disconnect()
			flyForceConnection = nil
		end
	end
end, 170)

local noclipConnection
createButton("Noclip", extraTab, function()
	noclip = not noclip
	if noclip then
		noclipConnection = RunService.Stepped:Connect(function()
			if LocalPlayer.Character then
				for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		if LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
		end
	end
end, 210)
