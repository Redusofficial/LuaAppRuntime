local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))
local PseudoHttp = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Services"):WaitForChild("PseudoHttp"))

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
        ["Method"] = function(self, url: string, data: string, contentType: string?, httpRequestType: Enum.HttpRequestType?)
        --["Method"] = function(self, ...)
            local ResultData = PseudoHttp:Execute("POST", url, {}, data)

            if ResultData.StatusCode == 200 then
                return ResultData.Body
            end

            return ""
        end
    },
    ["HttpGetAsync"] = {
        ["Method"] = function(self, url: string, httpRequestType: Enum.HttpRequestType?)
        --["Method"] = function(self, ...)
            local ResultData = PseudoHttp:Execute("GET", url, {}, "")

            if ResultData.StatusCode == 200 then
                return ResultData.Body
            end

            return ""
        end
    }
}

local FakeGame = WrapperService:Create(game)

FakeGame:Add(Overrides)

return FakeGame