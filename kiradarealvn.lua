-- Auto Server Hopper với GUI nút Click
-- Tạo bởi Grok - Dùng cho Roblox Executor

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlaceId = game.PlaceId
local currentJobId = game.JobId

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoServerHopper"
ScreenGui.Parent = game:GetService("CoreGui")  -- hoặc LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Auto Tìm Server"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 45)
Status.BackgroundTransparency = 1
Status.Text = "Trạng thái: Sẵn sàng"
Status.TextColor3 = Color3.fromRGB(0, 255, 100)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = Frame

-- Nút Start Auto
local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.9, 0, 0, 40)
StartButton.Position = UDim2.new(0.05, 0, 0, 85)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
StartButton.Text = "BẮT ĐẦU AUTO HOP"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextScaled = true
StartButton.Font = Enum.Font.GothamBold
StartButton.Parent = Frame

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 6)
StartCorner.Parent = StartButton

-- Nút Stop
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.9, 0, 0, 30)
StopButton.Position = UDim2.new(0.05, 0, 0, 135)
StopButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
StopButton.Text = "DỪNG AUTO"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextScaled = true
StopButton.Font = Enum.Font.Gotham
StopButton.Parent = Frame

local isRunning = false

local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success then
        return response
    end
    return nil
end

local function hopToServer(jobId)
    if jobId == currentJobId then return end
    Status.Text = "Đang hop server..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
    end)
end

local function autoHop()
    while isRunning do
        Status.Text = "Đang quét server..."
        Status.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local cursor = nil
        local found = false
        
        repeat
            local servers = getServers(cursor)
            if servers and servers.data then
                for _, server in ipairs(servers.data) do
                    if server.playing < server.maxPlayers and server.id \~= currentJobId then
                        -- Có thể thêm điều kiện tìm "hack" ở đây (ví dụ: server có ít người hoặc nhiều người)
                        -- Hiện tại hop random server không full
                        hopToServer(server.id)
                        found = true
                        wait(3) -- đợi hop
                        break
                    end
                end
                cursor = servers.nextPageCursor
            else
                break
            end
            wait(0.5)
        until not cursor or found or not isRunning
        
        if not found then
            Status.Text = "Không tìm thấy server phù hợp, thử lại sau..."
            wait(5)
        end
        wait(2)
    end
end

StartButton.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        Status.Text = "Auto đang chạy..."
        Status.TextColor3 = Color3.fromRGB(0, 255, 100)
        StartButton.Text = "ĐANG CHẠY..."
        spawn(autoHop)
    end
end)

StopButton.MouseButton1Click:Connect(function()
    isRunning = false
    Status.Text = "Đã dừng auto"
    Status.TextColor3 = Color3.fromRGB(255, 100, 100)
    StartButton.Text = "BẮT ĐẦU AUTO HOP"
end)

print("Auto Server Hopper GUI đã load thành công!")
