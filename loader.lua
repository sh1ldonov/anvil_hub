if not game:IsLoaded() then game.Loaded:Wait() end

local key = "ANVILHUB-JAAQW-1337"
local supportedGameId = "93978595733734"
local scriptUrl = "https://raw.githubusercontent.com/sh1ldonov/anvil_hub/main/vd.lua"

local player = game.Players.LocalPlayer
local placeId = tostring(game.PlaceId)

local savePath = "anvil_key.txt"
local savedKey = pcall(readfile) and isfile(savePath) and readfile(savePath) or ""

local sg = Instance.new("ScreenGui")
sg.Name = "AnvilHubLoader"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 350, 0, 210)
f.Position = UDim2.new(0.5, -175, 0.5, -105)
f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
f.BorderSizePixel = 2
f.BorderColor3 = Color3.fromRGB(255, 170, 0)
f.Active = true
f.Draggable = true

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 0, 35)
t.BackgroundTransparency = 1
t.Text = "ANVIL HUB"
t.TextColor3 = Color3.fromRGB(255, 170, 0)
t.Font = Enum.Font.GothamBold
t.TextSize = 22

local st = Instance.new("TextLabel")
st.Size = UDim2.new(1, 0, 0, 20)
st.Position = UDim2.new(0, 0, 0, 32)
st.BackgroundTransparency = 1
st.Text = "введи ключ доступа"
st.TextColor3 = Color3.fromRGB(180, 180, 180)
st.Font = Enum.Font.Gotham
st.TextSize = 13

local tb = Instance.new("TextBox")
tb.Size = UDim2.new(0, 300, 0, 36)
tb.Position = UDim2.new(0.5, -150, 0, 60)
tb.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
tb.BorderColor3 = Color3.fromRGB(255, 170, 0)
tb.PlaceholderText = "ключ..."
tb.Text = savedKey
tb.TextColor3 = Color3.fromRGB(255, 255, 255)
tb.Font = Enum.Font.Gotham
tb.TextSize = 16
tb.ClearTextOnFocus = false

local bn = Instance.new("TextButton")
bn.Size = UDim2.new(0, 160, 0, 40)
bn.Position = UDim2.new(0.5, -80, 0, 110)
bn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
bn.BorderSizePixel = 0
bn.Text = "ЗАГРУЗИТЬ"
bn.TextColor3 = Color3.fromRGB(20, 20, 20)
bn.Font = Enum.Font.GothamBold
bn.TextSize = 16

local sl = Instance.new("TextLabel")
sl.Size = UDim2.new(1, 0, 0, 25)
sl.Position = UDim2.new(0, 0, 0, 160)
sl.BackgroundTransparency = 1
sl.Text = ""
sl.TextColor3 = Color3.fromRGB(255, 100, 100)
sl.Font = Enum.Font.Gotham
sl.TextSize = 13

local cl = Instance.new("TextButton")
cl.Size = UDim2.new(0, 20, 0, 20)
cl.Position = UDim2.new(1, -25, 0, 5)
cl.BackgroundTransparency = 1
cl.Text = "X"
cl.TextColor3 = Color3.fromRGB(150, 150, 150)
cl.Font = Enum.Font.Gotham
cl.TextSize = 14
cl.TextScaled = true

cl.Parent = f
t.Parent = f
st.Parent = f
tb.Parent = f
bn.Parent = f
sl.Parent = f
f.Parent = sg
sg.Parent = player:WaitForChild("PlayerGui")

local function fetch(url)
    local success, result = pcall(game.HttpGetAsync, game, url)
    if success then return result end
    success, result = pcall(function() return syn.request({Url = url, Method = "GET"}).Body end)
    if success then return result end
    success, result = pcall(function() return request({Url = url, Method = "GET"}).Body end)
    if success then return result end
    return nil
end

cl.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

bn.MouseButton1Click:Connect(function()
    local input = tb.Text:gsub("%s+", "")
    if input ~= key then
        sl.Text = "неверный ключ"
        sl.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    if placeId ~= supportedGameId then
        player:Kick("not supported game anvil hub")
        return
    end
    pcall(writefile, savePath, input)
    sl.Text = "загрузка..."
    sl.TextColor3 = Color3.fromRGB(100, 255, 100)
    local code = fetch(scriptUrl)
    if code then
        local good, fn = pcall(loadstring, code)
        if good then
            sg:Destroy()
            pcall(fn)
        else
            player:Kick("script error: " .. tostring(fn))
        end
    else
        sl.Text = "ошибка загрузки"
        sl.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
