local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

getgenv().Config = {
    AutoFarm = false,
    AutoQuest = false,
    AutoStats = false,
    FruitSniper = false,
    AutoBoss = false,
    AutoHydra = false,
    AutoSeaKing = false,
    AutoGhostShip = false,
    FarmRange = 150,
    StatsMode = "Melee"  -- Mude pra Defense/Gun/etc. se quiser
}

getgenv().masterEnabled = true

local function safeWait(time)
    wait(time or 0.1)
end

local function safeFire(remoteName, ...)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        end
    end)
end

-- GUI Simples e Limpa
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0

local posY = 10  -- Posição inicial pros botões

local function createToggleButton(name, height, stateKey, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham

    btn.MouseButton1Click:Connect(function()
        getgenv().Config[stateKey] = not getgenv().Config[stateKey]
        btn.Text = name .. ": " .. (getgenv().Config[stateKey] and "ON" or "OFF")
        btn.BackgroundColor3 = getgenv().Config[stateKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 80)
        if callback then callback() end
    end)

    posY = posY + height + 10
    return btn
end

local function createTPButton(name, height, cframe)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            hrp.CFrame = cframe
            game.StarterGui:SetCore("SendNotification", {Title = "Teleportado!", Text = name, Duration = 2})
        end)
    end)

    posY = posY + height + 10
    return btn
end

-- Criando botões (agora em ordem)
createToggleButton("Auto Farm", 50, "AutoFarm")
createToggleButton("Auto Quest", 50, "AutoQuest")
createToggleButton("Auto Stats", 50, "AutoStats")
createToggleButton("Fruit Sniper", 50, "FruitSniper")
createToggleButton("Auto Boss", 50, "AutoBoss")
createToggleButton("Auto Hydra", 50, "AutoHydra")
createToggleButton("Auto Sea King", 50, "AutoSeaKing")
createToggleButton("Auto Ghost Ship", 50, "AutoGhostShip")

createTPButton("Marine HQ", 50, CFrame.new(-2850, 20, 2155))
createTPButton("Prison", 50, CFrame.new(4847, 717, 404))
createTPButton("Sky Island", 50, CFrame.new(-7900, 5600, 100))
createTPButton("Sea 3", 50, CFrame.new(2680, 4300, -1400))

-- Botão Master Toggle
local masterToggle = Instance.new("TextButton")
masterToggle.Parent = MainFrame
masterToggle.Size = UDim2.new(0.9, 0, 0, 50)
masterToggle.Position = UDim2.new(0.05, 0, 0, posY + 10)
masterToggle.Text = "MASTER (ON/OFF TUDO)"
masterToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
masterToggle.TextScaled = true
masterToggle.Font = Enum.Font.GothamBold

masterToggle.MouseButton1Click:Connect(function()
    getgenv().masterEnabled = not getgenv().masterEnabled
    masterToggle.Text = "MASTER: " .. (getgenv().masterEnabled and "ON" or "OFF")
    masterToggle.BackgroundColor3 = getgenv().masterEnabled and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(100, 100, 100)
end)

ScreenGui.Parent = player.PlayerGui

-- Funções (todas integradas)
local function autoFarm()
    if not getgenv().Config.AutoFarm or not getgenv().masterEnabled then return end
    pcall(function()
        for _, enemy in pairs(Workspace:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local name = enemy.Name:lower()
                if name:find("bandit") or name:find("gorilla") or name:find("marine") or name:find("boss") or name:find("enemy") then
                    local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < getgenv().Config.FarmRange then
                        hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, -3)
                        VirtualUser:ClickButton1(Vector2.new())
                        humanoid:MoveTo(enemy.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end)
end

local function autoQuest()
    if not getgenv().Config.AutoQuest or not getgenv().masterEnabled then return end
    pcall(function()
        safeFire("Quest", "StartQuest")
        safeFire("CommF_Quest", "Start")
        safeFire("GetQuest", "BartiloQuest", "Start")
    end)
end

local function autoStats()
    if not getgenv().Config.AutoStats or not getgenv().masterEnabled then return end
    pcall(function()
        safeFire("Stats", getgenv().Config.StatsMode, 3000)
        safeFire("RebirthStats", getgenv().Config.StatsMode, 3000)
    end)
end

local function fruitSniper()
    if not getgenv().Config.FruitSniper or not getgenv().masterEnabled then return end
    pcall(function()
        for _, fruit in pairs(Workspace:GetChildren()) do
            if fruit.Name:find("Fruit") or fruit.Name:find("Leopard") or fruit.Name:find("Dough") or fruit.Name:find("Magu") then
                if fruit:FindFirstChild("Handle") then
                    local dist = (hrp.Position - fruit.Handle.Position).Magnitude
                    if dist < 100 then
                        hrp.CFrame = fruit.Handle.CFrame
                        local click = fruit:FindFirstChildOfClass("ClickDetector")
                        if click then fireclickdetector(click) end
                    end
                end
            end
        end
    end)
end

local function autoBoss()
    if not getgenv().Config.AutoBoss or not getgenv().masterEnabled then return end
    pcall(function()
        for _, boss in pairs(Workspace:GetChildren()) do
            if boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                VirtualUser:ClickButton1(Vector2.new())
            end
        end
    end)
end

local function autoSeaEvents()
    if not getgenv().masterEnabled then return end
    pcall(function()
        for _, obj in pairs(Workspace:GetChildren()) do
            if getgenv().Config.AutoHydra and obj.Name:find("Hydra") then
                hrp.CFrame = obj.CFrame
            elseif getgenv().Config.AutoSeaKing and obj.Name:find("Sea King") then
                hrp.CFrame = obj.CFrame
            elseif getgenv().Config.AutoGhostShip and obj.Name:find("Ghost Ship") then
                hrp.CFrame = obj.CFrame
            end
        end
    end)
end

-- Loop Principal
spawn(function()
    while true do
        pcall(function()
            safeWait()
            autoFarm()
            autoQuest()
            autoStats()
            fruitSniper()
            autoBoss()
            autoSeaEvents()
        end)
        wait(0.2)
    end
end)

-- Anti-AFK
spawn(function()
    while true do
        safeWait(120)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, "W", false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
        end)
    end
end)

-- F1 Toggle Master
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        getgenv().masterEnabled = not getgenv().masterEnabled
        print("MASTER: " .. (getgenv().masterEnabled and "ON" or "OFF"))
        game.StarterGui:SetCore("SendNotification", {Title = "Master Toggle", Text = getgenv().masterEnabled and "Tudo ON!" or "Tudo OFF!", Duration = 3})
    end
end)

print("SCRIPT FINAL CARREGADO! Sem erros.")
game.StarterGui:SetCore("SendNotification", {
    Title = "Minato Hub Pronto!",
    Text = "GUI aberta - Use toggles e F1!",
    Duration = 5
})
