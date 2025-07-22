-- Создание GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gu.Name = "MyCheatGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Text = "Чит-меню"
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка ×
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.MouseButton1Click:Connect(function()
	title:Destroy()
	frame:Destroy()
	gui:Destroy()
end)

-- Кнопка свернуть
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "🕽"
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -60, 0, 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16

-- Контейнер содержимого
local content = Instance.new("Frame", frame)
content.Name = "Content"
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
		frame.Size = UDim2.new(0, 250, 0, 300)
		toggleBtn.Text = "🕽"
	end
end)

-- Визуальный круг прицела
local aimCircle = Instance.new("Frame", gui)
aimCircle.Size = UDim2.new(0, 150, 0, 150)
aimCircle.Position = UDim2.new(0.5, -75, 0.5, -75)
aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
aimCircle.BackgroundTransparency = 1

local circle = Instance.new("ImageLabel", aimCircle)
circle.Size = UDim2.new(1, 0, 1, 0)
circle.BackgroundTransparency = 1
circle.Image = "rbxassetid://3570695787"
circle.ImageColor3 = Color3.new(1, 0, 0)
circle.ImageTransparency = 0.4
circle.ScaleType = Enum.ScaleType.Fit

local localPlayer = game:GetService("Players").LocalPlayer
local radius = 75

local function updateCircleSize()
	aimCircle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
	aimCircle.Position = UDim2.new(0.5, -radius, 0.5, -radius)
end

-- Кнопка ESP
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
		espConnection = game:GetService("RunService").RenderStepped:Connect(function()
			for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
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
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
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

local running = false
local healthLoop
hpButton.MouseButton1Click:Connect(function()
	running = not running
	hpButton.Text = running and "Выкл. ХП" or "Бесконечное ХП"
	if running then
		healthLoop = game:GetService("RunService").Heartbeat:Connect(function()
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.Health = char.Humanoid.MaxHealth
			end
		end)
	else
		if healthLoop then healthLoop:Disconnect() end
	end
end)

-- Aimbot
local aimButton = Instance.new("TextButton", content)
aimButton.Text = "Включить Aimbot"
aimButton.Size = UDim2.new(0, 200, 0, 40)
aimButton.Position = UDim2.new(0.5, -100, 0, 110)
aimButton.BackgroundColor3 = Color3.fromRGB(100, 80, 80)
aimButton.TextColor3 = Color3.new(1, 1, 1)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 16

local aimEnabled = false
local aimLoop

local function getClosestPlayer()
	local camera = workspace.CurrentCamera
	local closestPlayer = nil
	local shortestDistance = radius

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local screenPos = Vector2.new(headPos.X, headPos.Y)
				local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
				local dist = (screenPos - screenCenter).Magnitude
				if dist < shortestDistance then
					local rayOrigin = camera.CFrame.Position
					local direction = (head.Position - rayOrigin).Unit * 500
					local params = RaycastParams.new()
					params.FilterDescendantsInstances = {localPlayer.Character}
					params.FilterType = Enum.RaycastFilterType.Blacklist
					params.IgnoreWater = true
					local result = workspace:Raycast(rayOrigin, direction, params)
					if result and result.Instance and result.Instance:IsDescendantOf(player.Character) then
						shortestDistance = dist
						closestPlayer = player
					end
				end
			end
		end
	end
	return closestPlayer
end

aimButton.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	aimButton.Text = aimEnabled and "Выключить Aimbot" or "Включить Aimbot"
	if aimEnabled then
		aimLoop = game:GetService("RunService").RenderStepped:Connect(function()
			local target = getClosestPlayer()
			if target and target.Character and target.Character:FindFirstChild("Head") then
				workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
			end
		end)
	else
		if aimLoop then aimLoop:Disconnect() end
	end
end)

-- Кнопки регулировки круга
local plusBtn = Instance.new("TextButton", content)
plusBtn.Text = "➕"
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(0.5, -100, 0, 160)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.TextSize = 18

local minusBtn = Instance.new("TextButton", content)
minusBtn.Text = "➖"
minusBtn.Size = UDim2.new(0, 40, 0, 40)
minusBtn.Position = UDim2.new(0.5, 60, 0, 160)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.TextSize = 18

plusBtn.MouseButton1Click:Connect(function()
	radius = math.min(radius + 10, 300)
	updateCircleSize()
end)

minusBtn.MouseButton1Click:Connect(function()
	radius = math.max(radius - 10, 20)
	updateCircleSize()
end)

-- Инициализация круга
updateCircleSize()
