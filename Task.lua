-- 🔥 KING LEGACY HUB FIX 2026 - Teste Delta 🔥
-- Limpo, sem erros nil, GUI simples removida pra teste rápido

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

getgenv().Config = {
    AutoFarm = true,
    AutoStats = true,
    FruitSniper = true,
    MasterEnabled = true,
    FarmRange = 150
}

local function safeFire(remoteName, ...)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        end
    end)
end

-- Auto Farm
spawn(function()
    while true do
        if getgenv().Config.AutoFarm and getgenv().Config.MasterEnabled then
            pcall(function()
                for _, enemy in pairs(Workspace:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if dist < getgenv().Config.FarmRange then
                            hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            VirtualUser:ClickButton1(Vector2.new())
                        end
                    end
                end
            end)
        end
        wait(0.15)
    end
end)

-- Auto Stats
spawn(function()
    while wait(8) do
        if getgenv().Config.AutoStats and getgenv().Config.MasterEnabled then
            safeFire("Stats", "Melee", 3000)
            safeFire("Stats", "Defense", 3000)
            safeFire("RebirthStats", "Melee", 3000)
        end
    end
end)

-- Fruit Sniper
spawn(function()
    while wait(1) do
        if getgenv().Config.FruitSniper and getgenv().Config.MasterEnabled then
            pcall(function()
                for _, item in pairs(Workspace:GetChildren()) do
                    if item.Name:find("Fruit") and item:FindFirstChild("Handle") then
                        hrp.CFrame = item.Handle.CFrame + Vector3.new(0, 10, 0)
                    end
                end
            end)
        end
    end
end)

-- Anti-AFK
spawn(function()
    while wait(120) do
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
        end)
    end
end)

-- Toggle Master com F1
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        getgenv().Config.MasterEnabled = not getgenv().Config.MasterEnabled
        print("MASTER: " .. (getgenv().Config.MasterEnabled and "ON" or "OFF"))
        game.StarterGui:SetCore("SendNotification", {
            Title = "Master Toggle",
            Text = getgenv().Config.MasterEnabled and "Tudo ATIVADO!" or "Tudo PAUSADO!",
            Duration = 3
        })
    end
end)

print("HUB TESTE CARREGADO! F1 pra pausar tudo.")
game.StarterGui:SetCore("SendNotification", {
    Title = "Minato Hub Teste",
    Text = "Auto Farm/Stats/Fruit ON! F1 toggle.",
    Duration = 8
})
