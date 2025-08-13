--!nocheck
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = require(ReplicatedStorage:WaitForChild("assets"))

return function(Environment)
    local CoreGui: CoreGui = Environment.game:GetService("CoreGui")

    local function SetIgnoreGuiInset()
		for _, Item: ScreenGui in CoreGui:GetDescendants() do
            if Item:IsA("ScreenGui") then
                Item.IgnoreGuiInset = true
            end
        end
    end

    CoreGui.DescendantAdded:Connect(SetIgnoreGuiInset)
end