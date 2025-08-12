local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))
local Signal = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("goodsignal"))

local Overrides = {
    ["BroadcastNotification"] = {
        ["Method"] = function(self, data: string, notificationType: number)
            if not Config.DEBUG then
                return
            end

            warn("GuiService:BroadcastNotification", data, notificationType)
        end
    },
    ["OpenNativeOverlay"] = {
        ["Method"] = function(self, title: string, url: string)
            if not Config.DEBUG then
                return
            end

            warn("GuiService:OpenNativeOverlay", title, url)
        end
    },
    ["GetResolutionScale"] = {
        ["Method"] = function()
            return 1
        end
    },
    ["IsTenFootInterface"] = {
        ["Method"] = function()
            return false
        end
    },
    ["GetSafeZoneOffsets"] = {
        ["Method"] = function()
            return {
                    ["bottom"] = 0,
                    ["left"] = 0,
                    ["right"] = 0,
                    ["top"] = 0
                }
        end
    },
    ["OpenBrowserWindow"] = {
        ["Method"] = function() end
    },
    ["AddSelectionParent"] = {
        ["Method"] = function() end
    },
    ["RemoveSelectionGroup"] = {
        ["Method"] = function() end
    },
    ["SetSafeZoneOffsets"] = {
        ["Method"] = function() end
    },
    ["SetGlobalGuiInset"] = {
        ["Method"] = function() end
    },
    ["ShowLeaveConfirmation"] = {
        ["Property"] = Signal.new()
    },
}

local FakeGuiService = WrapperService:Create(GuiService)

FakeGuiService:Add(Overrides)

return FakeGuiService