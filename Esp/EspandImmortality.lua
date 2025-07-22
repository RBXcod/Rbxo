local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyCheatGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
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
		toggleBtn.Text = "🔽"
	end
end)

local espActive = false
local espConnection

local espButton = Instance.new("TextButton", content)
espButton.Text = "Включить ESP"
espButton.Size = UDim2.new(0, 200, 0, 40)
espButton.Position = UDim2.new(0.5, -100, 0, 10)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16

espButton.MouseButton1Click:Connect(function()
	espActive = not espActive
	espButton.Text = espActive and "Выключить ESP" or "Включить ESP"

	if espActive then
		espConnection = RunService.RenderStepped:Connect(function()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
					if not player.Character:FindFirstChild("ESPBox") then
						local box = Instance.new("BoxHandleAdornment")
						box.Name = "ESPBox"
						box.Adornee = player.Character
						box.Size = Vector3.new(4, 5, 2)
						box.Color3 = Color3.fromRGB(255, 48, 48)
						box.AlwaysOnTop = true
						box.Transparency = 0.5
						box.ZIndex = 5
						box.Parent = player.Character
					end
				end
			end
		end)
	else
		if espConnection then
			espConnection:Disconnect()
		end
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("ESPBox") then
				player.Character.ESPBox:Destroy()
			end
		end
	end
end)

local godMode = false
local godConnection

local godButton = Instance.new("TextButton", content)
godButton.Text = "Бессмертие"
godButton.Size = UDim2.new(0, 200, 0, 40)
godButton.Position = UDim2.new(0.5, -100, 0, 60)
godButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
godButton.TextColor3 = Color3.new(1, 1, 1)
godButton.Font = Enum.Font.SourceSansBold
godButton.TextSize = 16

godButton.MouseButton1Click:Connect(function()
	godMode = not godMode
	godButton.Text = godMode and "Откл. Бессмертие" or "Бессмертие"
	if godMode then
		godConnection = RunService.Heartbeat:Connect(function()
			local char = localPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				local humanoid = char.Humanoid
				humanoid.MaxHealth = math.huge
				humanoid.Health = math.huge
			end
		end)
	else
		if godConnection then
			godConnection:Disconnect()
		end
	end
end)

local aimbotActive = false
local circleVisible = true
local radius = 100

local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Thickness = 1
circle.Filled = false
circle.Radius = radius
circle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
circle.Visible = true

local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = radius

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

				if distance <= radius then
					local rayParams = RaycastParams.new()
					rayParams.FilterDescendantsInstances = {localPlayer.Character}
					rayParams.FilterType = Enum.RaycastFilterType.Blacklist
					local rayResult = Workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500, rayParams)

					if rayResult and rayResult.Instance:IsDescendantOf(player.Character) then
						if distance < shortestDistance then
							shortestDistance = distance
							closestTarget = head
						end
					end
				end
			end
		end
	end

	return closestTarget
end

RunService.RenderStepped:Connect(function()
	circle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	circle.Radius = radius
	circle.Visible = aimbotActive and circleVisible

	if aimbotActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = getClosestTarget()
		if target then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
		end
	end
end)

local aimbotButton = Instance.new("TextButton", content)
aimbotButton.Text = "Включить Aimbot"
aimbotButton.Size = UDim2.new(0, 200, 0, 40)
aimbotButton.Position = UDim2.new(0.5, -100, 0, 110)
aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
aimbotButton.TextColor3 = Color3.new(1, 1, 1)
aimbotButton.Font = Enum.Font.SourceSansBold
aimbotButton.TextSize = 16

aimbotButton.MouseButton1Click:Connect(function()
	aimbotActive = not aimbotActive
	aimbotButton.Text = aimbotActive and "Выключить Aimbot" or "Включить Aimbot"
end)

local toggleCircleBtn = Instance.new("TextButton", content)
toggleCircleBtn.Text = "Скрыть круг"
toggleCircleBtn.Size = UDim2.new(0, 200, 0, 40)
toggleCircleBtn.Position = UDim2.new(0.5, -100, 0, 160)
toggleCircleBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
toggleCircleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleCircleBtn.Font = Enum.Font.SourceSansBold
toggleCircleBtn.TextSize = 16

toggleCircleBtn.MouseButton1Click:Connect(function()
	circleVisible = not circleVisible
	toggleCircleBtn.Text = circleVisible and "Скрыть круг" or "Показать круг"
end)

local increaseRadiusBtn = Instance.new("TextButton", content)
increaseRadiusBtn.Text = "+"
increaseRadiusBtn.Size = UDim2.new(0, 40, 0, 40)
increaseRadiusBtn.Position = UDim2.new(0.5, 50, 0, 210)
increaseRadiusBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
increaseRadiusBtn.TextColor3 = Color3.new(1, 1, 1)
increaseRadiusBtn.Font = Enum.Font.SourceSansBold
increaseRadiusBtn.TextSize = 24

local decreaseRadiusBtn = Instance.new("TextButton", content)
decreaseRadiusBtn.Text = "–"
decreaseRadiusBtn.Size = UDim2.new(0, 40, 0, 40)
decreaseRadiusBtn.Position = UDim2.new(0.5, -90, 0, 210)
decreaseRadiusBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
decreaseRadiusBtn.TextColor3 = Color3.new(1, 1, 1)
decreaseRadiusBtn.Font = Enum.Font.SourceSansBold
decreaseRadiusBtn.TextSize = 24

increaseRadiusBtn.MouseButton1Click:Connect(function()
	radius = math.clamp(radius + 10, 20, 500)
end)

decreaseRadiusBtn.MouseButton1Click:Connect(function()
	radius = math.clamp(radius - 10, 20, 500)
end)
