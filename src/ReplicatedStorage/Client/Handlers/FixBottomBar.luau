return function(Environment)
    local CoreGui: CoreGui = Environment.game:GetService("CoreGui")

    local BottomBar = CoreGui:WaitForChild("BottomBar")

    local Contents: Frame = BottomBar:WaitForChild("Contents")

    Contents.Position = UDim2.new(0, 0, 1, -Contents.Frame.Size.Y.Offset)
end