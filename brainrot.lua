if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local camera = ws.CurrentCamera

local espEnabled = false
local espShowNames = false
local espShowDistance = false
local tracersEnabled = false
local speedKey = Enum.KeyCode.V
local speedAmount = 100
local walkSpeedEnabled = false
local walkSpeed = 16
local jumpPowerEnabled = false
local jumpPower = 50
local noclipEnabled = false
local autoFarmEnabled = false
local autoStealEnabled = false
local antiAfkEnabled = false
local fpsBoostEnabled = false
local isUnloaded = false
local connections = {}
local espCache = {}
local espBillboards = {}
local fpsBoostApplied = false

local ts = game:GetService("TweenService")
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "AnvilNotifs"; notifGui.ResetOnSpawn = false
pcall(function() notifGui.Parent = player:WaitForChild("PlayerGui") end)

local function notify(text, color)
    pcall(function()
        color = color or Color3.fromRGB(0,150,255)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0,300,0,42); f.Position = UDim2.new(1,20,0,-60)
        f.BackgroundColor3 = Color3.fromRGB(22,22,22); f.BackgroundTransparency = 1
        f.BorderSizePixel = 0; f.Parent = notifGui
        local corner = Instance.new("UICorner", f); corner.CornerRadius = UDim.new(0,6)
        local stroke = Instance.new("UIStroke", f)
        stroke.Color = Color3.fromRGB(40,40,40); stroke.Thickness = 1; stroke.Transparency = 1
        local bar = Instance.new("Frame", f)
        bar.Size = UDim2.new(0,3,0.6,0); bar.Position = UDim2.new(0,0,0.2,0)
        bar.BorderSizePixel = 0; bar.BackgroundColor3 = color; bar.BackgroundTransparency = 1
        local barCorner = Instance.new("UICorner", bar); barCorner.CornerRadius = UDim.new(0,2)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1,-20,1,0); lbl.Position = UDim2.new(0,16,0,0)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Text = text; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t1 = ts:Create(f, ti, {Position = UDim2.new(1,-320,0,20), BackgroundTransparency = 0})
        local t2 = ts:Create(stroke, ti, {Transparency = 0})
        local t3 = ts:Create(bar, ti, {BackgroundTransparency = 0})
        t1:Play(); t2:Play(); t3:Play()
        t1.Completed:Connect(function()
            task.wait(2.5)
            local to = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local t4 = ts:Create(f, to, {Position = UDim2.new(1,20,0,-60), BackgroundTransparency = 1})
            local t5 = ts:Create(stroke, to, {Transparency = 1})
            local t6 = ts:Create(bar, to, {BackgroundTransparency = 1})
            t4:Play(); t5:Play(); t6:Play()
            t4.Completed:Connect(function() pcall(function() f:Destroy() end) end)
            task.delay(0.5, function() pcall(function() f:Destroy() end) end)
        end)
    end)
end

local function espColor(target, color, cache)
    local h = cache[target]
    if not h then
        h = Instance.new("Highlight"); h.Parent = target; h.FillTransparency = 0.4
        h.OutlineColor = Color3.fromRGB(255,255,255); h.OutlineTransparency = 0; h.Enabled = false; cache[target] = h
    end
    h.FillColor = color; h.Enabled = true
end

local function updateESP()
    if not espEnabled then
        for _, h in pairs(espCache) do h.Enabled = false end
        for _, b in pairs(espBillboards) do pcall(function() b:Destroy() end) end; espBillboards = {}; return
    end
    local char, root = player.Character, player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local c = plr.Character; espColor(c, Color3.fromRGB(255,170,0), espCache)
            if (espShowDistance or espShowNames) and root then
                local cr = c:FindFirstChild("HumanoidRootPart")
                if cr then
                    local b = espBillboards[c]
                    if not b then
                        b = Instance.new("BillboardGui"); b.Parent = c; b.Size = UDim2.new(0,100,0,20)
                        b.StudsOffset = Vector3.new(0,3,0); b.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel"); lbl.Parent = b; lbl.Size = UDim2.new(1,0,1,0)
                        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1); lbl.TextStrokeTransparency = 0.5
                        lbl.Font = Enum.Font.SourceSansBold; lbl.TextScaled = true; espBillboards[c] = b
                    end
                    local dist = math.floor((cr.Position - root.Position).Magnitude)
                    local lbl = b:FindFirstChildOfClass("TextLabel")
                    if lbl then
                        local txt = ""; if espShowNames then txt = plr.Name end
                        if espShowDistance then if txt ~= "" then txt = txt .. " " end; txt = txt .. "[" .. dist .. "m]" end
                        lbl.Text = txt
                    end
                end
            else local b = espBillboards[c]; if b then b:Destroy(); espBillboards[c] = nil end end
        end
    end
    for t, h in pairs(espCache) do if not t.Parent then h:Destroy(); espCache[t] = nil end end
    for t, b in pairs(espBillboards) do if not t.Parent then b:Destroy(); espBillboards[t] = nil end end
end

local tracersObjs = {}
local function updateTracers()
    if not tracersEnabled then for _, t in pairs(tracersObjs) do pcall(function() t:Remove() end) end; tracersObjs = {}; return end
    local targets = {}; local char = player.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then local cr = plr.Character:FindFirstChild("HumanoidRootPart"); if cr then table.insert(targets, {pos = cr.Position, color = Color3.fromRGB(255,170,0), name = plr.Name}) end end
    end
    while #tracersObjs < #targets do local d = Drawing.new("Line"); d.Thickness = 1; d.Color = Color3.new(1,1,1); d.Transparency = 0.7; d.Visible = true; table.insert(tracersObjs, d) end
    for i, t in pairs(tracersObjs) do if targets[i] then local sp, ep = camera:WorldToViewportPoint(root.Position), camera:WorldToViewportPoint(targets[i].pos); t.From = Vector2.new(sp.X, sp.Y); t.To = Vector2.new(ep.X, ep.Y); t.Color = targets[i].color; t.Visible = true else t.Visible = false end end
end

local function findBrainrots()
    local items = {}
    for _, v in pairs(ws:GetDescendants()) do
        local n = v.Name:lower()
        if v:IsA("BasePart") and (n:find("brainrot") or n:find("brain") or n:find("money") or n:find("coin") or n:find("drop") or n:find("steal")) then
            table.insert(items, v)
        end
    end
    return items
end

local function applyFpsBoost()
    if fpsBoostApplied then return end; fpsBoostApplied = true
    lighting.GlobalShadows = false; local s = settings(); s.Rendering.QualityLevel = 1; ws.Terrain.AutomaticCellCount = false
    for _, v in pairs(ws:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end end) end
end

local function revertFpsBoost() if not fpsBoostApplied then return end; fpsBoostApplied = false; lighting.GlobalShadows = true; local s = settings(); s.Rendering.QualityLevel = 2 end

local function unloadAll()
    isUnloaded = true; espEnabled = false; tracersEnabled = false; noclipEnabled = false; walkSpeedEnabled = false; jumpPowerEnabled = false; antiAfkEnabled = false; fpsBoostEnabled = false; autoFarmEnabled = false; autoStealEnabled = false
    for _, h in pairs(espCache) do pcall(function() h:Destroy() end) end; espCache = {}
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end; connections = {}
    revertFpsBoost(); for _, b in pairs(espBillboards) do pcall(function() b:Destroy() end) end; espBillboards = {}
    for _, t in pairs(tracersObjs) do pcall(function() t:Remove() end) end; tracersObjs = {}
    pcall(function() local g = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Rayfield"); if g then g:Destroy() end end)
    pcall(function() local g = game:GetService("CoreGui"):FindFirstChild("Rayfield"); if g then g:Destroy() end end)
    pcall(function() local c = player.Character; if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
end

pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({Name = "Steal a Brainrot", LoadingTitle = "Brainrot", LoadingSubtitle = "by anvil", TabPadding = 8, MenuSide = "Left"})
    uis.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.K then Rayfield.Enabled = not Rayfield.Enabled end end)
    uis.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.N then noclipEnabled = not noclipEnabled; notify(noclipEnabled and "Noclip вкл" or "Noclip выкл") end end)
    uis.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode == speedKey then local c = player.Character; if c then local h = c:FindFirstChildOfClass("Humanoid"); if h then local o = h.WalkSpeed; h.WalkSpeed = speedAmount; task.delay(3, function() if h and not isUnloaded then h.WalkSpeed = walkSpeedEnabled and walkSpeed or o end end) end end end end)

    local visTab = Window:CreateTab("Visuals")
    local fullbrightEnabled = false
    visTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) fullbrightEnabled = v; pcall(function() if v then lighting.Brightness = 2; lighting.ClockTime = 14; lighting.FogEnd = 100000; lighting.GlobalShadows = false; lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) else lighting.Brightness = 1; lighting.GlobalShadows = true end end) end})
    visTab:CreateToggle({Name = "ESP", CurrentValue = false, Callback = function(v) espEnabled = v end})
    visTab:CreateToggle({Name = "ESP Names", CurrentValue = false, Callback = function(v) espShowNames = v end})
    visTab:CreateToggle({Name = "ESP Distance", CurrentValue = false, Callback = function(v) espShowDistance = v end})
    visTab:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) tracersEnabled = v end})
    visTab:CreateToggle({Name = "FPS Boost", CurrentValue = false, Callback = function(v) fpsBoostEnabled = v; pcall(function() if v then applyFpsBoost() else revertFpsBoost() end end) end})

    local moveTab = Window:CreateTab("Movement")
    moveTab:CreateKeybind({Name = "Speed Boost Key", CurrentKeybind = "V", Callback = function(k) speedKey = k end})
    moveTab:CreateSlider({Name = "Boost Speed", Range = {30, 500}, Increment = 5, CurrentValue = 100, Callback = function(v) speedAmount = v end})
    moveTab:CreateToggle({Name = "WalkSpeed", CurrentValue = false, Callback = function(v) walkSpeedEnabled = v end})
    moveTab:CreateSlider({Name = "WalkSpeed", Range = {1, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
    moveTab:CreateToggle({Name = "JumpPower", CurrentValue = false, Callback = function(v) jumpPowerEnabled = v end})
    moveTab:CreateSlider({Name = "JumpPower", Range = {0, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) jumpPower = v end})
    moveTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) noclipEnabled = v end})

    local farmTab = Window:CreateTab("Farm")
    farmTab:CreateToggle({Name = "Auto Farm Money", CurrentValue = false, Callback = function(v) autoFarmEnabled = v; notify(v and "Auto Farm вкл" or "Auto Farm выкл", Color3.fromRGB(100,255,100)) end})
    farmTab:CreateToggle({Name = "Auto Steal Brainrots", CurrentValue = false, Callback = function(v) autoStealEnabled = v; notify(v and "Auto Steal вкл" or "Auto Steal выкл", Color3.fromRGB(255,200,100)) end})
    farmTab:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) antiAfkEnabled = v end})
    farmTab:CreateButton({Name = "Unload", Callback = unloadAll})
end)

table.insert(connections, rs.RenderStepped:Connect(function()
    if isUnloaded then return end; local char = player.Character; if not char then return end; local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if espEnabled then pcall(updateESP) end; pcall(updateTracers)
    if autoFarmEnabled or autoStealEnabled then
        for _, obj in pairs(ws:GetDescendants()) do
            local n = obj.Name:lower()
            if obj:IsA("BasePart") and obj.Parent and root then
                if autoFarmEnabled and (n:find("money") or n:find("coin") or n:find("cash") or n:find("generator") or n:find("drop")) then
                    if (obj.Position - root.Position).Magnitude < 20 then hum:MoveTo(obj.Position) end
                end
                if autoStealEnabled and (n:find("brainrot") or n:find("brain") or n:find("steal") or n:find("item") or n:find("backpack")) then
                    if (obj.Position - root.Position).Magnitude < 20 then hum:MoveTo(obj.Position) end
                end
            end
        end
    end
end))

table.insert(connections, rs.Stepped:Connect(function()
    if isUnloaded then return end; local char = player.Character; if not char then return end
    if noclipEnabled then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    else for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end; if jumpPowerEnabled then hum.JumpPower = jumpPower end end
end))

table.insert(connections, rs.Heartbeat:Connect(function()
    if isUnloaded then return end; local char = player.Character; if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end; if jumpPowerEnabled then hum.JumpPower = jumpPower end end
end))

table.insert(connections, player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end; if jumpPowerEnabled then hum.JumpPower = jumpPower end
        table.insert(connections, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() if not isUnloaded and walkSpeedEnabled then hum.WalkSpeed = walkSpeed end end))
        table.insert(connections, hum:GetPropertyChangedSignal("JumpPower"):Connect(function() if not isUnloaded and jumpPowerEnabled then hum.JumpPower = jumpPower end end))
    end
end))

task.spawn(function() while not isUnloaded do task.wait(30); if antiAfkEnabled and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.new(0,0,0.1),true); task.wait(0.1); h:Move(Vector3.new(0,0,0),true) end end end end)
task.spawn(function() while not isUnloaded do task.wait(10); if fpsBoostEnabled then for _, v in pairs(ws:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end end) end end end end)
