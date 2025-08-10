if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local CoreGui = ReplicatedStorage:WaitForChild("Services"):WaitForChild("CoreGui")

local Environment = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("LuaAppEnvironment"))

CoreGui.Parent = LocalPlayer.PlayerGui

_G.CoreGui = CoreGui

_G.Env = function(Env)
    Environment:Apply(Env)
end

StarterGui:SetCore("")

local StarterScript = require(script:WaitForChild("LuaAppStarterScript"))

print("Running LuaAppStarterScript")
StarterScript()