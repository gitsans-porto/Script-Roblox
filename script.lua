--[[
    Skrip Teleportasi Universal v3.0
    Didesain untuk kompatibilitas maksimal dan kenyamanan pengguna.
    
    Fitur Baru:
    - Tombol Minimize/Maximize untuk menyembunyikan/menampilkan UI.
    - Animasi transisi yang mulus saat minimize/maximize.
    - Struktur kode yang lebih rapi.
]]

-- Mencegah skrip berjalan dua kali
if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UniversalTeleportGUI_v3") then
    print("Skrip Teleportasi v3 sudah berjalan.")
    return
end

print("Memulai Skrip Teleportasi Universal v3.0...")

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Pemain Lokal
local localPlayer = Players.LocalPlayer

-- Membuat ScreenGui (Wadah Utama UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalTeleportGUI_v3"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
local originalSize = UDim2.new(0, 300, 0, 130) -- Simpan ukuran asli
mainFrame.Size = originalSize
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37)
mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57)
mainFrame.BorderSizePixel = 1
mainFrame.ClipsDescendants = true -- Penting untuk animasi
mainFrame.Parent = screenGui

-- Membuat Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0) -- Beri ruang untuk tombol
titleLabel.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
titleLabel.BorderSizePixel = 0
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansSemibold
titleLabel.Text = "Teleport"
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

-- Tombol Tutup (Close Button)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = titleBar.BackgroundColor3
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 20
closeButton.Parent = titleBar

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -60, 0, 0) -- Posisikan di sebelah tombol close
minimizeButton.BackgroundColor3 = titleBar.BackgroundColor3
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Text = "_" -- Simbol minimize
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

-- Konten di dalam Frame (TextBox dan Tombol Teleport)
local contentHolder = Instance.new("Frame")
contentHolder.Name = "ContentHolder"
contentHolder.Size = UDim2.new(1, 0, 1, -30)
contentHolder.Position = UDim2.new(0, 0, 0, 30)
contentHolder.BackgroundTransparency = 1
contentHolder.BorderSizePixel = 0
contentHolder.Parent = mainFrame

local nameTextBox = Instance.new("TextBox")
nameTextBox.Name = "PlayerNameTextBox"
nameTextBox.Size = UDim2.new(1, -20, 0, 35)
nameTextBox.Position = UDim2.new(0, 10, 0, 10)
nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
nameTextBox.BorderSizePixel = 0
nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
nameTextBox.PlaceholderText = "Ketik nama pemain..."
nameTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
nameTextBox.Font = Enum.Font.SourceSans
nameTextBox.TextSize = 14
nameTextBox.ClearTextOnFocus = false
nameTextBox.Parent = contentHolder

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -20, 0, 35)
teleportButton.Position = UDim2.new(0, 10, 0, 55)
teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
teleportButton.BorderSizePixel = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Text = "TELEPORT"
teleportButton.TextSize = 16
teleportButton.Parent = contentHolder

-- Logika dan Fungsi
local isMinimized = false
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Fungsi Minimize/Maximize
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    local targetSize
    if isMinimized then
        targetSize = UDim2.new(0, 300, 0, 30) -- Ukuran title bar saja
        minimizeButton.Text = "❐" -- Simbol maximize
        contentHolder.Visible = false
    else
        targetSize = originalSize
        minimizeButton.Text = "_" -- Simbol minimize
        contentHolder.Visible = true
    end
    
    local sizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    sizeTween:Play()
end)

-- Fungsi Teleportasi (tidak berubah)
local function teleportToPlayer(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not targetPlayer then print("Pemain tidak ditemukan: " .. targetPlayerName) return end
    if targetPlayer == localPlayer then print("Anda tidak bisa teleport ke diri sendiri.") return end
    local localCharacter = localPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (localCharacter and targetCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and targetCharacter:FindFirstChild("HumanoidRootPart")) then print("Karakter tidak valid.") return end
    print("Teleportasi ke " .. targetPlayer.Name .. "...")
    localCharacter.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    print("Teleportasi berhasil.")
end

-- Event Listeners
teleportButton.MouseButton1Click:Connect(function()
    if nameTextBox.Text ~= "" then teleportToPlayer(nameTextBox.Text) else print("Nama pemain tidak boleh kosong.") end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("UI Teleportasi ditutup.")
end)

-- Fungsi Drag Kustom (tidak berubah)
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Menempatkan GUI ke pemain
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
print("GUI Teleportasi v3.0 berhasil dimuat.")
