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
    },
    ["getService"] = {
        ["Method"] = function(self, Name: string)
            if script:FindFirstChild(Name) then
                return require(script:FindFirstChild(Name))
            end

            return game:GetService(Name)
        end
    },
    ["HttpPostAsync"] = {
        --["Method"] = function(self, url: string, data: string, contentType: string?, httpRequestType: Enum.HttpRequestType?)
        ["Method"] = function(self, ...)
            print(...)

            return nil
        end
    },
    ["HttpGetAsync"] = {
        --["Method"] = function(self, url: string, httpRequestType: Enum.HttpRequestType?)
        ["Method"] = function(self, ...)
            print(...)

            return nil
        end
    }
}

local FakeGame = WrapperService:Create(game)

FakeGame:Add(Overrides)

return FakeGame