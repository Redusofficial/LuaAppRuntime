local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))
local Signal = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("goodsignal"))

local StatusBarSize = Vector2.new(1280, 0)
local ChangedSignals = {
    ["StatusBarSize"] = Signal.new(),
    ["BottomBarSize"] = Signal.new(),
    ["RightBarSize"] = Signal.new(),
    ["NavBarSize"] = Signal.new(),
}

local Overrides = {
    ["GetPlatform"] = {
        ["Method"] = function(self)
            return Enum.Platform.Android
        end
    },
    ["GetPropertyChangedSignal"] = {
        ["Method"] = function(self, property: string)
            if ChangedSignals[property] then
                return ChangedSignals[property]
            end

            return UserInputService:GetPropertyChangedSignal(property)
        end
    },
    ["StatusBarSize"] = {
        ["Property"] = StatusBarSize -- Will making it 0, 0 break stuff?
    },
    ["BottomBarSize"] = {
        ["Property"] = StatusBarSize
    },
    ["RightBarSize"] = {
        ["Property"] = Vector2.new()
    },
    ["NavBarSize"] = {
        ["Property"] = Vector2.new(1280, 44) -- These values are recorded from 
    },
    ["StatusBarTapped"] = {
        ["Property"] = Signal.new()
    },
}

local FakeUserInputService = WrapperService:Create(UserInputService)

FakeUserInputService:Add(Overrides)

return FakeUserInputService