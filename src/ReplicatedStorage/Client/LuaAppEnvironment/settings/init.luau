local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FFlags = require(script:WaitForChild("FFlags"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local RequestedFFlags = {}
local IsDebug = Config.DEBUG

if IsDebug then
    _G.DumpFFlagNames = function()
        return RequestedFFlags
    end
end

return {
    ["settings"] = function()
        return {
            ["GetFFlag"] = function(self, Name: string)
                if IsDebug then
                    RequestedFFlags[Name] = true
                end

                for _, Type: string in {"FFlag", "DFFlag"} do
                    if FFlags[Type..Name] ~= nil then
                        return FFlags[Type..Name]
                    end
                end
                
                if IsDebug then
                    warn("Missing FFlag", Name)
                end

                return false
            end,
            ["GetFVariable"] = function(self, Name: string)
                if IsDebug then
                    RequestedFFlags[Name] = true
                end

                for _, Type: string in {"FInt", "FString", "DFInt", "DFString"} do
                    if FFlags[Type..Name] ~= nil then
                        return FFlags[Type..Name]
                    end
                end

                if IsDebug then
                    warn("Missing FVariable", Name)
                end

                return 0
            end,
            ["Rendering"] = {
                ["QualityLevel"] = 1
            }
        }
    end,
    ["UserSettings"] = function()
        return {
            ["GameSettings"] = {
                ["InStudioMode"] = function(self)
                    return RunService:IsStudio()
                end
            }
        }
    end
}