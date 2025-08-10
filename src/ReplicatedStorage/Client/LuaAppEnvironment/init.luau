local FakeGame = require(script:WaitForChild("game"))
local settings = require(script:WaitForChild("settings"))

local Environment = {
    ["Environment"] = {
        ["game"] = FakeGame,
        ["Game"] = FakeGame,
        ["settings"] = settings.settings,
        ["UserSettings"] = settings.UserSettings
    }
}

--[[
Replace items in the environment the LuaApp modules use
Planned usage:
_G.Env(getfenv())

Definition:
_G.Env = function(Env)
    Environment:Apply(Env)
end
]] 

function Environment:Apply(Env: {[string]: any})
    for Name, Value in Environment.Environment do
        Env[Name] = Value
    end
end

return Environment