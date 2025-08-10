local FFlags = require(script.FFlags)
local RunService = game:GetService("RunService")

return {
    ["settings"] = function()
        return {
            ["GetFFlag"] = function(self, Name: string)
                if not FFlags["FFlag"..Name] then
                    warn("Missing FFlag", "FFlag"..Name)

                    return nil
                end

                return FFlags["FFlag"..Name]
            end,
            ["GetFVariable"] = function(self, Name: string)
                if not FFlags["FString"..Name] then
                    warn("Missing FString", "FString"..Name)

                    return nil
                end
                
                return FFlags["FString"..Name]
            end
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