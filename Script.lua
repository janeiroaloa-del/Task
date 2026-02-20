-- Script Auto Farm Básico para King Legacy (Do Zero - 2026)
-- Autor: Grok (baseado em APIs comuns do jogo)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configs
local FARM_RANGE = 50  -- Distância para detectar mobs
local AUTO_STATS = true  -- Auto up stats (melee, defense, etc.)

-- Função para pegar quests (exemplo genérico - ajuste se mudar)
local function getQuest()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local questRemote = remotes:FindFirstChild("Quest") or remotes:FindFirstChild("CommF_Quest")  -- Nomes comuns
        if questRemote and questRemote:IsA("RemoteEvent") then
            questRemote:FireServer("StartQuest")  -- Inicia quest
        end
    end
end

-- Função para atacar mobs
local function farmMobs()
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < FARM_RANGE then
                -- Teleporta para o mob
                humanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                -- Ataca (usa tool ou skill)
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())  -- Clique auto
                wait(0.1)
            end
        end
    end
end

-- Auto Stats (distribui pontos)
local function autoStats()
    if AUTO_STATS then
        local statsRemote = ReplicatedStorage.Remotes:FindFirstChild("Stats")
        if statsRemote then
            statsRemote:FireServer("Melee", 100)  -- Exemplo: +100 Melee (ajuste valores)
            statsRemote:FireServer("Defense", 100)
            -- Adicione mais: Sword, Gun, Demon Fruit
        end
    end
end

-- Loop principal
spawn(function()
    while true do
        pcall(function()  -- Evita crashes
            getQuest()
            farmMobs()
            autoStats()
        end)
        wait(0.5)  -- Delay para não lagar
    end
end)

print("Script Auto Farm King Legacy carregado! Level up rápido! 🚀")
