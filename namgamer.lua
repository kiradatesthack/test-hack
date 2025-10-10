local gameId = game.PlaceId
local supportedGames = {
    [2753915549] = "Blox Fruits",
    [1234567890] = "99 Nights" -- Replace with the actual PlaceId of 99 Nights
}
if not supportedGames[gameId] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Warning",
        Text = "This game may not support all scripts. Try and check!",
        Duration = 10
    })
end

-- Load UI
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)

-- Intro animation with image
local function createIntroAnimation()
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local ContentProvider = game:GetService("ContentProvider")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "IntroGui"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "nấm gamer\nAuthor: nấm gamer\nCreated & written by: nấm gamer & hiếu tv 124"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0, 100, 0, 100)
    imageLabel.Position = UDim2.new(0.5, -50, 0.6, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://75676578090181"
    imageLabel.ImageTransparency = 1
    imageLabel.Parent = frame

    pcall(function()
        ContentProvider:PreloadAsync({"rbxassetid://75676578090181"})
    end)

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local fadeInText = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0})
    local fadeInFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.2})
    local fadeInImage = TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 0})

    local fadeOutText = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})
    local fadeOutFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
    local fadeOutImage = TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 1})

    fadeInText:Play()
    fadeInFrame:Play()
    fadeInImage:Play()
    fadeInText.Completed:Wait()

    wait(5)

    fadeOutText:Play()
    fadeOutFrame:Play()
    fadeOutImage:Play()
    fadeOutText.Completed:Wait()

    screenGui:Destroy()
end
createIntroAnimation()

-- Create UI
local Window = MakeWindow({
    Hub = {Title = "nấm gamer", Animation = "tiktok: nấm gamer"},
    Key = {KeySystem = false, Title = "Key System", Keys = {"1234"}, Notifi = {Notifications = true, CorrectKey = "Running the Script...", Incorrectkey = "The key is incorrect", CopyKeyLink = "Copied to Clipboard"}}
})

-- Preload logo
pcall(function()
    game:GetService("ContentProvider"):PreloadAsync({"rbxassetid://89326205091486"})
end)

MinimizeButton({
    Image = "rbxassetid://89326205091486",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

-- Function to add script buttons
local function addScriptButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            local success, err = pcall(function()
                local scriptContent = game:HttpGet(url)
                loadstring(scriptContent)()
            end)
            if not success then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Failed to run script " .. name .. ": " .. tostring(err),
                    Duration = 5
                })
            end
        end
    })
end

-- Tab: Blox Fruit
local Tab1o = MakeTab({Name = "Blox Fruit"})
addScriptButton(Tab1o, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
addScriptButton(Tab1o, "H4X Script", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
addScriptButton(Tab1o, "Nat Hub", "https://get.nathub.xyz/loader")
addScriptButton(Tab1o, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
addScriptButton(Tab1o, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
addScriptButton(Tab1o, "OMG HUB server vip free (getkey)", "https://pastefy.app/US0MtPIY/raw")
addScriptButton(Tab1o, "Reduce Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")

-- Tab: Hop Server
local Tab2o = MakeTab({Name = "Hop Server"})
addScriptButton(Tab2o, "Teddy Hub (getkey)", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")

-- Tab: 99 Nights
local Tab3o = MakeTab({Name = "99 Nights"})
addScriptButton(Tab3o, "NATHUB (getkey)", "https://get.nathub.xyz/loader")
addScriptButton(Tab3o, "H4X (getkey)", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
addScriptButton(Tab3o, "Speed Hub (getkey)", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
addScriptButton(Tab3o, "Diamond Farm Hack", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
addScriptButton(Tab3o, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")

-- Tab: Key System
local Tab5o = MakeTab({Name = "Key System"})
AddButton(Tab5o, {
    Name = "Copy Speed Hub Key",
    Callback = function()
        local success, err = pcall(function()
            setclipboard("KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")
        end)
        if not success then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Failed to copy Speed Hub key: " .. tostring(err),
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Key System",
                Text = "Speed Hub key has been copied to clipboard! Source: YouTube EZ AK Gaming",
                Duration = 10
            })
        end
    end
})

-- Tab: Social Media
local Tab4o = MakeTab({Name = "Social Media"})
local function addLinkButton(tab, name, url, platform)
    AddButton(tab, {
        Name = name,
        Callback = function()
            local success, err = pcall(function()
                setclipboard(url)
            end)
            if not success then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Failed to copy " .. platform .. " link: " .. tostring(err),
                    Duration = 5
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = platform,
                    Text = "Copied " .. platform .. " link to clipboard!",
                    Duration = 5
                })
            end
        end
    })
end
addLinkButton(Tab4o, "Copy Discord Link", "https://discord.gg/kJ9ydA2PP4", "Discord")
addLinkButton(Tab4o, "Copy TikTok Link", "https://www.tiktok.com/@namgamer082", "TikTok")

-- Wait until game is loaded
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer.PlayerGui
