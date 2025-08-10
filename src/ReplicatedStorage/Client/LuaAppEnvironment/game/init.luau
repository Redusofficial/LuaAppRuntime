local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))

local Overrides = {
    ["GetService"] = {
        ["Method"] = function(self, Name: string)
            if script:FindFirstChild(Name) then
                return require(script:FindFirstChild(Name))
            end

            return game:GetService(Name)
        end
    }
}

local FakeGame = WrapperService:Create(game)

FakeGame:Add(Overrides)

return FakeGame