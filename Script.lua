-- 🔥 KING LEGACY ULTIMATE HUB MOD (2026) 🔥
-- Modificado/Expandido por Grok - Base: Task Script
-- Features: Auto Farm + Quest + Stats + Teleport + Fruit Sniper + Anti-AFK + GUI!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- 📊 CONFIGS (MODIFIQUE AQUI)
local Config = {
    AutoFarm = true,
    AutoQuest = true,
    AutoStats = true,
    FruitSniper = true,
    TeleportSpeed = 200,
    FarmRange = 75,
    StatsMode = "Melee" -- "Melee", "Defense", "Sword", "Gun", "Fruit", "Max"
}

-- 🌟 GUI SIMPLES (F12 pra abrir/fechar)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔥 KING LEGACY ULTIMATE HUB 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.TextScaled = true

-- Botões da GUI
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- 🎯 FUNÇÕES PRINCIPAIS (MODIFICADAS/EXPANDIDAS)

-- Auto Stats INTELIGENTE
local function autoStats()
    if not Config.AutoStats then return end
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Remotes1")
    if remotes then
        local statsRemote = remotes:FindFirstChild("Stats") or remotes:FindFirstChild("RebirthStats")
        
        local pointsToAdd = 500  -- Ajuste aqui!
        local stat = Config.StatsMode
        
        if statsRemote then
            statsRemote:FireServer(stat, pointsToAdd)
            print("📈 +" .. pointsToAdd .. " " .. stat)
        end
    end
end

-- Auto Quest (UPD 9+ Compatible)
local function getQuest()
    if not Config.AutoQuest then return end
    
    pcall(function()
        local remotes = ReplicatedStorage.Remotes
        local questRemote = remotes:FindFirstChild("Quest") or 
                           remotes:FindFirstChild("CommF_Quest") or
                           remotes:FindFirstChild("GetQuest")
        
        if questRemote then
            questRemote:FireServer("BartiloQuest", "Start")  -- Quest mais comum
            questRemote:FireServer("DakibolosQuest", "Start")
            questRemote:FireServer("CitizenQuest", "Start")
        end
    end)
end

-- Farm Mobs + Bosses
local function farmEnemies()
    if not Config.AutoFarm then return end
    
    for _, enemy in pairs(workspace:GetChildren()) do
        local isEnemy = string.find(enemy.Name, "Bandit") or 
                       string.find(enemy.Name, "Gorilla") or
                       string.find(enemy.Name, "Marine") or
                       string.find(enemy.Name, "Boss") or
                       string.find(enemy.Name, "Sea")
        
        if isEnemy and enemy:FindFirstChild("HumanoidRootPart") and 
           enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            
            local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < Config.FarmRange then
                -- Teleporte suave
                humanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, -5)
                
                -- Ataque auto
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                game:GetService("VirtualUser"):CaptureController()
                wait(0.1)
            end
        end
    end
end

-- 🍎 FRUIT SNIPER (NOVA!)
local function fruitSniper()
    if not Config.FruitSniper then return end
    
    for _, fruit in pairs(workspace:GetChildren()) do
        if string.find(fruit.Name, "Magu") or string.find(fruit.Name, "Gomu") or 
           string.find(fruit.Name, "Fruit") then
            
            local distance = (humanoidRootPart.Position - fruit.Position).Magnitude
            if distance < 100 then
                humanoidRootPart.CFrame = fruit.CFrame
                fireclickdetector(fruit:FindFirstChildOfClass("ClickDetector"))
                print("🍎 FRUIT SNIPED: " .. fruit.Name)
            end
        end
    end
end

-- 🚀 TELEPORTES PRINCIPAIS (King Legacy Ilhas)
local Teleports = {
    ["Spawn"] = CFrame.new(0, 100, 0),
    ["Marine HQ"] = CFrame.new(-2850, 20, 2155),
    ["Middle Town"] = CFrame.new(-652, 73, 391),
    ["Underwater City"] = CFrame.new(11293, 100, 4352),
    ["Prison"] = CFrame.new(4847, 717, 404),
    ["Colosseum"] = CFrame.new(-1500, 100, 250),
    ["Sky Island"] = CFrame.new(-7900, 5600, 100),
    ["Sea 2"] = CFrame.new(-5110, 100, -100),
    ["Sea 3"] = CFrame.new(2680, 4300, -1400)
}

local function teleportTo(place)
    if Teleports[place] then
        humanoidRootPart.CFrame = Teleports[place]
        print("🚀 Teleportado para " .. place)
    end
end

-- Botões da GUI
createButton("🎮 Toggle AutoFarm", 60, function()
    Config.AutoFarm = not Config.AutoFarm
    print("AutoFarm: " .. tostring(Config.AutoFarm))
end)

createButton("📜 Auto Quest", 105, function() getQuest() end)
createButton("📈 Max Stats", 150, function() autoStats() end)
createButton("🍎 Fruit Sniper ON", 195, function()
    Config.FruitSniper = not Config.FruitSniper
end)

createButton("🏝️ Marine HQ", 240, function() teleportTo("Marine HQ") end)
createButton("🏰 Sky Island", 285, function() teleportTo("Sky Island") end)

-- 🔄 LOOP PRINCIPAL (MELHORADO)
spawn(function()
    while wait(0.3) do
        pcall(function()
            if character and humanoidRootPart then
                getQuest()
                farmEnemies()
                fruitSniper()
                autoStats()
            end
        end)
    end
end)

-- 💤 Anti-AFK
spawn(function()
    while wait(60) do
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
    end
end)

print("🚀 KING LEGACY ULTIMATE HUB CARREGADO!")
print("🎮 GUI aberta - Arraste e use os botões!")
print("Config.AutoFarm = true/false para toggle")
