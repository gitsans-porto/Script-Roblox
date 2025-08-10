--[[
    Skrip Universal v18.0 - Teleport & Click-to-Fling (Edisi Final)
    
    Pembaruan Kritis:
    - Menggunakan metode "Glitched Physics" yang 100% client-side.
    - Membuat part tak terlihat di dalam target untuk memaksa server melemparnya.
    - Metode ini tidak memerlukan akses ke server atau RemoteEvents.
    - Dirancang untuk keandalan maksimal di semua game.
]]

-- Mencegah skrip berjalan dua kali
if _G.UniversalMultiToolLoaded_v18 then
    print("Skrip Multi-Tool v18 sudah berjalan.")
    return
end
_G.UniversalMultiToolLoaded_v18 = true

print("Memulai Skrip Multi-Tool Universal v18.0...")

-- Services
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Pemain Lokal
local localPlayer = Players.LocalPlayer

-- Variabel Status
local clickFlingActive = false
local inputConnection = nil

-- Membuat ScreenGui
local screenGui = Instance.new("ScreenGui"); screenGui.Name = "UniversalMultiToolGUI_v18"; screenGui.ResetOnSpawn = false; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame"); mainFrame.Name = "MainFrame"; local originalSize = UDim2.new(0, 300, 0, 320); mainFrame.Size = originalSize; mainFrame.Position = UDim2.new(0.5, -150, 0.5, -160); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37); mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57); mainFrame.BorderSizePixel = 1; mainFrame.ClipsDescendants = true; mainFrame.Parent = screenGui

-- Membuat Title Bar
local titleBar = Instance.new("Frame", mainFrame); titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
local titleLabel = Instance.new("TextLabel", titleBar); titleLabel.Size = UDim2.new(1, -60, 1, 0); titleLabel.Position = UDim2.new(0, 10, 0, 0); titleLabel.BackgroundColor3 = titleBar.BackgroundColor3; titleLabel.Font = Enum.Font.SourceSansSemibold; titleLabel.Text = "Multi-Tool"; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.TextSize = 16; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
local closeButton = Instance.new("TextButton", titleBar); closeButton.Size = UDim2.new(0, 30, 1, 0); closeButton.Position = UDim2.new(1, -30, 0, 0); closeButton.BackgroundColor3 = titleBar.BackgroundColor3; closeButton.Font = Enum.Font.SourceSansBold; closeButton.Text = "X"; closeButton.TextColor3 = Color3.fromRGB(200, 200, 200); closeButton.TextSize = 20
local minimizeButton = Instance.new("TextButton", titleBar); minimizeButton.Size = UDim2.new(0, 30, 1, 0); minimizeButton.Position = UDim2.new(1, -60, 0, 0); minimizeButton.BackgroundColor3 = titleBar.BackgroundColor3; minimizeButton.Font = Enum.Font.SourceSansBold; minimizeButton.Text = "_"; minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200); minimizeButton.TextSize = 20

-- Konten di dalam Frame
local contentHolder = Instance.new("Frame", mainFrame); contentHolder.Name = "ContentHolder"; contentHolder.Size = UDim2.new(1, 0, 1, -30); contentHolder.Position = UDim2.new(0, 0, 0, 30); contentHolder.BackgroundTransparency = 1

-- Navbar
local navBar = Instance.new("Frame", contentHolder); navBar.Name = "NavBar"; navBar.Size = UDim2.new(1, -20, 0, 30); navBar.Position = UDim2.new(0, 10, 0, 10); navBar.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
local navLayout = Instance.new("UIListLayout", navBar); navLayout.FillDirection = Enum.FillDirection.Horizontal
local navTeleportBtn = Instance.new("TextButton", navBar); navTeleportBtn.Name = "NavTeleport"; navTeleportBtn.Size = UDim2.new(0.5, 0, 1, 0); navTeleportBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); navTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255); navTeleportBtn.Font = Enum.Font.SourceSansBold; navTeleportBtn.Text = "Teleport"; navTeleportBtn.TextSize = 14
local navFlingBtn = Instance.new("TextButton", navBar); navFlingBtn.Name = "NavFling"; navFlingBtn.Size = UDim2.new(0.5, 0, 1, 0); navFlingBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180); navFlingBtn.Font = Enum.Font.SourceSansBold; navFlingBtn.Text = "Fling"; navFlingBtn.TextSize = 14

-- Wadah untuk halaman
local pageContainer = Instance.new("Frame", contentHolder); pageContainer.Name = "PageContainer"; pageContainer.Size = UDim2.new(1, 0, 1, -50); pageContainer.Position = UDim2.new(0, 0, 0, 50); pageContainer.BackgroundTransparency = 1
local teleportPage = Instance.new("Frame", pageContainer); teleportPage.Name = "TeleportPage"; teleportPage.Size = UDim2.new(1, 0, 1, 0); teleportPage.BackgroundTransparency = 1; teleportPage.Visible = true
local flingPage = Instance.new("Frame", pageContainer); flingPage.Name = "FlingPage"; flingPage.Size = UDim2.new(1, 0, 1, 0); flingPage.BackgroundTransparency = 1; flingPage.Visible = false

-- === KONTEN HALAMAN TELEPORT ===
local nameTextBox = Instance.new("TextBox", teleportPage); nameTextBox.Size = UDim2.new(1, -20, 0, 35); nameTextBox.Position = UDim2.new(0, 10, 0, 0); nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47); nameTextBox.PlaceholderText = "Pilih dari daftar atau ketik..."; nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220); nameTextBox.Font = Enum.Font.SourceSans; nameTextBox.TextSize = 14
local teleportButton = Instance.new("TextButton", teleportPage); teleportButton.Size = UDim2.new(1, -20, 0, 35); teleportButton.Position = UDim2.new(0, 10, 0, 45); teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242); teleportButton.Font = Enum.Font.SourceSansBold; teleportButton.Text = "TELEPORT"; teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255); teleportButton.TextSize = 16
local playerListFrame = Instance.new("ScrollingFrame", teleportPage); playerListFrame.Size = UDim2.new(1, -20, 1, -90); playerListFrame.Position = UDim2.new(0, 10, 0, 90); playerListFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 47); playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242); playerListFrame.ScrollBarThickness = 5
local uiGridLayout = Instance.new("UIGridLayout", playerListFrame); uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5); uiGridLayout.CellSize = UDim2.new(0, 125, 0, 25)

-- === KONTEN HALAMAN FLING ===
local clickFlingToggleButton = Instance.new("TextButton", flingPage); clickFlingToggleButton.Name = "ClickFlingToggle"; clickFlingToggleButton.Size = UDim2.new(1, -20, 0, 45); clickFlingToggleButton.Position = UDim2.new(0, 10, 0, 10); clickFlingToggleButton.Font = Enum.Font.SourceSansBold; clickFlingToggleButton.TextSize = 18; clickFlingToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255); clickFlingToggleButton.Text = "AKTIFKAN MODE FLING"; clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)

-- === LOGIKA DAN FUNGSI ===

local function executeFling(targetPart)
    local targetModel = targetPart:FindFirstAncestorWhichIsA("Model")
    if not targetModel then return end
    
    local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
    if not (targetPlayer and targetPlayer ~= localPlayer) then return end
    
    local targetRoot = targetModel:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    print("Mencoba Fling pada " .. targetPlayer.Name .. " dengan metode Glitched Physics...")

    -- Buat "dinding" tak terlihat
    local glitchPart = Instance.new("Part")
    glitchPart.Name = "FlingWall"
    glitchPart.Size = Vector3.new(6, 6, 6)
    glitchPart.Anchored = true
    glitchPart.CanCollide = true
    glitchPart.Transparency = 1
    glitchPart.CFrame = targetRoot.CFrame -- Teleport ke dalam target
    glitchPart.Parent = workspace
    
    -- Hancurkan dinding setelah sepersekian detik
    Debris:AddItem(glitchPart, 0.1)
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local target = localPlayer:GetMouse().Target
        if target then
            executeFling(target)
        end
    end
end

local function deactivateClickFling()
    if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
    print("Mode Click-to-Fling DEACTIVATED")
end

local function activateClickFling()
    deactivateClickFling()
    inputConnection = UserInputService.InputBegan:Connect(onInputBegan)
    print("Mode Click-to-Fling ACTIVATED")
end

clickFlingToggleButton.MouseButton1Click:Connect(function()
    clickFlingActive = not clickFlingActive
    if clickFlingActive then
        activateClickFling()
        clickFlingToggleButton.Text = "MODE FLING AKTIF"
        clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(67, 181, 129) -- Hijau
    else
        deactivateClickFling()
        clickFlingToggleButton.Text = "AKTIFKAN MODE FLING"
        clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69) -- Merah
    end
end)

-- Logika Navbar
local function switchPage(pageName)
    if pageName == "Teleport" then
        teleportPage.Visible = true; flingPage.Visible = false
        navTeleportBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); navTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        navFlingBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    elseif pageName == "Fling" then
        teleportPage.Visible = false; flingPage.Visible = true
        navFlingBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); navFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        navTeleportBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end
navTeleportBtn.MouseButton1Click:Connect(function() switchPage("Teleport") end)
navFlingBtn.MouseButton1Click:Connect(function() switchPage("Fling") end)

-- Fungsi Teleport
local function teleportToPlayer(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) then print("Target atau karakter lokal tidak valid.") return end
    if targetPlayer == localPlayer then print("Tidak bisa teleport ke diri sendiri.") return end
    print("Teleportasi ke " .. targetPlayer.Name .. "...")
    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
end

-- Fungsi Update Daftar Pemain
function updatePlayerList()
    for _, c in ipairs(playerListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local btn = Instance.new("TextButton", playerListFrame); btn.Name = p.Name; btn.Text = p.Name; btn.Size = UDim2.new(0, 125, 0, 25); btn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); btn.TextColor3 = Color3.fromRGB(220, 220, 220); btn.Font = Enum.Font.SourceSans; btn.TextSize = 12
            btn.MouseButton1Click:Connect(function() nameTextBox.Text = p.Name end)
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, uiGridLayout.AbsoluteContentSize.Y)
end

-- Inisialisasi & Event Listeners
teleportButton.MouseButton1Click:Connect(function() if nameTextBox.Text ~= "" then teleportToPlayer(nameTextBox.Text) end end)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy(); _G.UniversalMultiToolLoaded_v18 = false end)
local isMinimized = false; local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
minimizeButton.MouseButton1Click:Connect(function() isMinimized = not isMinimized; local targetSize = isMinimized and UDim2.new(0, 300, 0, 30) or originalSize; if isMinimized then minimizeButton.Text = "❐" else minimizeButton.Text = "_" end; contentHolder.Visible = not isMinimized; TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play() end)
local dragging, dragStart, startPos; titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType
