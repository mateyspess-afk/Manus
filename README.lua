--[[ 
   Manus Combat V3 + Seguir (VERSÃO DEFINITIVA)
   Abas: ORBIT | PASSAR | SEGUIR | IA | OPÇÕES
   Altura movida para a aba ORBIT com Scroll funcional
   Compatível com Delta Executor
   COM TELA DE CARREGAMENTO RGB E CHAT IA DINÂMICA
   ROLAGEM LATERAL NAS CATEGORIAS E VERTICAL NO CHAT
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Configurações Globais
local ORBIT_DISTANCE = 10
local ORBIT_SPEED = 3
local ORBIT_HEIGHT = 2

local DASH_SPEED = 15
local DASH_DISTANCE = 12
local DASH_HEIGHT = 2

local FOLLOW_DISTANCE = 5
local FOLLOW_ENABLED = false
local FOLLOW_AIMBOT = false

local TARGET_NAME = ""
local ORBIT_ENABLED = false
local AIMBOT_CORPO = false
local DASH_PASS_ENABLED = false
local DASH_AIMBOT = false

local angle = 0
local dashTime = 0
local originalAutoRotate = true

-- ==============================================
-- TELA DE CARREGAMENTO COM RGB
-- ==============================================
local ScreenGuiLoading = Instance.new("ScreenGui")
ScreenGuiLoading.Name = "LoadingScreen"
ScreenGuiLoading.ResetOnSpawn = false
ScreenGuiLoading.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGuiLoading.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Background escuro
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
LoadingFrame.BackgroundTransparency = 0
LoadingFrame.Parent = ScreenGuiLoading

-- Efeito de gradiente sutil
local Gradient = Instance.new("Frame")
Gradient.Size = UDim2.new(1, 0, 1, 0)
Gradient.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Gradient.BackgroundTransparency = 0.85
Gradient.BorderSizePixel = 0
Gradient.Parent = LoadingFrame

-- Texto principal com efeito RGB
local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 70)
LoadingTitle.Position = UDim2.new(0, 0, 0.5, -50)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "MANUS COMBAT V3"
LoadingTitle.TextScaled = true
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.TextStrokeTransparency = 0.3
LoadingTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
LoadingTitle.Parent = LoadingFrame

-- Animação RGB para o título
local hue = 0
local rgbConnection
rgbConnection = RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    LoadingTitle.TextColor3 = color
end)

-- Container da barra de progresso
local ProgressContainer = Instance.new("Frame")
ProgressContainer.Size = UDim2.new(0.5, 0, 0, 50)
ProgressContainer.Position = UDim2.new(0.25, 0, 0.6, 0)
ProgressContainer.BackgroundTransparency = 1
ProgressContainer.Parent = LoadingFrame

-- Barra de progresso fundo
local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(1, 0, 0, 6)
ProgressBg.Position = UDim2.new(0, 0, 0.3, 0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = ProgressContainer

local UICornerProgress = Instance.new("UICorner")
UICornerProgress.CornerRadius = UDim.new(1, 0)
UICornerProgress.Parent = ProgressBg

-- Barra de progresso preenchimento (também RGB)
local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg

local UICornerFill = Instance.new("UICorner")
UICornerFill.CornerRadius = UDim.new(1, 0)
UICornerFill.Parent = ProgressFill

-- Texto de porcentagem RGB
local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 0, 30)
PercentText.Position = UDim2.new(0, 0, 0, 0)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.Font = Enum.Font.GothamBold
PercentText.TextSize = 18
PercentText.Parent = ProgressContainer

-- Texto de status RGB
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0.7, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Inicializando sistema..."
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11
StatusText.Parent = ProgressContainer

-- Versão RGB
local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0, 20)
VersionText.Position = UDim2.new(0, 0, 0.92, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "v3.0 DEFINITIVA | DELTA OPTIMIZED"
VersionText.Font = Enum.Font.Gotham
VersionText.TextSize = 9
VersionText.Parent = LoadingFrame

-- Animação RGB para os textos
local function createRGBAnimation(textLabel, speed)
    local h = 0
    RunService.RenderStepped:Connect(function(dt)
        if textLabel and textLabel.Parent then
            h = (h + dt * speed) % 1
            textLabel.TextColor3 = Color3.fromHSV(h, 1, 0.8)
        end
    end)
end

-- Aplicar animações RGB
createRGBAnimation(PercentText, 0.3)
createRGBAnimation(StatusText, 0.2)
createRGBAnimation(VersionText, 0.15)

-- Animação da barra de progresso RGB
local barHue = 0
RunService.RenderStepped:Connect(function(dt)
    if ProgressFill and ProgressFill.Parent then
        barHue = (barHue + dt * 0.4) % 1
        ProgressFill.BackgroundColor3 = Color3.fromHSV(barHue, 1, 0.7)
    end
end)

-- Variável de progresso
local currentProgress = 0
local progressTween = nil

-- Função para atualizar progresso com animação suave
local function updateProgress(targetPercent, text)
    targetPercent = math.clamp(targetPercent, 0, 1)
    
    if progressTween then
        progressTween:Cancel()
    end
    
    progressTween = TweenService:Create(ProgressFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad), 
        {Size = UDim2.new(targetPercent, 0, 1, 0)})
    progressTween:Play()
    
    -- Animação do texto de porcentagem
    local startPercent = currentProgress * 100
    local endPercent = targetPercent * 100
    local duration = 0.5
    local startTime = tick()
    
    local percentConnection
    percentConnection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local t = math.min(1, elapsed / duration)
        local currentPercent = startPercent + (endPercent - startPercent) * t
        PercentText.Text = math.floor(currentPercent) .. "%"
        
        if t >= 1 then
            percentConnection:Disconnect()
        end
    end)
    
    currentProgress = targetPercent
    StatusText.Text = text
end

-- ==============================================
-- Função para encontrar o alvo
-- ==============================================
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
    
    if (ORBIT_ENABLED or DASH_PASS_ENABLED or FOLLOW_ENABLED) and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetHrp = target.Character.HumanoidRootPart
        local targetPos = targetHrp.Position
        
        if FOLLOW_ENABLED then
            local behindOffset = targetHrp.CFrame * CFrame.new(0, 0, FOLLOW_DISTANCE)
            
            if FOLLOW_AIMBOT then
                if humanoid.AutoRotate then 
                    originalAutoRotate = humanoid.AutoRotate 
                    humanoid.AutoRotate = false 
                end
                hrp.CFrame = CFrame.new(behindOffset.Position, targetPos)
            else
                if not humanoid.AutoRotate and originalAutoRotate then 
                    humanoid.AutoRotate = humanoid.AutoRotate 
                end
                hrp.CFrame = behindOffset
            end
            
        elseif DASH_PASS_ENABLED then
            dashTime = dashTime + (DASH_SPEED * dt)
            local offsetMultiplier = math.sin(dashTime) * DASH_DISTANCE
            local direction = targetHrp.CFrame.LookVector
            local dashPos = targetPos + (direction * offsetMultiplier) + Vector3.new(0, DASH_HEIGHT, 0)
            
            if DASH_AIMBOT then
                if humanoid.AutoRotate then 
                    originalAutoRotate = humanoid.AutoRotate 
                    humanoid.AutoRotate = false 
                end
                hrp.CFrame = CFrame.new(dashPos, targetPos)
            else
                if not humanoid.AutoRotate and originalAutoRotate then 
                    humanoid.AutoRotate = humanoid.AutoRotate 
                end
                hrp.CFrame = CFrame.new(dashPos) * hrp.CFrame.Rotation
            end
            
        elseif ORBIT_ENABLED then
            angle = angle + (ORBIT_SPEED * dt)
            local offset = Vector3.new(math.cos(angle) * ORBIT_DISTANCE, ORBIT_HEIGHT, math.sin(angle) * ORBIT_DISTANCE)
            local orbitPos = targetPos + offset
            
            if AIMBOT_CORPO then
                if humanoid.AutoRotate then 
                    originalAutoRotate = humanoid.AutoRotate 
                    humanoid.AutoRotate = false 
                end
                hrp.CFrame = CFrame.new(orbitPos, targetPos)
            else
                if not humanoid.AutoRotate and originalAutoRotate then 
                    humanoid.AutoRotate = humanoid.AutoRotate 
                end
                hrp.CFrame = CFrame.new(orbitPos) * hrp.CFrame.Rotation
            end
        end
    else
        if not humanoid.AutoRotate and originalAutoRotate then 
            humanoid.AutoRotate = originalAutoRotate 
        end
    end
end)

-- ==============================================
-- Criação da GUI Principal
-- ==============================================
local ScreenGui = nil
local MainFrame = nil

local function createMainGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ManusDefinitiveGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.Text = "MANUS COMBAT V3"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.Parent = MainFrame
    Instance.new("UICorner").Parent = Title

    -- Som de Clique
    local ClickSound = Instance.new("Sound")
    ClickSound.SoundId = "rbxassetid://12221967"
    ClickSound.Volume = 0.5
    ClickSound.Parent = game:GetService("SoundService")

    -- Botão Minimizar
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -38, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Parent = MainFrame
    Instance.new("UICorner").Parent = MinimizeBtn

    -- Container das Abas (COM ROLAGEM LATERAL)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 0, 35)
    TabScroll.Position = UDim2.new(0, 0, 0, 40)
    TabScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 450, 0, 0)
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabScroll

    -- Container do Conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, 0, 1, -75)
    ContentContainer.Position = UDim2.new(0, 0, 0, 75)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local tabs = {}
    local tabButtons = {}

    local function createTabFrame(name, canvasSize)
        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.ScrollBarThickness = 3
        frame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        frame.CanvasSize = UDim2.new(0, 0, 0, canvasSize or 300)
        frame.Visible = false
        frame.Parent = ContentContainer
        tabs[name] = frame
        return frame
    end

    local function createTabBtn(name, text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 90, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 8
        btn.Parent = TabScroll

        btn.MouseButton1Click:Connect(function()
            ClickSound:Play()
            for tabName, tabFrame in pairs(tabs) do
                tabFrame.Visible = false
            end
            for _, otherBtn in pairs(tabButtons) do
                otherBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                otherBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            tabs[name].Visible = true
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
        end)
        table.insert(tabButtons, btn)
        return btn
    end

    -- Criar as Abas
    local orbitFrame = createTabFrame("Orbit", 350)
    local dashFrame = createTabFrame("Dash", 300)
    local followFrame = createTabFrame("Follow", 250)
    local aiFrame = createTabFrame("IA", 245)
    local settingsFrame = createTabFrame("Settings", 150)

    createTabBtn("Orbit", "ORBIT")
    createTabBtn("Dash", "PASSAR")
    createTabBtn("Follow", "SEGUIR")
    createTabBtn("IA", "IA")
    createTabBtn("Settings", "OPÇÕES")

    -- Funções Auxiliares de UI
    local function createBtn(text, pos, color, parent, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.Parent = parent
        Instance.new("UICorner").Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function createSlider(text, pos, min, max, default, parent, callback)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.9, 0, 0, 15)
        label.Position = pos
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 9
        label.Parent = parent

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
        sliderBg.Position = pos + UDim2.new(0, 0, 0, 18)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderBg.Parent = parent
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

    -- ABA 1: ORBIT
    local orbitToggleBtn, aimToggleBtn
    orbitToggleBtn = createBtn("ORBIT: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(180, 50, 50), orbitFrame, function()
        ORBIT_ENABLED = not ORBIT_ENABLED
        DASH_PASS_ENABLED = false
        FOLLOW_ENABLED = false
        orbitToggleBtn.Text = ORBIT_ENABLED and "ORBIT: ON" or "ORBIT: OFF"
        orbitToggleBtn.BackgroundColor3 = ORBIT_ENABLED and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
        ClickSound:Play()
    end)

    aimToggleBtn = createBtn("AIMBOT CORPO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(150, 100, 50), orbitFrame, function()
        AIMBOT_CORPO = not AIMBOT_CORPO
        aimToggleBtn.Text = AIMBOT_CORPO and "AIMBOT CORPO: ON" or "AIMBOT CORPO: OFF"
        aimToggleBtn.BackgroundColor3 = AIMBOT_CORPO and Color3.fromRGB(50, 150, 200) or Color3.fromRGB(150, 100, 50)
        ClickSound:Play()
    end)

    createSlider("Orbit: Velocidade", UDim2.new(0.05, 0, 0, 100), 1, 20, ORBIT_SPEED, orbitFrame, function(v) ORBIT_SPEED = v end)
    createSlider("Orbit: Distância", UDim2.new(0.05, 0, 0, 140), 2, 50, ORBIT_DISTANCE, orbitFrame, function(v) ORBIT_DISTANCE = v end)
    createSlider("Altura (Orbit/Dash)", UDim2.new(0.05, 0, 0, 180), -10, 20, ORBIT_HEIGHT, orbitFrame, function(v) ORBIT_HEIGHT = v; DASH_HEIGHT = v end)

    local OrbitNameInput = Instance.new("TextBox")
    OrbitNameInput.Size = UDim2.new(0.9, 0, 0, 35)
    OrbitNameInput.Position = UDim2.new(0.05, 0, 0, 230)
    OrbitNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    OrbitNameInput.PlaceholderText = "Nome do Alvo (Vazio = Próximo)"
    OrbitNameInput.Text = ""
    OrbitNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    OrbitNameInput.Font = Enum.Font.Gotham
    OrbitNameInput.TextSize = 10
    OrbitNameInput.Parent = orbitFrame
    Instance.new("UICorner").Parent = OrbitNameInp
