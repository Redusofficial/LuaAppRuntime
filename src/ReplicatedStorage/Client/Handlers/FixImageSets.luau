--!nocheck
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = require(ReplicatedStorage:WaitForChild("assets"))

return function(Environment)
    local CoreGui: CoreGui = Environment.game:GetService("CoreGui")

    CoreGui.DescendantAdded:Connect(function(Descendant: Instance)
		for _, Item: ImageLabel | ImageButton in Descendant:GetDescendants() do
			if not Item:IsA("ImageLabel") and not Item:IsA("ImageButton") then
                continue
            end 

			if Item.Image:sub(1, 32) ~= "rbxasset://textures/ui/ImageSet/" then
                continue
			end

            Item.Image = Assets[Item.Image:sub(33)]
        end
    end)
end