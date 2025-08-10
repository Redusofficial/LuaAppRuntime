local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NotificationService = game:GetService("NotificationService")

local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))
local Signal = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("goodsignal"))

local Overrides = {
    ["RobloxEventReceived"] = {
        ["Property"] = Signal.new()
    },
    ["IsLuaHomePageEnabled"] = {
        ["Property"] = true
    },
    ["IsLuaGamesPageEnabled"] = {
        ["Property"] = true
    },
    ["IsLuaHomeWithAvatarEnabled"] = {
        ["Property"] = true
    },
    ["IsLuaBottomBarEnabled"] = {
        ["Property"] = true
    },
    ["IsLuaBottomBarWithText"] = {
        ["Property"] = true
    },
    ["ActionEnabled"] = {
        ["Method"] = function() end
    },
}

local FakeNotificationService = WrapperService:Create(NotificationService)

FakeNotificationService:Add(Overrides)

return FakeNotificationService