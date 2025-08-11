local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))

local Overrides = {
    ["GetUnder13"] = {
        ["Method"] = function()
            return true
        end
    }
}

local FakePlayers = WrapperService:Create(Players)

FakePlayers:Add(Overrides)

return FakePlayers