if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local camera = ws.CurrentCamera

local espPlayer = false
local espNextbot = false
local espTicket = false
local espShowDistance = false
local espShowNames = false
local healthEspEnabled = false
local tracersEnabled = false
local arrowsEnabled = false
local arrowsShowNames = false
local arrowsShowDistance = false
local speedKeyEnabled = false
local speedKey = Enum.KeyCode.V
local speedAmount = 80
local stealKey = Enum.KeyCode.X
local bhopKey = Enum.KeyCode.B
local stealEnabled = false
local bhopEnabled = false
local noclipEnabled = false
local walkSpeedEnabled = false
local walkSpeed = 16
local jumpPowerEnabled = false
local jumpPower = 50
local antiAfkEnabled = false
local fpsBoostEnabled = false
local flyEnabled = false
local autoReviveEnabled = false
local isUnloaded = false
local espColors = {
    player = Color3.fromRGB(0, 200, 255),
    nextbot = Color3.fromRGB(255, 0, 0),
    ticket = Color3.fromRGB(255, 255, 0),
    downed = Color3.fromRGB(255, 150, 0)
}
local connections = {}
local espCache = {}
local espObjectCache = {}
local espBillboards = {}
local fpsBoostApplied = false
local flyBodyVelocity = nil
local flyConnection = nil
local cachedTickets = {}
local cachedNextbots = {}

local ts = game:GetService("TweenService")
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "AnvilNotifs"; notifGui.ResetOnSpawn = false
pcall(function() notifGui.Parent = player:WaitForChild("PlayerGui") end)

local normalSpeed = 16

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
        h = Instance.new("Highlight")
        h.Parent = target
        h.FillTransparency = 0.4
        h.OutlineColor = Color3.fromRGB(255, 255, 255)
        h.OutlineTransparency = 0
        h.Enabled = false
        cache[target] = h
    end
    h.FillColor = color
    h.Enabled = true
end

local function espHideAll(cache)
    for _, h in pairs(cache) do
        h.Enabled = false
    end
end

local function isAlive(plr)
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isDowned(plr)
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and hum:GetState() == Enum.HumanoidStateType.Physics
end

local function updateObjectCache()
    cachedTickets = {}
    cachedNextbots = {}
    for _, obj in pairs(ws:GetDescendants()) do
        local n = obj.Name:lower()
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if n:find("ticket") or n:find("coin") or n:find("money") or n:find("bubble") or n:find("token") then
                table.insert(cachedTickets, obj)
            end
            if n:find("nextbot") or n:find("bot") or obj:FindFirstChild("Nextbot") or obj:FindFirstChild("AI") then
                table.insert(cachedNextbots, obj)
            end
        end
    end
end

local function updateESP()
    if not (espPlayer or espNextbot or espTicket) then
        espHideAll(espCache); espHideAll(espObjectCache)
        for _, b in pairs(espBillboards) do pcall(function() b:Destroy() end) end
        espBillboards = {}
        return
    end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character and espPlayer then
            local c = plr.Character
            local clr = isDowned(plr) and espColors.downed or espColors.player
            espColor(c, clr, espCache)
            if (espShowDistance or espShowNames) and root then
                local cRoot = c:FindFirstChild("HumanoidRootPart")
                if cRoot then
                    local b = espBillboards[c]
                    if not b then
                        b = Instance.new("BillboardGui")
                        b.Parent = c; b.Size = UDim2.new(0, 100, 0, 20)
                        b.StudsOffset = Vector3.new(0, 3, 0); b.AlwaysOnTop = true
                        local label = Instance.new("TextLabel")
                        label.Parent = b; label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1, 1, 1)
                        label.TextStrokeTransparency = 0.5; label.Font = Enum.Font.SourceSansBold
                        label.TextScaled = true
                        espBillboards[c] = b
                    end
                    local dist = math.floor((cRoot.Position - root.Position).Magnitude)
                    local label = b:FindFirstChildOfClass("TextLabel")
                    if label then
                        local text = ""
                        if espShowNames then text = plr.Name end
                        if espShowDistance then
                            if text ~= "" then text = text .. " " end
                            text = text .. "[" .. dist .. "m]"
                        end
                        label.Text = text
                    end
                end
            else
                local b = espBillboards[c]
                if b then b:Destroy(); espBillboards[c] = nil end
            end
        end
    end
    if espNextbot then
        for _, obj in pairs(cachedNextbots) do
            if obj.Parent then espColor(obj, espColors.nextbot, espObjectCache) end
        end
    end
    if espTicket then
        for _, obj in pairs(cachedTickets) do
            if obj.Parent then espColor(obj, espColors.ticket, espObjectCache) end
        end
    end
    for target, h in pairs(espCache) do
        if not target.Parent then h:Destroy(); espCache[target] = nil end
    end
    for target, h in pairs(espObjectCache) do
        if not target.Parent then h:Destroy(); espObjectCache[target] = nil end
    end
    for target, b in pairs(espBillboards) do
        if not target.Parent then b:Destroy(); espBillboards[target] = nil end
    end
end

local scanTimer = 0
local tracersObjs = {}
local arrowsObjs = {}
local arrowLabels = {}

local function updateTracers()
    if not tracersEnabled then
        for _, t in pairs(tracersObjs) do pcall(function() t:Remove() end) end
        tracersObjs = {}
        return
    end
    local targets = {}
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local cr = plr.Character:FindFirstChild("HumanoidRootPart")
            if cr then
                table.insert(targets, {pos = cr.Position, color = espColors.player, name = plr.Name})
            end
        end
    end
    while #tracersObjs < #targets do
        local d = Drawing.new("Line")
        d.Thickness = 1; d.Color = Color3.new(1,1,1); d.Transparency = 0.7; d.Visible = true
        table.insert(tracersObjs, d)
    end
    for i, t in pairs(tracersObjs) do
        if targets[i] then
            local sp, ep = camera:WorldToViewportPoint(root.Position), camera:WorldToViewportPoint(targets[i].pos)
            t.From = Vector2.new(sp.X, sp.Y); t.To = Vector2.new(ep.X, ep.Y)
            t.Color = targets[i].color; t.Visible = true
        else
            t.Visible = false
        end
    end
end

local function updateArrows()
    if not arrowsEnabled then
        for _, a in pairs(arrowsObjs) do pcall(function() a:Remove() end) end
        arrowsObjs = {}
        for _, l in pairs(arrowLabels) do pcall(function() l:Remove() end) end
        arrowLabels = {}
        return
    end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cx, cy = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
    local radius = 80
    local targets = {}
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local cr = plr.Character:FindFirstChild("HumanoidRootPart")
            if cr then
                local sp = camera:WorldToViewportPoint(cr.Position)
                if sp.Z > 0 then
                    table.insert(targets, {pos = cr.Position, sp = sp, name = plr.Name, plr = plr})
                end
            end
        end
    end
    while #arrowsObjs < #targets do
        local a = Drawing.new("Triangle")
        a.Visible = true; a.Color = Color3.new(1,1,1); a.Transparency = 0.9; a.Thickness = 0
        table.insert(arrowsObjs, a)
        if arrowsShowNames or arrowsShowDistance then
            local l = Drawing.new("Text")
            l.Visible = true; l.Color = Color3.new(1,1,1); l.Size = 12; l.Center = true
            l.Font = 0; l.Outline = true
            table.insert(arrowLabels, l)
        end
    end
    for i, t in pairs(targets) do
        local dir = (t.pos - root.Position).Unit
        local angle = math.atan2(dir.X, dir.Z) + math.rad(90)
        local px = cx + math.cos(angle) * radius
        local py = cy + math.sin(angle) * radius
        local a = arrowsObjs[i]
        if a then a.Point = Vector2.new(px, py - 10); a.Color = espColors.player end
        if arrowsShowNames or arrowsShowDistance then
            local l = arrowLabels[i]
            if l then
                local txt = ""
                if arrowsShowNames then txt = t.name end
                if arrowsShowDistance then
                    local d = math.floor((t.pos - root.Position).Magnitude)
                    if txt ~= "" then txt = txt .. " " end
                    txt = txt .. "[" .. d .. "m]"
                end
                l.Text = txt; l.Position = Vector2.new(px, py + 5)
            end
        end
    end
    for i = #targets + 1, #arrowsObjs do
        arrowsObjs[i].Visible = false
        if arrowLabels[i] then arrowLabels[i].Visible = false end
    end
end

local function findDownedPlayers()
    local result = {}
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character and not isAlive(plr) then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then table.insert(result, plr) end
        end
    end
    return result
end

local function applyFpsBoost()
    if fpsBoostApplied then return end
    fpsBoostApplied = true
    lighting.GlobalShadows = false
    local s = settings()
    s.Rendering.QualityLevel = 1
    ws.Terrain.AutomaticCellCount = false
    for _, v in pairs(ws:GetDescendants()) do
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
        end)
    end
end

local function revertFpsBoost()
    if not fpsBoostApplied then return end
    fpsBoostApplied = false
    lighting.GlobalShadows = true
    local s = settings()
    s.Rendering.QualityLevel = 2
end

local function toggleFly(state)
    if state == flyEnabled then return end
    flyEnabled = state
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if flyEnabled then
        hum.PlatformStand = true
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new()
        flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1e5
        flyBodyVelocity.P = 1e5
        flyBodyVelocity.Parent = root
        flyConnection = rs.RenderStepped:Connect(function()
            if not flyEnabled or not flyBodyVelocity or not flyBodyVelocity.Parent then
                if flyEnabled then toggleFly(false) end
                return
            end
            local move = Vector3.new()
            if uis:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
            flyBodyVelocity.Velocity = move * 50
        end)
    else
        hum.PlatformStand = false
        if flyBodyVelocity then pcall(function() flyBodyVelocity:Destroy() end); flyBodyVelocity = nil end
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    end
end

local function unloadAll()
    isUnloaded = true
    espPlayer = false; espNextbot = false; espTicket = false
    espShowDistance = false; espShowNames = false; healthEspEnabled = false
    tracersEnabled = false; arrowsEnabled = false; speedKeyEnabled = false
    stealEnabled = false; bhopEnabled = false
    noclipEnabled = false; walkSpeedEnabled = false; jumpPowerEnabled = false
    antiAfkEnabled = false; fpsBoostEnabled = false; autoReviveEnabled = false
    toggleFly(false)
    for _, h in pairs(espCache) do pcall(function() h:Destroy() end) end
    espCache = {}
    for _, h in pairs(espObjectCache) do pcall(function() h:Destroy() end) end
    espObjectCache = {}
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
    connections = {}
    revertFpsBoost()
    for _, b in pairs(espBillboards) do pcall(function() b:Destroy() end) end
    espBillboards = {}
    for _, t in pairs(tracersObjs) do pcall(function() t:Remove() end) end
    tracersObjs = {}
    for _, a in pairs(arrowsObjs) do pcall(function() a:Remove() end) end
    arrowsObjs = {}
    for _, l in pairs(arrowLabels) do pcall(function() l:Remove() end) end
    arrowLabels = {}
    pcall(function()
        local gui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Rayfield")
        if gui then gui:Destroy() end
    end)
    pcall(function()
        local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
        if gui then gui:Destroy() end
    end)
    pcall(function() local c = player.Character; if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
end

pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Evade",
        LoadingTitle = "Evade",
        LoadingSubtitle = "by anvil",
        TabPadding = 8,
        MenuSide = "Left"
    })
    uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.K then Rayfield.Enabled = not Rayfield.Enabled end
    end)
    uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.N then
            noclipEnabled = not noclipEnabled
            notify(noclipEnabled and "Noclip вкл" or "Noclip выкл", noclipEnabled and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100))
        end
    end)
    uis.InputBegan:Connect(function(input, gp)
        if gp then return end
        if speedKeyEnabled and input.KeyCode == speedKey then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = speedAmount; task.delay(3, function() if hum and not isUnloaded and walkSpeedEnabled then hum.WalkSpeed = walkSpeed elseif hum then hum.WalkSpeed = normalSpeed end end) end
            end
        end
        if input.KeyCode == stealKey then
            stealEnabled = not stealEnabled
            notify(stealEnabled and "Steal вкл" or "Steal выкл", Color3.fromRGB(255,200,100))
        end
        if input.KeyCode == bhopKey then
            bhopEnabled = not bhopEnabled
            notify(bhopEnabled and "Bhop вкл" or "Bhop выкл", Color3.fromRGB(100,200,255))
        end
    end)

    local visTab = Window:CreateTab("Visuals")
    visTab:CreateSection("Визуал")
    local fullbrightEnabled = false
    visTab:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v)
        fullbrightEnabled = v
        pcall(function()
            if v then lighting.Brightness = 2; lighting.ClockTime = 14; lighting.FogEnd = 100000; lighting.GlobalShadows = false; lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
            else lighting.Brightness = 1; lighting.GlobalShadows = true end
        end)
    end})
    local noFogEnabled = false
    visTab:CreateToggle({Name = "No Fog", CurrentValue = false, Callback = function(v)
        noFogEnabled = v
        pcall(function() if v then lighting.FogEnd = 100000; lighting.FogStart = 0 else lighting.FogEnd = 500; lighting.FogStart = 0 end end)
    end})

    visTab:CreateSection("ESP")
    local espOpts = {"Игроки","Nextbot","Ticket","Дистанция","Ники"}
    local function setESP(i, v)
        if i == 1 then espPlayer = v elseif i == 2 then espNextbot = v elseif i == 3 then espTicket = v
        elseif i == 4 then espShowDistance = v elseif i == 5 then espShowNames = v end
    end
    visTab:CreateDropdown({
        Name = "ESP",
        Options = espOpts,
        CurrentOption = {},
        MultipleOptions = true,
        Callback = function(o)
            for i = 1, 5 do setESP(i, false) end
            for _, name in pairs(o or {}) do
                for i = 1, 5 do if espOpts[i] == name then setESP(i, true) end end
            end
            pcall(updateESP)
        end
    })
    visTab:CreateToggle({Name = "FPS Boost", CurrentValue = false, Callback = function(v) fpsBoostEnabled = v; pcall(function() if v then applyFpsBoost() else revertFpsBoost() end end) end})
    visTab:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) tracersEnabled = v end})
    visTab:CreateToggle({Name = "Arrows", CurrentValue = false, Callback = function(v) arrowsEnabled = v end})
    local arrowOpts = {"Ники", "Дистанция"}
    visTab:CreateDropdown({
        Name = "Arrows Info",
        Options = arrowOpts,
        CurrentOption = {},
        MultipleOptions = true,
        Callback = function(o)
            arrowsShowNames = false; arrowsShowDistance = false
            for _, v in pairs(o or {}) do
                if v == "Ники" then arrowsShowNames = true end
                if v == "Дистанция" then arrowsShowDistance = true end
            end
        end
    })

    local moveTab = Window:CreateTab("Movement")
    moveTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) noclipEnabled = v; notify(v and "Noclip вкл" or "Noclip выкл", v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end})
    moveTab:CreateToggle({Name = "WalkSpeed", CurrentValue = false, Callback = function(v) walkSpeedEnabled = v end})
    moveTab:CreateSlider({Name = "WalkSpeed", Range = {1, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
    moveTab:CreateToggle({Name = "JumpPower", CurrentValue = false, Callback = function(v) jumpPowerEnabled = v end})
    moveTab:CreateSlider({Name = "JumpPower", Range = {0, 200}, Increment = 1, CurrentValue = 50, Callback = function(v) jumpPower = v end})
    moveTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) toggleFly(v); notify(v and "Fly вкл" or "Fly выкл", Color3.fromRGB(100,200,255)) end})

    moveTab:CreateKeybind({
        Name = "Speed Key (press to boost)",
        CurrentKeybind = "V",
        Callback = function(k) speedKey = k; speedKeyEnabled = true end
    })
    moveTab:CreateSlider({Name = "Speed Boost Amount", Range = {30, 250}, Increment = 5, CurrentValue = 80, Callback = function(v) speedAmount = v end})

    local utilTab = Window:CreateTab("Utility")
    utilTab:CreateKeybind({
        Name = "Steal Toggle Key",
        CurrentKeybind = "X",
        Callback = function(k) stealKey = k end
    })
    utilTab:CreateToggle({Name = "Auto Steal", CurrentValue = false, Callback = function(v) stealEnabled = v; notify(v and "Auto Steal вкл" or "Auto Steal выкл", Color3.fromRGB(255,200,100)) end})
    utilTab:CreateKeybind({
        Name = "Bhop Toggle Key",
        CurrentKeybind = "B",
        Callback = function(k) bhopKey = k end
    })
    utilTab:CreateToggle({Name = "Auto Bhop", CurrentValue = false, Callback = function(v) bhopEnabled = v; notify(v and "Auto Bhop вкл" or "Auto Bhop выкл", Color3.fromRGB(100,200,255)) end})
    utilTab:CreateToggle({Name = "Auto Revive", CurrentValue = false, Callback = function(v) autoReviveEnabled = v; notify(v and "Auto Revive вкл" or "Auto Revive выкл", Color3.fromRGB(100,255,100)) end})
    utilTab:CreateToggle({Name = "Anti-AFK", CurrentValue = false, Callback = function(v) antiAfkEnabled = v end})
    utilTab:CreateButton({Name = "Unload", Callback = unloadAll})
end)

local espTimer = 0
table.insert(connections, rs.RenderStepped:Connect(function(dt)
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    espTimer = espTimer + (dt or 0.016)
    if espTimer >= 0.15 then
        espTimer = 0
        if espPlayer or espNextbot or espTicket then pcall(updateESP) end
    end

    pcall(updateTracers)
    pcall(updateArrows)

    if bhopEnabled and hum:GetState() == Enum.HumanoidStateType.Running and uis:IsKeyDown(Enum.KeyCode.Space) then
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
            task.wait(0.05)
            hum.Jump = false
        end
    end

    if flyEnabled then
        hum.PlatformStand = true
    end

    if stealEnabled then
        for _, obj in pairs(cachedTickets) do
            if obj.Parent and obj:IsA("BasePart") then
                local dist = (obj.Position - root.Position).Magnitude
                if dist < 15 then root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0), root.Position); hum:MoveTo(obj.Position) end
            end
        end
    end
end))

table.insert(connections, rs.Stepped:Connect(function()
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    if noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then hum.JumpPower = jumpPower end
    end
end))

table.insert(connections, rs.Heartbeat:Connect(function()
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then hum.JumpPower = jumpPower end
    end
end))

table.insert(connections, player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then hum.JumpPower = jumpPower end
        normalSpeed = hum.WalkSpeed
        table.insert(connections, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if not isUnloaded and walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        end))
        table.insert(connections, hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if not isUnloaded and jumpPowerEnabled then hum.JumpPower = jumpPower end
        end))
    end
end))

task.spawn(function()
    while not isUnloaded do
        task.wait(1)
        if espNextbot or espTicket then pcall(updateObjectCache) end
        if autoReviveEnabled then
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and hum:GetState() == Enum.HumanoidStateType.Physics then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if myRoot and (root.Position - myRoot.Position).Magnitude < 8 then
                                local reviveRemote = plr.Character:FindFirstChildWhichIsA("RemoteEvent", true)
                                if reviveRemote then pcall(function() reviveRemote:FireServer(plr) end) end
                                for _, tool in pairs(player.Backpack:GetChildren()) do
                                    if tool:IsA("Tool") and (tool.Name:lower():find("revive") or tool.Name:lower():find("med")) then
                                        pcall(function() tool:Activate(); tool:FireServer(plr) end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while not isUnloaded do
        task.wait(30)
        if antiAfkEnabled and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:Move(Vector3.new(0, 0, 0.1), true); task.wait(0.1); hum:Move(Vector3.new(0, 0, 0), true) end
        end
    end
end)

task.spawn(function()
    while not isUnloaded do
        task.wait(10)
        if fpsBoostEnabled then
            for _, v in pairs(ws:GetDescendants()) do
                pcall(function()
                    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
                end)
            end
        end
    end
end)
