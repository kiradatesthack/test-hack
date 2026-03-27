-- Headlock Aimbot + ESP for Mobile (Delta) 2026
local aimbotEnabled = false
local ESPEnabled = true
local Key = Enum.KeyCode.Q          -- Giữ Q để bám đầu (hoặc toggle nếu muốn)
local Hitpart = "Head"              -- "Head" hoặc "HumanoidRootPart"
local Smoothness = 0.25             -- 0.1 = bám cứng, 0.4 = mượt hơn
local FOV = 120                     -- Bán kính tìm mục tiêu

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ================== ESP ==================
local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder"
espFolder.Parent = game.CoreGui

local function createESP(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    
    local name = Drawing.new("Text")
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if ESPEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
            local root = plr.Character.HumanoidRootPart
            local head = plr.Character.Head
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            
            local pos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local top = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                local bottom = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                
                local height = bottom.Y - top.Y
                box.Size = Vector2.new(height / 2, height)
                box.Position = Vector2.new(pos.X - box.Size.X / 2, top.Y)
                box.Visible = true
                
                name.Text = plr.Name .. " [" .. math.floor(humanoid.Health) .. "]"
                name.Position = Vector2.new(pos.X, top.Y - 20)
                name.Visible = true
            else
                box.Visible = false
                name.Visible = false
            end
        else
            box.Visible = false
            name.Visible = false
        end
    end)
end

for _, plr in ipairs(game.Players:GetPlayers()) do
    createESP(plr)
end
game.Players.PlayerAdded:Connect(createESP)

-- ================== HEADLOCK AIMBOT ==================
local target = nil

local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local mousePos = UIS:GetMouseLocation()
    
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr \~= player and plr.Character and plr.Character:FindFirstChild(Hitpart) then
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local partPos = plr.Character[Hitpart].Position
                local screenPos, onScreen = camera:WorldToViewportPoint(partPos)
                
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < FOV and dist < shortest then
                        closest = plr
                        shortest = dist
                    end
                end
            end
        end
    end
    return closest
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Key then
        aimbotEnabled = not aimbotEnabled  -- Toggle hoặc giữ cũng được
        print("Headlock: " .. (aimbotEnabled and "ON" or "OFF"))
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Hitpart) then
            local targetPos = camera:WorldToViewportPoint(target.Character[Hitpart].Position)
            local currentPos = UIS:GetMouseLocation()
            
            local deltaX = (targetPos.X - currentPos.X) * Smoothness
            local deltaY = (targetPos.Y - currentPos.Y) * Smoothness
            
            mousemoverel(deltaX, deltaY)
        end
    end
end)

print("✅ Headlock Aimbot + ESP loaded! Giữ/toggle Q để bám đầu | ESP tự động bật")
