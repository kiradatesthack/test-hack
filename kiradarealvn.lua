-- SAYGEX MENU for Mobile Delta 🗿
local Library = {}
local MenuOpen = true

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SaygexMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner bo tròn
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Tiêu đề SAYGEX
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "🗿 SAYGEX MENU 🗿"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Nút đóng menu (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    print("Saygex menu closed 🗿")
end)

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 60)
Status.BackgroundTransparency = 1
Status.Text = "Headlock: OFF | ESP: ON"
Status.TextColor3 = Color3.fromRGB(0, 255, 100)
Status.TextScaled = true
Status.Parent = MainFrame

-- ================== TOGGLE BUTTONS ==================
local function CreateToggle(name, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 50)
    Btn.Position = UDim2.new(0.05, 0, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Btn
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 60)
        callback(enabled)
        Status.Text = "Headlock: " .. (aimbotEnabled and "ON" or "OFF") .. " | ESP: " .. (ESPEnabled and "ON" or "OFF")
    end)
end

-- Variables
local aimbotEnabled = false
local ESPEnabled = true
local Hitpart = "Head"
local Smoothness = 0.25
local FOV = 120

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Toggle Headlock
CreateToggle("Headlock Aimbot (Toggle)", 100, function(state)
    aimbotEnabled = state
end)

-- Toggle ESP
CreateToggle("ESP Box + Name", 160, function(state)
    ESPEnabled = state
end)

-- ================== ESP Code (giữ nguyên như trước) ==================
local espFolder = Instance.new("Folder")
espFolder.Name = "SaygexESP"
espFolder.Parent = game.CoreGui

local function createESP(plr)
    if plr == player then return end
    -- (code ESP Drawing giống script cũ, tao rút gọn để ngắn)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Color = Color3.fromRGB(255, 0, 100)
    
    local nameTag = Drawing.new("Text")
    nameTag.Size = 15
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.new(1,1,1)
    
    RunService.RenderStepped:Connect(function()
        if ESPEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if head and hum then
                local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local top = camera:WorldToViewportPoint(head.Position + Vector3.new(0,2,0))
                    local bottom = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                    local height = bottom.Y - top.Y
                    
                    box.Size = Vector2.new(height/2, height)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, top.Y)
                    box.Visible = true
                    
                    nameTag.Text = plr.Name .. " [" .. math.floor(hum.Health) .. "]"
                    nameTag.Position = Vector2.new(pos.X, top.Y - 25)
                    nameTag.Visible = true
                else
                    box.Visible = false
                    nameTag.Visible = false
                end
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

for _, plr in game.Players:GetPlayers() do createESP(plr) end
game.Players.PlayerAdded:Connect(createESP)

-- ================== Headlock Aimbot ==================
local target = nil

local function getClosest()
    local closest, dist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, plr in game.Players:GetPlayers() do
        if plr \~= player and plr.Character and plr.Character:FindFirstChild(Hitpart) then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(plr.Character[Hitpart].Position)
                if onScreen then
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if d < FOV and d < dist then
                        closest = plr
                        dist = d
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getClosest()
        if target and target.Character and target.Character:FindFirstChild(Hitpart) then
            local tPos = camera:WorldToViewportPoint(target.Character[Hitpart].Position)
            local mPos = UIS:GetMouseLocation()
            mousemoverel((tPos.X - mPos.X) * Smoothness, (tPos.Y - mPos.Y) * Smoothness)
        end
    end
end)

print("🗿 SAYGEX MENU loaded successfully! Menu sẽ hiện ngay khi execute.")
