-- Получение сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Создание GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 320)
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

-- Кнопка ❌
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

-- Контейнер содержимого
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 35)
content.Size = UDim2.new(1, 0, 1, -35)
content.BackgroundTransparency = 1

-- ESP кнопка
local espButton = Instance.new("TextButton", content)
espButton.Text = "Включить ESP"
espButton.Size = UDim2.new(0, 200, 0, 40)
espButton.Position = UDim2.new(0.5, -100, 0, 10)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16

-- ESP логика
local espActive = false
local espConnection

espButton.MouseButton1Click:Connect(function()
	espActive = not espActive
	espButton.Text = espActive and "Выключить ESP" or "Включить ESP"

	if espActive then
		espConnection = RunService.RenderStepped:Connect(function()
			for _, player in ipairs(Players:GetPlayers()) do
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
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("ESPBox") then
				player.Character.ESPBox:Destroy()
			end
		end
	end
end)

-- Бессмертие
local godButton = Instance.new("TextButton", content)
godButton.Text = "Включить бессмертие"
godButton.Size = UDim2.new(0, 200, 0, 40)
godButton.Position = UDim2.new(0.5, -100, 0, 60)
godButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
godButton.TextColor3 = Color3.new(1, 1, 1)
godButton.Font = Enum.Font.SourceSansBold
godButton.TextSize = 16

local godMode = false
local godLoop

godButton.MouseButton1Click:Connect(function()
	godMode = not godMode
	godButton.Text = godMode and "Выключить бессмертие" or "Включить бессмертие"

	if godMode then
		godLoop = RunService.Heartbeat:Connect(function()
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				local hum = char.Humanoid
				hum.MaxHealth = math.huge
				hum.Health = math.huge
			end
		end)
	else
		if godLoop then godLoop:Disconnect() end
	end
end)

-- Круг Aimbot
local aimbotRadius = 100
local aimbotVisible = true

local aimCircle = Drawing.new("Circle")
aimCircle.Color = Color3.new(0, 1, 0)
aimCircle.Thickness = 1.5
aimCircle.NumSides = 100
aimCircle.Radius = aimbotRadius
aimCircle.Filled = false
aimCircle.Transparency = 1
aimCircle.Visible = aimbotVisible

RunService.RenderStepped:Connect(function()
	local mouse = UserInputService:GetMouseLocation()
	aimCircle.Position = Vector2.new(mouse.X, mouse.Y)
end)

-- Кнопка: видимость круга
local toggleCircle = Instance.new("TextButton", content)
toggleCircle.Text = "Скрыть круг"
toggleCircle.Size = UDim2.new(0, 200, 0, 40)
toggleCircle.Position = UDim2.new(0.5, -100, 0, 110)
toggleCircle.BackgroundColor3 = Color3.fromRGB(80, 100, 100)
toggleCircle.TextColor3 = Color3.new(1, 1, 1)
toggleCircle.Font = Enum.Font.SourceSansBold
toggleCircle.TextSize = 16

toggleCircle.MouseButton1Click:Connect(function()
	aimbotVisible = not aimbotVisible
	aimCircle.Visible = aimbotVisible
	toggleCircle.Text = aimbotVisible and "Скрыть круг" or "Показать круг"
end)

-- Регулировка круга
local increaseButton = Instance.new("TextButton", content)
increaseButton.Text = "Увеличить радиус"
increaseButton.Size = UDim2.new(0, 200, 0, 30)
increaseButton.Position = UDim2.new(0.5, -100, 0, 160)
increaseButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
increaseButton.TextColor3 = Color3.new(1, 1, 1)
increaseButton.Font = Enum.Font.SourceSansBold
increaseButton.TextSize = 14

increaseButton.MouseButton1Click:Connect(function()
	aimbotRadius = aimbotRadius + 20
	aimCircle.Radius = aimbotRadius
end)

local decreaseButton = Instance.new("TextButton", content)
decreaseButton.Text = "Уменьшить радиус"
decreaseButton.Size = UDim2.new(0, 200, 0, 30)
decreaseButton.Position = UDim2.new(0.5, -100, 0, 195)
decreaseButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
decreaseButton.TextColor3 = Color3.new(1, 1, 1)
decreaseButton.Font = Enum.Font.SourceSansBold
decreaseButton.TextSize = 14

decreaseButton.MouseButton1Click:Connect(function()
	aimbotRadius = math.max(20, aimbotRadius - 20)
	aimCircle.Radius = aimbotRadius
end)
