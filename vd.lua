-- ============================================
-- VIOLENCE DISTRICT
-- ============================================

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local ts = game:GetService("TweenService")

-- ===== ПЕРЕМЕННЫЕ =====
local espKiller = false
local espSurvivor = false
local espGenerator = false
local espWindow = false
local espPallet = false
local espItems = false
local espExit = false
local espShowDistance = false
local espShowNames = false
local autoParryEnabled = false
local autoGenEnabled = false
local killAuraEnabled = false
local aimAssistEnabled = false
local autoAttackEnabled = false
local parryCooldown = false
local isUnloaded = false
local manualKillers = {}
local noclipEnabled = false
local walkSpeedEnabled = false
local walkSpeed = 16
local jumpPowerEnabled = false
local jumpPower = 50
local autoHealEnabled = false
local antiTrapEnabled = false
local autoExitEnabled = false
local antiAfkEnabled = false
local noCooldownEnabled = false
local fpsBoostEnabled = false
local tracersEnabled = false
local healthEspEnabled = false
local autoSabotageEnabled = false
local noStunEnabled = false
local autoDropEnabled = false
local autoFireEnabled = false
local invisibleEnabled = false
local arrowsEnabled = false
local arrowsShowNames = false
local arrowsShowDistance = false
local autoScanTimer = 0
local autoSkillCheckEnabled = false
local spinbotEnabled = false
local spinbotSpeed = 8
local autoMoonwalkEnabled = false
local moonwalkKeys = {W = false, A = false, S = false, D = false}
local spinY = 0
local espColors = {
    killer = Color3.fromRGB(255, 0, 0),
    survivor = Color3.fromRGB(0, 255, 0),
    generator = Color3.fromRGB(50, 200, 255),
    window = Color3.fromRGB(255, 200, 50),
    pallet = Color3.fromRGB(255, 100, 255),
    item = Color3.fromRGB(255, 255, 0),
    exit = Color3.fromRGB(0, 255, 100),
    trap = Color3.fromRGB(255, 50, 50)
}
local connections = {}
local autoFollowEnabled = false
local espBillboards = {}
local cachedItems = {}
local cachedExitGates = {}
local cachedTraps = {}
local antiAfkTimer = 0
local fpsBoostApplied = false
local godmodeEnabled = false

-- ============================================
-- LANGUAGE SELECTION & LOADING
-- ============================================
local lang = "en"
local L = {}
local langLoaded = false

-- ScreenGui for language selection
local langGui = Instance.new("ScreenGui")
langGui.Name = "AnvilLang"; langGui.ResetOnSpawn = false; langGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
langGui.Parent = player:WaitForChild("PlayerGui")

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundColor3 = Color3.fromRGB(5,5,8); overlay.BackgroundTransparency = 0.3; overlay.BorderSizePixel = 0; overlay.Parent = langGui

local langBox = Instance.new("Frame")
langBox.Size = UDim2.new(0,360,0,260); langBox.Position = UDim2.new(0.5,-180,0.5,-130)
langBox.BackgroundColor3 = Color3.fromRGB(18,18,24); langBox.BorderSizePixel = 0; langBox.Active = true; langBox.Parent = langGui
Instance.new("UICorner", langBox).CornerRadius = UDim.new(0,12)
local lstroke = Instance.new("UIStroke", langBox); lstroke.Color = Color3.fromRGB(50,50,65); lstroke.Thickness = 1

local langBoxScale = Instance.new("UIScale", langBox); langBoxScale.Scale = 0

local langTitle = Instance.new("TextLabel"); langTitle.Size = UDim2.new(1,0,0,60); langTitle.Position = UDim2.new(0,0,0,30); langTitle.BackgroundTransparency = 1
langTitle.Text = "Violence District"; langTitle.TextColor3 = Color3.fromRGB(220,220,235); langTitle.Font = Enum.Font.GothamBold; langTitle.TextSize = 26; langTitle.TextTransparency = 1; langTitle.Parent = langBox

local langSub = Instance.new("TextLabel"); langSub.Size = UDim2.new(1,0,0,24); langSub.Position = UDim2.new(0,0,0,85); langSub.BackgroundTransparency = 1
langSub.Text = "select language / выбери язык"; langSub.TextColor3 = Color3.fromRGB(130,130,155); langSub.Font = Enum.Font.Gotham; langSub.TextSize = 13; langSub.TextTransparency = 1; langSub.Parent = langBox

local function makeLangBtn(y, text)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,200,0,40); btn.Position = UDim2.new(0.5,-100,0,y); btn.BackgroundColor3 = Color3.fromRGB(35,35,48); btn.BorderSizePixel = 0; btn.Text = text; btn.TextColor3 = Color3.fromRGB(200,200,215); btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Parent = langBox
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(55,55,75); Instance.new("UIStroke", btn).Thickness = 1
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(48,48,65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,48) end)
    return btn
end

local ruBtn = makeLangBtn(125, "Русский")
local enBtn = makeLangBtn(178, "English")

-- lang screen animation
task.spawn(function()
    ts:Create(langBoxScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    task.wait(0.25)
    ts:Create(langTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(0.15)
    ts:Create(langSub, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
end)

local function selectLang(chosen)
    lang = chosen
    if lang == "ru" then
        L.Title = "Violence District"
        L.Subtitle = "by anvil"
        L.TabVisuals = "Visuals"; L.TabCombat = "Combat"; L.TabRage = "Rage"; L.TabUtility = "Utility"; L.TabTeleport = "Teleport"
        L.SectionVisual = "Визуал"; L.SectionEsp = "ESP"
        L.Fullbright = "Fullbright"; L.NoFog = "No Fog"; L.FpsBoost = "FPS Boost"
        L.EspKiller="Киллер"; L.EspSurvivor="Выжившие"; L.EspGenerator="Генераторы"; L.EspWindow="Окна"; L.EspPallet="Палеты"; L.EspItems="Предметы"; L.EspExit="Выход"; L.EspDist="Дистанция"; L.EspHealth="Health"; L.EspNames="Ники"
        L.Tracers="Tracers"; L.Arrows="Arrows"; L.ArrowsInfo="Arrows Info"
        L.AutoParry="Auto Parry"; L.KillAura="Kill Aura"; L.AimAssist="Aim Assist"; L.AutoAttack="Auto Attack"; L.Follow="За спиной"; L.Sabotage="Auto Sabotage"; L.Drop="Auto Drop"; L.Fire="Auto Fire"; L.SkillCheck="Auto Skill Check"
        L.AutoGen="Auto Generator"; L.Noclip="Noclip"; L.WalkSpeed="WalkSpeed"; L.JumpPower="JumpPower"; L.AutoHeal="Auto Heal"; L.AntiTrap="Anti-Trap"; L.AutoExit="Auto Exit"; L.AntiAfk="Anti-AFK"; L.NoCooldown="No Cooldown"; L.Spinbot="Spinbot"; L.Moonwalk="Auto Moonwalk"; L.NoStun="No Stun"; L.Invisible="Invisible"
        L.Heal="Heal"; L.Teleport="Teleport to Gen"; L.Unload="Unload"
        L.On="вкл"; L.Off="выкл"
        L.Loaded="Violence District загружен."
        L.Unloaded="Скрипт выгружен"
        L.SliderSpin="Spinbot Speed"; L.SliderWalk="WalkSpeed"; L.SliderJump="JumpPower"
        L.LoadInit="Инициализация..."; L.LoadESP="Загрузка ESP..."; L.LoadCombat="Подготовка модулей..."; L.LoadUI="Построение интерфейса..."; L.LoadDone="Готово!"

    else
        L.Title = "Violence District"; L.Subtitle = "by anvil"
        L.TabVisuals = "Visuals"; L.TabCombat = "Combat"; L.TabRage = "Rage"; L.TabUtility = "Utility"; L.TabTeleport = "Teleport"
        L.SectionVisual = "Visual"; L.SectionEsp = "ESP"
        L.Fullbright = "Fullbright"; L.NoFog = "No Fog"; L.FpsBoost = "FPS Boost"
        L.EspKiller="Killer"; L.EspSurvivor="Survivor"; L.EspGenerator="Generators"; L.EspWindow="Windows"; L.EspPallet="Pallets"; L.EspItems="Items"; L.EspExit="Exit"; L.EspDist="Distance"; L.EspHealth="Health"; L.EspNames="Names"
        L.Tracers="Tracers"; L.Arrows="Arrows"; L.ArrowsInfo="Arrows Info"
        L.AutoParry="Auto Parry"; L.KillAura="Kill Aura"; L.AimAssist="Aim Assist"; L.AutoAttack="Auto Attack"; L.Follow="Behind"; L.Sabotage="Auto Sabotage"; L.Drop="Auto Drop"; L.Fire="Auto Fire"; L.SkillCheck="Auto Skill Check"
        L.AutoGen="Auto Generator"; L.Noclip="Noclip"; L.WalkSpeed="WalkSpeed"; L.JumpPower="JumpPower"; L.AutoHeal="Auto Heal"; L.AntiTrap="Anti-Trap"; L.AutoExit="Auto Exit"; L.AntiAfk="Anti-AFK"; L.NoCooldown="No Cooldown"; L.Spinbot="Spinbot"; L.Moonwalk="Auto Moonwalk"; L.NoStun="No Stun"; L.Invisible="Invisible"
        L.Heal="Heal"; L.Teleport="Teleport to Gen"; L.Unload="Unload"
        L.On="on"; L.Off="off"
        L.Loaded="Violence District loaded."
        L.Unloaded="Script unloaded"
        L.SliderSpin="Spinbot Speed"; L.SliderWalk="WalkSpeed"; L.SliderJump="JumpPower"
        L.LoadInit="Initializing..."; L.LoadESP="Loading ESP..."; L.LoadCombat="Preparing modules..."; L.LoadUI="Building UI..."; L.LoadDone="Done!"
    end

    langGui:Destroy()
    langLoaded = true
end

ruBtn.MouseButton1Click:Connect(function() selectLang("ru") end)
enBtn.MouseButton1Click:Connect(function() selectLang("en") end)

repeat task.wait() until langLoaded

-- ============================================
-- HUD NOTIFICATIONS
-- ============================================
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
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextStrokeTransparency = 1
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

-- ============================================
-- HOOK DETECTION
-- ============================================
local hookedPlayers = {}
local cachedHooks = {}
local hookCacheTimer = 0
task.spawn(function()
    while not isUnloaded do
        task.wait(0.5)
        pcall(function()
            hookCacheTimer = hookCacheTimer + 1
            if hookCacheTimer >= 6 then
                hookCacheTimer = 0
                cachedHooks = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent then
                        local n = obj.Name:lower()
                        if n:find("hook") or n:find("cage") or n:find("крюк") or n:find("клетк") or n:find("висел") then
                            table.insert(cachedHooks, obj)
                        end
                    end
                end
            end
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if root and hum then
                        local onHook = false
                        for _, obj in pairs(cachedHooks) do
                            if obj.Parent and (obj.Position - root.Position).Magnitude < 8 then
                                onHook = true; break
                            end
                        end
                        if onHook and not hookedPlayers[plr.Name] then
                            hookedPlayers[plr.Name] = true
                        elseif not onHook and hookedPlayers[plr.Name] then
                            hookedPlayers[plr.Name] = nil
                        end
                    end
                end
            end
        end)
    end
end)

-- ===== КЕШ ГЕНЕРАТОРОВ =====
local cachedGenerators = {}
local lastGenUpdate = 0
local GEN_UPDATE_INTERVAL = 1

-- ============================================
-- ПОЛНЫЙ СПИСОК УБИЙЦ
-- ============================================
local function isKiller(character)
    if not character then return false end
    for _, plr in pairs(players:GetPlayers()) do
        if plr.Character == character then
            if manualKillers[plr.Name] then return true end
            if plr.Team then
                return plr.Team.Name:lower():find("killer") ~= nil
            end
            return false
        end
    end
    return false
end

-- ============================================
-- ⚠️ КУРСОР НЕ МЕНЯЕТСЯ! (убраны все функции showCursor/hideCursor)
-- ============================================

-- ============================================
-- ESP CACHE + ИНКРЕМЕНТАЛЬНОЕ ОБНОВЛЕНИЕ
-- ============================================
local espCache = {}
local espObjectCache = {}

local function espColor(target, color, cache)
    cache = cache or espCache
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

local function updatePlayerESP()
    if not (espKiller or espSurvivor) then
        espHideAll(espCache)
        for _, b in pairs(espBillboards) do
            pcall(function() b:Destroy() end)
        end
        espBillboards = {}
        return
    end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    local function isAbsoluteKiller(character)
        if not character then return false end
        for _, plr in pairs(players:GetPlayers()) do
            if plr.Character == character and plr.Team then
                return plr.Team.Name:lower():find("killer") ~= nil
            end
        end
        return false
    end
    
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local c = otherPlayer.Character
            local isKillerTeam = isAbsoluteKiller(c)
            if (isKillerTeam and espKiller) or (not isKillerTeam and espSurvivor) then
                espColor(c, isKillerTeam and espColors.killer or espColors.survivor, espCache)
                if (espShowDistance or espShowNames) and root then
                    local cRoot = c:FindFirstChild("HumanoidRootPart")
                    if cRoot then
                        local b = espBillboards[c]
                        if not b then
                            b = Instance.new("BillboardGui")
                            b.Parent = c
                            b.Size = UDim2.new(0, 100, 0, 20)
                            b.StudsOffset = Vector3.new(0, 3, 0)
                            b.AlwaysOnTop = true
                            local label = Instance.new("TextLabel")
                            label.Parent = b
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.TextStrokeTransparency = 0.5
                            label.Font = Enum.Font.SourceSansBold
                            label.TextScaled = true
                            espBillboards[c] = b
                        end
                        local dist = math.floor((cRoot.Position - root.Position).Magnitude)
                        local label = b:FindFirstChildOfClass("TextLabel")
                        if label then
                            local text = ""
                            if espShowNames then text = otherPlayer.Name end
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
            else
                local h = espCache[c]
                if h then h.Enabled = false end
                local b = espBillboards[c]
                if b then b:Destroy(); espBillboards[c] = nil end
            end
        end
    end
    for target, h in pairs(espCache) do
        if not target.Parent then
            h:Destroy()
            espCache[target] = nil
        end
    end
    for target, b in pairs(espBillboards) do
        if not target.Parent then
            b:Destroy()
            espBillboards[target] = nil
        end
    end
end

local function updateObjectESP()
    if not (espGenerator or espWindow or espPallet or espItems or espExit or antiTrapEnabled) then
        espHideAll(espObjectCache)
        return
    end
    local checked = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
        local name = obj.Name:lower()
        if espGenerator and (name:find("generator") or name:find("gen") or name:find("генератор")) then
            checked[obj] = true
            espColor(obj, espColors.generator, espObjectCache)
        elseif espWindow and (name:find("window") or name:find("окн") or name:find("vault")) then
            checked[obj] = true
            espColor(obj, espColors.window, espObjectCache)
        elseif espPallet and (name:find("pallet") or name:find("palet") or name:find("pal") or name:find("поддон") or name:find("доск")) then
            checked[obj] = true
            espColor(obj, espColors.pallet, espObjectCache)
        elseif espItems and (name:find("key") or name:find("medkit") or name:find("heal") or name:find("chest") or name:find("crate") or name:find("box") or name:find("аптечк") or name:find("ящик") or name:find("ключ")) then
            checked[obj] = true
            espColor(obj, espColors.item, espObjectCache)
        elseif espExit and (name:find("exit") or name:find("gate") or name:find("door") or name:find("выход") or name:find("двер")) then
            checked[obj] = true
            espColor(obj, espColors.exit, espObjectCache)
        elseif antiTrapEnabled and (name:find("trap") or name:find("bear") or name:find("капкан") or name:find("ловушк")) then
            checked[obj] = true
            espColor(obj, espColors.trap, espObjectCache)
        end
    end
    for target, h in pairs(espObjectCache) do
        if not target.Parent then
            h:Destroy()
            espObjectCache[target] = nil
        elseif not checked[target] then
            h.Enabled = false
        end
    end
end

local function updateESP()
    updatePlayerESP()
    updateObjectESP()
end

-- ============================================
-- ПОДСЛЕЖИВАНИЕ ЗА НОВЫМИ ИГРОКАМИ
-- ============================================
local function setupPlayerTracking()
    table.insert(connections, players.PlayerAdded:Connect(function(newPlayer)
        table.insert(connections, newPlayer.CharacterAdded:Connect(function(char)
            task.wait(1)
            if not isUnloaded then updateESP() end
        end))
        if newPlayer.Character then
            task.wait(1)
            if not isUnloaded then updateESP() end
        end
    end))
    
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            table.insert(connections, plr.CharacterAdded:Connect(function(char)
                task.wait(1)
                if not isUnloaded then updateESP() end
            end))
        end
    end
end

task.spawn(function()
    while not isUnloaded do
        task.wait(0.15)
        if espKiller or espSurvivor then
            pcall(updatePlayerESP)
        end
    end
end)

local objTimer = 0
task.spawn(function()
    while not isUnloaded do
        task.wait(0.15)
        objTimer = objTimer + 1
        if objTimer >= 10 and (espGenerator or espWindow or espPallet or espItems or espExit or antiTrapEnabled) then
            objTimer = 0
            pcall(updateObjectESP)
        end
    end
end)

-- ============================================
-- AUTO FOLLOW (за спиной убийцы)
-- ============================================
local function autoFollowUpdate()
    if not autoFollowEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local nearestKiller = nil
    local nearestDist = 25
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and isKiller(otherPlayer.Character) then
            local kRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if kRoot then
                local dist = (kRoot.Position - root.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestKiller = kRoot
                end
            end
        end
    end

    if nearestKiller then
        local lv = nearestKiller.CFrame.LookVector
        local behind = nearestKiller.Position - lv * 5
        root.CFrame = CFrame.new(root.Position, nearestKiller.Position)
        local dir = (behind - root.Position).Unit
        if (behind - root.Position).Magnitude > 3 then
            hum:Move(dir, true)
        else
            hum:Move(Vector3.new(), true)
            root.CFrame = CFrame.new(behind, nearestKiller.Position)
        end
    end
end

-- ============================================
-- AUTO HEAL
-- ============================================
local function findMedkit()
    local char = player.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Tool") and (v.Name:lower():find("medkit") or v.Name:lower():find("heal") or v.Name:lower():find("аптечк")) then
            return v
        end
    end
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("medkit") or v.Name:lower():find("heal") or v.Name:lower():find("аптечк")) then
            return v
        end
    end
end

local function getHealth()
    local char = player.Character
    if not char then return 100 end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health or 100
end

-- ============================================
-- AUTO EXIT GATE
-- ============================================
local exitGateRefresh = 0
local function findExitGate()
    exitGateRefresh = exitGateRefresh + 1
    if exitGateRefresh >= 10 or #cachedExitGates == 0 then
        exitGateRefresh = 0
        cachedExitGates = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local name = obj.Name:lower()
                if name:find("exit") or name:find("gate") or name:find("выход") then
                    local cd = obj:FindFirstChild("ClickDetector")
                    if not cd then
                        for _, sub in pairs(obj:GetDescendants()) do
                            if sub:IsA("ClickDetector") then cd = sub; break end
                        end
                    end
                    if cd then table.insert(cachedExitGates, {obj = obj, cd = cd}) end
                end
            end
        end
    end
    for _, entry in pairs(cachedExitGates) do
        if entry.obj and entry.obj.Parent then return entry.obj, entry.cd end
    end
end

-- ============================================
-- ТЕЛЕПОРТ
-- ============================================
local function teleportToNearestGenerator()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local nearest = nil
    local nearestDist = math.huge
    for _, gen in pairs(cachedGenerators) do
        if gen and gen.Parent then
            local dist = (gen.Position - root.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = gen
            end
        end
    end
    if nearest then
        root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 5, 0))
    end
end

-- ============================================
-- FPS BOOST
-- ============================================
local function applyFpsBoost()
    if fpsBoostApplied then return end
    fpsBoostApplied = true
    lighting.GlobalShadows = false
    local s = settings()
    s.Rendering.QualityLevel = 1
    workspace.Terrain.AutomaticCellCount = false
    for _, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
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


-- ============================================
-- TRACERS
-- ============================================
local tracersObjs = {}
local arrowsObjs = {}
local arrowLabels = {}
local camera = workspace.CurrentCamera

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
                local isK = isKiller(plr.Character)
                table.insert(targets, {pos = cr.Position, color = isK and espColors.killer or espColors.survivor, name = plr.Name})
            end
        end
    end
    while #tracersObjs < #targets do
        local d = Drawing.new("Line")
        d.Thickness = 1; d.Color = Color3.new(1,1,1); d.Transparency = 0.7; d.Visible = true
        table.insert(tracersObjs, d)
    end
    while #tracersObjs > #targets do
        local d = table.remove(tracersObjs); pcall(function() d:Remove() end)
    end
    local screenSize = camera.ViewportSize
    local from = Vector2.new(screenSize.X / 2, screenSize.Y)
    for i, t in pairs(targets) do
        local sp, onScreen = camera:WorldToViewportPoint(t.pos)
        if onScreen and sp.Z > 0 then
            tracersObjs[i].From = from
            tracersObjs[i].To = Vector2.new(sp.X, sp.Y)
            tracersObjs[i].Color = t.color; tracersObjs[i].Visible = true
        else
            tracersObjs[i].Visible = false
        end
    end
end

local function updateArrows()
    for _, l in pairs(arrowLabels) do pcall(function() l.Visible = false end) end
    if not arrowsEnabled then
        for _, a in pairs(arrowsObjs) do pcall(function() a.Visible = false end) end
        return
    end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local camPos = camera.CFrame.Position
    local targets = {}
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local cr = plr.Character:FindFirstChild("HumanoidRootPart")
            if cr then
                local isK = isKiller(plr.Character)
                table.insert(targets, {pos = cr.Position, color = isK and espColors.killer or espColors.survivor, name = plr.Name, dist = math.floor((cr.Position - root.Position).Magnitude)})
            end
        end
    end
    local needed = #targets * 5
    while #arrowsObjs < needed do local a = Drawing.new("Line"); a.Thickness = 2; a.Transparency = 1; a.Visible = true; table.insert(arrowsObjs, a) end
    while #arrowsObjs > needed do local a = table.remove(arrowsObjs); pcall(function() a:Remove() end) end
    while #arrowLabels < #targets do local l = Drawing.new("Text"); l.Center = true; l.Size = 14; l.Outline = true; l.OutlineColor = Color3.new(0,0,0); table.insert(arrowLabels, l) end
    while #arrowLabels > #targets do local l = table.remove(arrowLabels); pcall(function() l:Remove() end) end
    local ss = camera.ViewportSize; local cx = ss.X/2; local cy = ss.Y/2; local r = 80
    for i, t in pairs(targets) do
        local sp, on = camera:WorldToViewportPoint(t.pos)
        local inFront = sp.Z > 0
        local tx, ty
        if inFront then tx = sp.X; ty = sp.Y
        else
            local d = (t.pos - camPos).Unit; local bp = camPos + d * 500
            local sb = camera:WorldToViewportPoint(bp); tx = sb.X; ty = sb.Y
        end
        local dx = tx - cx; local dy = ty - cy; local dd = math.sqrt(dx*dx + dy*dy)
        if dd > 0 then
            local nx = dx/dd; local ny = dy/dd
            local ax, ay
            if inFront and dd < r then ax = tx; ay = ty else ax = cx + nx*r; ay = cy + ny*r end
            local sz = 10
            local tip = Vector2.new(ax, ay)
            local left = Vector2.new(ax - nx*sz + ny*sz*0.5, ay - ny*sz - nx*sz*0.5)
            local right = Vector2.new(ax - nx*sz - ny*sz*0.5, ay - ny*sz + nx*sz*0.5)
            local base = Vector2.new(ax - nx*sz*0.6, ay - ny*sz*0.6)
            local idx = (i-1)*5
            arrowsObjs[idx+1].From = base; arrowsObjs[idx+1].To = tip; arrowsObjs[idx+1].Color = t.color; arrowsObjs[idx+1].Visible = true
            arrowsObjs[idx+2].From = tip; arrowsObjs[idx+2].To = left; arrowsObjs[idx+2].Color = t.color; arrowsObjs[idx+2].Visible = true
            arrowsObjs[idx+3].From = tip; arrowsObjs[idx+3].To = right; arrowsObjs[idx+3].Color = t.color; arrowsObjs[idx+3].Visible = true
            arrowsObjs[idx+4].From = left; arrowsObjs[idx+4].To = right; arrowsObjs[idx+4].Color = t.color; arrowsObjs[idx+4].Visible = true
            arrowsObjs[idx+5].From = base; arrowsObjs[idx+5].To = Vector2.new(ax - nx*sz*0.3, ay - ny*sz*0.3); arrowsObjs[idx+5].Color = t.color; arrowsObjs[idx+5].Visible = true
            if arrowLabels[i] then
                local txt = ""
                if arrowsShowNames then txt = t.name end
                if arrowsShowDistance then
                    if txt ~= "" then txt = txt .. " " end
                    txt = txt .. "[" .. t.dist .. "m]"
                end
                arrowLabels[i].Text = txt; arrowLabels[i].Color = t.color
                arrowLabels[i].Position = Vector2.new(ax + nx*15, ay + ny*15)
                arrowLabels[i].Visible = txt ~= ""
            end
        end
    end
end

-- ============================================
-- HEALTH ESP
-- ============================================
local healthBillboards = {}

local function updateHealthESP()
    if not healthEspEnabled then
        for _, b in pairs(healthBillboards) do
            pcall(function() b:Destroy() end)
        end
        healthBillboards = {}
        return
    end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local b = healthBillboards[plr]
                if not b then
                    local r2 = plr.Character:FindFirstChild("HumanoidRootPart")
                    if not r2 then continue end
                    b = Instance.new("BillboardGui")
                    b.Parent = plr.Character
                    b.Size = UDim2.new(0, 60, 0, 16)
                    b.StudsOffset = Vector3.new(0, 2.5, 0)
                    b.AlwaysOnTop = true
                    local lb = Instance.new("TextLabel")
                    lb.Parent = b
                    lb.Size = UDim2.new(1, 0, 1, 0)
                    lb.BackgroundTransparency = 1
                    lb.TextColor3 = Color3.new(1, 1, 1)
                    lb.TextStrokeTransparency = 0.5
                    lb.Font = Enum.Font.SourceSansBold
                    lb.TextScaled = true
                    healthBillboards[plr] = b
                end
                local lb = b:FindFirstChildOfClass("TextLabel")
                if lb then
                    local hp = math.floor(hum.Health)
                    local mhp = math.floor(hum.MaxHealth)
                    lb.Text = hp .. "/" .. mhp
                    lb.TextColor3 = hp > 60 and Color3.fromRGB(0, 255, 0) or hp > 30 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
    for plr, b in pairs(healthBillboards) do
        if not plr.Character or not plr.Character.Parent then
            pcall(function() b:Destroy() end)
            healthBillboards[plr] = nil
        end
    end
end

local cachedClickables = {}
local clickableTimer = 0
local function refreshClickables()
    clickableTimer = clickableTimer + 1
    if clickableTimer >= 6 then
        clickableTimer = 0
        cachedClickables = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and obj.Position then
                local name = obj.Name:lower()
                local relevant = name:find("generator") or name:find("gen") or name:find("генератор") or name:find("pallet") or name:find("pal") or name:find("поддон")
                if relevant then
                    local cd = obj:FindFirstChild("ClickDetector")
                    if not cd then
                        for _, sub in pairs(obj:GetDescendants()) do
                            if sub:IsA("ClickDetector") then cd = sub; break end
                        end
                    end
                    if cd then table.insert(cachedClickables, {obj = obj, cd = cd}) end
                end
            end
        end
    end
end

-- ============================================
-- AUTO SABOTAGE
-- ============================================
local function doAutoSabotage()
    if not autoSabotageEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(refreshClickables)
    for _, entry in pairs(cachedClickables) do
        if entry.obj and entry.obj.Parent and (entry.obj.Position - root.Position).Magnitude < 8 then
            pcall(function() entry.cd:Click() end)
        end
    end
end

-- ============================================
-- AUTO DROP
-- ============================================
local function doAutoDrop()
    if not autoDropEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local killerNear = false
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character and isKiller(plr.Character) then
            local kr = plr.Character:FindFirstChild("HumanoidRootPart")
            if kr and (kr.Position - root.Position).Magnitude < 15 then
                killerNear = true; break
            end
        end
    end
    if not killerNear then return end
    pcall(refreshClickables)
    for _, entry in pairs(cachedClickables) do
        if entry.obj and entry.obj.Parent then
            local name = entry.obj.Name:lower()
            if (name:find("pallet") or name:find("pal") or name:find("поддон")) and (entry.obj.Position - root.Position).Magnitude < 10 then
                pcall(function() entry.cd:Click() end)
            end
        end
    end
end

-- ============================================
-- AUTO FIRE
-- ============================================
local function doAutoFire()
    if not autoFireEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local function getWeaponTool(container)
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Tool") then
                local remotes = {}
                for _, sub in pairs(v:GetDescendants()) do
                    if sub:IsA("RemoteEvent") then table.insert(remotes, sub) end
                end
                if #remotes > 0 then return v, remotes end
            end
        end
        return nil, {}
    end

    local tool, remotes = getWeaponTool(char)
    if not tool then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then tool, remotes = getWeaponTool(backpack) end
    end
    if not tool then
        local starter = player:FindFirstChild("StarterGear")
        if starter then tool, remotes = getWeaponTool(starter) end
    end
    if not tool then return end

    if tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
        return
    end

    pcall(function()
        tool:Activate()
        for _, r in pairs(remotes) do
            r:FireServer()
            r:FireServer(true)
            r:FireServer(100)
            r:FireServer(1)
        end
    end)
end
-- ============================================
-- ОТКЛЮЧЕНИЕ
-- ============================================
local function unloadAll()
    isUnloaded = true
    espKiller = false
    espSurvivor = false
    espGenerator = false
    espWindow = false
    espPallet = false
    for _, cache in pairs({espCache, espObjectCache}) do
        for _, h in pairs(cache) do
            pcall(function() h:Destroy() end)
        end
    end
    espCache = {}
    espObjectCache = {}
    autoParryEnabled = false
    autoGenEnabled = false
    killAuraEnabled = false
    parryCooldown = false
    noclipEnabled = false
    autoHealEnabled = false
    antiTrapEnabled = false
    autoExitEnabled = false
    antiAfkEnabled = false
    noCooldownEnabled = false
    fpsBoostEnabled = false
    aimAssistEnabled = false
    autoAttackEnabled = false
    autoSabotageEnabled = false
    autoDropEnabled = false
    autoFireEnabled = false
    noStunEnabled = false
    invisibleEnabled = false
    spinbotEnabled = false
    autoMoonwalkEnabled = false
    godmodeEnabled = false
    autoSkillCheckEnabled = false
    
    for _, c in pairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}
    
    revertFpsBoost()
    for _, b in pairs(espBillboards) do
        pcall(function() b:Destroy() end)
    end
    espBillboards = {}
    pcall(function()
        local gui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("AnvilMenu")
        if gui then gui:Destroy() end
    end)
    pcall(function()
        local gui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("AnvilLoad")
        if gui then gui:Destroy() end
    end)
    pcall(function()
        local gui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("AnvilLang")
        if gui then gui:Destroy() end
    end)
    pcall(function()
        for _, g in pairs(game:GetService("CoreGui"):GetChildren()) do
            if g.Name == "AnvilKeybinds" then g:Destroy() end
        end
        local g = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("AnvilKeybinds")
        if g then g:Destroy() end
    end)
    
    print(L.Unloaded)
    pcall(function()local c=player.Character;if c then for _,p in pairs(c:GetDescendants())do if p:IsA("BasePart")then p.Transparency=0;p.CanCollide=true end end end end)
end

-- ============================================
-- ОБНОВЛЕНИЕ КЕША ГЕНЕРАТОРОВ
-- ============================================
local function updateGeneratorCache()
    cachedGenerators = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("generator") or name:find("gen") or name:find("генератор") then
                table.insert(cachedGenerators, obj)
            end
        end
    end
end

updateGeneratorCache()

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") or obj:IsA("Model") then
        local name = obj.Name:lower()
        if name:find("generator") or name:find("gen") or name:find("генератор") then
            table.insert(cachedGenerators, obj)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    for i, gen in pairs(cachedGenerators) do
        if gen == obj then
            table.remove(cachedGenerators, i)
            break
        end
    end
end)

-- ============================================
-- CUSTOM MENU (by anvil)
-- ============================================
local sg = Instance.new("ScreenGui"); sg.Name = "AnvilMenu"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.DisplayOrder = 100
local succ, _ = pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not succ then pcall(function() sg.Parent = player:WaitForChild("PlayerGui") end) end
sg.Enabled = false

local ACCENT = Color3.fromRGB(50,120,255)
local BG = Color3.fromRGB(12,12,16)
local BG2 = Color3.fromRGB(18,18,24)
local SIDE = Color3.fromRGB(8,8,12)
local TXT = Color3.fromRGB(180,180,195)
local TXT2 = Color3.fromRGB(120,120,140)

local main = Instance.new("Frame"); main.Size = UDim2.new(0,640,0,450); main.Position = UDim2.new(0.5,-320,0.5,-225)
main.BackgroundColor3 = BG; main.BorderSizePixel = 0; main.Active = true; main.ZIndex = 10
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)
local mst = Instance.new("UIStroke", main); mst.Color = Color3.fromRGB(35,35,45); mst.Thickness = 1; mst.ZIndex = 10

local title = Instance.new("TextButton"); title.Size = UDim2.new(1,0,0,34); title.BackgroundColor3 = BG2; title.AutoButtonColor = false
title.Text = L.Title; title.TextColor3 = Color3.fromRGB(210,210,225); title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.ZIndex = 11
Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)
local ts2 = Instance.new("UIStroke", title); ts2.Color = Color3.fromRGB(35,35,45); ts2.Thickness = 1; ts2.ZIndex = 11

local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-32,0,4)
closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(200,70,70); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14; closeBtn.ZIndex = 12

-- drag via title
local dragActive = false; local dragStart; local framePos
title.MouseButton1Down:Connect(function()
    dragActive = true; dragStart = userInputService:GetMouseLocation(); framePos = main.Position
    local con; con = userInputService.InputEnded:Connect(function(inp2) if inp2.UserInputType == Enum.UserInputType.MouseButton1 then dragActive = false; con:Disconnect() end end)
end)
userInputService.InputChanged:Connect(function(inp)
    if dragActive and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = userInputService:GetMouseLocation() - dragStart
        main.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- sidebar
local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.new(0,100,1,-42); sidebar.Position = UDim2.new(0,0,0,42); sidebar.BackgroundColor3 = SIDE; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 10
local sc = Instance.new("UICorner", sidebar); sc.CornerRadius = UDim.new(0,6)
local ss = Instance.new("UIStroke", sidebar); ss.Color = Color3.fromRGB(25,25,34); ss.Thickness = 1; ss.ZIndex = 10

-- content area
local contentBg = Instance.new("Frame"); contentBg.Size = UDim2.new(1,-102,1,-44); contentBg.Position = UDim2.new(0,102,0,44); contentBg.BackgroundTransparency = 1; contentBg.BorderSizePixel = 0; contentBg.ZIndex = 10

local tabNames = {L.TabVisuals, L.TabCombat, L.TabRage, L.TabUtility, L.TabTeleport}
local tabBtns = {}; local tabPanels = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,30); btn.Position = UDim2.new(0,5,0,(i-1)*34+8)
    btn.BackgroundColor3 = i == 1 and ACCENT or Color3.fromRGB(14,14,20)
    btn.BorderSizePixel = 0; btn.Text = "  " .. name; btn.TextColor3 = i == 1 and Color3.new(1,1,1) or TXT
    btn.Font = Enum.Font.Gotham; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.ZIndex = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    btn.Parent = sidebar
    tabBtns[name] = btn

    local panel = Instance.new("ScrollingFrame")
    panel.Size = UDim2.new(1,0,1,0); panel.BackgroundTransparency = 1; panel.BorderSizePixel = 0; panel.ZIndex = 10
    panel.ScrollBarThickness = 4; panel.ScrollBarImageColor3 = Color3.fromRGB(30,30,40)
    panel.CanvasSize = UDim2.new(0,0,0,0); panel.Visible = name == L.TabVisuals; panel.Parent = contentBg
    tabPanels[name] = panel
end

-- helpers
local yOff = 4
local getY = function() return yOff end
local addY = function(v) yOff = yOff + v end
local resetY = function() yOff = 4 end

-- ===== BIND SYSTEM =====
local binds = {}
local bindGui = nil

local function closeBindWindow()
    if bindGui then
        pcall(function() bindGui:Destroy() end)
    end
    bindGui = nil
end

local function openBindWindow(label, toggleFn)
    closeBindWindow()
    bindGui = Instance.new("ScreenGui"); bindGui.Name = "AnvilBind"; bindGui.ResetOnSpawn = false; bindGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; bindGui.DisplayOrder = 100
    local ok, _ = pcall(function() bindGui.Parent = game:GetService("CoreGui") end)
    if not ok then pcall(function() bindGui.Parent = player:WaitForChild("PlayerGui") end) end

    local ov = Instance.new("Frame"); ov.Size = UDim2.new(1,0,1,0); ov.BackgroundColor3 = Color3.new(0,0,0); ov.BackgroundTransparency = 0.35; ov.BorderSizePixel = 0; ov.Parent = bindGui
    ov.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then closeBindWindow() end end)

    local bx = Instance.new("Frame"); bx.Size = UDim2.new(0,280,0,150); bx.Position = UDim2.new(0.5,-140,0.5,-75); bx.BackgroundColor3 = BG; bx.BorderSizePixel = 0; bx.Active = true; bx.Parent = bindGui
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0,8)
    local bxs = Instance.new("UIStroke", bx); bxs.Color = Color3.fromRGB(35,35,45); bxs.Thickness = 1

    local ttl = Instance.new("TextLabel"); ttl.Size = UDim2.new(1,0,0,30); ttl.Position = UDim2.new(0,0,0,10); ttl.BackgroundTransparency = 1
    ttl.Text = "Bind: " .. label; ttl.TextColor3 = Color3.fromRGB(210,210,225); ttl.Font = Enum.Font.GothamBold; ttl.TextSize = 14; ttl.TextStrokeTransparency = 0.9; ttl.Parent = bx

    local info = Instance.new("TextLabel"); info.Size = UDim2.new(1,0,0,18); info.Position = UDim2.new(0,0,0,44); info.BackgroundTransparency = 1
    info.Text = "Type a letter (A-Z), 0 = remove"; info.TextColor3 = Color3.fromRGB(120,120,140); info.Font = Enum.Font.Gotham; info.TextSize = 11; info.TextStrokeTransparency = 0.92; info.Parent = bx

    local input = Instance.new("TextBox"); input.Size = UDim2.new(0,120,0,34); input.Position = UDim2.new(0.5,-60,0,66); input.BackgroundColor3 = Color3.fromRGB(22,22,30); input.BorderSizePixel = 0; input.Text = ""; input.TextColor3 = Color3.fromRGB(210,210,225); input.Font = Enum.Font.GothamBold; input.TextSize = 16; input.PlaceholderText = "A"; input.PlaceholderColor3 = Color3.fromRGB(70,70,90); input.ClearTextOnFocus = false; input.ZIndex = 10; input.Parent = bx
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)
    local inputStroke = Instance.new("UIStroke", input); inputStroke.Color = Color3.fromRGB(40,40,55); inputStroke.Thickness = 1

    local save = Instance.new("TextButton"); save.Size = UDim2.new(0,90,0,28); save.Position = UDim2.new(0.5,-45,0,106); save.BackgroundColor3 = ACCENT; save.BorderSizePixel = 0; save.Text = "Save"; save.TextColor3 = Color3.new(1,1,1); save.Font = Enum.Font.GothamBold; save.TextSize = 13; save.Parent = bx
    Instance.new("UICorner", save).CornerRadius = UDim.new(0,6)

    local function saveBind()
        local key = (input.Text or ""):upper():gsub("[%s%p]", ""):sub(1,1)
        if key == "" then return end
        for k in pairs(binds) do
            if k == key then binds[k] = nil end
        end
        if key ~= "0" then
            binds[key] = toggleFn
        end
        closeBindWindow()
    end
    save.MouseButton1Click:Connect(saveBind)
    input.FocusLost:Connect(function(enter) if enter then saveBind() end end)
    task.wait(0.1)
    pcall(function() input:CaptureFocus() end)
end

-- global bind key handler
userInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Unknown then return end
    local fn = binds[input.KeyCode.Name]
    if fn then fn() end
end)

local function makeToggle(panel, name, def, cb)
    local y = getY()
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,26); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,170,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(185,185,195); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 10; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local box = Instance.new("Frame"); box.Size = UDim2.new(0,16,0,16); box.Position = UDim2.new(1,-26,0,5); box.BackgroundColor3 = def and Color3.fromRGB(0,180,80) or Color3.fromRGB(40,40,48); box.BorderSizePixel = 0; Instance.new("UICorner", box).CornerRadius = UDim.new(0,3); box.ZIndex = 10; box.Parent = bg
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 11; btn.Parent = bg
    local val = def
    local function apply()
        val = not val
        box.BackgroundColor3 = val and Color3.fromRGB(0,180,80) or Color3.fromRGB(40,40,48)
        pcall(cb, val)
    end
    btn.MouseButton1Click:Connect(apply)
    btn.MouseButton3Click:Connect(function() openBindWindow(name, apply) end)
    addY(28)
    return function() return val end, function(v) val = v; box.BackgroundColor3 = v and Color3.fromRGB(0,180,80) or Color3.fromRGB(40,40,48) end
end

local function makeSlider(panel, name, mn, mx, inc, def, cb)
    local y = getY()
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,32); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,170,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = name .. ": " .. def; lbl.TextColor3 = Color3.fromRGB(185,185,195); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local val = def
    local sbg = Instance.new("Frame"); sbg.Size = UDim2.new(0,180,0,4); sbg.Position = UDim2.new(0,220,0,14); sbg.BackgroundColor3 = Color3.fromRGB(40,40,48); sbg.BorderSizePixel = 0; Instance.new("UICorner", sbg).CornerRadius = UDim.new(0,2); sbg.Parent = bg
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((def-mn)/(mx-mn),0,1,0); fill.BackgroundColor3 = Color3.fromRGB(0,150,255); fill.BorderSizePixel = 0; Instance.new("UICorner", fill).CornerRadius = UDim.new(0,2); fill.Parent = sbg
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1,0,1,0); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = sbg
    local dragging = false
    drag.MouseButton1Down:Connect(function()
        dragging = true
        local con
        con = userInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false; con:Disconnect() end
        end)
    end)
    drag.MouseButton1Down:Connect(function()
        local absPos = sbg.AbsolutePosition; local sz = sbg.AbsoluteSize.X
        local frac = math.max(0, math.min(1, (userInputService:GetMouseLocation().X - absPos.X) / sz))
        local v = math.floor((mn + frac * (mx - mn)) / inc + 0.5) * inc; v = math.max(mn, math.min(mx, v))
        val = v; fill.Size = UDim2.new((v-mn)/(mx-mn),0,1,0); lbl.Text = name .. ": " .. v; pcall(cb, v)
    end)
    userInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = sbg.AbsolutePosition; local sz = sbg.AbsoluteSize.X
            local frac = math.max(0, math.min(1, (userInputService:GetMouseLocation().X - absPos.X) / sz))
            local v = math.floor((mn + frac * (mx - mn)) / inc + 0.5) * inc; v = math.max(mn, math.min(mx, v))
            val = v; fill.Size = UDim2.new((v-mn)/(mx-mn),0,1,0); lbl.Text = name .. ": " .. v; pcall(cb, v)
        end
    end)
    addY(34)
end

local function makeDropdown(panel, name, opts, def, cb)
    local y = getY()
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,26); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,170,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(185,185,195); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local val = def
    local ddBtn = Instance.new("TextButton"); ddBtn.Size = UDim2.new(0,120,0,20); ddBtn.Position = UDim2.new(0,220,0,3); ddBtn.BackgroundColor3 = Color3.fromRGB(35,35,42); ddBtn.BorderSizePixel = 0; ddBtn.Text = def or opts[1] or ""; ddBtn.TextColor3 = Color3.fromRGB(180,180,190); ddBtn.Font = Enum.Font.Gotham; ddBtn.TextSize = 12; Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0,3); ddBtn.Parent = bg
    local open = false; local ddList = nil; local openTime = 0
    ddBtn.MouseButton1Click:Connect(function()
        if ddList then ddList:Destroy(); ddList = nil; open = false; return end
        open = true; openTime = os.clock()
        ddList = Instance.new("Frame"); ddList.Size = UDim2.new(0,120,0,#opts*24); ddList.Position = UDim2.new(0,220,0,23); ddList.BackgroundColor3 = Color3.fromRGB(25,25,32); ddList.BorderSizePixel = 0; ddList.ZIndex = 10; Instance.new("UICorner", ddList).CornerRadius = UDim.new(0,3); ddList.Parent = bg
        for i2, opt in ipairs(opts) do
            local ob = Instance.new("TextButton"); ob.Size = UDim2.new(1,0,0,24); ob.Position = UDim2.new(0,0,0,(i2-1)*24); ob.BackgroundColor3 = opt == val and Color3.fromRGB(40,40,50) or Color3.fromRGB(25,25,32); ob.BorderSizePixel = 0; ob.Text = opt; ob.TextColor3 = Color3.fromRGB(180,180,190); ob.Font = Enum.Font.Gotham; ob.TextSize = 12; ob.ZIndex = 10; ob.Parent = ddList
            ob.MouseButton1Click:Connect(function()
                val = opt; ddBtn.Text = opt; open = false; pcall(cb, opt)
                if ddList then ddList:Destroy(); ddList = nil end
            end)
        end
    end)
    local con; con = userInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if not open or not ddList then return end
        if os.clock() - openTime < 0.2 then return end
        local abs = ddList.AbsolutePosition; local sz = ddList.AbsoluteSize
        local mx = userInputService:GetMouseLocation().X; local my = userInputService:GetMouseLocation().Y
        if mx < abs.X or mx > abs.X + sz.X or my < abs.Y or my > abs.Y + sz.Y then
            ddList:Destroy(); ddList = nil; open = false
        end
    end)
    addY(28)
end

local function makeSection(panel, name, cb)
    local y = getY()
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,0,22); lbl.Position = UDim2.new(0,0,0,y); lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(100,120,180); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextStrokeTransparency = 0.88; lbl.Parent = panel
    addY(24); if cb then cb() end
end

local function makeButton(panel, name, cb)
    local y = getY()
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,160,0,28); btn.Position = UDim2.new(0.5,-80,0,y); btn.BackgroundColor3 = Color3.fromRGB(40,40,50); btn.BorderSizePixel = 0; btn.Text = name; btn.TextColor3 = Color3.fromRGB(200,70,70); btn.Font = Enum.Font.Gotham; btn.TextSize = 13; btn.TextStrokeTransparency = 0.92; Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4); btn.Parent = panel
    btn.MouseButton1Click:Connect(cb)
    btn.MouseButton3Click:Connect(function() openBindWindow(name, cb) end)
    addY(34)
end

-- ===== TAB: VISUALS =====
resetY(); local vPanel = tabPanels[L.TabVisuals]
makeSection(vPanel, L.SectionVisual)
local fullbrightEnabled = false
makeToggle(vPanel, L.Fullbright, false, function(v) fullbrightEnabled = v; pcall(function() if v then lighting.Brightness = 2; lighting.ClockTime = 14; lighting.FogEnd = 100000; lighting.GlobalShadows = false; lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) else lighting.Brightness = 1; lighting.GlobalShadows = true end end) end)
local noFogEnabled = false
makeToggle(vPanel, L.NoFog, false, function(v) noFogEnabled = v; pcall(function() if v then lighting.FogEnd = 100000; lighting.FogStart = 0 else lighting.FogEnd = 500; lighting.FogStart = 0 end end) end)
makeToggle(vPanel, L.FpsBoost, false, function(v) fpsBoostEnabled = v; pcall(function() if v then applyFpsBoost() else revertFpsBoost() end end) end)

makeSection(vPanel, L.SectionEsp)
makeToggle(vPanel, L.EspKiller, false, function(v) espKiller = v; pcall(function()if v then pcall(setupPlayerTracking)end end); pcall(updateESP) end)
makeToggle(vPanel, L.EspSurvivor, false, function(v) espSurvivor = v; pcall(function()if v then pcall(setupPlayerTracking)end end); pcall(updateESP) end)
makeToggle(vPanel, L.EspGenerator, false, function(v) espGenerator = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspWindow, false, function(v) espWindow = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspPallet, false, function(v) espPallet = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspItems, false, function(v) espItems = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspExit, false, function(v) espExit = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspDist, false, function(v) espShowDistance = v; pcall(updateESP) end)
makeToggle(vPanel, L.EspHealth, false, function(v) healthEspEnabled = v end)
makeToggle(vPanel, L.EspNames, false, function(v) espShowNames = v; pcall(updateESP) end)
makeToggle(vPanel, L.Tracers, false, function(v) tracersEnabled = v end)
makeToggle(vPanel, L.Arrows, false, function(v) arrowsEnabled = v end)
local arrowOpts = {"Names", "Distance"}
makeDropdown(vPanel, L.ArrowsInfo, arrowOpts, "Names", function(o)
    arrowsShowNames = false; arrowsShowDistance = false
    if o == "Names" then arrowsShowNames = true elseif o == "Distance" then arrowsShowDistance = true end
end)
vPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: COMBAT =====
resetY(); local cPanel = tabPanels[L.TabCombat]
makeToggle(cPanel, L.Follow, false, function(v) autoFollowEnabled = v end)
makeToggle(cPanel, L.SkillCheck, false, function(v) autoSkillCheckEnabled = v end)
cPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: RAGE =====
resetY(); local rPanel = tabPanels[L.TabRage]
makeToggle(rPanel, L.KillAura, false, function(v) killAuraEnabled = v; notify(L.KillAura .. " " .. (v and L.On or L.Off), v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end)
makeToggle(rPanel, L.AimAssist, false, function(v) aimAssistEnabled = v end)
makeToggle(rPanel, L.AutoAttack, false, function(v) autoAttackEnabled = v end)
makeToggle(rPanel, L.AutoParry, false, function(v) autoParryEnabled = v; notify(L.AutoParry .. " " .. (v and L.On or L.Off), v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end)
makeToggle(rPanel, L.Spinbot, false, function(v) spinbotEnabled = v end)
makeSlider(rPanel, L.SliderSpin, 1, 50, 1, 8, function(v) spinbotSpeed = v end)
makeToggle(rPanel, L.Moonwalk, false, function(v) autoMoonwalkEnabled = v end)
makeToggle(rPanel, L.NoCooldown, false, function(v) noCooldownEnabled = v end)
makeToggle(rPanel, L.NoStun, false, function(v) noStunEnabled = v end)
makeToggle(rPanel, L.Fire, false, function(v) autoFireEnabled = v end)
makeToggle(rPanel, L.Sabotage, false, function(v) autoSabotageEnabled = v end)
makeToggle(rPanel, L.Drop, false, function(v) autoDropEnabled = v end)
makeToggle(rPanel, "Godmode", false, function(v) godmodeEnabled = v; notify("Godmode " .. (v and L.On or L.Off), v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end)
rPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: UTILITY =====
resetY(); local uPanel = tabPanels[L.TabUtility]
makeToggle(uPanel, L.AutoGen, false, function(v) autoGenEnabled = v; if v then updateGeneratorCache() end end)
makeToggle(uPanel, L.Noclip, false, function(v) noclipEnabled = v; notify(L.Noclip .. " " .. (v and L.On or L.Off), v and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)) end)
makeToggle(uPanel, L.WalkSpeed, false, function(v) walkSpeedEnabled = v; if v and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = walkSpeed end end end)
makeSlider(uPanel, L.SliderWalk, 1, 200, 1, 16, function(v) walkSpeed = v; if walkSpeedEnabled and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end end)
makeToggle(uPanel, L.JumpPower, false, function(v) jumpPowerEnabled = v; if v and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = jumpPower end end end)
makeSlider(uPanel, L.SliderJump, 0, 200, 1, 50, function(v) jumpPower = v; if jumpPowerEnabled and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = v end end end)
makeToggle(uPanel, L.AutoHeal, false, function(v) autoHealEnabled = v end)
makeToggle(uPanel, L.AntiTrap, false, function(v) antiTrapEnabled = v; pcall(updateESP) end)
makeToggle(uPanel, L.AutoExit, false, function(v) autoExitEnabled = v end)
makeToggle(uPanel, L.AntiAfk, false, function(v) antiAfkEnabled = v end)
makeToggle(uPanel, L.Invisible, false, function(v) invisibleEnabled = v; pcall(function()local c=player.Character;if c then for _,p in pairs(c:GetDescendants())do if p:IsA("BasePart")then p.Transparency=v and 1 or 0 end end end end) end)
makeButton(uPanel, L.Heal, function() pcall(function()local c=player.Character;if c then local h=c:FindFirstChildOfClass("Humanoid");if h then h.Health=h.MaxHealth end end end) end)
makeButton(uPanel, L.Teleport, teleportToNearestGenerator)
makeButton(uPanel, L.Unload, unloadAll)
uPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: TELEPORT =====
resetY(); local tPanel = tabPanels[L.TabTeleport]
makeSection(tPanel, L.TabTeleport)
local tpButtons = {}
local function refreshTpList()
    for _, btn in pairs(tpButtons) do pcall(function() btn:Destroy() end) end
    tpButtons = {}
    resetY()
    local y = getY()
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-20,0,28); btn.Position = UDim2.new(0,10,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(35,35,45); btn.BorderSizePixel = 0
            btn.Text = plr.Name; btn.TextColor3 = Color3.fromRGB(180,180,200); btn.Font = Enum.Font.Gotham; btn.TextSize = 13
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
            btn.Parent = tPanel
            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45,45,60) end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,45) end)
            btn.MouseButton1Click:Connect(function()
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root and plr.Character then
                        local target = plr.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                            root.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0))
                            notify("Teleported to " .. plr.Name, Color3.fromRGB(0,200,255))
                        end
                    end
                end
            end)
            table.insert(tpButtons, btn)
            y = y + 34
        end
    end
    addY(#tpButtons * 34 + 4)
    tPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)
end
refreshTpList()
players.PlayerAdded:Connect(function() task.wait(1); refreshTpList() end)
players.PlayerRemoving:Connect(function() refreshTpList() end)
-- auto-refresh every 3 seconds
task.spawn(function() while not isUnloaded do task.wait(3); pcall(refreshTpList) end end)

-- tab switching
for _, name in ipairs(tabNames) do
    tabBtns[name].MouseButton1Click:Connect(function()
        for _, n in ipairs(tabNames) do
            tabPanels[n].Visible = n == name
            local active = n == name
            tabBtns[n].BackgroundColor3 = active and ACCENT or Color3.fromRGB(14,14,20)
            tabBtns[n].TextColor3 = active and Color3.new(1,1,1) or TXT
        end
    end)
end

-- assemble
title.Parent = main; closeBtn.Parent = main; sidebar.Parent = main; contentBg.Parent = main
main.Parent = sg
local MENU_POS = main.Position
local MENU_HIDDEN = UDim2.new(MENU_POS.X.Scale, MENU_POS.X.Offset, MENU_POS.Y.Scale, MENU_POS.Y.Offset - 60)
main.Position = MENU_HIDDEN; sg.Enabled = true
local menuOpen = true
ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = MENU_POS}):Play()

-- toggle
local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        sg.Enabled = true
        main.Position = MENU_HIDDEN
        ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = MENU_POS}):Play()
    else
        local t = ts:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = MENU_HIDDEN})
        t:Play()
        t.Completed:Connect(function() sg.Enabled = false; main.Position = MENU_POS end)
    end
end

closeBtn.MouseButton1Click:Connect(toggleMenu)

-- hotkey
userInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Insert then toggleMenu() end
end)

-- ===== KEYBINDS HUD =====
local kbGui = Instance.new("ScreenGui"); kbGui.Name = "AnvilKeybinds"; kbGui.ResetOnSpawn = false; kbGui.IgnoreGuiInset = true; kbGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; kbGui.DisplayOrder = 100
local succ2, _ = pcall(function() kbGui.Parent = game:GetService("CoreGui") end)
if not succ2 then pcall(function() kbGui.Parent = player:WaitForChild("PlayerGui") end) end
local kbFrame = Instance.new("Frame"); kbFrame.Size = UDim2.new(0,130,0,64); kbFrame.Position = UDim2.new(1,-140,0,8); kbFrame.BackgroundColor3 = Color3.fromRGB(12,12,16); kbFrame.BorderSizePixel = 0; kbFrame.Active = true; kbFrame.Parent = kbGui
Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0,6)
local kbStroke = Instance.new("UIStroke", kbFrame); kbStroke.Color = Color3.fromRGB(35,35,45); kbStroke.Thickness = 1
local kbTitle = Instance.new("TextButton"); kbTitle.Size = UDim2.new(1,0,0,18); kbTitle.Position = UDim2.new(0,8,0,4); kbTitle.BackgroundTransparency = 1; kbTitle.AutoButtonColor = false; kbTitle.Text = ""; kbTitle.ZIndex = 10; kbTitle.Parent = kbFrame
local kbTitleLbl = Instance.new("TextLabel"); kbTitleLbl.Size = UDim2.new(1,0,1,0); kbTitleLbl.BackgroundTransparency = 1; kbTitleLbl.Text = "Keybinds"; kbTitleLbl.TextColor3 = Color3.fromRGB(100,120,180); kbTitleLbl.Font = Enum.Font.GothamBold; kbTitleLbl.TextSize = 11; kbTitleLbl.TextXAlignment = Enum.TextXAlignment.Left; kbTitleLbl.TextStrokeTransparency = 0.88; kbTitleLbl.Parent = kbTitle

-- drag keybinds (only when menu is open)
local kbDrag = false; local kbStart; local kbPos
kbTitle.MouseButton1Down:Connect(function()
    if not menuOpen then return end
    kbDrag = true; kbStart = userInputService:GetMouseLocation(); kbPos = kbFrame.Position
    local con; con = userInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then kbDrag = false; con:Disconnect() end
    end)
end)
userInputService.InputChanged:Connect(function(inp)
    if kbDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = userInputService:GetMouseLocation() - kbStart
        kbFrame.Position = UDim2.new(kbPos.X.Scale, kbPos.X.Offset + delta.X, kbPos.Y.Scale, kbPos.Y.Offset + delta.Y)
    end
end)

local function makeBindEntry(y, key, name, stateFn)
    local entry = Instance.new("Frame"); entry.Size = UDim2.new(1,-16,0,16); entry.Position = UDim2.new(0,8,0,y); entry.BackgroundTransparency = 1; entry.Parent = kbFrame
    local keyBox = Instance.new("Frame"); keyBox.Size = UDim2.new(0,18,0,16); keyBox.BackgroundColor3 = Color3.fromRGB(18,18,24); keyBox.BorderSizePixel = 0; keyBox.Parent = entry
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,3)
    local ks = Instance.new("UIStroke", keyBox); ks.Color = Color3.fromRGB(55,55,65); ks.Thickness = 1
    local kl = Instance.new("TextLabel"); kl.Size = UDim2.new(1,0,1,0); kl.BackgroundTransparency = 1; kl.Text = key; kl.TextColor3 = Color3.fromRGB(185,185,195); kl.Font = Enum.Font.GothamBold; kl.TextSize = 11; kl.TextStrokeTransparency = 0.92; kl.Parent = keyBox
    local nl = Instance.new("TextLabel"); nl.Size = UDim2.new(1,-22,1,0); nl.Position = UDim2.new(0,22,0,0); nl.BackgroundTransparency = 1; nl.Text = name; nl.TextColor3 = Color3.fromRGB(170,170,185); nl.Font = Enum.Font.Gotham; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left; nl.TextStrokeTransparency = 0.92; nl.Parent = entry
    return {stroke = ks, state = stateFn}
end

local bindEntries = {
    makeBindEntry(26, "I", "Menu", function() return menuOpen end),
    makeBindEntry(44, "N", "Noclip", function() return noclipEnabled end),
}
-- update keybinds every frame
runService.RenderStepped:Connect(function()
    for _, e in ipairs(bindEntries) do
        e.stroke.Color = e.state() and Color3.fromRGB(0,200,80) or Color3.fromRGB(55,55,65)
    end
end)

print(L.Loaded)

userInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        notify(L.Noclip .. " " .. (noclipEnabled and L.On or L.Off), noclipEnabled and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100))
    end
end)

-- ============================================
-- ФОНОВЫЕ ПРОЦЕССЫ
-- ============================================

table.insert(connections, runService.RenderStepped:Connect(function()
    if isUnloaded then return end
    if not autoParryEnabled then return end
    if parryCooldown then return end
    
    local char = player.Character
    if not char then return end
    
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and isKiller(otherPlayer.Character) then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if root and myRoot and (root.Position - myRoot.Position).Magnitude < 18 then
                local tools = char:GetChildren()
                for _, tool in pairs(tools) do
                    if tool:IsA("Tool") then
                        pcall(function()
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then hum:EquipTool(tool) end
                            tool:Activate()
                            local activate = tool:FindFirstChild("Activate")
                            if activate and activate:IsA("RemoteEvent") then
                                activate:FireServer()
                            end
                        end)
                        parryCooldown = true
                        task.delay(1.2, function() parryCooldown = false end)
                        break
                    end
                end
            end
        end
    end
end))

-- Auto Generator + Skill Check
local function findSkillCheckRemote()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return end
    for _, v in pairs(gui:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("skill") or v.Name:lower():find("check")) then
            return v
        end
    end
end

task.spawn(function()
    while not isUnloaded do
        task.wait(GEN_UPDATE_INTERVAL)
        if autoGenEnabled then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentTime = tick()
                    if currentTime - lastGenUpdate > 5 then
                        updateGeneratorCache()
                        lastGenUpdate = currentTime
                    end
                    local nearestGen = nil
                    local nearestDist = 20
                    for _, gen in pairs(cachedGenerators) do
                        if gen and gen.Parent then
                            local dist = (gen.Position - root.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestGen = gen
                            end
                        end
                    end
                    if nearestGen then
                        root.CFrame = CFrame.new(root.Position, nearestGen.Position + Vector3.new(0, 2, 0))
                        local clickDetector = nearestGen:FindFirstChild("ClickDetector")
                        if clickDetector then
                            pcall(function() clickDetector:Click() end)
                        end
                        userInputService:SetKeyDown(Enum.KeyCode.R)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while not isUnloaded do
        task.wait(0.1)
        if autoGenEnabled or autoSkillCheckEnabled then
            local remote = findSkillCheckRemote()
            if remote then
                pcall(function() remote:FireServer(true) end)
            end
            pcall(function()
                local gui = player:FindFirstChild("PlayerGui")
                if gui then
                    for _, v in pairs(gui:GetDescendants()) do
                        if v:IsA("ImageButton") or v:IsA("TextButton") then
                            local n = v.Name:lower()
                            if n:find("skill") or n:find("check") or n:find("hit") then
                                v:Fire("MouseButton1Click")
                            end
                        end
                    end
                end
            end)
        end
    end
end)

table.insert(connections, runService.RenderStepped:Connect(function()
    if isUnloaded then return end
    if not killAuraEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
            if otherRoot and (otherRoot.Position - root.Position).Magnitude < 12 then
                root.CFrame = CFrame.new(root.Position, otherRoot.Position)
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    local remote = tool:FindFirstChildWhichIsA("RemoteEvent")
                    if remote then remote:FireServer() end
                end
            end
        end
    end
end))

table.insert(connections, runService.Stepped:Connect(function()
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local climbing = hum and hum:GetState() == Enum.HumanoidStateType.Climbing
    if noclipEnabled then
        local collide = climbing
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = collide
            end
        end
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then hum.JumpPower = jumpPower end
    end
end))

userInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then moonwalkKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A then moonwalkKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then moonwalkKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then moonwalkKeys.D = true end
end)
userInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then moonwalkKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A then moonwalkKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then moonwalkKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then moonwalkKeys.D = false end
end)

table.insert(connections, runService.Heartbeat:Connect(function(dt)
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root then return end

    if spinbotEnabled then
        local moving = userInputService:IsKeyDown(Enum.KeyCode.W) or userInputService:IsKeyDown(Enum.KeyCode.A) or userInputService:IsKeyDown(Enum.KeyCode.S) or userInputService:IsKeyDown(Enum.KeyCode.D)
        local jumping = userInputService:IsKeyDown(Enum.KeyCode.Space)
        if not moving and not jumping then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinbotSpeed), 0)
        end
    end

    if hum then hum.AutoRotate = true end

    if autoMoonwalkEnabled and root and hum then
        hum.AutoRotate = false
        local cam = workspace.CurrentCamera
        if cam then
            local moveVec = Vector3.new(
                (moonwalkKeys.D and 1 or 0) - (moonwalkKeys.A and 1 or 0),
                0,
                (moonwalkKeys.S and 1 or 0) - (moonwalkKeys.W and 1 or 0)
            )
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit
                local camLook = (cam.CFrame.LookVector * Vector3.new(1,0,1)).Unit
                local camRight = (cam.CFrame.RightVector * Vector3.new(1,0,1)).Unit
                local worldDir = (camLook * -moveVec.Z + camRight * moveVec.X).Unit
                root.CFrame = CFrame.new(root.Position, root.Position - worldDir)
                hum:Move(worldDir, false)
            end
        end
    end

    if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
    if jumpPowerEnabled then hum.JumpPower = jumpPower end
end))

table.insert(connections, player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if walkSpeedEnabled then hum.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then hum.JumpPower = jumpPower end
        if invisibleEnabled then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 1 end
            end
        end
        table.insert(connections, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if not isUnloaded and walkSpeedEnabled then
                hum.WalkSpeed = walkSpeed
            end
        end))
        table.insert(connections, hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if not isUnloaded and jumpPowerEnabled then
                hum.JumpPower = jumpPower
            end
        end))
        table.insert(connections, hum.HealthChanged:Connect(function()
            if not isUnloaded and godmodeEnabled then
                hum.Health = 9e9
            end
        end))
    end
end))

-- Auto Heal + Auto Exit + Aim Assist + Auto Attack + Auto Follow
local scanTimer = 0
table.insert(connections, runService.RenderStepped:Connect(function(dt)
    if isUnloaded then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    scanTimer = scanTimer + (dt or 0.016)
    local canScan = scanTimer >= 0.3

    pcall(updateTracers)
    pcall(updateHealthESP)
    pcall(updateArrows)
    if noStunEnabled and hum.Sit then hum.Sit = false end
    if canScan then
        scanTimer = 0
        if autoSabotageEnabled then pcall(doAutoSabotage) end
        if autoDropEnabled then pcall(doAutoDrop) end
        if autoExitEnabled then
            local gate, cd = findExitGate()
            if gate and cd and root then
                local dist = (gate.Position - root.Position).Magnitude
                if dist < 15 then pcall(function() cd:Click() end) end
            end
        end
        if autoHealEnabled and hum.Health < 40 then
            local medkit = findMedkit()
            if medkit then
                pcall(function()
                    local hum2 = char:FindFirstChildOfClass("Humanoid")
                    if hum2 then hum2:EquipTool(medkit) end
                    medkit:Activate()
                end)
            end
        end
    end
    if autoFireEnabled then pcall(doAutoFire) end

    if autoFollowEnabled then pcall(autoFollowUpdate) end

    if godmodeEnabled and hum then
        hum.MaxHealth = 9e9
        hum.Health = 9e9
    end

    if fullbrightEnabled then
        pcall(function() lighting.Brightness = 2; lighting.ClockTime = 14; lighting.GlobalShadows = false; lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) end)
    end
    if noFogEnabled then
        pcall(function() lighting.FogEnd = 100000; lighting.FogStart = 0 end)
    end

    if aimAssistEnabled then
        local nearest = nil
        local nearestDist = 20
        for _, otherPlayer in pairs(players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot and not isKiller(otherPlayer.Character) then
                    local dist = (otherRoot.Position - root.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = otherRoot
                    end
                end
            end
        end
        if nearest then
            root.CFrame = CFrame.new(root.Position, nearest.Position)
        end
    end

    if autoAttackEnabled then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for _, otherPlayer in pairs(players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot and not isKiller(otherPlayer.Character) and (otherRoot.Position - root.Position).Magnitude < 12 then
                        root.CFrame = CFrame.new(root.Position, otherRoot.Position)
                        tool:Activate()
                        local remote = tool:FindFirstChildWhichIsA("RemoteEvent")
                        if remote then remote:FireServer() end
                    end
                end
            end
        end
    end
end))

-- Anti-AFK
task.spawn(function()
    while not isUnloaded do
        task.wait(30)
        if antiAfkEnabled and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:Move(Vector3.new(0, 0, 0.1), true)
                task.wait(0.1)
                hum:Move(Vector3.new(0, 0, 0), true)
            end
        end
    end
end)

-- No Cooldown
task.spawn(function()
    while not isUnloaded do
        task.wait(0.3)
        if noCooldownEnabled and player.Character then
            local function clearTool(tool)
                if not tool:IsA("Tool") then return end
                for _, v in pairs(tool:GetDescendants()) do
                    pcall(function()
                        if (v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("FloatValue") or v:IsA("DoubleValue")) then
                            local n = v.Name:lower()
                            if n:find("cooldown") or n:find("cd") or n:find("timer") or n:find("delay") or n:find("time") or n:find("last") or n:find("stam") then
                                v.Value = 0
                            end
                        end
                        if v:IsA("BoolValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("canuse") or v.Name:lower():find("ready") or v.Name:lower():find("canatk")) then
                            v.Value = true
                        end
                        if v:IsA("RemoteEvent") and (v.Name:lower():find("cooldown") or v.Name:lower():find("reset")) then
                            v:FireServer()
                        end
                    end)
                end
                pcall(function()
                    for attr, _ in pairs(tool:GetAttributes()) do
                        local an = attr:lower()
                        if an:find("cooldown") or an:find("cd") or an:find("timer") or an:find("last") then
                            tool:SetAttribute(attr, 0)
                        end
                    end
                end)
            end
            for _, tool in pairs(player.Character:GetChildren()) do clearTool(tool) end
            local bp = player:FindFirstChild("Backpack")
            if bp then for _, tool in pairs(bp:GetChildren()) do clearTool(tool) end end
        end
    end
end)

-- FPS Boost maintenance
task.spawn(function()
    while not isUnloaded do
        task.wait(10)
        if fpsBoostEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                pcall(function()
                    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end)
            end
        end
    end
end)
