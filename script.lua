--[[
    Skrip Universal v20.0 - Edisi "Velocity"
    
    Pembaruan Kritis:
    - [DIPERBAIKI] Fungsi Fling sekarang menggunakan metode 'AssemblyLinearVelocity' yang jauh lebih andal daripada metode fisika glitch.
    - Menambahkan kekuatan lemparan ke atas (upward force) untuk hasil yang lebih baik.
    - Menggunakan pcall untuk mencegah crash total jika UI gagal dibuat.
    - Menggunakan teknik "Parenting Tertunda" untuk mencoba melewati deteksi keamanan.
]]

-- Mencegah skrip berjalan dua kali
if _G.UniversalMultiToolLoaded_v20 then
    print("Skrip Multi-Tool v20 sudah berjalan.")
    return
end
_G.UniversalMultiToolLoaded_v20 = true

print("Memulai Skrip Multi-Tool Universal v20.0...")

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

-- === FUNGSI UTAMA PEMBUATAN UI (DIBUNGKUS DALAM PCALL) ===
local success, uiElements = pcall(function()
    print("Debug: Memulai pembuatan UI di dalam pcall...")

    local gui = {}
    
    gui.screenGui = Instance.new("ScreenGui"); gui.screenGui.Name = "UniversalMultiToolGUI_v20"; gui.screenGui.ResetOnSpawn = false; gui.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    print("Debug: ScreenGui dibuat.")

    gui.mainFrame = Instance.new("Frame", gui.screenGui); gui.mainFrame.Name = "MainFrame"; gui.mainFrame.Size = UDim2.new(0, 300, 0, 320); gui.mainFrame.Position = UDim2.new(0.5, -150, 0.5, -160); gui.mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37); gui.mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57); gui.mainFrame.BorderSizePixel = 1; gui.mainFrame.ClipsDescendants = true
    print("Debug: MainFrame dibuat.")

    gui.titleBar = Instance.new("Frame", gui.mainFrame); gui.titleBar.Name = "TitleBar"; gui.titleBar.Size = UDim2.new(1, 0, 0, 30); gui.titleBar.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
    gui.titleLabel = Instance.new("TextLabel", gui.titleBar); gui.titleLabel.Size = UDim2.new(1, -60, 1, 0); gui.titleLabel.Position = UDim2.new(0, 10, 0, 0); gui.titleLabel.BackgroundColor3 = gui.titleBar.BackgroundColor3; gui.titleLabel.Font = Enum.Font.SourceSansSemibold; gui.titleLabel.Text = "Multi-Tool"; gui.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); gui.titleLabel.TextSize = 16; gui.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    gui.closeButton = Instance.new("TextButton", gui.titleBar); gui.closeButton.Size = UDim2.new(0, 30, 1, 0); gui.closeButton.Position = UDim2.new(1, -30, 0, 0); gui.closeButton.BackgroundColor3 = gui.titleBar.BackgroundColor3; gui.closeButton.Font = Enum.Font.SourceSansBold; gui.closeButton.Text = "X"; gui.closeButton.TextColor3 = Color3.fromRGB(200, 200, 200); gui.closeButton.TextSize = 20
    gui.minimizeButton = Instance.new("TextButton", gui.titleBar); gui.minimizeButton.Size = UDim2.new(0, 30, 1, 0); gui.minimizeButton.Position = UDim2.new(1, -60, 0, 0); gui.minimizeButton.BackgroundColor3 = gui.titleBar.BackgroundColor3; gui.minimizeButton.Font = Enum.Font.SourceSansBold; gui.minimizeButton.Text = "_"; gui.minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200); gui.minimizeButton.TextSize = 20
    print("Debug: TitleBar dibuat.")

    gui.contentHolder = Instance.new("Frame", gui.mainFrame); gui.contentHolder.Name = "ContentHolder"; gui.contentHolder.Size = UDim2.new(1, 0, 1, -30); gui.contentHolder.Position = UDim2.new(0, 0, 0, 30); gui.contentHolder.BackgroundTransparency = 1
    gui.navBar = Instance.new("Frame", gui.contentHolder); gui.navBar.Name = "NavBar"; gui.navBar.Size = UDim2.new(1, -20, 0, 30); gui.navBar.Position = UDim2.new(0, 10, 0, 10); gui.navBar.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
    gui.navLayout = Instance.new("UIListLayout", gui.navBar); gui.navLayout.FillDirection = Enum.FillDirection.Horizontal
    gui.navTeleportBtn = Instance.new("TextButton", gui.navBar); gui.navTeleportBtn.Name = "NavTeleport"; gui.navTeleportBtn.Size = UDim2.new(0.5, 0, 1, 0); gui.navTeleportBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); gui.navTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255); gui.navTeleportBtn.Font = Enum.Font.SourceSansBold; gui.navTeleportBtn.Text = "Teleport"; gui.navTeleportBtn.TextSize = 14
    gui.navFlingBtn = Instance.new("TextButton", gui.navBar); gui.navFlingBtn.Name = "NavFling"; gui.navFlingBtn.Size = UDim2.new(0.5, 0, 1, 0); gui.navFlingBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); gui.navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180); gui.navFlingBtn.Font = Enum.Font.SourceSansBold; gui.navFlingBtn.Text = "Fling"; gui.navFlingBtn.TextSize = 14
    print("Debug: NavBar dibuat.")

    gui.pageContainer = Instance.new("Frame", gui.contentHolder); gui.pageContainer.Name = "PageContainer"; gui.pageContainer.Size = UDim2.new(1, 0, 1, -50); gui.pageContainer.Position = UDim2.new(0, 0, 0, 50); gui.pageContainer.BackgroundTransparency = 1
    gui.teleportPage = Instance.new("Frame", gui.pageContainer); gui.teleportPage.Name = "TeleportPage"; gui.teleportPage.Size = UDim2.new(1, 0, 1, 0); gui.teleportPage.BackgroundTransparency = 1; gui.teleportPage.Visible = true
    gui.flingPage = Instance.new("Frame", gui.pageContainer); gui.flingPage.Name = "FlingPage"; gui.flingPage.Size = UDim2.new(1, 0, 1, 0); gui.flingPage.BackgroundTransparency = 1; gui.flingPage.Visible = false
    
    gui.nameTextBox = Instance.new("TextBox", gui.teleportPage); gui.nameTextBox.Size = UDim2.new(1, -20, 0, 35); gui.nameTextBox.Position = UDim2.new(0, 10, 0, 0); gui.nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47); gui.nameTextBox.PlaceholderText = "Pilih dari daftar atau ketik..."; gui.nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220); gui.nameTextBox.Font = Enum.Font.SourceSans; gui.nameTextBox.TextSize = 14
    gui.teleportButton = Instance.new("TextButton", gui.teleportPage); gui.teleportButton.Size = UDim2.new(1, -20, 0, 35); gui.teleportButton.Position = UDim2.new(0, 10, 0, 45); gui.teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242); gui.teleportButton.Font = Enum.Font.SourceSansBold; gui.teleportButton.Text = "TELEPORT"; gui.teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255); gui.teleportButton.TextSize = 16
    gui.playerListFrame = Instance.new("ScrollingFrame", gui.teleportPage); gui.playerListFrame.Size = UDim2.new(1, -20, 1, -90); gui.playerListFrame.Position = UDim2.new(0, 10, 0, 90); gui.playerListFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 47); gui.playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242); gui.playerListFrame.ScrollBarThickness = 5
    gui.uiGridLayout = Instance.new("UIGridLayout", gui.playerListFrame); gui.uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5); gui.uiGridLayout.CellSize = UDim2.new(0, 125, 0, 25)
    print("Debug: Halaman Teleport dibuat.")

    gui.clickFlingToggleButton = Instance.new("TextButton", gui.flingPage); gui.clickFlingToggleButton.Name = "ClickFlingToggle"; gui.clickFlingToggleButton.Size = UDim2.new(1, -20, 0, 45); gui.clickFlingToggleButton.Position = UDim2.new(0, 10, 0, 10); gui.clickFlingToggleButton.Font = Enum.Font.SourceSansBold; gui.clickFlingToggleButton.TextSize = 18; gui.clickFlingToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255); gui.clickFlingToggleButton.Text = "AKTIFKAN MODE FLING"; gui.clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    print("Debug: Halaman Fling dibuat.")

    return gui
end)

-- Periksa apakah UI berhasil dibuat
if not success then
    warn("FATAL: Pembuatan UI gagal. Game ini mungkin memiliki sistem keamanan yang sangat ketat. Error: " .. tostring(uiElements))
    return
end

-- Jika berhasil, ambil semua elemen UI dari tabel
local ui = uiElements

-- === LOGIKA DAN FUNGSI (DI LUAR PCALL) ===

-- [FUNGSI FLING YANG DIPERBAIKI]
local function executeFling(targetPart)
    -- Dapatkan model dan pemain dari bagian yang diklik
    local targetModel = targetPart:FindFirstAncestorWhichIsA("Model")
    if not targetModel then return end
    local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
    
    -- Pastikan target adalah pemain yang valid dan bukan pemain lokal
    if not (targetPlayer and targetPlayer ~= localPlayer) then return end
    
    -- Dapatkan HumanoidRootPart dari target dan pemain lokal
    local targetRoot = targetModel:FindFirstChild("HumanoidRootPart")
    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not (targetRoot and localRoot) then
        print("Error: Tidak dapat menemukan HumanoidRootPart untuk target atau pemain lokal.")
        return
    end
    
    print("Mencoba Fling pada " .. targetPlayer.Name .. " dengan metode Velocity...")

    -- Tentukan kekuatan dan arah lemparan (bisa diubah sesuai selera)
    local FLING_POWER = 200    -- Kekuatan lemparan ke depan/belakang
    local UPWARD_FORCE = 100   -- Kekuatan lemparan ke atas

    -- Hitung arah dari pemain kita ke target
    local direction = (targetRoot.Position - localRoot.Position).Unit
    
    -- Terapkan kecepatan ke HumanoidRootPart target.
    -- Ini akan secara langsung melempar pemain ke arah yang dihitung.
    targetRoot.AssemblyLinearVelocity = (direction * FLING_POWER) + Vector3.new(0, UPWARD_FORCE, 0)
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mouse = localPlayer:GetMouse()
        if not mouse then return end
        local target = mouse.Target
        if target then executeFling(target) end
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

ui.clickFlingToggleButton.MouseButton1Click:Connect(function()
    clickFlingActive = not clickFlingActive
    if clickFlingActive then
        activateClickFling()
        ui.clickFlingToggleButton.Text = "MODE FLING AKTIF"
        ui.clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
    else
        deactivateClickFling()
        ui.clickFlingToggleButton.Text = "AKTIFKAN MODE FLING"
        ui.clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    end
end)

local function switchPage(pageName)
    if pageName == "Teleport" then
        ui.teleportPage.Visible = true; ui.flingPage.Visible = false
        ui.navTeleportBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); ui.navTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.navFlingBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); ui.navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    elseif pageName == "Fling" then
        ui.teleportPage.Visible = false; ui.flingPage.Visible = true
        ui.navFlingBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); ui.navFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.navTeleportBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); ui.navTeleportBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end
ui.navTeleportBtn.MouseButton1Click:Connect(function() switchPage("Teleport") end)
ui.navFlingBtn.MouseButton1Click:Connect(function() switchPage("Fling") end)

local function teleportToPlayer(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) then print("Target atau karakter lokal tidak valid.") return end
    if targetPlayer == localPlayer then print("Tidak bisa teleport ke diri sendiri.") return end
    print("Teleportasi ke " .. targetPlayer.Name .. "...")
    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
end

function updatePlayerList()
    for _, c in ipairs(ui.playerListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local btn = Instance.new("TextButton", ui.playerListFrame); btn.Name = p.Name; btn.Text = p.Name; btn.Size = UDim2.new(0, 125, 0, 25); btn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); btn.TextColor3 = Color3.fromRGB(220, 220, 220); btn.Font = Enum.Font.SourceSans; btn.TextSize = 12
            btn.MouseButton1Click:Connect(function() ui.nameTextBox.Text = p.Name end)
        end
    end
    ui.playerListFrame.CanvasSize = UDim2.new(0, 0, 0, ui.uiGridLayout.AbsoluteContentSize.Y)
end

ui.teleportButton.MouseButton1Click:Connect(function() if ui.nameTextBox.Text ~= "" then teleportToPlayer(ui.nameTextBox.Text) end end)
ui.closeButton.MouseButton1Click:Connect(function() ui.screenGui:Destroy(); _G.UniversalMultiToolLoaded_v20 = false end)
local isMinimized = false; local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local originalSize = ui.mainFrame.Size
ui.minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 300, 0, 30) or originalSize
    if isMinimized then ui.minimizeButton.Text = "❐" else ui.minimizeButton.Text = "_" end
    ui.contentHolder.Visible = not isMinimized
    TweenService:Create(ui.mainFrame, tweenInfo, {Size = targetSize}):Play()
end)
local dragging, dragStart, startPos; ui.titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, ui.mainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); ui.titleBar.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; ui.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local function initialize()
    task.wait() -- Penundaan singkat sebelum parenting
    ui.screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    print("Debug: UI berhasil dipasangkan ke PlayerGui.")
    print("GUI Multi-Tool v20.0 berhasil dimuat.")
    updatePlayerList()
    if _G.playerAddedConnection then _G.playerAddedConnection:Disconnect() end
    if _G.playerRemovingConnection then _G.playerRemovingConnection:Disconnect() end
    _G.playerAddedConnection = Players.PlayerAdded:Connect(updatePlayerList)
    _G.playerRemovingConnection = Players.PlayerRemoving:Connect(updatePlayerList)
end

initialize()

localPlayer.CharacterAdded:Connect(function(character)
    print("Karakter baru terdeteksi. Mode Fling telah direset.")
    if clickFlingActive then
        clickFlingActive = false
        deactivateClickFling()
        ui.clickFlingToggleButton.Text = "AKTIFKAN MODE FLING"
        ui.clickFlingToggleButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    end
end)
