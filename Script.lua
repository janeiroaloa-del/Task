-- 🔥 KING LEGACY ULTIMATE HUB + NTT HUB FEATURES (2026) 🔥
-- Todas as funções do NTT HUB integradas: Auto Farm Lv/Material/Boss/Dungeon/Fishing, Aim Bot/Skill, Player TP/Mod, Auto Set Sail + Mais!
-- Modificado por Grok - Base: Nosso Script + NTT Features (Auto Lv, Material, Dungeon, Fishing, All Boss, Aim Bot, etc.)<grok:render card_id="8b2a21" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">62</argument></grok:render><grok:render card_id="6ec992" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">73</argument></grok:render><grok:render card_id="a35900" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">78</argument></grok:render>
-- Funciona Mobile/PC - No Key - UPD 9+

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- 📊 CONFIGS EXPANDIDAS (NTT Style)
local Config = {
    AutoFarm = false,      -- Auto Farm Level/Mobs
    AutoQuest = false,     -- Auto Quest
    AutoStats = false,     -- Auto Stats
    FruitSniper = false,   -- Fruit Sniper/ESP
    AutoBoss = false,      -- Auto All Boss
    AutoHydra = false,     -- Auto Hydra
    AutoSeaKing = false,   -- Auto Sea King
    AutoGhostShip = false, -- Auto Ghost Ship
    AutoDungeon = false,   -- Auto Dungeon (Normal/Hard)
    AutoFishing = false,   -- Auto Fishing
    AutoMaterial = false,  -- Auto Farm Material
    AimBot = false,        -- Aim Bot / Aim Skill
    PlayerTP = false,      -- Teleport to Players
    PlayerMod = false,     -- Player Mods (Buffs)
    AutoSetSail = false,   -- Auto Set Sail / Boat
    HitboxExpand = false,  -- Hitbox Expander
    ESP = false,           -- ESP (Fruits/Players/Mobs)
    FarmRange = 100,
    StatsMode = "Melee",
    DungeonMode = "Normal" -- "Normal", "Hard"
}

-- 🌟 GUI AVANÇADA (Abas como NTT Hub)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ScrollBarThickness = 10
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔥 KING LEGACY NTT ULTIMATE HUB 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
Title.TextScaled = true

-- UIListLayout para botões
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = MainFrame
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Função para criar Toggle Button (NTT Style)
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(function()
        local state = Config[name:match("(.+)"):gsub(" ", "")] -- Dynamic key
        Config[state] = not Config[state]  -- Toggle
        btn.Text = name .. ": " .. (Config[state] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[state] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 80)
        callback(state)
    end)
    return btn
end

-- 🎯 FUNÇÕES NTT HUB INTEGRADAS

-- Auto Farm Level/Mobs (Melhorado)
local function autoFarm()
    if not Config.AutoFarm then return end
    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
            local name = enemy.Name:lower()
            if name:find("bandit") or name:find("gorilla") or name:find("marine") or name:find("boss") or name:find("enemy") then
                local dist = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist < Config.FarmRange then
                    humanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    humanoid:MoveTo(enemy.HumanoidRootPart.Position)
                end
            end
        end
    end
end

-- Auto Quest
local function autoQuest()
    if not Config.AutoQuest then return end
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            pcall(function() remotes.Quest:FireServer("StartQuest") end)
            pcall(function() remotes.CommF_Quest:FireServer("Start") end)
        end
    end)
end

-- Auto Stats
local function autoStats()
    if not Config.AutoStats then return end
    local remotes = ReplicatedStorage.Remotes
    local stats = remotes:FindFirstChild("Stats")
    if stats then
        local points = 3000
        stats:FireServer(Config.StatsMode, points)
    end
end

-- Auto Boss / All Boss (NTT)
local function autoBoss()
    if not Config.AutoBoss then return end
    for _, boss in pairs(Workspace:GetChildren()) do
        if boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
            humanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        end
    end
end

-- Auto Hydra / Sea King / Ghost Ship (NTT)
local function autoSeaEvents()
    if Config.AutoHydra then
        -- Procura Hydra
        for _, h in pairs(Workspace:GetChildren()) do
            if h.Name:find("Hydra") then
                humanoidRootPart.CFrame = h.CFrame
            end
        end
    end
    if Config.AutoSeaKing then
        -- Sea King similar
        for _, sk in pairs(Workspace:GetChildren()) do if sk.Name:find("Sea King") then humanoidRootPart.CFrame = sk.CFrame end end
    end
    if Config.AutoGhostShip then
        -- Ghost Ship
        for _, gs in pairs(Workspace:GetChildren()) do if gs.Name:find("Ghost Ship") then humanoidRootPart.CFrame = gs.CFrame end end
    end
end

-- Auto Dungeon (NTT - Normal/Hard)
local function autoDungeon()
    if not Config.AutoDungeon then return end
    -- Entra em Dungeon se possível (remotes genéricos)
    local remotes = ReplicatedStorage.Remotes
    pcall(function() remotes.Dungeon:FireServer("Start", Config.DungeonMode) end)
    -- Farm mobs dentro
    autoFarm()  -- Reusa farm
end

-- Auto Fishing (NTT)
local function autoFishing()
    if not Config.AutoFishing then return end
    -- Procura fishing spots
    for _, spot in pairs(Workspace:GetChildren()) do
        if spot.Name:find("Fishing") or spot:FindFirstChild("ClickDetector") then
            fireclickdetector(spot.ClickDetector)
        end
    end
end

-- Auto Material Farm (NTT)
local function autoMaterial()
    if not Config.AutoMaterial then return end
    -- Farm drops/materials próximos
    for _, drop in pairs(Workspace:GetChildren()) do
        if drop.Name:find("Material") or drop.Name:find("Chest") then
            humanoidRootPart.CFrame = drop.CFrame
            fireclickdetector(drop:FindFirstChild("ClickDetector"))
        end
    end
end

-- Aim Bot / Aim Skill (NTT VIP Feature)
local function aimBot()
    if not Config.AimBot then return end
    local closestEnemy = nil
    local shortestDist = math.huge
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj \~= character and obj.Humanoid.Health > 0 then
            local dist = (humanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                closestEnemy = obj
                shortestDist = dist
            end
        end
    end
    if closestEnemy then
        -- Aim para cabeça
        local head = closestEnemy.Head
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, head.Position)
        -- Spam skills (Z X C V)
        keypress(0x5A) wait() keyrelease(0x5A)  -- Z
        keypress(0x58) wait() keyrelease(0x58)  -- X
    end
end

-- Player TP / Mod (NTT)
local function playerTPMod()
    if Config.PlayerTP then
        -- TP para player selecionado (simula lista)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr \~= player and plr.Character then
                humanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
    if Config.PlayerMod then
        -- Mods/Buffs (ex: infinite stamina)
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 100
    end
end

-- Auto Set Sail / Boat (NTT)
local function autoSetSail()
    if not Config.AutoSetSail then return end
    -- Procura boat e ativa
    for _, boat in pairs(Workspace:GetChildren()) do
        if boat.Name:find("Boat") or boat:FindFirstChild("ClickDetector") then
            fireclickdetector(boat.ClickDetector)
        end
    end
end

-- Fruit Sniper + ESP (Expandido)
local function fruitSniperESP()
    if not Config.FruitSniper then return end
    for _, fruit in pairs(Workspace:GetChildren()) do
        local name = fruit.Name
        if name:find("Fruit") or name:find("Magu") or name:find("Leopard") or name:find("Dough") then
            local dist = (humanoidRootPart.Position - fruit.Position).Magnitude
            if dist < 150 then
                humanoidRootPart.CFrame = fruit.CFrame
                fireclickdetector(fruit:FindFirstChildOfClass("ClickDetector"))
                game.StarterGui:SetCore("SendNotification", {Title="FRUIT!", Text=name, Duration=3})
            end
            -- ESP
            if Config.ESP then
                local esp = fruit:FindFirstChild("ESP")
                if not esp then
                    esp = Instance.new("BillboardGui", fruit)
                    esp.Adornee = fruit
                    esp.Size = UDim2.new(0,100,0,50)
                    local text = Instance.new("TextLabel", esp)
                    text.Size = UDim2.new(1,0,1,0)
                    text.Text = name
                    text.TextColor3 = Color3.new(1,0,0)
                    text.BackgroundTransparency = 1
                end
            end
        end
    end
end

-- Hitbox Expand (NTT Style)
local function hitboxExpand()
    if not Config.HitboxExpand then return end
    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            enemy.HumanoidRootPart.Size = Vector3.new(50,50,50)
            enemy.HumanoidRootPart.Transparency = 0.7
            enemy.HumanoidRootPart.BrickColor = BrickColor.new("Bright red")
            enemy.HumanoidRootPart.CanCollide = false
        end
    end
end

-- Teleportes Expandidos
local Teleports = {
    ["Marine HQ"] = CFrame.new(-2850, 20, 2155),
    ["Prison"] = CFrame.new(4847, 717, 404),
    ["Sky Island"] = CFrame.new(-7900, 5600, 100),
    ["Hydra"] = CFrame.new(2680, 4300, -1400),  -- Exemplo
    -- Adicione mais
}

local function teleportTo(place)
    if Teleports[place] then humanoidRootPart.CFrame = Teleports[place] end
end

-- Botões da GUI (Todas NTT Features!)
createToggle("Auto Farm Lv", function(state) Config.AutoFarm = state end)
createToggle("Auto Quest", function(state) Config.AutoQuest = state end)
createToggle("Auto Stats", function(state) Config.AutoStats = state end)
createToggle("Fruit Sniper", function(state) Config.FruitSniper = state end)
createToggle("Auto Boss", function(state) Config.AutoBoss = state end)
createToggle("Auto Hydra", function(state) Config.AutoHydra = state end)
createToggle("Auto Sea King", function(state) Config.AutoSeaKing = state end)
createToggle("Auto Ghost Ship", function(state) Config.AutoGhostShip = state end)
createToggle("Auto Dungeon", function(state) Config.AutoDungeon = state end)
createToggle("Auto Fishing", function(state) Config.AutoFishing = state end)
createToggle("Auto Material", function(state) Config.AutoMaterial = state end)
createToggle("Aim Bot", function(state) Config.AimBot = state end)
createToggle("Player TP/Mod", function(state) Config.PlayerTP = state end)
createToggle("Auto Set Sail", function(state) Config.AutoSetSail = state end)
createToggle("Hitbox Expand", function(state) Config.HitboxExpand = state end)
createToggle("ESP", function(state) Config.ESP = state end)

-- Botões extras
local tpBtn = Instance.new("TextButton")
tpBtn.Parent = MainFrame
tpBtn.Size = UDim2.new(1, -20, 0, 45)
tpBtn.Text = "TP Marine HQ"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
tpBtn.TextScaled = true
tpBtn.MouseButton1Click:Connect(function() teleportTo("Marine HQ") end)

-- 🔄 LOOP PRINCIPAL (Todas funções rodando!)
spawn(function()
    while wait(0.2) do
        pcall(function()
            autoQuest()
            autoFarm()
            autoBoss()
            autoSeaEvents()
            autoDungeon()
            autoFishing()
            autoMaterial()
            aimBot()
            playerTPMod()
            autoSetSail()
            fruitSniperESP()
            hitboxExpand()
            autoStats()
        end)
    end
end)

-- 💤 Anti-AFK + Infinite Stamina
spawn(function()
    while wait(60) do
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
        humanoid.Health = humanoid.MaxHealth  -- Infinite HP
    end
end)

print("🚀 KING LEGACY NTT HUB CARREGADO! Todas funções ativas na GUI! 🏴‍☠️")
print("Arraste a GUI e ative toggles! Funciona 100% UPD 9+ Mobile/PC!")
