-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 370)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "Чит-меню"
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "🔽"
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -60, 0, 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 35)
content.Size = UDim2.new(1, 0, 1, -35)
content.BackgroundTransparency = 1

local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		content.Visible = false
		frame.Size = UDim2.new(0, 250, 0, 35)
		toggleBtn.Text = "🔼"
	else
		content.Visible = true
		frame.Size = UDim2.new(0, 250, 0, 370)
		toggleBtn.Text = "🔽"
	end
end)

-- ESP
local espButton = Instance.new("TextButton", content)
espButton.Text = "Включить ESP"
espButton.Size = UDim2.new(0, 200, 0, 40)
espButton.Position = UDim2.new(0.5, -100, 0, 10)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16

local espActive = false
local espConnection
espButton.MouseButton1Click:Connect(function()
	espActive = not espActive
	espButton.Text = espActive and "Выключить ESP" or "Включить ESP"
	if espActive then
		espConnection = RunService.RenderStepped:Connect(function()
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
					if not player.Character:FindFirstChild("ESPBox") then
						local adorn = Instance.new("BoxHandleAdornment")
						adorn.Name = "ESPBox"
						adorn.Adornee = player.Character
						adorn.Size = Vector3.new(4, 5, 2)
						adorn.Color3 = Color3.fromRGB(255, 48, 48)
						adorn.AlwaysOnTop = true
						adorn.ZIndex = 5
						adorn.Transparency = 0.5
						adorn.Parent = player.Character
					end
				end
			end
		end)
	else
		if espConnection then espConnection:Disconnect() end
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("ESPBox") then
				player.Character.ESPBox:Destroy()
			end
		end
	end
end)

-- Бесконечное ХП
local hpButton = Instance.new("TextButton", content)
hpButton.Text = "Бесконечное ХП"
hpButton.Size = UDim2.new(0, 200, 0, 40)
hpButton.Position = UDim2.new(0.5, -100, 0, 60)
hpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hpButton.TextColor3 = Color3.new(1, 1, 1)
hpButton.Font = Enum.Font.SourceSansBold
hpButton.TextSize = 16

local hpLoop
local hpRunning = false
hpButton.MouseButton1Click:Connect(function()
	hpRunning = not hpRunning
	hpButton.Text = hpRunning and "Выключить ХП" or "Бесконечное ХП"
	if hpRunning then
		hpLoop = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.Health = char.Humanoid.MaxHealth
			end
		end)
	else
		if hpLoop then hpLoop:Disconnect() end
	end
end)

-- Aimbot
local aimbotEnabled = false
local aimbotRadius = 100

local aimbotBtn = Instance.new("TextButton", content)
aimbotBtn.Text = "Включить Aimbot"
aimbotBtn.Size = UDim2.new(0, 200, 0, 40)
aimbotBtn.Position = UDim2.new(0.5, -100, 0, 110)
aimbotBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
aimbotBtn.TextColor3 = Color3.new(1, 1, 1)
aimbotBtn.Font = Enum.Font.SourceSansBold
aimbotBtn.TextSize = 16

local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 1
fovCircle.Radius = aimbotRadius
fovCircle.NumSides = 64
fovCircle.Transparency = 0.4
fovCircle.Filled = false
fovCircle.Visible = false

RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local function getClosestPlayer()
	local closest, shortest = nil, aimbotRadius
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
				if dist < shortest then
					-- Проверка на стены
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
					raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
					raycastParams.IgnoreWater = true
					local raycastResult = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
					if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(player.Character) then
						closest = player
						shortest = dist
					end
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

aimbotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	aimbotBtn.Text = aimbotEnabled and "Выключить Aimbot" or "Включить Aimbot"
	fovCircle.Visible = aimbotEnabled
end)

local radiusButton = Instance.new("TextButton", content)
radiusButton.Text = "Радиус: "..aimbotRadius
radiusButton.Size = UDim2.new(0, 200, 0, 40)
radiusButton.Position = UDim2.new(0.5, -100, 0, 160)
radiusButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
radiusButton.TextColor3 = Color3.new(1, 1, 1)
radiusButton.Font = Enum.Font.SourceSansBold
radiusButton.TextSize = 16

radiusButton.MouseButton1Click:Connect(function()
	aimbotRadius = aimbotRadius + 25
	if aimbotRadius > 300 then
		aimbotRadius = 50
	end
	fovCircle.Radius = aimbotRadius
	radiusButton.Text = "Радиус: "..aimbotRadius
end)
