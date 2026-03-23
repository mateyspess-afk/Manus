--[[ 
   Script de Combat com Menu Minimizável e Som de Clique no Botão (-)
   Compatível com Delta Executor
   Desenvolvido por Manus AI
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configurações de Orbit
local ORBIT_DISTANCE = 10
local ORBIT_SPEED = 3
local ORBIT_HEIGHT = 2

-- Configurações de Passar Rápido
local DASH_SPEED = 15
local DASH_DISTANCE = 12
local DASH_HEIGHT = 2

local TARGET_NAME = ""
local ORBIT_ENABLED = false
local AIMBOT_CORPO = false
local DASH_PASS_ENABLED = false

local angle = 0
local dashTime = 0
local originalAutoRotate = true

-- Função para encontrar o alvo
local function getTarget()
    if TARGET_NAME ~= "" then
        local target = Players:FindFirstChild(TARGET_NAME)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            return target
        end
    end
    
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = p end
        end
    end
    return closest
end

-- Loop Principal (Heartbeat)
RunService.Heartbeat:Connect(function(dt)
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local target = getTarget()
    
    if (ORBIT_ENABLED or DASH_PASS_ENABLED) and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetHrp = target.Character.HumanoidRootPart
        local targetPos = targetHrp.Position
        
        if DASH_PASS_ENABLED then
            dashTime = dashTime + (DASH_SPEED * dt)
            local offsetMultiplier = math.sin(dashTime) * DASH_DISTANCE
            local direction = targetHrp.CFrame.LookVector
            local dashPos = targetPos + (direction * offsetMultiplier) + Vector3.new(0, DASH_HEIGHT, 0)
            hrp.CFrame = CFrame.new(dashPos, targetPos)
        elseif ORBIT_ENABLED then
            angle = angle + (ORBIT_SPEED * dt)
            local offset = Vector3.new(math.cos(angle) * ORBIT_DISTANCE, ORBIT_HEIGHT, math.sin(angle) * ORBIT_DISTANCE)
            local orbitPos = targetPos + offset
            
            if AIMBOT_CORPO then
                if humanoid.AutoRotate then originalAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
                hrp.CFrame = CFrame.new(orbitPos, targetPos)
            else
                if not humanoid.AutoRotate and not originalAutoRotate then humanoid.AutoRotate = originalAutoRotate end
                hrp.CFrame = CFrame.new(orbitPos) * hrp.CFrame.Rotation
            end
        end
    else
        if not humanoid.AutoRotate and not originalAutoRotate then
            humanoid.AutoRotate = originalAutoRotate
        end
    end
end)

-- Interface Gráfica (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ManusCombatSomGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 480)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "MANUS COMBAT V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame
Instance.new("UICorner").Parent = Title

-- Configuração do Som de Clique
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://12221967"
ClickSound.Volume = 0.5
ClickSound.Parent = game:GetService("SoundService")

-- Botão de Minimizar (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner").Parent = MinimizeBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local isMinimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 230, 0, 40), "Out", "Quart", 0.3, true)
        ContentFrame.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(originalSize, "Out", "Quart", 0.3, true)
        ContentFrame.Visible = true
        MinimizeBtn.Text = "-"
    end
end)

local function createBtn(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = ContentFrame
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local orbitBtn, dashBtn

orbitBtn = createBtn("ORBIT: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(180, 50, 50), function()
    ORBIT_ENABLED = not ORBIT_ENABLED
    DASH_PASS_ENABLED = false
    orbitBtn.Text = ORBIT_ENABLED and "ORBIT: ON" or "ORBIT: OFF"
    orbitBtn.BackgroundColor3 = ORBIT_ENABLED and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    dashBtn.Text = "PASSAR RÁPIDO: OFF"
    dashBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 180)
end)

dashBtn = createBtn("PASSAR RÁPIDO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(50, 50, 180), function()
    DASH_PASS_ENABLED = not DASH_PASS_ENABLED
    ORBIT_ENABLED = false
    dashBtn.Text = DASH_PASS_ENABLED and "PASSAR RÁPIDO: ON" or "PASSAR RÁPIDO: OFF"
    dashBtn.BackgroundColor3 = DASH_PASS_ENABLED and Color3.fromRGB(50, 180, 180) or Color3.fromRGB(50, 50, 180)
    orbitBtn.Text = "ORBIT: OFF"
    orbitBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
end)

local aimBtn = createBtn("AIMBOT CORPO: OFF", UDim2.new(0.05, 0, 0, 90), Color3.fromRGB(150, 100, 50), function()
    AIMBOT_CORPO = not AIMBOT_CORPO
    aimBtn.Text = AIMBOT_CORPO and "AIMBOT CORPO: ON" or "AIMBOT CORPO: OFF"
    aimBtn.BackgroundColor3 = AIMBOT_CORPO and Color3.fromRGB(50, 150, 200) or Color3.fromRGB(150, 100, 50)
end)

-- Título "OPÇÕES DO ORBIT" centralizado acima dos sliders do orbit
local OrbitTitle = Instance.new("TextLabel")
OrbitTitle.Size = UDim2.new(0.9, 0, 0, 20)
OrbitTitle.Position = UDim2.new(0.05, 0, 0, 215) -- Posicionado acima do "Orbit: Velocidade"
OrbitTitle.BackgroundTransparency = 1
OrbitTitle.Text = "OPÇÕES DO ORBIT"
OrbitTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
OrbitTitle.Font = Enum.Font.GothamBold
OrbitTitle.TextSize = 11
OrbitTitle.TextXAlignment = Enum.TextXAlignment.Center -- Centralizado
OrbitTitle.Parent = ContentFrame

-- Linha separadora acima do título (opcional)
local TopSeparator = Instance.new("Frame")
TopSeparator.Size = UDim2.new(0.9, 0, 0, 1)
TopSeparator.Position = UDim2.new(0.05, 0, 0, 210)
TopSeparator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TopSeparator.Parent = ContentFrame

-- Linha separadora abaixo do título
local BottomSeparator = Instance.new("Frame")
BottomSeparator.Size = UDim2.new(0.9, 0, 0, 1)
BottomSeparator.Position = UDim2.new(0.05, 0, 0, 237)
BottomSeparator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BottomSeparator.Parent = ContentFrame

local function createSlider(text, pos, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 15)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.Parent = ContentFrame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 5)
    sliderBg.Position = pos + UDim2.new(0, 0, 0, 18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = ContentFrame
    Instance.new("UICorner").Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sliderFill.Parent = sliderBg
    Instance.new("UICorner").Parent = sliderFill

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local connection
            connection = RunService.RenderStepped:Connect(function()
                local mPos = UserInputService:GetMouseLocation()
                local p = math.clamp((mPos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                sliderFill.Size = UDim2.new(p, 0, 1, 0)
                local val = math.floor(min + (p * (max - min)))
                label.Text = text .. ": " .. val
                callback(val)
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)
end

createSlider("Passar: Velocidade", UDim2.new(0.05, 0, 0, 135), 5, 60, DASH_SPEED, function(v) DASH_SPEED = v end)
createSlider("Passar: Distância", UDim2.new(0.05, 0, 0, 175), 2, 50, DASH_DISTANCE, function(v) DASH_DISTANCE = v end)
createSlider("Orbit: Velocidade", UDim2.new(0.05, 0, 0, 245), 1, 20, ORBIT_SPEED, function(v) ORBIT_SPEED = v end)
createSlider("Orbit: Distância", UDim2.new(0.05, 0, 0, 285), 2, 50, ORBIT_DISTANCE, function(v) ORBIT_DISTANCE = v end)
createSlider("Altura (Ambos)", UDim2.new(0.05, 0, 0, 325), -10, 20, ORBIT_HEIGHT, function(v) ORBIT_HEIGHT = v; DASH_HEIGHT = v end)

local NameInput = Instance.new("TextBox")
NameInput.Size = UDim2.new(0.9, 0, 0, 35)
NameInput.Position = UDim2.new(0.05, 0, 0, 370)
NameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NameInput.PlaceholderText = "Nome do Alvo (Vazio = Próximo)"
NameInput.Text = ""
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.Font = Enum.Font.Gotham
NameInput.TextSize = 10
NameInput.Parent = ContentFrame
Instance.new("UICorner").Parent = NameInput
NameInput.FocusLost:Connect(function() TARGET_NAME = NameInput.Text end)

print("Manus Combat V3 com Som no (-) Carregado!")
