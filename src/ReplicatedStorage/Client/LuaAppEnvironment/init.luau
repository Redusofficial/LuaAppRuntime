local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FakeGame = require(script:WaitForChild("game"))
local settings = require(script:WaitForChild("settings"))
local Config = require(ReplicatedStorage:WaitForChild("Config"))

local Environment = {
    ["Environment"] = {
        ["game"] = FakeGame,
        ["Game"] = FakeGame,
        ["settings"] = settings.settings,
        ["UserSettings"] = settings.UserSettings,
        ["pcall"] = function(Function: (any) -> (any), ...: any)
			local Success, Return = pcall(Function, ...)
			
			if not Success and Config.DEBUG then
				warn(debug.traceback(Return, 2))
			end
			
			return Success, Return
		end
    }
}

--[[
Replace items in the environment the LuaApp modules use
Usage:
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