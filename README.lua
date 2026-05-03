--[[ 
   Manus Hub + Seguir + Passar + Orbit (VERSÃO COM PERFIL)
   Abas: ORBIT | PASSAR | SEGUIR | PASSAR+ORBIT | OPÇÕES
   ⚠️caso copia o script iremos denunciar e sua conta e removidas usamos bot de moderação no script⚠️
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

-- Configurações Passar+Orbit
local DASH_ORBIT_ENABLED = false
local DASH_ORBIT_SPEED = 5
local DASH_ORBIT_DISTANCE = 8
local DASH_ORBIT_DASH_SPEED = 20
local DASH_ORBIT_DASH_DISTANCE = 8
local DASH_ORBIT_HEIGHT = 2
local DASH_ORBIT_AIMBOT = false

local angle = 0
local dashTime = 0
local originalAutoRotate = true
local dashOrbitTime = 0

-- CORREÇÃO: Variável para armazenar o alvo atual
local currentTarget = nil

-- CORREÇÃO: Função que verifica se o alvo ESTÁ VIVO e COM CHARACTER
local function isAlive(target)
    if not target then return false end
    if target == LocalPlayer then return false end
    
    local character = target.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    -- Verifica se está vivo (Health > 0)
    if humanoid.Health <= 0 then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    return true
end

-- CORREÇÃO: Encontra o jogador mais próximo VIVO
local function getNearestAlivePlayer()
    local closest = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        -- Ignora você mesmo
        if player ~= LocalPlayer then
            -- Verifica se está vivo E tem character
            if isAlive(player) then
                local hrp = player.Character.HumanoidRootPart
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- CORREÇÃO: Atualiza o alvo a cada frame (se o atual morreu, muda)
local function updateTarget()
    -- Se não tem nenhum modo ativo, não precisa de alvo
    if not (ORBIT_ENABLED or DASH_PASS_ENABLED or FOLLOW_ENABLED or DASH_ORBIT_ENABLED) then
        currentTarget = nil
        return
    end
    
    -- Caso 1: Tem nome específico definido
    if TARGET_NAME ~= "" then
        local namedTarget = Players:FindFirstChild(TARGET_NAME)
        if namedTarget and isAlive(namedTarget) then
            currentTarget = namedTarget
            return
        else
            -- O alvo específico morreu ou não existe, limpa o nome
            if TARGET_NAME ~= "" then
                TARGET_NAME = ""
                -- Atualiza o TextBox se existir
                local textBox = orbitFrame and orbitFrame:FindFirstChild("TextBox")
                if textBox then textBox.Text = "" end
            end
            currentTarget = nil
        end
    end
    
    -- Caso 2: Se não tem alvo OU o alvo atual morreu, procura outro VIVO
    if not currentTarget or not isAlive(currentTarget) then
        currentTarget = getNearestAlivePlayer()
    end
end

-- Loop Principal CORRIGIDO
RunService.Heartbeat:Connect(function(dt)
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    -- ATUALIZA O ALVO A CADA FRAME
    updateTarget()
    
    -- Só executa se tiver um alvo VIVO
    if (ORBIT_ENABLED or DASH_PASS_ENABLED or FOLLOW_ENABLED or DASH_ORBIT_ENABLED) and currentTarget then
        local targetCharacter = currentTarget.Character
        if targetCharacter then
            local targetHrp = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local targetPos = targetHrp.Position
                
                if DASH_ORBIT_ENABLED then
                    dashOrbitTime = dashOrbitTime + (DASH_ORBIT_DASH_SPEED * dt)
                    angle = angle + (DASH_ORBIT_SPEED * dt)
                    local orbitOffset = Vector3.new(math.cos(angle) * DASH_ORBIT_DISTANCE, DASH_ORBIT_HEIGHT, math.sin(angle) * DASH_ORBIT_DISTANCE)
                    local direction = targetHrp.CFrame.LookVector
                    local dashOffset = direction * (math.sin(dashOrbitTime) * DASH_ORBIT_DASH_DISTANCE)
                    local finalPos = targetPos + orbitOffset + dashOffset
                    
                    if DASH_ORBIT_AIMBOT then
                        if humanoid.AutoRotate then originalAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
                        hrp.CFrame = CFrame.new(finalPos, targetPos)
                    else
                        if not humanoid.AutoRotate and originalAutoRotate then humanoid.AutoRotate = originalAutoRotate end
                        hrp.CFrame = CFrame.new(finalPos) * hrp.CFrame.Rotation
                    end
                    
                elseif FOLLOW_ENABLED then
                    local behindOffset = targetHrp.CFrame * CFrame.new(0, 0, FOLLOW_DISTANCE)
                    if FOLLOW_AIMBOT then
                        if humanoid.AutoRotate then originalAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
                        hrp.CFrame = CFrame.new(behindOffset.Position, targetPos)
                    else
                        if not humanoid.AutoRotate and originalAutoRotate then humanoid.AutoRotate = originalAutoRotate end
                        hrp.CFrame = behindOffset
                    end
                    
                elseif DASH_PASS_ENABLED then
                    dashTime = dashTime + (DASH_SPEED * dt)
                    local dashPos = targetPos + (targetHrp.CFrame.LookVector * (math.sin(dashTime) * DASH_DISTANCE)) + Vector3.new(0, DASH_HEIGHT, 0)
                    if DASH_AIMBOT then
                        if humanoid.AutoRotate then originalAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
                        hrp.CFrame = CFrame.new(dashPos, targetPos)
                    else
                        if not humanoid.AutoRotate and originalAutoRotate then humanoid.AutoRotate = originalAutoRotate end
                        hrp.CFrame = CFrame.new(dashPos) * hrp.CFrame.Rotation
                    end
                    
                elseif ORBIT_ENABLED then
                    angle = angle + (ORBIT_SPEED * dt)
                    local orbitPos = targetPos + Vector3.new(math.cos(angle) * ORBIT_DISTANCE, ORBIT_HEIGHT, math.sin(angle) * ORBIT_DISTANCE)
                    if AIMBOT_CORPO then
                        if humanoid.AutoRotate then originalAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
                        hrp.CFrame = CFrame.new(orbitPos, targetPos)
                    else
                        if not humanoid.AutoRotate and originalAutoRotate then humanoid.AutoRotate = originalAutoRotate end
                        hrp.CFrame = CFrame.new(orbitPos) * hrp.CFrame.Rotation
                    end
                end
            end
        end
    else
        -- Se não tem alvo, reseta a rotação
        if not humanoid.AutoRotate and originalAutoRotate then
            humanoid.AutoRotate = originalAutoRotate
        end
    end
end)

-- Interface Gráfica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ManusHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 460)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Frame do Perfil (lado esquerdo)
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 60, 0, 60)
ProfileFrame.Position = UDim2.new(0, 8, 0, 8)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ProfileFrame.BorderSizePixel = 0
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = MainFrame

-- Imagem de Perfil (quadrada)
local ProfileImage = Instance.new("ImageLabel")
ProfileImage.Size = UDim2.new(0, 50, 0, 50)
ProfileImage.Position = UDim2.new(0, 5, 0, 5)
ProfileImage.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ProfileImage.BackgroundTransparency = 0
ProfileImage.BorderSizePixel = 0
ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=7344788878&w=420&h=420"
ProfileImage.Parent = ProfileFrame
Instance.new("UICorner").Parent = ProfileImage
local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8)
profileCorner.Parent = ProfileImage

-- Título Principal (movido para a direita para não sobrepor o perfil)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 28)
Title.Position = UDim2.new(0, 70, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "MANUS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Subtítulo (by Mateusx9992)
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -70, 0, 16)
SubTitle.Position = UDim2.new(0, 70, 0, 32)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by Mateusx9992"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = MainFrame

-- Efeito RGB no título
local hue = 0
local rgbEffect = RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    Title.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- Som de Clique
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://12221967"
ClickSound.Volume = 0.5
ClickSound.Parent = game:GetService("SoundService")

-- Botão Minimizar (ajustado)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -36, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner").Parent = MinimizeBtn

-- Container das Abas
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 0, 45)
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
TabContainer.Parent = MainFrame

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -115)
ContentContainer.Position = UDim2.new(0, 0, 0, 115)
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
    frame.CanvasSize = UDim2.new(0, 0, 0, canvasSize or 350)
    frame.Visible = false
    frame.Parent = ContentContainer
    tabs[name] = frame
    return frame
end

local function createTabBtn(name, text, positionX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, -5)
    btn.Position = UDim2.new(0, positionX, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = ButtonsContainer
    Instance.new("UICorner").Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, tabFrame in pairs(tabs) do tabFrame.Visible = false end
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

-- Criar Abas
local orbitFrame = createTabFrame("Orbit", 400)
local dashFrame = createTabFrame("Dash", 350)
local followFrame = createTabFrame("Follow", 300)
local dashOrbitFrame = createTabFrame("DashOrbit", 450)
local settingsFrame = createTabFrame("Settings", 150)

-- Botões das abas
local buttonsData = {
    {"Orbit", "ORBIT", 5},
    {"Dash", "PASSAR", 85},
    {"Follow", "SEGUIR", 165},
    {"DashOrbit", "PASS+ORBIT", 245},
    {"Settings", "OPÇÕES", 325}
}
for _, data in ipairs(buttonsData) do createTabBtn(data[1], data[2], data[3]) end
ButtonsContainer.Size = UDim2.new(0, 405, 1, 0)

-- Funções UI
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

-- Variáveis globais para os botões
local orbitToggleBtn, aimToggleBtn, dashToggleBtn, dashAimbotBtn
local followToggleBtn, followAimbotBtn, dashOrbitToggleBtn, dashOrbitAimbotBtn

-- Função para desativar todos os modos
local function disableAllModes()
    ORBIT_ENABLED = false
    DASH_PASS_ENABLED = false
    FOLLOW_ENABLED = false
    DASH_ORBIT_ENABLED = false
    
    if orbitToggleBtn then
        orbitToggleBtn.Text = "ORBIT: OFF"
        orbitToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
    if dashToggleBtn then
        dashToggleBtn.Text = "PASSAR RÁPIDO: OFF"
        dashToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 180)
    end
    if followToggleBtn then
        followToggleBtn.Text = "SEGUIR JOGADOR: OFF"
        followToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    end
    if dashOrbitToggleBtn then
        dashOrbitToggleBtn.Text = "PASSAR+ORBIT: OFF"
        dashOrbitToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
    end
end

-- ABA ORBIT
orbitToggleBtn = createBtn("ORBIT: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(180, 50, 50), orbitFrame, function()
    if ORBIT_ENABLED then
        ORBIT_ENABLED = false
        orbitToggleBtn.Text = "ORBIT: OFF"
        orbitToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        currentTarget = nil
    else
        disableAllModes()
        ORBIT_ENABLED = true
        orbitToggleBtn.Text = "ORBIT: ON"
        orbitToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        updateTarget()
    end
end)

aimToggleBtn = createBtn("CORPO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(150, 100, 50), orbitFrame, function()
    AIMBOT_CORPO = not AIMBOT_CORPO
    if AIMBOT_CORPO then
        aimToggleBtn.Text = "CORPO: ON"
        aimToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    else
        aimToggleBtn.Text = "CORPO: OFF"
        aimToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    end
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
Instance.new("UICorner").Parent = OrbitNameInput
OrbitNameInput.FocusLost:Connect(function() 
    TARGET_NAME = OrbitNameInput.Text
    updateTarget()
end)

-- ABA PASSAR
dashToggleBtn = createBtn("PASSAR RÁPIDO: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(50, 50, 180), dashFrame, function()
    if DASH_PASS_ENABLED then
        DASH_PASS_ENABLED = false
        dashToggleBtn.Text = "PASSAR RÁPIDO: OFF"
        dashToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 180)
        currentTarget = nil
    else
        disableAllModes()
        DASH_PASS_ENABLED = true
        dashToggleBtn.Text = "PASSAR RÁPIDO: ON"
        dashToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 180)
        updateTarget()
    end
end)

dashAimbotBtn = createBtn("CORPO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(150, 100, 50), dashFrame, function()
    DASH_AIMBOT = not DASH_AIMBOT
    if DASH_AIMBOT then
        dashAimbotBtn.Text = "CORPO: ON"
        dashAimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    else
        dashAimbotBtn.Text = "CORPO: OFF"
        dashAimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    end
end)

createSlider("Passar: Velocidade", UDim2.new(0.05, 0, 0, 100), 5, 60, DASH_SPEED, dashFrame, function(v) DASH_SPEED = v end)
createSlider("Passar: Distância", UDim2.new(0.05, 0, 0, 140), 2, 50, DASH_DISTANCE, dashFrame, function(v) DASH_DISTANCE = v end)

-- ABA SEGUIR
followToggleBtn = createBtn("SEGUIR JOGADOR: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(100, 50, 150), followFrame, function()
    if FOLLOW_ENABLED then
        FOLLOW_ENABLED = false
        followToggleBtn.Text = "SEGUIR JOGADOR: OFF"
        followToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        currentTarget = nil
    else
        disableAllModes()
        FOLLOW_ENABLED = true
        followToggleBtn.Text = "SEGUIR JOGADOR: ON"
        followToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
        updateTarget()
    end
end)

followAimbotBtn = createBtn("CORPO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(150, 100, 50), followFrame, function()
    FOLLOW_AIMBOT = not FOLLOW_AIMBOT
    if FOLLOW_AIMBOT then
        followAimbotBtn.Text = "CORPO: ON"
        followAimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    else
        followAimbotBtn.Text = "CORPO: OFF"
        followAimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    end
end)

createSlider("Seguir: Distância", UDim2.new(0.05, 0, 0, 100), 1, 30, FOLLOW_DISTANCE, followFrame, function(v) FOLLOW_DISTANCE = v end)

-- ABA PASSAR+ORBIT
dashOrbitToggleBtn = createBtn("PASSAR+ORBIT: OFF", UDim2.new(0.05, 0, 0, 10), Color3.fromRGB(150, 50, 150), dashOrbitFrame, function()
    if DASH_ORBIT_ENABLED then
        DASH_ORBIT_ENABLED = false
        dashOrbitToggleBtn.Text = "PASSAR+ORBIT: OFF"
        dashOrbitToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
        currentTarget = nil
    else
        disableAllModes()
        DASH_ORBIT_ENABLED = true
        dashOrbitToggleBtn.Text = "PASSAR+ORBIT: ON"
        dashOrbitToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        updateTarget()
    end
end)

dashOrbitAimbotBtn = createBtn("CORPO: OFF", UDim2.new(0.05, 0, 0, 50), Color3.fromRGB(150, 100, 50), dashOrbitFrame, function()
    DASH_ORBIT_AIMBOT = not DASH_ORBIT_AIMBOT
    if DASH_ORBIT_AIMBOT then
        dashOrbitAimbotBtn.Text = "CORPO: ON"
        dashOrbitAimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    else
        dashOrbitAimbotBtn.Text = "CORPO: OFF"
        dashOrbitAimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    end
end)

createSlider("Orbit: Velocidade", UDim2.new(0.05, 0, 0, 100), 1, 20, DASH_ORBIT_SPEED, dashOrbitFrame, function(v) DASH_ORBIT_SPEED = v end)
createSlider("Orbit: Distância", UDim2.new(0.05, 0, 0, 140), 2, 40, DASH_ORBIT_DISTANCE, dashOrbitFrame, function(v) DASH_ORBIT_DISTANCE = v end)
createSlider("Altura (PASS+ORBIT)", UDim2.new(0.05, 0, 0, 180), -10, 20, DASH_ORBIT_HEIGHT, dashOrbitFrame, function(v) DASH_ORBIT_HEIGHT = v end)
createSlider("Passar: Velocidade", UDim2.new(0.05, 0, 0, 220), 5, 50, DASH_ORBIT_DASH_SPEED, dashOrbitFrame, function(v) DASH_ORBIT_DASH_SPEED = v end)
createSlider("Passar: Distância", UDim2.new(0.05, 0, 0, 260), 2, 30, DASH_ORBIT_DASH_DISTANCE, dashOrbitFrame, function(v) DASH_ORBIT_DASH_DISTANCE = v end)

-- ABA OPÇÕES
local CloseBtn = createBtn("FECHAR MENU", UDim2.new(0.05, 0, 0, 20), Color3.fromRGB(150, 50, 50), settingsFrame, function()
    ScreenGui:Destroy()
    rgbEffect:Disconnect()
end)

-- CORRIGIDO: Minimizar sem esconder perfil e subtítulo
local isMinimized = false
local originalSize = MainFrame.Size
MinimizeBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    isMinimized = not isMinimized
    if isMinimized then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 70)})
        tween:Play()
        tween.Completed:Connect(function()
            TabContainer.Visible = false
            ContentContainer.Visible = false
            -- PERFIL E SUBTÍTULO CONTINUAM VISÍVEIS (não escondemos mais!)
        end)
        MinimizeBtn.Text = "+"
    else
        TabContainer.Visible = true
        ContentContainer.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = originalSize})
        tween:Play()
        MinimizeBtn.Text = "-"
    end
end)

-- Abrir aba padrão
tabs["Orbit"].Visible = true
tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 50, 100)

print("Manus Hub Carregado - Versão com Perfil | by Mateusx9992")
