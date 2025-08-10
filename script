--[[
    Skrip Teleportasi Pemain (Versi Loadstring)
    Dibuat untuk dieksekusi melalui exploit executor.
    Skrip ini akan membuat UI-nya sendiri secara dinamis.
]]

-- Mencegah skrip berjalan lebih dari sekali dan membuat UI duplikat
if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("TeleportUI_Frame") then
    return
end

-- Mendapatkan Service dan pemain lokal
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Membuat elemen-elemen UI
local mainFrame = Instance.new("Frame")
local nameTextBox = Instance.new("TextBox")
local teleportButton = Instance.new("TextButton")
local titleLabel = Instance.new("TextLabel")

-- Konfigurasi Main Frame (wadah utama UI)
mainFrame.Name = "TeleportUI_Frame"
mainFrame.Size = UDim2.new(0, 300, 0, 120) -- Ukuran frame
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -60) -- Posisi di tengah layar
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Warna latar belakang gelap
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Memungkinkan frame digeser
mainFrame.Draggable = true -- Membuat frame bisa digeser-geser
mainFrame.Parent = playerGui

-- Konfigurasi Title Label (Judul UI)
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleLabel.BorderSizePixel = 0
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Teleport ke Pemain"
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Konfigurasi TextBox (untuk input nama pemain)
nameTextBox.Name = "PlayerNameTextBox"
nameTextBox.Size = UDim2.new(1, -20, 0, 30)
nameTextBox.Position = UDim2.new(0.5, -140, 0, 45)
nameTextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
nameTextBox.BorderSizePixel = 0
nameTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameTextBox.PlaceholderText = "Ketik nama pemain..."
nameTextBox.Font = Enum.Font.SourceSans
nameTextBox.TextSize = 14
nameTextBox.ClearTextOnFocus = false
nameTextBox.Parent = mainFrame

-- Konfigurasi TextButton (tombol untuk teleport)
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0.5, -140, 0, 80)
teleportButton.BackgroundColor3 = Color3.fromRGB(85, 85, 255)
teleportButton.BorderSizePixel = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Text = "TELEPORT"
teleportButton.TextSize = 16
teleportButton.Parent = mainFrame

-- Fungsi untuk melakukan teleportasi
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
    
    if not localCharacter or not targetCharacter then
        print("Karakter tidak ditemukan.")
        return
    end
    
    local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
    local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRootPart or not targetRootPart then
        print("HumanoidRootPart tidak ditemukan.")
        return
    end
    
    print("Teleportasi ke " .. targetPlayer.Name .. "...")
    localRootPart.CFrame = targetRootPart.CFrame + Vector3.new(0, 5, 0)
end

-- Menghubungkan fungsi ke event klik pada tombol
teleportButton.MouseButton1Click:Connect(function()
    local playerName = nameTextBox.Text
    if playerName and playerName ~= "" then
        teleportToPlayer(playerName)
    else
        print("Silakan masukkan nama pemain terlebih dahulu.")
    end
end)

print("UI Teleportasi berhasil dimuat.")
