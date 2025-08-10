--[[
    Skrip Teleportasi Universal v2.0
    Didesain untuk kompatibilitas maksimal di berbagai game Roblox.
    
    Fitur:
    - Struktur GUI yang benar (menggunakan ScreenGui).
    - Fungsi geser (drag) kustom yang andal.
    - Tidak hilang saat respawn.
    - Tombol tutup.
    - Pesan diagnostik untuk debugging.
]]

-- Mencegah skrip berjalan dua kali
if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("UniversalTeleportGUI") then
    print("Skrip Teleportasi sudah berjalan.")
    return
end

print("Memulai Skrip Teleportasi Universal v2.0...")

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Pemain Lokal
local localPlayer = Players.LocalPlayer
if not localPlayer then
    warn("Gagal mendapatkan pemain lokal.")
    return
end

-- Membuat ScreenGui (Wadah Utama UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalTeleportGUI"
screenGui.ResetOnSpawn = false -- Agar tidak hilang saat mati/respawn
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 130)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37)
mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57)
mainFrame.BorderSizePixel = 1
mainFrame.Parent = screenGui

-- Membuat Title Bar (Untuk Judul dan Dragging)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -30, 1, 0)
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

-- TextBox untuk Input Nama
local nameTextBox = Instance.new("TextBox")
nameTextBox.Name = "PlayerNameTextBox"
nameTextBox.Size = UDim2.new(1, -20, 0, 35)
nameTextBox.Position = UDim2.new(0, 10, 0, 40)
nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
nameTextBox.BorderSizePixel = 0
nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
nameTextBox.PlaceholderText = "Ketik nama pemain..."
nameTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
nameTextBox.Font = Enum.Font.SourceSans
nameTextBox.TextSize = 14
nameTextBox.ClearTextOnFocus = false
nameTextBox.Parent = mainFrame

-- Tombol Teleport
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -20, 0, 35)
teleportButton.Position = UDim2.new(0, 10, 0, 85)
teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
teleportButton.BorderSizePixel = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Text = "TELEPORT"
teleportButton.TextSize = 16
teleportButton.Parent = mainFrame

-- Fungsi Teleportasi
local function teleportToPlayer(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not targetPlayer then
        print("Pemain tidak ditemukan: " .. targetPlayerName)
        return
    end
    if targetPlayer == localPlayer then
        print("Anda tidak bisa teleport ke diri sendiri.")
        return
    end

    local localCharacter = localPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (localCharacter and targetCharacter and localCharacter:FindFirstChild("HumanoidRootPart") and targetCharacter:FindFirstChild("HumanoidRootPart")) then
        print("Karakter tidak valid atau tidak ditemukan.")
        return
    end
    
    print("Mencoba teleportasi ke " .. targetPlayer.Name .. "...")
    localCharacter.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    print("Teleportasi berhasil.")
end

-- Event Listeners
teleportButton.MouseButton1Click:Connect(function()
    if nameTextBox.Text ~= "" then
        teleportToPlayer(nameTextBox.Text)
    else
        print("Nama pemain tidak boleh kosong.")
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("UI Teleportasi ditutup.")
end)

-- Fungsi Drag Kustom
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

-- Menempatkan GUI ke pemain
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
print("GUI Teleportasi berhasil dimuat ke PlayerGui.")
