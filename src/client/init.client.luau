if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local CoreGui = ReplicatedStorage:WaitForChild("Services"):WaitForChild("CoreGui")
local ScreenGuiV2 = ReplicatedStorage:WaitForChild("ScreenGuiV2")

local Environment = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("LuaAppEnvironment"))
local Handlers = ReplicatedStorage:WaitForChild("Client"):WaitForChild("Handlers")

CoreGui.Parent = LocalPlayer.PlayerGui
ScreenGuiV2.Parent = game:GetService("ServerStorage")

_G.CoreGui = CoreGui

_G.Env = function(Env)
    Environment:Apply(Env)
end

task.spawn(function()
    for i = 1, 25 do
        if pcall(function(...)
            for _, Type in {"TopbarEnabled", "ResetButtonCallback"} do
                StarterGui:SetCore(Type, false)
            end
        end) then
            break
        end
        
        task.wait(0.1)
    end
end)

local StarterScript = require(script:WaitForChild("LuaAppStarterScript"))

for _, Handler in Handlers:GetChildren() do
    task.spawn(require(Handler), Environment.Environment)
end

print("Running LuaAppStarterScript")
StarterScript()