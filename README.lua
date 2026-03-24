-- Existing content

local originalAutoRotate = false

-- Code to display "MANUS" above players' heads
local function displayTextAbovePlayers()
    for _, player in pairs(game.Players:GetPlayers()) do
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Adornee = player.Character and player.Character:FindFirstChild("Head")
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel", billboardGui)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Text = "MANUS"
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)

        billboardGui.Parent = player.Character.Head
    end
end

-- Call the display function in the heartbeat loop
game:GetService("RunService").Heartbeat:Connect(function()
    displayTextAbovePlayers() 
end)