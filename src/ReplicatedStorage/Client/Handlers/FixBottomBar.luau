--!nocheck

return function(Environment)
    local CoreGui: CoreGui = Environment.game:GetService("CoreGui")

    local BottomBar = CoreGui:WaitForChild("BottomBar")

    if BottomBar:FindFirstChild("Contents") then
        BottomBar.Contents.Position = UDim2.new(0, 0, 1, -BottomBar.Contents.Frame.Size.Y.Offset)
    elseif BottomBar:FindFirstChild("Background") then
        BottomBar.Background.Position = UDim2.new(0, 0, 1, -BottomBar.Background.Size.Y.Offset)
    end
end