-- Загружаем OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/OrionLib.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "TROLL MENU 😈",
    HidePremium = false,
    SaveConfig = false
})

-- Главная вкладка
local TrollTab = Window:MakeTab({
    Name = "Троллинг игроков",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 🔨 Пнуть игроков
TrollTab:AddButton({
    Name = "Пнуть всех игроков ➡️",
    Callback = function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.Velocity = Vector3.new(100, 0, 0)
            end
        end
    end
})

-- 🚀 Телепорт к каждому игроку по очереди
TrollTab:AddButton({
    Name = "ТП к игрокам по очереди",
    Callback = function()
        local me = game.Players.LocalPlayer
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= me and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                me.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                wait(1.5)
            end
        end
    end
})

-- 🧱 Поставить "стенку" перед всеми
TrollTab:AddButton({
    Name = "Поставить стены перед игроками 🧱",
    Callback = function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local part = Instance.new("Part")
                part.Size = Vector3.new(5, 5, 1)
                part.Position = plr.Character.Head.Position + plr.Character.Head.CFrame.LookVector * 3
                part.Anchored = true
                part.CanCollide = true
                part.BrickColor = BrickColor.Random()
                part.Parent = workspace
                game.Debris:AddItem(part, 10)
            end
        end
    end
})

-- 🎵 Рикролл в уши
TrollTab:AddButton({
    Name = "Рикролл для всех 😂",
    Callback = function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local sound = Instance.new("Sound", plr.Character.Head)
                sound.SoundId = "rbxassetid://130776150" -- Rick Astley - Never Gonna Give You Up
                sound.Volume = 10
                sound:Play()
                game.Debris:AddItem(sound, 10)
            end
        end
    end
})
