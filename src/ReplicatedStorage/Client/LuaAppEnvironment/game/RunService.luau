local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))

local Overrides = {
    ["GetRobloxVersion"] = {
        ["Method"] = function(self)
            return Config.ROBLOX_VERSION or version()
        end
    },
    ["Set3dRenderingEnabled"] = {
        ["Method"] = function() end
    },
    ["setThrottleFramerateEnabled"] = {
        ["Method"] = function() end
    }
}

local FakeRunService = WrapperService:Create(RunService)

FakeRunService:Add(Overrides)

return FakeRunService