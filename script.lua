--[[
    Skrip Universal v8.0 - Teleport & Fling
    
    Pembaruan Fitur (Metode Final):
    - Mengganti total mekanisme Fling dengan metode "Body Mover" yang sangat kuat.
    - Memasang BodyVelocity secara langsung ke target untuk memaksa reaksi fisika.
    - Metode ini didesain untuk keandalan maksimal di berbagai game.
]]

-- Mencegah skrip berjalan dua kali
if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UniversalMultiToolGUI_v8") then
    print("Skrip Multi-Tool v8 sudah berjalan.")
    return
end

print("Memulai Skrip Multi-Tool Universal v8.0 (Metode Final)...")

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Pemain Lokal
local localPlayer = Players.LocalPlayer

-- Variabel Status
local isFlinging = false
local originalPosition
local originalCharacterTransparency = {}

-- Membuat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalMultiToolGUI_v8"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
local originalSize = UDim2.new(0, 300, 0, 320)
mainFrame.Size = originalSize
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37)
mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57)
mainFrame.BorderSizePixel = 1
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

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

-- Area Halaman Fitur
local pagesHolder = Instance.new("Frame", contentHolder); pagesHolder.Size = UDim2.new(1, 0, 0, 40); pagesHolder.Position = UDim2.new(0, 0, 0, 90); pagesHolder.BackgroundTransparency = 1
local teleportPage = Instance.new("Frame", pagesHolder); teleportPage.Size = UDim2.new(1, 0, 1, 0); teleportPage.BackgroundTransparency = 1; teleportPage.Visible = true
local flingPage = Instance.new("Frame", pagesHolder); flingPage.Size = UDim2.new(1, 0, 1, 0); flingPage.BackgroundTransparency = 1; flingPage.Visible = false
local teleportButton = Instance.new("TextButton", teleportPage); teleportButton.Size = UDim2.new(1, -20, 1, -5); teleportButton.Position = UDim2.new(0, 10, 0, 0); teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242); teleportButton.Font = Enum.Font.SourceSansBold; teleportButton.Text = "TELEPORT"; teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255); teleportButton.TextSize = 16
local flingButton = Instance.new("TextButton", flingPage); flingButton.Size = UDim2.new(1, -20, 1, -5); flingButton.Position = UDim2.new(0, 10, 0, 0); flingButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69); flingButton.Font = Enum.Font.SourceSansBold; flingButton.Text = "FLING"; flingButton.TextColor3 = Color3.fromRGB(255, 255, 255); flingButton.TextSize = 16

-- Komponen Bersama
local nameTextBox = Instance.new("TextBox", contentHolder); nameTextBox.Size = UDim2.new(1, -20, 0, 35); nameTextBox.Position = UDim2.new(0, 10, 0, 50); nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47); nameTextBox.PlaceholderText = "Pilih dari daftar atau ketik..."; nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220); nameTextBox.Font = Enum.Font.SourceSans; nameTextBox.TextSize = 14
local playerListFrame = Instance.new("ScrollingFrame", contentHolder); playerListFrame.Size = UDim2.new(1, -20, 1, -140); playerListFrame.Position = UDim2.new(0, 10, 0, 130); playerListFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 47); playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242); playerListFrame.ScrollBarThickness = 5
local uiGridLayout = Instance.new("UIGridLayout", playerListFrame); uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5); uiGridLayout.CellSize = UDim2.new(0, 125, 0, 25)

-- === LOGIKA DAN FUNGSI ===

-- Logika Navbar
local function switchPage(pageName)
    if isFlinging then print("Selesaikan Fling terlebih dahulu!") return end
    if pageName == "Teleport" then
        teleportPage.Visible = true; flingPage.Visible = false
        navTeleportBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); navTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        navFlingBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); navFlingBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    elseif pageName == "Fling" then
        teleportPage.Visible = false; flingPage.Visible = true
        navFlingBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); navFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        navTeleportBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63); navTeleportBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end
navTeleportBtn.MouseButton1Click:Connect(function() switchPage("Teleport") end)
navFlingBtn.MouseButton1Click:Connect(function() switchPage("Fling") end)

-- Fungsi untuk membuat karakter tak terlihat/terlihat
local function setCharacterVisible(character, visible)
    if visible then
        for part, transparency in pairs(originalCharacterTransparency) do if part and part.Parent then part.Transparency = transparency end end
        originalCharacterTransparency = {}
    else
        originalCharacterTransparency = {}
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then originalCharacterTransparency[part] = part.Transparency; part.Transparency = 1 end
        end
    end
end

-- === FUNGSI FLING UTAMA (METODE BODY MOVER) ===
local function handleFling(targetPlayerName)
    local myCharacter = localPlayer.Character
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then print("Karakter lokal tidak valid.") return end
    
    if isFlinging then
        -- === LOGIKA UNTUK STOP FLING ===
        print("Menghentikan Fling dan kembali ke posisi semula...")
        myCharacter.HumanoidRootPart.Anchored = false
        myCharacter.HumanoidRootPart.CFrame = originalPosition
        setCharacterVisible(myCharacter, true)
        
        isFlinging = false
        flingButton.Text = "FLING"
        flingButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    else
        -- === LOGIKA UNTUK MEMULAI FLING ===
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) then print("Target tidak valid untuk di-fling.") return end
        
        print("Memulai Fling pada " .. targetPlayer.Name .. "...")
        
        -- Simpan status & buat tak terlihat
        originalPosition = myCharacter.HumanoidRootPart.CFrame
        setCharacterVisible(myCharacter, false)
        
        -- Teleport & Jangkar
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        myCharacter.HumanoidRootPart.CFrame = targetRoot.CFrame
        myCharacter.HumanoidRootPart.Anchored = true
        
        -- Buat dan pasang "mesin jet" (BodyVelocity) ke target
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(math.random(-200, 200), 1000, math.random(-200, 200)) -- Kecepatan dorongan
        bodyVelocity.P = 50000 -- Agresivitas
        bodyVelocity.Parent = targetRoot
        
        -- Hancurkan "mesin jet" setelah 0.5 detik
        Debris:AddItem(bodyVelocity, 0.5)
        
        isFlinging = true
        flingButton.Text = "STOP FLING"
        flingButton.BackgroundColor3 = Color3.fromRGB(67, 181, 129) -- Warna hijau
    end
end

-- Fungsi Teleport (tidak berubah)
local function teleportToPlayer(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) then print("Target atau karakter lokal tidak valid.") return end
    if targetPlayer == localPlayer then print("Tidak bisa teleport ke diri sendiri.") return end
    print("Teleportasi ke " .. targetPlayer.Name .. "...")
    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
end

-- Fungsi Update Daftar Pemain (tidak berubah)
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

-- Event Listeners
teleportButton.MouseButton1Click:Connect(function() if nameTextBox.Text ~= "" then teleportToPlayer(nameTextBox.Text) end end)
flingButton.MouseButton1Click:Connect(function() if nameTextBox.Text ~= "" or isFlinging then handleFling(nameTextBox.Text) end end)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
local isMinimized = false; local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
minimizeButton.MouseButton1Click:Connect(function() isMinimized = not isMinimized; local targetSize = isMinimized and UDim2.new(0, 300, 0, 30) or originalSize; if isMinimized then minimizeButton.Text = "❐" else minimizeButton.Text = "_" end; contentHolder.Visible = not isMinimized; TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play() end)
local dragging, dragStart, startPos; titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, mainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); titleBar.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Inisialisasi
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
print("GUI Multi-Tool v8.0 (Final) berhasil dimuat.")
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
