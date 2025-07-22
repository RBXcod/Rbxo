-- Создание GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"

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

-- Кнопка свернуть 🔽 / 🔼
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "🔽"
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

-- Логика свертывания
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
		toggleBtn.Text = "🔽"
	end
end)

-- Кнопка ESP
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
local localPlayer = game:GetService("Players").LocalPlayer

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

-- Вторая кнопка (например: бесконечное здоровье)
local newButton = Instance.new("TextButton", content)
newButton.Text = "Бесконечное ХП"
newButton.Size = UDim2.new(0, 200, 0, 40)
newButton.Position = UDim2.new(0.5, -100, 0, 60)
newButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
newButton.TextColor3 = Color3.new(1, 1, 1)
newButton.Font = Enum.Font.SourceSansBold
newButton.TextSize = 16

-- При нажатии - ХП всегда 100
local running = false
local healthLoop

newButton.MouseButton1Click:Connect(function()
	if running then
		running = false
		if healthLoop then healthLoop:Disconnect() end
		newButton.Text = "Бесконечное ХП"
	else
		running = true
		newButton.Text = "Выключить ХП"
		healthLoop = game:GetService("RunService").Heartbeat:Connect(function()
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.Health = 100
			end
		end)
	end
end)-- Создание GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"

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

-- Кнопка свернуть 🔽 / 🔼
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "🔽"
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

-- Логика свертывания
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
		toggleBtn.Text = "🔽"
	end
end)

-- Кнопка ESP
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
local localPlayer = game:GetService("Players").LocalPlayer

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

-- Вторая кнопка (например: бесконечное здоровье)
local newButton = Instance.new("TextButton", content)
newButton.Text = "Бесконечное ХП"
newButton.Size = UDim2.new(0, 200, 0, 40)
newButton.Position = UDim2.new(0.5, -100, 0, 60)
newButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
newButton.TextColor3 = Color3.new(1, 1, 1)
newButton.Font = Enum.Font.SourceSansBold
newButton.TextSize = 16

-- При нажатии - ХП всегда 100
local running = false
local healthLoop

newButton.MouseButton1Click:Connect(function()
	if running then
		running = false
		if healthLoop then healthLoop:Disconnect() end
		newButton.Text = "Бесконечное ХП"
	else
		running = true
		newButton.Text = "Выключить ХП"
		healthLoop = game:GetService("RunService").Heartbeat:Connect(function()
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.Health = 100
			end
		end)
	end
end)
