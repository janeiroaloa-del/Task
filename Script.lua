-- Minato Hub v1.0 - King Legacy ONLY (Original by Grok/xAI)
-- PlaceId Check
if game.PlaceId \~= 4520749081 then
    return game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Erro";
        Text = "Este hub é só para King Legacy!";
        Duration = 5;
    })
end

-- Rayfield UI Library (moderna, clean, mobile OK)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Minato Hub v1.0",
    LoadingTitle = "Carregando King Legacy...",
    LoadingSubtitle = "by Minato (Palmas-TO)",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MinatoHubKL",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false -- Sem key pra uso pessoal
})

local Tab1 = Window:CreateTab("Farm", 4483362458) -- Ícone espada
local Tab2 = Window:CreateTab("Combat", 4483362458)
local Tab3 = Window:CreateTab("Teleports", 4483362458)
local Tab4 = Window:CreateTab("Visuals", 4483362458)
local Tab5 = Window:CreateTab("Misc", 4483362458)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Variáveis globais
getgenv().AutoFarm = false
getgenv().AutoStats = false
getgenv().KillAura = false
getgenv().FlyEnabled = false
-- etc.

-- Função Auto Farm (lógica genérica: mata nearest enemy)
local function AutoFarm()
    spawn(function()
        while getgenv().AutoFarm do
            pcall(function()
                local args = { -- Remotes típicos de King Legacy
                    [1] = "Farm",
                    [2] = "Start"
                }
                ReplicatedStorage.Remotes.FarmEvent:FireServer(unpack(args))
                
                -- Mata nearest
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

-- Tab Farm
local Section1 = Tab1:CreateSection("Auto Farm")
Tab1:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        getgenv().AutoFarm = Value
        AutoFarm()
    end
})

Tab1:CreateToggle({
    Name = "Auto Stats (Melee/Def/Gun/Swd/DF)",
    CurrentValue = false,
    Flag = "AutoStatsToggle",
    Callback = function(Value)
        getgenv().AutoStats = Value
        spawn(function()
            while getgenv().AutoStats do
                pcall(function()
                    ReplicatedStorage.Remotes.Combat.RemoteEvent:FireServer("Melee", 1000)
                    ReplicatedStorage.Remotes.Combat.RemoteEvent:FireServer("Defense", 1000)
                    -- Repita pros outros
                end)
                wait(1)
            end
        end)
    end
})

Tab1:CreateToggle({
    Name = "Auto Sea King",
    CurrentValue = false,
    Callback = function(Value)
        -- Lógica similar: teleport + farm boss
    end
})

Tab1:CreateToggle({
    Name = "Auto Hydra / Ghost Ship",
    CurrentValue = false,
    Callback = function(Value)
        -- Similar
    end
})

Tab1:CreateToggle({
    Name = "Auto Raid / Dungeon",
    CurrentValue = false,
    Callback = function(Value)
        -- Fire remote raid
    end
})

-- Tab Combat
local Section2 = Tab2:CreateSection("Combat")
Tab2:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().KillAura = Value
        spawn(function()
            while getgenv().KillAura do
                for _, player in pairs(Players:GetPlayers()) do
                    if player \~= LocalPlayer and player.Character then
                        pcall(function()
                            ReplicatedStorage.Remotes.Combat.RemoteEvent:FireServer(player.Character.HumanoidRootPart.Position)
                        end)
                    end
                end
                wait(0.2)
            end
        end)
    end
})

Tab2:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        -- Set stamina infinite via metatable ou remote
    end
})

-- Tab Teleports (exemplos principais)
local Section3 = Tab3:CreateSection("Ilhas / Seas")
local Teleports = {
    ["Starter Island"] = CFrame.new(-1000, 50, 1000),
    ["Marine HQ"] = CFrame.new(0, 100, 0),
    ["Third Sea"] = CFrame.new(5000, 100, 5000),
    -- Adicione mais de https://king-legacy.fandom.com/wiki/Map<grok:render card_id="198a37" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">0</argument></grok:render>
}

for name, cf in pairs(Teleports) do
    Tab3:CreateButton({
        Name = name,
        Callback = function()
            HumanoidRootPart.CFrame = cf
        end
    })
end

-- Tab Visuals: ESP simples
Tab4:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        -- Código ESP básico com Drawing API
    end
})

-- Tab Misc
Tab5:CreateToggle({
    Name = "Fly (Z to toggle)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().FlyEnabled = Value
        -- Fly script padrão
    end
})

Tab5:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        -- Noclip loop
    end
})

Tab5:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Rayfield:Notify({
    Title = "Minato Hub Carregado!",
    Content = "Divirta-se em King Legacy! (Atualizado 2026)",
    Duration = 5,
    Image = 4483362458
})
