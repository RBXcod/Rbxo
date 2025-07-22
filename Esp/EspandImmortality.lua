local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local aimbotActive = false
local circleVisible = true
local radius = 100

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Cheatmenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Cheat menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local toggleAimbot = Instance.new("TextButton", frame)
toggleAimbot.Size = UDim2.new(1, -20, 0, 30)
toggleAimbot.Position = UDim2.new(0, 10, 0, 40)
toggleAimbot.Text = "Вкл/Выкл Aimbot"
toggleAimbot.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
toggleAimbot.TextColor3 = Color3.new(1, 1, 1)
toggleAimbot.Font = Enum.Font.SourceSansBold
toggleAimbot.TextSize = 18
toggleAimbot.MouseButton1Click:Connect(function()
	aimbotActive = not aimbotActive
end)

local toggleCircle = Instance.new("TextButton", frame)
toggleCircle.Size = UDim2.new(1, -20, 0, 30)
toggleCircle.Position = UDim2.new(0, 10, 0, 80)
toggleCircle.Text = "Показать/Скрыть Круг"
toggleCircle.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
toggleCircle.TextColor3 = Color3.new(1, 1, 1)
toggleCircle.Font = Enum.Font.SourceSansBold
toggleCircle.TextSize = 18
toggleCircle.MouseButton1Click:Connect(function()
	circleVisible = not circleVisible
end)

local increaseBtn = Instance.new("TextButton", frame)
increaseBtn.Size = UDim2.new(0.5, -15, 0, 30)
increaseBtn.Position = UDim2.new(0, 10, 0, 120)
increaseBtn.Text = "+"
increaseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
increaseBtn.TextColor3 = Color3.new(1, 1, 1)
increaseBtn.Font = Enum.Font.SourceSansBold
increaseBtn.TextSize = 24
increaseBtn.MouseButton1Click:Connect(function()
	radius = radius + 10
end)

local decreaseBtn = Instance.new("TextButton", frame)
decreaseBtn.Size = UDim2.new(0.5, -15, 0, 30)
decreaseBtn.Position = UDim2.new(0.5, 5, 0, 120)
decreaseBtn.Text = "-"
decreaseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
decreaseBtn.TextColor3 = Color3.new(1, 1, 1)
decreaseBtn.Font = Enum.Font.SourceSansBold
decreaseBtn.TextSize = 24
decreaseBtn.MouseButton1Click:Connect(function()
	radius = math.max(10, radius - 10)
end)

local circle = Instance.new("Frame", gui)
circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.new(0.5, 0, 0.5, 0)
circle.BackgroundTransparency = 1

local uicorner = Instance.new("UICorner", circle)
uicorner.CornerRadius = UDim.new(1, 0)

local circleOutline = Instance.new("ImageLabel", circle)
circleOutline.Size = UDim2.new(1, 0, 1, 0)
circleOutline.Position = UDim2.new(0, 0, 0, 0)
circleOutline.BackgroundTransparency = 1
circleOutline.Image = "rbxassetid://3570695787"
circleOutline.ImageColor3 = Color3.new(0, 1, 0)
circleOutline.ScaleType = Enum.ScaleType.Slice
circleOutline.SliceCenter = Rect.new(100, 100, 100, 100)

local function updateCircle()
	circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
end

local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = radius

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

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
	updateCircle()
	circle.Visible = circleVisible

	if aimbotActive then
		local target = getClosestTarget()
		if target then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
		end
	end
end)
