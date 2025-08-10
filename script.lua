--[[
    Skrip Teleportasi Universal v4.1
    
    Perbaikan Bug:
    - Memperbaiki masalah di mana daftar pemain hanya menampilkan maksimal 10 pemain.
    - Sekarang secara dinamis mengatur CanvasSize dari ScrollingFrame untuk memastikan semua pemain di server terlihat.
]]

-- Mencegah skrip berjalan dua kali
if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UniversalTeleportGUI_v4_1") then
    print("Skrip Teleportasi v4.1 sudah berjalan.")
    return
end

print("Memulai Skrip Teleportasi Universal v4.1...")

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Pemain Lokal
local localPlayer = Players.LocalPlayer

-- Membuat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalTeleportGUI_v4_1"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
local originalSize = UDim2.new(0, 300, 0, 280)
mainFrame.Size = originalSize
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 37)
mainFrame.BorderColor3 = Color3.fromRGB(48, 51, 57)
mainFrame.BorderSizePixel = 1
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Membuat Title Bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(48, 51, 57)
titleBar.BorderSizePixel = 0

-- (Isi dari Title Bar)
local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -60, 1, 0); titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundColor3 = titleBar.BackgroundColor3; titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.SourceSansSemibold; titleLabel.Text = "Teleport"; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16; titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 30, 1, 0); closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = titleBar.BackgroundColor3; closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.SourceSansBold; closeButton.Text = "X"; closeButton.TextColor3 = Color3.fromRGB(200, 200, 200); closeButton.TextSize = 20

local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 30, 1, 0); minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = titleBar.BackgroundColor3; minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSansBold; minimizeButton.Text = "_"; minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200); minimizeButton.TextSize = 20

-- Konten di dalam Frame
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Name = "ContentHolder"
contentHolder.Size = UDim2.new(1, 0, 1, -30)
contentHolder.Position = UDim2.new(0, 0, 0, 30)
contentHolder.BackgroundTransparency = 1

local nameTextBox = Instance.new("TextBox", contentHolder)
nameTextBox.Size = UDim2.new(1, -20, 0, 35); nameTextBox.Position = UDim2.new(0, 10, 0, 10)
nameTextBox.BackgroundColor3 = Color3.fromRGB(40, 42, 47); nameTextBox.BorderSizePixel = 0
nameTextBox.TextColor3 = Color3.fromRGB(220, 220, 220); nameTextBox.PlaceholderText = "Pilih dari daftar atau ketik..."
nameTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); nameTextBox.Font = Enum.Font.SourceSans
nameTextBox.TextSize = 14; nameTextBox.ClearTextOnFocus = false

local teleportButton = Instance.new("TextButton", contentHolder)
teleportButton.Size = UDim2.new(1, -20, 0, 35); teleportButton.Position = UDim2.new(0, 10, 0, 55)
teleportButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242); teleportButton.BorderSizePixel = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255); teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Text = "TELEPORT"; teleportButton.TextSize = 16

-- Daftar Pemain
local playerListFrame = Instance.new("ScrollingFrame", contentHolder)
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, -20, 1, -105)
playerListFrame.Position = UDim2.new(0, 10, 0, 100)
playerListFrame.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
playerListFrame.ScrollBarThickness = 5

local uiGridLayout = Instance.new("UIGridLayout", playerListFrame)
uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
uiGridLayout.CellSize = UDim2.new(0, 125, 0, 25)
uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi untuk memperbarui daftar pemain
function updatePlayerList()
    for _, child in ipairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local playerButton = Instance.new("TextButton", playerListFrame)
            playerButton.Name = player.Name; playerButton.Text = player.Name
            playerButton.Size = UDim2.new(0, 125, 0, 25)
            playerButton.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            playerButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            playerButton.Font = Enum.Font.SourceSans; playerButton.TextSize = 12
            playerButton.MouseButton1Click:Connect(function()
                nameTextBox.Text = player.Name
            end)
        end
    end
    
    -- === PERBAIKAN KRUSIAL ADA DI SINI ===
    -- Mengatur ukuran kanvas scroll agar sesuai dengan konten di dalamnya.
    -- Tanpa ini, daftar akan terpotong dan tidak bisa digulir.
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, uiGridLayout.AbsoluteContentSize.Y)
end

-- === Logika dan Fungsi Lainnya (Tidak Berubah) ===
local isMinimized = false
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 300, 0, 30) or originalSize
    if isMinimized then minimizeButton.Text = "❐" else minimizeButton.Text = "_" end
    contentHolder.Visible = not isMinimized
    TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
end)

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

teleportButton.MouseButton1Click:Connect(function() if nameTextBox.Text ~= "" then teleportToPlayer(nameTextBox.Text) else print("Nama pemain tidak boleh kosong.") end end)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy(); print("UI Teleportasi ditutup.") end)

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, mainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
titleBar.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Menempatkan GUI dan Memulai Pembaruan Daftar Pemain
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
print("GUI Teleportasi v4.1 berhasil dimuat.")
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
