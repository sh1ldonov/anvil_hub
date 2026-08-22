-- ============================================
-- ANVIL SAN DIEGO BORDER ROLEPLAY | LOW GRAPHICS (menu + keybinds из anvil.lua)
-- Insert - меню | Q - хоткей (toggle/hold)
-- Target Lock - целится в одного, пока не умрёт
-- Middle-click по тумблеру - сменить хоткей
-- ============================================

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local camera = workspace.CurrentCamera

local isMobile = uis.TouchEnabled and not uis.KeyboardEnabled

local set = {
    enabled = false,
    hold = false,
    teamCheck = true,
    aimBots = true,
    targetLock = true,
    legitMode = false,      -- НОВОЕ: легит режим
    showFov = true,         -- НОВОЕ: показывать FOV круг
    fov = 200,
    maxDist = 120,
    smooth = 0.35,
    legitSmooth = 0.12,     -- НОВОЕ: сглаживание для легит режима (меньше = плавнее)
    legitFov = 45,          -- НОВОЕ: FOV для легит режима
    silentAim = false,      -- НОВОЕ: silent aim (стрельба без видимого наведения)
    silentDist = 150,       -- НОВОЕ: дистанция silent aim
    friends = {},
    esp = false,
    espRange = 100,
    espShowName = false,
    espShowDist = false,
    espShowHp = true,
    farmActive = false,
    farmStatus = "Ожидание",
    chamsSelf = false,
    chamsPlayers = false,
    chamsMode = "Solid",
    chamsAlpha = 0,
    chamsColor = "Тема",
    night = false,
    nightBright = 0.6,
    lowGFX = false,
    wallCheck = true,
    weaponCheck = true,
    lang = "Русский",
}

-- ===== LANGUAGE (RU/EN) =====
LANG = {
    ["Target Lock (одна цель)"] = "Target Lock (single target)",
    ["Hold (жми и держи)"] = "Hold (press and hold)",
    ["Aim на ботов (NPC)"] = "Aim at bots (NPC)",
    ["Legit Mode (плавно)"] = "Legit Mode (smooth)",
    ["Основные настройки"] = "Main settings",
    ["FOV (от прицела)"] = "FOV (from aim)",
    ["Показывать FOV круг"] = "Show FOV circle",
    ["Wall Check (не сквозь стены)"] = "Wall Check (not through walls)",
    ["Только с оружием"] = "Only with weapon",
    ["Средний клик по тумблеру — смена хоткея"] = "Middle click on a toggle — change hotkey",
    ["Wallhack (ESP)"] = "Wallhack (ESP)",
    ["ESP (по командам)"] = "ESP (for cops)",
    ["WH дистанция (м)"] = "WH distance (m)",
    ["Ники"] = "Names",
    ["Дистанция"] = "Distance",
    ["ХП бар"] = "HP bar",
    ["- Красный: враг | Зелёный: свои | Голубой: друг"] = "- Red: enemy | Green: teammate | Cyan: friend",
    ["Chams (себя)"] = "Chams (self)",
    ["Chams (игроки)"] = "Chams (players)",
    ["Chams прозрачность"] = "Chams transparency",
    ["Chams цвет"] = "Chams color",
    ["Тема"] = "Theme",
    ["Красный"] = "Red",
    ["Зелёный"] = "Green",
    ["Голубой"] = "Cyan",
    ["Жёлтый"] = "Yellow",
    ["Белый"] = "White",
    ["Фиолетовый"] = "Purple",
    ["Оранжевый"] = "Orange",
    ["Night Mode (ночь)"] = "Night Mode (darkness)",
    ["Яркость ночи"] = "Night brightness",
    ["Переливание"] = "Pulse",
    ["Пульс (переливание)"] = "Pulse (color shift)",
    ["Скорость"] = "Speed",
    ["Готовые темы"] = "Ready themes",
    ["Красный (R)"] = "Red (R)",
    ["Зелёный (G)"] = "Green (G)",
    ["Синий (B)"] = "Blue (B)",
    ["Основной цвет"] = "Primary color",
    ["Дополнительный цвет"] = "Secondary color",
    ["Скорость полёта"] = "Flight speed",
    ["Money Tracker (прибыль)"] = "Money Tracker (profit)",
    ["Статус: Ожидание"] = "Status: Waiting",
    ["Статус: покупаем "] = "Status: buying ",
    ["Статус: куплено "] = "Status: bought ",
    ["Статус: куплено, летим дальше"] = "Status: bought, flying on",
    ["Статус: летим — "] = "Status: flying — ",
    ["Статус: нажимаем — "] = "Status: pressing — ",
    ["Статус: ожидание персонажа..."] = "Status: waiting for character...",
    ["Статус: преступники не найдены"] = "Status: no criminals found",
    ["Статус: работаем — "] = "Status: working — ",
    ["Статус: тайзер"] = "Status: taser",
    ["Статус: наручники"] = "Status: handcuffs",
    ["Статус: арест"] = "Status: arrest",
    [" шт"] = " pcs",
    ["Купите полную версию"] = "Buy the full version",
    ["Нажмите и ссылка скопируется"] = "Click and the link will be copied",
    ["Закрыть"] = "Close",
    ["Ссылка скопирована в буфер обмена!"] = "Link copied to clipboard!",
    ["Друзья (никогда не целится)"] = "Friends (never targeted)",
    ["Ник друга:"] = "Friend's name:",
    ["   (клик - удалить)"] = "   (click to remove)",
    ["About"] = "About",
    ["Графика"] = "Graphics",
    ["LOW GRAPHICS (картофель)"] = "LOW GRAPHICS (potato)",
    ["Unload"] = "Unload",
    ["Unload (выгрузить скрипт)"] = "Unload (unload script)",
    ["ANVIL SAN DIEGO BORDER ROLEPLAY | LOW GRAPHICS\nInsert - меню | Средний клик по тумблеру - хоткей"] = "ANVIL SAN DIEGO BORDER ROLEPLAY | LOW GRAPHICS\nInsert - menu | Middle click on a toggle - hotkey",
    ["Поиск: Aimbot, ESP, Farm..."] = "Search: Aimbot, ESP, Farm...",
    ["Название конфига"] = "Config name",
    ["Конфиги:"] = "Configs:",
    ["Выбран: "] = "Selected: ",
    ["Сохранено: "] = "Saved: ",
    ["Ошибка: "] = "Error: ",
    ["Выберите конфиг в списке"] = "Select a config from the list",
    ["Конфиг не найден"] = "Config not found",
    ["пустой конфиг"] = "empty config",
    ["Загружено: "] = "Loaded: ",
    [" настроек"] = " settings",
    ["Папка открыта"] = "Folder opened",
    ["Не удалось открыть папку (путь: "] = "Failed to open folder (path: ",
    ["Сохранить конфиг"] = "Save config",
    ["Открыть папку"] = "Open folder",
    ["Загрузить конфиг"] = "Load config",
    ["Язык"] = "Language",
    ["Английский интерфейс"] = "English UI",
}

LANGR = {}
do
    for k, v in pairs(LANG) do LANGR[v] = k end
end

function loc(s)
    if set.lang == "English" then
        return LANG[s] or s
    else
        return LANGR[s] or s
    end
end

function trUI(s)
    local lang = set.lang
    if lang == "English" then
        if LANG[s] then return LANG[s] end
        local bestK
        for k in pairs(LANG) do
            if k ~= s and s:sub(1, #k) == k and (#(bestK or "") < #k) then bestK = k end
        end
        if bestK then return LANG[bestK] .. s:sub(#bestK + 1) end
    else
        if LANGR[s] then return s end
        local bestV
        for k, v in pairs(LANG) do
            if v ~= s and s:sub(1, #v) == v and (#(bestV or "") < #v) then bestV = v end
        end
        if bestV then return LANGR[bestV] .. s:sub(#bestV + 1) end
    end
    return s
end

function localizeUI()
    local roots = {}
    local function collect(par)
        if not par then return end
        for _, g in ipairs(par:GetChildren()) do
            if g:IsA("ScreenGui") and g.Name:sub(1, 5) == "Anvil" then
                roots[#roots + 1] = g
            end
        end
    end
    collect(game:GetService("CoreGui"))
    collect(game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"))
    for _, root in ipairs(roots) do
        for _, obj in ipairs(root:GetDescendants()) do
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local t = obj.Text
                    for _ = 1, 6 do
                        local n = trUI(t)
                        if n == t then break end
                        t = n
                    end
                    obj.Text = t
                elseif obj:IsA("TextBox") and obj.PlaceholderText ~= "" then
                    obj.PlaceholderText = loc(obj.PlaceholderText)
                end
            end)
        end
    end
end

local connections = {}
local unloaded = false
local keyDown = false
local lockTarget = nil
local unloadAll
local clearAllEsp
local startRingFarm
local setMoneyTracker
local resetMoneyBase
local farmTarget = nil
local farmRunning = false
local function on(ev, fn)
    connections[#connections + 1] = ev:Connect(fn)
end

local ASSET_CACHE = {}
local function loadRemoteImage(url)
    if ASSET_CACHE[url] then return ASSET_CACHE[url] end
    local res = url
    pcall(function()
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if ok and data and #data > 0 then
            local path = "anvil_" .. tostring(player.UserId) .. "_logo.png"
            pcall(function()
                writefile(path, data)
                res = getcustomasset(path)
            end)
        end
    end)
    ASSET_CACHE[url] = res
    return res
end

-- ===== UI (стиль anvil.lua) =====
local BG = Color3.fromRGB(13,13,18)
local BG2 = Color3.fromRGB(19,19,26)
local SIDE = Color3.fromRGB(9,9,14)
local TXT = Color3.fromRGB(226,226,238)
local TXT2 = Color3.fromRGB(128,128,152)
local ROW_BG = Color3.fromRGB(21,21,30)
local ROW_HOVER = Color3.fromRGB(29,29,40)
local SW_OFF = Color3.fromRGB(58,58,76)
local TRACK = Color3.fromRGB(38,38,52)
local INPUT_BG = Color3.fromRGB(24,24,34)
local STROKE = Color3.fromRGB(38,38,52)
local RED = Color3.fromRGB(224,80,80)
local GREEN = Color3.fromRGB(70,200,110)
local YELLOW = Color3.fromRGB(230,180,40)

-- ===== THEME (основной + доп цвет, переливание) =====
local theme = {
    pulse = true,
    speed = 2,
    primary = { r = 60, g = 140, b = 255 },
    secondary = { r = 255, g = 70, b = 150 },
}
local themeReg = {}
local function getAccent()
    local p = theme.primary; local s = theme.secondary
    local k = 0
    if theme.pulse then k = (math.sin(os.clock() * theme.speed) + 1) / 2 end
    return Color3.fromRGB(
        math.floor(p.r + (s.r - p.r) * k),
        math.floor(p.g + (s.g - p.g) * k),
        math.floor(p.b + (s.b - p.b) * k))
end
local function themeApply()
    local c = getAccent()
    for _, r in ipairs(themeReg) do
        pcall(function()
            if r.check then r.obj[r.prop] = r.check(c) else r.obj[r.prop] = c end
        end)
    end
end
local themeTick = 0
local accentCache = getAccent()
on(rs.RenderStepped, function(dt)
    themeTick = themeTick + dt
    if themeTick < 0.1 then return end
    themeTick = 0
    accentCache = getAccent()
    if theme.pulse then
        themeApply()
    end
end)

local function cleanupOld()
    for _, n in ipairs({ "AnvilAimMenu", "AnvilAimKeybinds", "AnvilAimWatermark" }) do
        pcall(function()
            local g = game:GetService("CoreGui"):FindFirstChild(n)
            if g then g:Destroy() end
        end)
        pcall(function()
            local g = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild(n)
            if g then g:Destroy() end
        end)
    end
end
cleanupOld()

local sg = Instance.new("ScreenGui"); sg.Name = "AnvilAimMenu"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.DisplayOrder = 100
local succ, _ = pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not succ then pcall(function() sg.Parent = player:WaitForChild("PlayerGui") end) end
sg.Enabled = false

local main = Instance.new("Frame"); main.Size = UDim2.new(0,660,0,480); main.Position = UDim2.new(0.5,-330,0.5,-240)
main.BackgroundColor3 = BG; main.BorderSizePixel = 0; main.Active = true; main.ZIndex = 10
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- ===== АВТО-МАСШТАБ МЕНЮ (телефон / маленький экран) =====
local MI = { open = true, scale = 1, ui = Instance.new("UIScale") }
do
    MI.ui.Name = "AnvilScale"
    MI.ui.Parent = main
    MI.pos = UDim2.new(0.5, -330, 0.5, -240)
    MI.hidden = UDim2.new(0.5, -330, 0.5, -300)
    MI.apply = function()
        local vp = camera.ViewportSize
        local w, h = vp.X, vp.Y
        if w > 0 and h > 0 then
            local s = math.min(w / 880, (h - 24) / 550)
            s = math.max(0.32, math.min(1, s))
            MI.scale = s
            MI.ui.Scale = s
            local halfW = math.floor(s * 660 / 2)
            local halfH = math.floor(s * 480 / 2)
            MI.pos = UDim2.new(0.5, -halfW, 0.5, -halfH)
            MI.hidden = UDim2.new(0.5, -halfW, 0.5, -halfH - math.floor(80 * s))
        end
    end
    MI.apply()
    on(camera:GetPropertyChangedSignal("ViewportSize"), function()
        MI.apply()
        if MI.open then main.Position = MI.pos else main.Position = MI.hidden end
    end)
end
local mst = Instance.new("UIStroke", main); mst.Color = STROKE; mst.Transparency = 0.4; mst.Thickness = 1; mst.ZIndex = 10
themeReg[#themeReg + 1] = { obj = mst, prop = "Color", check = function() return getAccent() end }

local title = Instance.new("TextButton"); title.Size = UDim2.new(1,0,0,44); title.BackgroundTransparency = 1; title.AutoButtonColor = false; title.Text = ""; title.ZIndex = 11; title.Parent = main
local logo = Instance.new("ImageLabel"); logo.Size = UDim2.new(0,22,0,22); logo.Position = UDim2.new(0,10,0,11); logo.BackgroundTransparency = 1; logo.Image = loadRemoteImage("https://i.ibb.co/r2DjrFMR/1-Photoroom.png"); logo.ZIndex = 12; logo.Parent = title
local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(0,320,0,20); titleLbl.Position = UDim2.new(0,36,0,9); titleLbl.BackgroundTransparency = 1; titleLbl.RichText = true; titleLbl.Text = "ANVIL PREMIUM"; titleLbl.TextColor3 = TXT; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 15; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 12; titleLbl.Parent = title
local titleSub = Instance.new("TextLabel"); titleSub.Size = UDim2.new(0,320,0,16); titleSub.Position = UDim2.new(0,36,0,28); titleSub.BackgroundTransparency = 1; titleSub.Text = "SAN DIEGO BORDER ROLEPLAY"; titleSub.TextColor3 = TXT2; titleSub.Font = Enum.Font.Gotham; titleSub.TextSize = 10; titleSub.TextXAlignment = Enum.TextXAlignment.Left; titleSub.ZIndex = 12; titleSub.Parent = title
local headerLine = Instance.new("Frame"); headerLine.Size = UDim2.new(1,0,0,1); headerLine.Position = UDim2.new(0,0,0,43); headerLine.BackgroundColor3 = STROKE; headerLine.BackgroundTransparency = 0.5; headerLine.BorderSizePixel = 0; headerLine.ZIndex = 11; headerLine.Parent = main

local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-14,0,9); closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(32,32,44); closeBtn.Text = "×"; closeBtn.TextColor3 = Color3.fromRGB(214,86,86); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 16; closeBtn.ZIndex = 12; closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = RED end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(32,32,44) end)
closeBtn.MouseButton1Down:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(120,44,44) end)
closeBtn.MouseButton1Up:Connect(function() closeBtn.BackgroundColor3 = RED end)

local dragActive = false; local dragStart; local framePos
title.MouseButton1Down:Connect(function()
    dragActive = true; dragStart = uis:GetMouseLocation(); framePos = main.Position
    local con; con = uis.InputEnded:Connect(function(inp2) if inp2.UserInputType == Enum.UserInputType.MouseButton1 then dragActive = false; con:Disconnect() end end)
end)
on(uis.InputChanged, function(inp)
    if dragActive and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = uis:GetMouseLocation() - dragStart
        main.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.new(0,132,1,-46); sidebar.Position = UDim2.new(0,0,0,46); sidebar.BackgroundColor3 = SIDE; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 10
local sCorner = Instance.new("UICorner", sidebar); sCorner.CornerRadius = UDim.new(0,8)
local ss = Instance.new("UIStroke", sidebar); ss.Color = STROKE; ss.Transparency = 0.4; ss.Thickness = 1; ss.ZIndex = 10

local contentBg = Instance.new("Frame"); contentBg.Size = UDim2.new(1,-136,1,-48); contentBg.Position = UDim2.new(0,134,0,48); contentBg.BackgroundTransparency = 1; contentBg.BorderSizePixel = 0; contentBg.ZIndex = 10

local tabNames = { "Combat", "Visuals", "Farm", "Friends", "Settings", "Theme" }
local tabBtns = {}; local tabPanels = {}
local activeTab = "Combat"
local paintTab

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-12,0,32); btn.Position = UDim2.new(0,6,0,(i-1)*38 + 9)
    btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.AutoButtonColor = false
    btn.Text = name; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextColor3 = TXT2; btn.ZIndex = 11
    btn.Parent = sidebar
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then btn.BackgroundColor3 = ROW_HOVER; btn.BackgroundTransparency = 0.5; btn.TextColor3 = TXT end
    end)
    btn.MouseLeave:Connect(function()
        paintTab(name)
    end)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    tabBtns[name] = btn

    local panel = Instance.new("ScrollingFrame")
    panel.Size = UDim2.new(1,0,1,-34); panel.Position = UDim2.new(0,0,0,34); panel.BackgroundTransparency = 1; panel.BorderSizePixel = 0; panel.ZIndex = 10
    panel.ScrollBarThickness = 5; panel.ScrollBarImageColor3 = Color3.fromRGB(48,48,64); panel.ScrollBarImageTransparency = 0.6
    panel.CanvasSize = UDim2.new(0,0,0,0); panel.Visible = i == 1; panel.Parent = contentBg
    tabPanels[name] = panel
end

local searchBox = Instance.new("TextBox"); searchBox.Size = UDim2.new(1,-16,0,26); searchBox.Position = UDim2.new(0,8,0,4)
searchBox.BackgroundColor3 = INPUT_BG; searchBox.BorderSizePixel = 0; searchBox.Text = ""; searchBox.TextColor3 = TXT
searchBox.Font = Enum.Font.Gotham; searchBox.TextSize = 13; searchBox.PlaceholderText = loc("Поиск: Aimbot, ESP, Farm..."); searchBox.PlaceholderColor3 = TXT2; searchBox.ClearTextOnFocus = true; searchBox.ZIndex = 11; searchBox.Parent = contentBg
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)
local searchStroke = Instance.new("UIStroke", searchBox); searchStroke.Color = STROKE; searchStroke.Thickness = 1
searchBox.MouseEnter:Connect(function() searchStroke.Color = getAccent(); searchStroke.Thickness = 1.5 end)
searchBox.MouseLeave:Connect(function() searchStroke.Color = STROKE; searchStroke.Thickness = 1 end)

paintTab = function(n)
    local a = (n == activeTab)
    local btn = tabBtns[n]
    btn.BackgroundColor3 = a and ROW_HOVER or ROW_BG
    btn.BackgroundTransparency = a and 0.55 or 1
    btn.TextColor3 = a and TXT or TXT2
end
for _, n in ipairs(tabNames) do paintTab(n) end

for _, name in ipairs(tabNames) do
    tabBtns[name].MouseButton1Click:Connect(function()
        if activeTab == name then return end
        activeTab = name
        for _, n in ipairs(tabNames) do
            tabPanels[n].Visible = n == name
            paintTab(n)
        end
    end)
end
themeReg[#themeReg + 1] = { obj = main, prop = "BackgroundColor3", check = function() return BG end }

-- helpers
local yOff = 4
local getY = function() return yOff end
local addY = function(v) yOff = yOff + v end
local resetY = function() yOff = 4 end

-- search registry
local widgetRows = {}
local function applySearch(q)
    q = (q or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
    if q == "" then
        for _, r in ipairs(widgetRows) do r.root.Visible = true end
        for _, n in ipairs(tabNames) do tabPanels[n].Visible = n == activeTab end
        return
    end
    local shownPanel = nil
    for _, r in ipairs(widgetRows) do
        local match = string.find(r.name:lower(), q, 1, true) ~= nil
        r.root.Visible = match
        if match and not shownPanel then shownPanel = r.panel end
    end
    for _, n in ipairs(tabNames) do
        local vis = shownPanel and tabPanels[n] == shownPanel
        tabPanels[n].Visible = vis or false
        paintTab(n)
        if vis then activeTab = n end
    end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(function() applySearch(searchBox.Text) end)

local function makeSection(panel, name)
    local y = getY()
    local bar = Instance.new("Frame"); bar.Size = UDim2.new(0,3,0,12); bar.Position = UDim2.new(0,12,0,y+2); bar.BackgroundColor3 = getAccent(); bar.BorderSizePixel = 0; bar.ZIndex = 10; bar.Parent = panel
    themeReg[#themeReg + 1] = { obj = bar, prop = "BackgroundColor3", check = function() return getAccent() end }
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-40,0,16); lbl.Position = UDim2.new(0,22,0,y); lbl.BackgroundTransparency = 1
    lbl.Text = loc(name); lbl.TextColor3 = TXT2; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextStrokeTransparency = 0.92; lbl.Parent = panel
    local line = Instance.new("Frame"); line.Size = UDim2.new(1,-44,0,1); line.Position = UDim2.new(0,22,0,y+15); line.BackgroundColor3 = getAccent(); line.BackgroundTransparency = 0.35; line.BorderSizePixel = 0; line.Parent = panel
    themeReg[#themeReg + 1] = { obj = line, prop = "BackgroundColor3", check = function() return getAccent() end }
    addY(24)
    widgetRows[#widgetRows + 1] = { panel = panel, root = bar, name = name }
end

-- ===== BIND SYSTEM (из anvil.lua) =====
local binds = {}
local bindGui = nil
local function closeBindWindow()
    if bindGui then pcall(function() bindGui:Destroy() end); bindGui = nil end
end

local function openBindWindow(label, toggleFn, stateFn)
    closeBindWindow()
    local ov = Instance.new("Frame"); ov.Size = UDim2.new(1,0,1,0); ov.BackgroundColor3 = Color3.new(0,0,0); ov.BackgroundTransparency = 0.5; ov.ZIndex = 50
    pcall(function() ov.Parent = sg end)
    ov.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then closeBindWindow() end end)

    local bx = Instance.new("Frame"); bx.Size = UDim2.new(0,220,0,145); bx.Position = UDim2.new(0.5,-110,0.5,-72); bx.BackgroundColor3 = BG2; bx.BorderSizePixel = 0; bx.Active = true; bx.ZIndex = 60; bx.Parent = ov
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0,8)
    local bxs = Instance.new("UIStroke", bx); bxs.Color = STROKE; bxs.Transparency = 0.5; bxs.Thickness = 1

    local ttl = Instance.new("TextLabel"); ttl.Size = UDim2.new(1,0,0,30); ttl.Position = UDim2.new(0,14,0,10); ttl.BackgroundTransparency = 1; ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Text = "Bind: " .. loc(label); ttl.TextColor3 = TXT; ttl.Font = Enum.Font.GothamBold; ttl.TextSize = 14; ttl.TextStrokeTransparency = 0.9; ttl.Parent = bx

    local info = Instance.new("TextLabel"); info.Size = UDim2.new(1,-28,0,18); info.Position = UDim2.new(0,14,0,44); info.BackgroundTransparency = 1; info.TextXAlignment = Enum.TextXAlignment.Left
    info.Text = "Type a letter (A-Z), 0 = remove"; info.TextColor3 = TXT2; info.Font = Enum.Font.Gotham; info.TextSize = 11; info.TextStrokeTransparency = 0.92; info.Parent = bx

    local input = Instance.new("TextBox"); input.Size = UDim2.new(0,120,0,34); input.Position = UDim2.new(0.5,-60,0,66); input.BackgroundColor3 = INPUT_BG; input.BorderSizePixel = 0; input.Text = ""; input.TextColor3 = TXT; input.Font = Enum.Font.GothamBold; input.TextSize = 16; input.PlaceholderText = "A"; input.PlaceholderColor3 = Color3.fromRGB(70,70,90); input.ClearTextOnFocus = false; input.ZIndex = 10; input.Parent = bx
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)
    local inputStroke = Instance.new("UIStroke", input); inputStroke.Color = STROKE; inputStroke.Thickness = 1

    local save = Instance.new("TextButton"); save.Size = UDim2.new(0,90,0,28); save.Position = UDim2.new(0.5,-45,0,106); save.BackgroundColor3 = getAccent(); save.BorderSizePixel = 0; save.Text = "Save"; save.TextColor3 = Color3.new(1,1,1); save.Font = Enum.Font.GothamBold; save.TextSize = 13; save.Parent = bx
    themeReg[#themeReg + 1] = { obj = save, prop = "BackgroundColor3", check = function() return getAccent() end }
    Instance.new("UICorner", save).CornerRadius = UDim.new(0,6)

    bindGui = ov
    local function saveBind()
        local key = (input.Text or ""):upper():gsub("[%s%p]", ""):sub(1,1)
        if key == "" then return end
        for k, b in pairs(binds) do
            if b and b.name == label then binds[k] = nil end
        end
        local keyTaken = nil
        for k in pairs(binds) do if k == key then keyTaken = k end end
        if keyTaken and binds[keyTaken].name ~= label then binds[keyTaken] = nil end
        if key ~= "0" then binds[key] = {fn = toggleFn, name = label, state = stateFn} end
        closeBindWindow()
        pcall(refreshBindHud)
    end
    save.MouseButton1Click:Connect(saveBind)
    input.FocusLost:Connect(function(enter) if enter then saveBind() end end)
    task.wait(0.1)
    pcall(function() input:CaptureFocus() end)
end

-- global bind key handler
on(uis.InputBegan, function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Unknown then return end
    local b = binds[input.KeyCode.Name]
    if b and b.fn then b.fn() end
end)

local function onMiddleClick(btn, fn)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton3 then pcall(fn) end
    end)
end

-- ===== WIDGETS =====
local W_LBL = 340
local W_CTRL_X = 366
local W_CTRL_W = 148
local OPT_BG = Color3.fromRGB(16,16,22)
local widgetValues = {}

local function makeToggle(panel, name, def, cb)
    local y = getY()
    local rowH = 30
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,rowH); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,W_LBL,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = loc(name); lbl.TextColor3 = TXT; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 10; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local sw = Instance.new("Frame"); sw.Size = UDim2.new(0,44,0,22); sw.Position = UDim2.new(0,W_CTRL_X + 102,0,(rowH-22)/2); sw.BackgroundColor3 = SW_OFF; sw.BorderSizePixel = 0; sw.ZIndex = 10; sw.Parent = bg
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame"); kn.Size = UDim2.new(0,18,0,18); kn.Position = UDim2.new(0,3,0,2); kn.BackgroundColor3 = Color3.fromRGB(245,245,250); kn.BorderSizePixel = 0; kn.ZIndex = 11; kn.Parent = sw
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 11; btn.Parent = bg
    local val = def
    themeReg[#themeReg + 1] = { obj = sw, prop = "BackgroundColor3", check = function() return val and getAccent() or SW_OFF end }
    local function paint()
        sw.BackgroundColor3 = val and getAccent() or SW_OFF
        kn.Position = val and UDim2.new(0,23,0,2) or UDim2.new(0,3,0,2)
    end
    local function apply()
        val = not val
        paint()
        pcall(cb, val)
        pcall(refreshBindHud)
    end
    paint()
    btn.MouseButton1Click:Connect(apply)
    onMiddleClick(btn, function() openBindWindow(name, apply, function() return val end) end)
    addY(rowH + 2)
    widgetRows[#widgetRows + 1] = { panel = panel, root = bg, name = name }
    widgetValues[name] = { get = function() return val end, set = function(v) val = v; paint(); pcall(cb, v); pcall(refreshBindHud) end, toggle = apply }
    return function() return val end, function(v) val = v; paint(); pcall(cb, v); pcall(refreshBindHud) end
end

local function makeSlider(panel, name, mn, mx, inc, def, cb)
    local y = getY()
    local rowH = 36
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,rowH); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,W_LBL,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = loc(name) .. ": " .. def; lbl.TextColor3 = TXT; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 10; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local val = def
    local frac0 = (def - mn) / (mx - mn)
    local sbg = Instance.new("Frame"); sbg.Size = UDim2.new(0,W_CTRL_W,0,6); sbg.Position = UDim2.new(0,W_CTRL_X,0,(rowH-6)/2); sbg.BackgroundColor3 = TRACK; sbg.BorderSizePixel = 0; sbg.Parent = bg
    Instance.new("UICorner", sbg).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new(frac0,0,1,0); fill.BackgroundColor3 = getAccent(); fill.BorderSizePixel = 0; fill.Parent = sbg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    themeReg[#themeReg + 1] = { obj = fill, prop = "BackgroundColor3", check = function() return getAccent() end }
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(0,math.floor(W_CTRL_X + frac0 * W_CTRL_W) - 7,0,(rowH-14)/2); knob.BackgroundColor3 = Color3.fromRGB(250,250,252); knob.BorderSizePixel = 0; knob.ZIndex = 11; knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local kst = Instance.new("UIStroke", knob); kst.Color = getAccent(); kst.Thickness = 1.5; kst.Transparency = 0.35
    themeReg[#themeReg + 1] = { obj = kst, prop = "Color", check = function() return getAccent() end }
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1,0,1,0); drag.BackgroundTransparency = 1; drag.Text = ""; drag.ZIndex = 12; drag.Parent = bg
    local dragging = false
    local function setVal(v)
        v = math.max(mn, math.min(mx, v))
        val = v
        local f = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(f,0,1,0)
        knob.Position = UDim2.new(0, math.floor(W_CTRL_X + f * W_CTRL_W) - 7, 0, (rowH-14)/2)
        lbl.Text = loc(name) .. ": " .. v
        pcall(cb, v)
    end
    local function setFrac()
        local absPos = sbg.AbsolutePosition; local sz = sbg.AbsoluteSize.X
        local frac = math.max(0, math.min(1, (uis:GetMouseLocation().X - absPos.X) / sz))
        local v = math.floor((mn + frac * (mx - mn)) / inc + 0.5) * inc
        setVal(v)
    end
    local function startDrag()
        dragging = true
        local con; con = uis.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false; con:Disconnect() end
        end)
        setFrac()
    end
    drag.MouseButton1Down:Connect(startDrag)
    drag.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch and inp.UserInputState == Enum.UserInputState.Begin then
            startDrag()
        end
    end)
    on(uis.InputChanged, function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then setFrac() end
    end)
    on(uis.InputChanged, function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.Touch then
            local px = pcall(function() return inp.Position and inp.Position.X or nil end)
            if px then setFrac() end
        end
    end)
    addY(rowH + 2)
    widgetRows[#widgetRows + 1] = { panel = panel, root = bg, name = name }
    widgetValues[name] = { get = function() return val end, set = setVal }
end

local function makeDropdown(panel, name, opts, def, cb)
    local y = getY()
    local rowH = 30
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(1,0,0,rowH); bg.Position = UDim2.new(0,0,0,y); bg.BackgroundTransparency = 1; bg.Parent = panel
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,W_LBL,1,0); lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1; lbl.Text = loc(name); lbl.TextColor3 = TXT; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 10; lbl.TextStrokeTransparency = 0.92; lbl.Parent = bg
    local val = def
    local ddBtn = Instance.new("TextButton"); ddBtn.Size = UDim2.new(0,W_CTRL_W,0,24); ddBtn.Position = UDim2.new(0,W_CTRL_X,0,3); ddBtn.BackgroundColor3 = INPUT_BG; ddBtn.BorderSizePixel = 0; ddBtn.Text = loc(def) .. "   ▾"; ddBtn.TextColor3 = TXT; ddBtn.Font = Enum.Font.Gotham; ddBtn.TextSize = 12; ddBtn.ZIndex = 11; ddBtn.Parent = bg
    Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0,6)
    local ddStroke = Instance.new("UIStroke", ddBtn); ddStroke.Color = STROKE; ddStroke.Thickness = 1
    themeReg[#themeReg + 1] = { obj = ddBtn, prop = "TextColor3", check = function() return getAccent() end }
    local function setVal(opt)
        val = opt
        ddBtn.Text = loc(opt) .. "   ▾"
        pcall(cb, opt)
    end
    local open = false; local ddList = nil; local openTime = 0
    ddBtn.MouseButton1Click:Connect(function()
        if ddList then ddList:Destroy(); ddList = nil; open = false; return end
        open = true; openTime = os.clock()
        local ap = ddBtn.AbsolutePosition; local as = ddBtn.AbsoluteSize
        local listY = ap.Y + as.Y + 3
        if listY + #opts * 24 > 620 then listY = ap.Y - #opts * 24 - 3 end
        local optH = math.floor(24 * MI.scale)
        ddList = Instance.new("Frame"); ddList.Size = UDim2.new(0, math.floor(W_CTRL_W * MI.scale), 0, math.ceil(#opts * optH)); ddList.Position = UDim2.new(0,ap.X,0,listY); ddList.BackgroundColor3 = OPT_BG; ddList.BorderSizePixel = 0; ddList.ZIndex = 50; ddList.Parent = sg
        Instance.new("UICorner", ddList).CornerRadius = UDim.new(0,6)
        local lstStroke = Instance.new("UIStroke", ddList); lstStroke.Color = STROKE; lstStroke.Transparency = 0.6; lstStroke.Thickness = 1
        for i2, opt in ipairs(opts) do
            local ob = Instance.new("TextButton"); ob.Size = UDim2.new(1,0,0,optH); ob.Position = UDim2.new(0,0,0,(i2-1)*optH); ob.BackgroundColor3 = opt == val and ROW_HOVER or OPT_BG; ob.BorderSizePixel = 0; ob.Text = loc(opt); ob.TextColor3 = opt == val and getAccent() or TXT2; ob.Font = Enum.Font.Gotham; ob.TextSize = 12; ob.ZIndex = 50; ob.Parent = ddList
            if opt ~= val then
                ob.MouseEnter:Connect(function() ob.BackgroundColor3 = ROW_HOVER; ob.TextColor3 = TXT end)
                ob.MouseLeave:Connect(function() ob.BackgroundColor3 = OPT_BG; ob.TextColor3 = TXT2 end)
            end
            ob.MouseButton1Click:Connect(function()
                val = opt; ddBtn.Text = loc(opt) .. "   ▾"; open = false; pcall(cb, opt)
                if ddList then ddList:Destroy(); ddList = nil end
            end)
        end
    end)
    local con; con = uis.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if not open or not ddList then return end
        if os.clock() - openTime < 0.2 then return end
        local abs = ddList.AbsolutePosition; local sz = ddList.AbsoluteSize
        local mx = uis:GetMouseLocation().X; local my = uis:GetMouseLocation().Y
        if mx < abs.X or mx > abs.X + sz.X or my < abs.Y or my > abs.Y + sz.Y then
            ddList:Destroy(); ddList = nil; open = false
        end
    end)
    addY(rowH + 2)
    widgetRows[#widgetRows + 1] = { panel = panel, root = bg, name = name }
    widgetValues[name] = { get = function() return val end, set = setVal }
end

local function makeButton(panel, name, cb)
    local y = getY()
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,-20,0,34); btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = INPUT_BG; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Text = loc(name); btn.TextColor3 = TXT; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.Parent = panel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local btnStroke = Instance.new("UIStroke", btn); btnStroke.Color = STROKE; btnStroke.Thickness = 1
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = ROW_HOVER end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = INPUT_BG end)
    btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = ROW_BG end)
    btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = ROW_HOVER end)
    btn.MouseButton1Click:Connect(cb)
    addY(38)
    widgetRows[#widgetRows + 1] = { panel = panel, root = btn, name = name }
end

-- ===== TAB: COMBAT =====
do
resetY(); local cPanel = tabPanels["Combat"]
local enabledGet, enabledSet = makeToggle(cPanel, "Aimbot", false, function(v) set.enabled = v end)
local lockGet, lockSet = makeToggle(cPanel, "Target Lock (одна цель)", true, function(v) set.targetLock = v; if not v then lockTarget = nil end end)
local holdGet, holdSet = makeToggle(cPanel, "Hold (жми и держи)", false, function(v) set.hold = v end)
local teamGet, teamSet = makeToggle(cPanel, "Team Check", true, function(v) set.teamCheck = v end)
local botGet, botSet = makeToggle(cPanel, "Aim на ботов (NPC)", true, function(v) set.aimBots = v end)

-- НОВОЕ: Legit Mode
makeSection(cPanel, "Legit Mode")
local legitGet, legitSet = makeToggle(cPanel, "Legit Mode (плавно)", false, function(v) 
    set.legitMode = v 
    if v then
        -- В легит режиме автоматически уменьшаем FOV для реалистичности
        if set.fov > 100 then
            set.fov = 45
        end
    end
end)
makeSlider(cPanel, "Legit FOV", 10, 100, 5, set.legitFov, function(v) set.legitFov = v end)
makeSlider(cPanel, "Legit Smooth", 0.01, 0.5, 0.01, set.legitSmooth, function(v) set.legitSmooth = v end)

makeSection(cPanel, "Основные настройки")
makeSlider(cPanel, "FOV (от прицела)", 10, 500, 5, set.fov, function(v) set.fov = v end)
makeSlider(cPanel, "Max distance", 20, 1000, 10, set.maxDist, function(v) set.maxDist = v end)
makeSlider(cPanel, "Smooth", 0.05, 1, 0.05, set.smooth, function(v) set.smooth = v end)
makeToggle(cPanel, "Показывать FOV круг", true, function(v) set.showFov = v end)
makeToggle(cPanel, "Wall Check (не сквозь стены)", true, function(v) set.wallCheck = v end)
makeToggle(cPanel, "Только с оружием", true, function(v) set.weaponCheck = v end)

-- НОВОЕ: Silent Aim (работает на ПК и телефоне)
makeSection(cPanel, "Silent Aim")
makeToggle(cPanel, "Silent Aim", false, function(v) set.silentAim = v end)
makeSlider(cPanel, "Silent distance", 10, 500, 10, set.silentDist, function(v) set.silentDist = v end)

local hint = Instance.new("TextLabel"); hint.Size = UDim2.new(1,-20,0,30); hint.Position = UDim2.new(0,10,0,getY()); hint.BackgroundTransparency = 1
hint.Text = loc("Средний клик по тумблеру — смена хоткея"); hint.TextColor3 = TXT2; hint.Font = Enum.Font.Gotham; hint.TextSize = 11; hint.TextXAlignment = Enum.TextXAlignment.Left; hint.TextWrapped = true; hint.Parent = cPanel
addY(32)
cPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: VISUALS (WH по командам) =====
resetY(); local vPanel = tabPanels["Visuals"]
makeSection(vPanel, "Wallhack (ESP)")
makeToggle(vPanel, "ESP (по командам)", false, function(v) set.esp = v; if not v then pcall(clearAllEsp) end end)
makeSlider(vPanel, "WH дистанция (м)", 10, 500, 10, 100, function(v) set.espRange = v end)
makeToggle(vPanel, "Ники", false, function(v) set.espShowName = v end)
makeToggle(vPanel, "Дистанция", false, function(v) set.espShowDist = v end)
makeToggle(vPanel, "ХП бар", true, function(v) set.espShowHp = v end)
local hint2 = Instance.new("TextLabel"); hint2.Size = UDim2.new(1,-24,0,30); hint2.Position = UDim2.new(0,10,0,getY()); hint2.BackgroundTransparency = 1
hint2.Text = loc("- Красный: враг | Зелёный: свои | Голубой: друг"); hint2.TextColor3 = TXT2; hint2.Font = Enum.Font.Gotham; hint2.TextSize = 11; hint2.TextXAlignment = Enum.TextXAlignment.Left; hint2.TextWrapped = true; hint2.Parent = vPanel
addY(32)

makeSection(vPanel, "Chams")
makeToggle(vPanel, "Chams (себя)", false, function(v) set.chamsSelf = v; pcall(applyChamsAll) end)
makeToggle(vPanel, "Chams (игроки)", false, function(v) set.chamsPlayers = v; pcall(applyChamsAll) end)
makeSlider(vPanel, "Chams прозрачность", 0, 1, 0.05, 0, function(v) set.chamsAlpha = v; pcall(applyChamsAll) end)
local chamColors = {"Тема","Красный","Зелёный","Голубой","Жёлтый","Белый","Фиолетовый","Оранжевый"}
makeDropdown(vPanel, "Chams цвет", chamColors, "Тема", function(v) set.chamsColor = v; pcall(applyChamsAll) end)

makeSection(vPanel, "Night Mode")
makeToggle(vPanel, "Night Mode (ночь)", false, function(v) pcall(toggleNightMode, v) end)
makeSlider(vPanel, "Яркость ночи", 0.1, 1, 0.05, 0.6, function(v) set.nightBright = v; if set.night then pcall(applyNight) end end)
vPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

-- ===== TAB: THEME =====
resetY(); local thPanel = tabPanels["Theme"]
makeSection(thPanel, "Переливание")
makeToggle(thPanel, "Пульс (переливание)", true, function(v) theme.pulse = v; if not v then themeApply() end end)
makeSlider(thPanel, "Скорость", 0.2, 5, 0.1, 2, function(v) theme.speed = v end)

local THEME_PRESETS = {
    { name = "Неон",     a = {60,140,255},  b = {255,70,150} },
    { name = "Кибер",    a = {0,255,200},   b = {120,80,255} },
    { name = "Пламя",    a = {255,120,40},  b = {255,40,60} },
    { name = "Яд",       a = {110,255,70},  b = {0,200,140} },
    { name = "Синь",     a = {40,120,255},  b = {40,220,255} },
    { name = "Закат",    a = {255,90,140},  b = {140,60,255} },
    { name = "Золото",   a = {255,200,60},  b = {200,120,40} },
    { name = "Лёд",      a = {140,220,255}, b = {220,220,255} },
    { name = "Роза",     a = {255,80,180},  b = {255,160,200} },
    { name = "Хакер",    a = {60,255,90},   b = {0,180,120} },
    { name = "Фиалка",   a = {150,90,255},  b = {255,90,200} },
    { name = "Аметист",  a = {140,120,255}, b = {90,60,200} },
}

makeSection(thPanel, "Готовые темы")
local gridY = getY()
local colW, rowH, pad = 44, 44, 8
for i, pr in ipairs(THEME_PRESETS) do
    local col = (i - 1) % 4
    local row = math.floor((i - 1) / 4)
    local x = 12 + col * (colW + pad)
    local y = gridY + row * (rowH + pad)
    local card = Instance.new("TextButton"); card.Size = UDim2.new(0,colW,0,rowH); card.Position = UDim2.new(0,x,0,y); card.BackgroundColor3 = Color3.new(1,1,1); card.BackgroundTransparency = 0; card.BorderSizePixel = 0; card.Text = ""; card.ZIndex = 10; card.Parent = thPanel
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)
    local cStroke = Instance.new("UIStroke", card); cStroke.Color = STROKE; cStroke.Thickness = 1
    local grad = Instance.new("UIGradient", card); grad.Rotation = 45
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(pr.a[1], pr.a[2], pr.a[3])),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(pr.a[1], pr.a[2], pr.a[3])),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(pr.b[1], pr.b[2], pr.b[3])),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(pr.b[1], pr.b[2], pr.b[3])),
    })
    card.MouseEnter:Connect(function() cStroke.Color = getAccent(); cStroke.Thickness = 1.5 end)
    card.MouseLeave:Connect(function() cStroke.Color = STROKE; cStroke.Thickness = 1 end)
    card.MouseButton1Click:Connect(function()
        theme.primary = { r = pr.a[1], g = pr.a[2], b = pr.a[3] }
        theme.secondary = { r = pr.b[1], g = pr.b[2], b = pr.b[3] }
        theme.pulse = true
        themeApply()
    end)
end
addY(math.ceil(#THEME_PRESETS / 4) * (rowH + pad) + 4)

local function makeColorPicker(panel, label, setRef)
    makeSection(panel, label)
    local r = setRef.r; local g = setRef.g; local b = setRef.b
    local swatch = Instance.new("Frame"); swatch.Size = UDim2.new(1,-24,0,20); swatch.Position = UDim2.new(0,12,0,getY()); swatch.BackgroundColor3 = Color3.fromRGB(r, g, b); swatch.BorderSizePixel = 0; Instance.new("UICorner", swatch).CornerRadius = UDim.new(0,3); swatch.Parent = panel
    themeReg[#themeReg + 1] = { obj = swatch, prop = "BackgroundColor3", check = function() return Color3.fromRGB(setRef.r, setRef.g, setRef.b) end }
    addY(24)
    makeSlider(panel, "Красный (R)", 0, 255, 1, r, function(v) setRef.r = v; themeApply() end)
    makeSlider(panel, "Зелёный (G)", 0, 255, 1, g, function(v) setRef.g = v; themeApply() end)
    makeSlider(panel, "Синий (B)", 0, 255, 1, b, function(v) setRef.b = v; themeApply() end)
end

makeColorPicker(thPanel, "Основной цвет", theme.primary)
makeColorPicker(thPanel, "Дополнительный цвет", theme.secondary)
thPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)
end

POLICE_MAX_RANGE = 800
FORBIDDEN_ON = false
FORBIDDEN_CENTER = nil
FORBIDDEN_RADIUS = 120

local buyHold; local farmStatusLbl
do -- TAB: FARM
resetY(); local fmPanel = tabPanels["Farm"]
makeSection(fmPanel, "Ring Farm")

local farmSpeed = 220
makeSlider(fmPanel, "Скорость полёта", 190, 300, 5, farmSpeed, function(v) farmSpeed = v end)

local farmBtn = Instance.new("TextButton"); farmBtn.Size = UDim2.new(1,-20,0,36); farmBtn.Position = UDim2.new(0,10,0,getY()); farmBtn.BackgroundColor3 = Color3.fromRGB(150,110,20); farmBtn.BorderSizePixel = 0; farmBtn.Text = "Start Ring Farm"; farmBtn.TextColor3 = Color3.new(1,1,1); farmBtn.Font = Enum.Font.GothamBold; farmBtn.TextSize = 13; farmBtn.Parent = fmPanel
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0,8)
addY(42)

farmStatusLbl = Instance.new("TextLabel"); farmStatusLbl.Size = UDim2.new(1,-24,0,20); farmStatusLbl.Position = UDim2.new(0,10,0,getY()); farmStatusLbl.BackgroundTransparency = 1
farmStatusLbl.Text = loc("Статус: Ожидание"); farmStatusLbl.TextColor3 = TXT2; farmStatusLbl.Font = Enum.Font.Gotham; farmStatusLbl.TextSize = 12; farmStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; farmStatusLbl.Parent = fmPanel
addY(24)

monaBtn = Instance.new("TextButton"); monaBtn.Size = UDim2.new(1,-20,0,36); monaBtn.Position = UDim2.new(0,10,0,getY()); monaBtn.BackgroundColor3 = Color3.fromRGB(90,110,150); monaBtn.BorderSizePixel = 0; monaBtn.Text = "Start Mona Lisa Farm"; monaBtn.TextColor3 = Color3.new(1,1,1); monaBtn.Font = Enum.Font.GothamBold; monaBtn.TextSize = 13; monaBtn.Parent = fmPanel
Instance.new("UICorner", monaBtn).CornerRadius = UDim.new(0,8)
addY(42)

monaStatusLbl = Instance.new("TextLabel"); monaStatusLbl.Size = UDim2.new(1,-24,0,20); monaStatusLbl.Position = UDim2.new(0,10,0,getY()); monaStatusLbl.BackgroundTransparency = 1
monaStatusLbl.Text = loc("Статус: Ожидание"); monaStatusLbl.TextColor3 = TXT2; monaStatusLbl.Font = Enum.Font.Gotham; monaStatusLbl.TextSize = 12; monaStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; monaStatusLbl.Parent = fmPanel
addY(24)

makeToggle(fmPanel, "Money Tracker (прибыль)", false, function(v) pcall(setMoneyTracker, v) end)
addY(30)

local policeBtn = Instance.new("TextButton"); policeBtn.Size = UDim2.new(1,-20,0,36); policeBtn.Position = UDim2.new(0,10,0,getY()); policeBtn.BackgroundColor3 = Color3.fromRGB(60,120,200); policeBtn.BorderSizePixel = 0; policeBtn.Text = "Police EXP Farm"; policeBtn.TextColor3 = Color3.new(1,1,1); policeBtn.Font = Enum.Font.GothamBold; policeBtn.TextSize = 13; policeBtn.Parent = fmPanel
Instance.new("UICorner", policeBtn).CornerRadius = UDim.new(0,8)
addY(42)

polStatusLbl = Instance.new("TextLabel"); polStatusLbl.Size = UDim2.new(1,-24,0,20); polStatusLbl.Position = UDim2.new(0,10,0,getY()); polStatusLbl.BackgroundTransparency = 1
polStatusLbl.Text = loc("Статус: Ожидание"); polStatusLbl.TextColor3 = TXT2; polStatusLbl.Font = Enum.Font.Gotham; polStatusLbl.TextSize = 12; polStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; polStatusLbl.Parent = fmPanel
addY(24)

local fbBtn = Instance.new("TextButton"); fbBtn.Size = UDim2.new(1,-20,0,28); fbBtn.Position = UDim2.new(0,10,0,getY()); fbBtn.BackgroundColor3 = INPUT_BG; fbBtn.BorderSizePixel = 0; fbBtn.Text = loc("Запретная зона: ВЫКЛ"); fbBtn.TextColor3 = TXT; fbBtn.Font = Enum.Font.GothamBold; fbBtn.TextSize = 12; fbBtn.Parent = fmPanel
Instance.new("UICorner", fbBtn).CornerRadius = UDim.new(0,6)
addY(34)
local fbBtnText = fbBtn

local fbMarkBtn = Instance.new("TextButton"); fbMarkBtn.Size = UDim2.new(1,-20,0,24); fbMarkBtn.Position = UDim2.new(0,10,0,getY()); fbMarkBtn.BackgroundColor3 = INPUT_BG; fbMarkBtn.BorderSizePixel = 0; fbMarkBtn.Text = loc("Отметить центр (где стоишь)"); fbMarkBtn.TextColor3 = TXT2; fbMarkBtn.Font = Enum.Font.Gotham; fbMarkBtn.TextSize = 11; fbMarkBtn.Parent = fmPanel
Instance.new("UICorner", fbMarkBtn).CornerRadius = UDim.new(0,6)
addY(30)
makeSlider(fmPanel, "Дальность поиска (м)", 200, 3000, 50, POLICE_MAX_RANGE, function(v) POLICE_MAX_RANGE = v end)
addY(30)
fmPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)

fbBtn.MouseButton1Click:Connect(function()
    FORBIDDEN_ON = not FORBIDDEN_ON
    fbBtnText.Text = loc("Запретная зона: ") .. (FORBIDDEN_ON and "ВКЛ" or "ВЫКЛ")
    fbBtnText.BackgroundColor3 = FORBIDDEN_ON and RED or (INPUT_BG)
end)
fbMarkBtn.MouseButton1Click:Connect(function()
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if hrp then
        FORBIDDEN_CENTER = hrp.Position
        FORBIDDEN_ON = true
        fbBtnText.Text = loc("Запретная зона: ВКЛ")
        fbBtnText.BackgroundColor3 = RED
        pcall(function()
            polStatusLbl.Text = loc("Запретная зона: центр отмечен (r")
                .. string.format("%.0f", FORBIDDEN_RADIUS) .. "m)"
        end)
    end
end)

policeBtn.MouseButton1Click:Connect(function()
    if policeActive or polRunning then
        policeActive = false
        stopPoliceFarm()
        policeBtn.Text = "Police EXP Farm"
        policeBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)
    else
        policeActive = true
        set.farmStop = false
        policeBtn.Text = "Stop Police Farm"
        policeBtn.BackgroundColor3 = RED
        pcall(startPoliceFarm, farmSpeed)
    end
end)

buyHold = 0.5

farmBtn.MouseButton1Click:Connect(function()
    if farmRunning then
        set.farmStop = true
        farmBtn.Text = "Start Ring Farm"
        farmBtn.BackgroundColor3 = Color3.fromRGB(150,110,20)
    else
        set.farmStop = false
        farmBtn.Text = "Stop Farm"
        farmBtn.BackgroundColor3 = RED
        pcall(startRingFarm, farmSpeed)
    end
end)

monaBtn.MouseButton1Click:Connect(function()
    if monaRunning then
        set.farmStop = true
        monaBtn.Text = "Start Mona Lisa Farm"
        monaBtn.BackgroundColor3 = Color3.fromRGB(90,110,150)
    else
        set.farmStop = false
        monaBtn.Text = "Stop Mona Farm"
        monaBtn.BackgroundColor3 = RED
        pcall(startMonaLisaFarm, farmSpeed)
    end
end)
end

do -- TAB: FRIENDS
resetY(); local fPanel = tabPanels["Friends"]
makeSection(fPanel, "Друзья (никогда не целится)")
local frmLbl = Instance.new("TextLabel"); frmLbl.Size = UDim2.new(1,-20,0,18); frmLbl.Position = UDim2.new(0,10,0,getY()); frmLbl.BackgroundTransparency = 1
frmLbl.Text = loc("Ник друга:"); frmLbl.TextColor3 = TXT; frmLbl.Font = Enum.Font.Gotham; frmLbl.TextSize = 12; frmLbl.TextXAlignment = Enum.TextXAlignment.Left; frmLbl.Parent = fPanel
addY(22)

local nameBox = Instance.new("TextBox"); nameBox.Size = UDim2.new(1,-110,0,28); nameBox.Position = UDim2.new(0,10,0,getY()); nameBox.BackgroundColor3 = INPUT_BG; nameBox.BorderSizePixel = 0; nameBox.Text = ""; nameBox.TextColor3 = TXT; nameBox.Font = Enum.Font.Gotham; nameBox.TextSize = 13; nameBox.PlaceholderText = "Nickname"; nameBox.PlaceholderColor3 = Color3.fromRGB(70,70,90); nameBox.ClearTextOnFocus = true; nameBox.Parent = fPanel
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,6)
local nameBoxStroke = Instance.new("UIStroke", nameBox); nameBoxStroke.Color = STROKE; nameBoxStroke.Thickness = 1

local addBtn = Instance.new("TextButton"); addBtn.Size = UDim2.new(0,84,0,28); addBtn.Position = UDim2.new(1,-96,0,getY()); addBtn.BackgroundColor3 = getAccent(); addBtn.BorderSizePixel = 0; addBtn.Text = "Add"; addBtn.TextColor3 = Color3.new(1,1,1); addBtn.Font = Enum.Font.GothamBold; addBtn.TextSize = 12; addBtn.Parent = fPanel
themeReg[#themeReg + 1] = { obj = addBtn, prop = "BackgroundColor3", check = function() return getAccent() end }
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0,6)
local addYBase = getY() + 30

local friendListBox = Instance.new("Frame"); friendListBox.Size = UDim2.new(1,-20,0,120); friendListBox.Position = UDim2.new(0,10,0,addYBase); friendListBox.BackgroundColor3 = OPT_BG; friendListBox.BorderSizePixel = 0; friendListBox.Parent = fPanel
Instance.new("UICorner", friendListBox).CornerRadius = UDim.new(0,8)
local flStroke = Instance.new("UIStroke", friendListBox); flStroke.Color = STROKE; flStroke.Thickness = 1
local flLayout = Instance.new("UIListLayout"); flLayout.SortOrder = Enum.SortOrder.LayoutOrder; flLayout.Padding = UDim.new(0,3); flLayout.Parent = friendListBox

function refreshFriends()
    for _, c in pairs(friendListBox:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, f in ipairs(set.friends) do
        local chip = Instance.new("TextButton"); chip.Size = UDim2.new(1,0,0,20); chip.BackgroundColor3 = ROW_BG; chip.BorderSizePixel = 0; chip.Text = f .. loc("   (клик - удалить)"); chip.TextColor3 = TXT2; chip.Font = Enum.Font.Gotham; chip.TextSize = 12; chip.TextXAlignment = Enum.TextXAlignment.Left; chip.Parent = friendListBox
        Instance.new("UICorner", chip).CornerRadius = UDim.new(0,4)
        chip.MouseEnter:Connect(function() chip.BackgroundColor3 = ROW_HOVER; chip.TextColor3 = TXT end)
        chip.MouseLeave:Connect(function() chip.BackgroundColor3 = ROW_BG; chip.TextColor3 = TXT2 end)
        chip.MouseButton1Click:Connect(function()
            for i, fr in ipairs(set.friends) do
                if fr == f then table.remove(set.friends, i); break end
            end
            refreshFriends()
        end)
    end
end

addBtn.MouseButton1Click:Connect(function()
    local n = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", ""):lower()
    if n ~= "" then
        local dup = false
        for _, f in ipairs(set.friends) do if f == n then dup = true; break end end
        if not dup then table.insert(set.friends, n); refreshFriends() end
        nameBox.Text = ""
    end
end)

refreshFriends()
addY(4)
fPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)
end

local potatoCons
do -- TAB: SETTINGS
resetY(); local sPanel = tabPanels["Settings"]
makeSection(sPanel, "About")
local about = Instance.new("TextLabel"); about.Size = UDim2.new(1,-20,0,40); about.Position = UDim2.new(0,10,0,getY()); about.BackgroundTransparency = 1
about.Text = loc("ANVIL SAN DIEGO BORDER ROLEPLAY | LOW GRAPHICS\nInsert - меню | Средний клик по тумблеру - хоткей"); about.TextColor3 = TXT2; about.Font = Enum.Font.Gotham; about.TextSize = 12; about.TextXAlignment = Enum.TextXAlignment.Left; about.TextWrapped = true; about.TextStrokeTransparency = 0.92; about.Parent = sPanel
addY(44)
makeToggle(sPanel, "Английский интерфейс", set.lang == "English", function(v)
    set.lang = v and "English" or "Русский"
    pcall(localizeUI)
    pcall(refreshBindHud)
end)
makeSection(sPanel, "Графика")
local potatoState = nil
local potatoDone = {}
local potatoEffects = {}
potatoCons = {}
local function potatoProcess(o)
    pcall(function()
        if o:IsA("BasePart") then
            if not potatoDone[o] then
                potatoDone[o] = true
                local isChar = player.Character and o:IsDescendantOf(player.Character)
                local hasBtn = o:FindFirstChildOfClass("ClickDetector") or o:FindFirstChildOfClass("ProximityPrompt")
                local hide = o.Anchored and (o.Size.X * o.Size.Z < 1500) and not isChar and not hasBtn
                potatoState.parts[#potatoState.parts + 1] = { o, o.Material, o.Color, o.Transparency, o.Reflectance, o.CastShadow }
                o.Material = Enum.Material.SmoothPlastic
                o.Color = Color3.fromRGB(160, 160, 160)
                o.Reflectance = 0
                o.CastShadow = false
                if hide then o.Transparency = 1 end
            end
        elseif o:IsA("Texture") or o:IsA("Decal") then
            if not potatoDone[o] then
                potatoDone[o] = true
                potatoState.decals[#potatoState.decals + 1] = { o, o.Transparency }
                o.Transparency = 1
            end
        elseif o:IsA("ParticleEmitter") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") or o:IsA("Trail") then
            if not potatoDone[o] then
                potatoDone[o] = true
                potatoState.effects[#potatoState.effects + 1] = { o, o.Enabled }
            end
            o.Enabled = false
            potatoEffects[#potatoEffects + 1] = o
        elseif o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight") then
            if not potatoDone[o] then
                potatoDone[o] = true
                potatoState.lights[#potatoState.lights + 1] = { o, o.Brightness, o.Enabled }
            end
            o.Brightness = 0
            o.Enabled = false
        elseif o:IsA("SurfaceAppearance") then
            if not potatoDone[o] then potatoDone[o] = true; potatoState.hidden[#potatoState.hidden + 1] = { o, o.Parent } end
            o.Parent = nil
        elseif o:IsA("SpecialMesh") then
            if not potatoDone[o] then
                potatoDone[o] = true
                potatoState.meshes[#potatoState.meshes + 1] = { o, o.Scale }
                o.Scale = Vector3.one
            end
        elseif o:IsA("Animator") then
            potatoState.anims[#potatoState.anims + 1] = { o, o.PlaybackSpeed }
            o.PlaybackSpeed = 0
        elseif o:IsA("Sky") then
            if not potatoDone[o] then potatoDone[o] = true; potatoState.hidden[#potatoState.hidden + 1] = { o, o.Parent } end
            o.Parent = nil
        end
    end)
end
makeToggle(sPanel, "LOW GRAPHICS (картофель)", false, function(v)
    local l = game:GetService("Lighting")
    set.lowGFX = v
    if v then
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        if not set.night then
        pcall(function()
            l.GlobalShadows = false
            l.FogEnd = 50
            l.Brightness = 2
            l.Ambient = Color3.fromRGB(255, 255, 255)
            l.ClockTime = 12
            l.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            l.EnvironmentDiffuseScale = 0
            l.EnvironmentSpecularScale = 0
        end)
        end
        potatoState = { parts = {}, decals = {}, effects = {}, lights = {}, meshes = {}, anims = {}, hidden = {} }
        potatoDone = {}
        potatoEffects = {}
        for _, o in pairs(workspace:GetDescendants()) do potatoProcess(o) end
        potatoCons[#potatoCons + 1] = workspace.DescendantAdded:Connect(function(o) potatoProcess(o) end)
        local t = 0
        potatoCons[#potatoCons + 1] = rs.RenderStepped:Connect(function(dt)
            t = t + dt
            if t >= 0.4 then
                t = 0
                for _, e in ipairs(potatoEffects) do
                    pcall(function() e.Enabled = false end)
                end
            end
        end)
    else
        pcall(function() settings().Rendering.QualityLevel = 2 end)
        if not set.night then
        pcall(function()
            l.GlobalShadows = true
            l.FogEnd = 100000
            l.Brightness = 1
            l.Ambient = Color3.new(1, 1, 1)
            l.OutdoorAmbient = Color3.fromRGB(148, 148, 148)
            l.EnvironmentDiffuseScale = 1
            l.EnvironmentSpecularScale = 1
        end)
        end
        for _, c in ipairs(potatoCons) do pcall(function() c:Disconnect() end) end
        potatoCons = {}
        if potatoState then
            for _, rec in ipairs(potatoState.parts) do
                pcall(function() rec[1].Material = rec[2]; rec[1].Color = rec[3]; rec[1].Transparency = rec[4]; rec[1].Reflectance = rec[5]; rec[1].CastShadow = rec[6] end)
            end
            for _, rec in ipairs(potatoState.decals) do
                pcall(function() rec[1].Transparency = rec[2] end)
            end
            for _, rec in ipairs(potatoState.effects) do
                pcall(function() rec[1].Enabled = rec[2] end)
            end
            for _, rec in ipairs(potatoState.lights) do
                pcall(function() rec[1].Brightness = rec[2]; rec[1].Enabled = rec[3] end)
            end
            for _, rec in ipairs(potatoState.meshes) do
                pcall(function() rec[1].Scale = rec[2] end)
            end
            for _, rec in ipairs(potatoState.anims) do
                pcall(function() rec[1].PlaybackSpeed = rec[2] end)
            end
            for _, rec in ipairs(potatoState.hidden) do
                pcall(function() rec[1].Parent = rec[2] end)
            end
            potatoState = nil
        end
    end
end)
makeSection(sPanel, "Unload")
makeButton(sPanel, "Unload (выгрузить скрипт)", function() unloadAll() end)
sPanel.CanvasSize = UDim2.new(0,0,0,getY()+4)
end

-- assemble
title.Parent = main; closeBtn.Parent = main; sidebar.Parent = main; contentBg.Parent = main
main.Parent = sg
MI.apply()
main.Position = MI.hidden; sg.Enabled = true
ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = MI.pos}):Play()

-- ===== CONFIG PANEL (справа от меню) =====
do
local CFG_DIR = "AnvilHubConfigs"
local http = game:GetService("HttpService")
local RGB_NAMES = { ["Красный (R)"] = true, ["Зелёный (G)"] = true, ["Синий (B)"] = true }
local selectedConfig = nil

local cfgPanel = Instance.new("Frame")
cfgPanel.Size = UDim2.new(0,200,0,330); cfgPanel.Position = UDim2.new(1,14,0,52)
cfgPanel.BackgroundColor3 = BG2; cfgPanel.BorderSizePixel = 0; cfgPanel.ZIndex = 10; cfgPanel.Parent = main
Instance.new("UICorner", cfgPanel).CornerRadius = UDim.new(0,10)
local cfgStroke = Instance.new("UIStroke", cfgPanel)
cfgStroke.Color = STROKE; cfgStroke.Transparency = 0.4; cfgStroke.Thickness = 1
themeReg[#themeReg + 1] = { obj = cfgStroke, prop = "Color", check = function() return getAccent() end }

local cfgTitle = Instance.new("TextLabel")
cfgTitle.Size = UDim2.new(1,0,0,30); cfgTitle.Position = UDim2.new(0,12,0,8)
cfgTitle.BackgroundTransparency = 1; cfgTitle.Text = "Config"
cfgTitle.TextColor3 = TXT; cfgTitle.Font = Enum.Font.GothamBold; cfgTitle.TextSize = 14
cfgTitle.TextXAlignment = Enum.TextXAlignment.Left; cfgTitle.ZIndex = 11; cfgTitle.Parent = cfgPanel

local cfgLine = Instance.new("Frame")
cfgLine.Size = UDim2.new(1,-20,0,1); cfgLine.Position = UDim2.new(0,10,0,42)
cfgLine.BackgroundColor3 = STROKE; cfgLine.BackgroundTransparency = 0.5; cfgLine.BorderSizePixel = 0; cfgLine.ZIndex = 10; cfgLine.Parent = cfgPanel

local cfgNameBox = Instance.new("TextBox")
cfgNameBox.Size = UDim2.new(1,-24,0,26); cfgNameBox.Position = UDim2.new(0,12,0,48)
cfgNameBox.BackgroundColor3 = INPUT_BG; cfgNameBox.BorderSizePixel = 0
cfgNameBox.Text = ""; cfgNameBox.TextColor3 = TXT; cfgNameBox.Font = Enum.Font.Gotham; cfgNameBox.TextSize = 12
cfgNameBox.PlaceholderText = loc("Название конфига"); cfgNameBox.PlaceholderColor3 = TXT2
cfgNameBox.ClearTextOnFocus = true; cfgNameBox.ZIndex = 11; cfgNameBox.Parent = cfgPanel
Instance.new("UICorner", cfgNameBox).CornerRadius = UDim.new(0,6)
local cfgNameStroke = Instance.new("UIStroke", cfgNameBox); cfgNameStroke.Color = STROKE; cfgNameStroke.Thickness = 1

local cfgStatus = Instance.new("TextLabel")
cfgStatus.Size = UDim2.new(1,-24,0,26); cfgStatus.Position = UDim2.new(0,12,0,176)
cfgStatus.BackgroundTransparency = 1; cfgStatus.Text = ""
cfgStatus.TextColor3 = TXT2; cfgStatus.Font = Enum.Font.Gotham; cfgStatus.TextSize = 10
cfgStatus.TextWrapped = true; cfgStatus.TextXAlignment = Enum.TextXAlignment.Left; cfgStatus.TextYAlignment = Enum.TextYAlignment.Top
cfgStatus.ZIndex = 11; cfgStatus.Parent = cfgPanel

local cfgListHead = Instance.new("TextLabel")
cfgListHead.Size = UDim2.new(1,-24,0,16); cfgListHead.Position = UDim2.new(0,12,0,204)
cfgListHead.BackgroundTransparency = 1; cfgListHead.Text = loc("Конфиги:")
cfgListHead.TextColor3 = TXT2; cfgListHead.Font = Enum.Font.GothamBold; cfgListHead.TextSize = 11
cfgListHead.TextXAlignment = Enum.TextXAlignment.Left; cfgListHead.ZIndex = 11; cfgListHead.Parent = cfgPanel

local cfgList = Instance.new("ScrollingFrame")
cfgList.Size = UDim2.new(1,-16,0,102); cfgList.Position = UDim2.new(0,8,0,220)
cfgList.BackgroundColor3 = OPT_BG; cfgList.BorderSizePixel = 0; cfgList.ZIndex = 10; cfgList.Parent = cfgPanel
Instance.new("UICorner", cfgList).CornerRadius = UDim.new(0,8)
local cfgListStroke = Instance.new("UIStroke", cfgList); cfgListStroke.Color = STROKE; cfgListStroke.Thickness = 1
cfgList.ScrollBarThickness = 4; cfgList.ScrollBarImageColor3 = Color3.fromRGB(48,48,64); cfgList.ScrollBarImageTransparency = 0.6
cfgList.CanvasSize = UDim2.new(0,0,0,0)

local function cfgFlash(msg, ok)
    cfgStatus.Text = msg
    cfgStatus.TextColor3 = ok and GREEN or RED
    task.delay(3, function()
        if cfgStatus.Text == msg then cfgStatus.Text = "" end
    end)
end

local function makeCfgButton(y, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-24,0,28); b.Position = UDim2.new(0,12,0,y)
    b.BackgroundColor3 = INPUT_BG; b.BorderSizePixel = 0; b.AutoButtonColor = false
    b.Text = text; b.TextColor3 = TXT; b.Font = Enum.Font.GothamSemibold; b.TextSize = 12
    b.ZIndex = 11; b.Parent = cfgPanel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local bs = Instance.new("UIStroke", b); bs.Color = STROKE; bs.Thickness = 1
    b.MouseEnter:Connect(function() b.BackgroundColor3 = ROW_HOVER end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = INPUT_BG end)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    return b
end

local function listConfigNames()
    local names = {}
    if type(listfiles) == "function" then
        local ok, files = pcall(listfiles, CFG_DIR)
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                local n = tostring(f):gsub("\\", "/"):match("[^/]+$") or ""
                if n:sub(-5) == ".json" then names[#names + 1] = n:sub(1, -6) end
            end
        end
    end
    table.sort(names)
    return names
end

local function refreshConfigList()
    for _, c in ipairs(cfgList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local names = listConfigNames()
    cfgList.CanvasSize = UDim2.new(0,0,0,math.max(1, #names) * 22)
    local y = 2
    for _, nm in ipairs(names) do
        local sel = (nm == selectedConfig)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1,-8,0,20); row.Position = UDim2.new(0,4,0,y)
        row.BackgroundColor3 = sel and ROW_HOVER or ROW_BG; row.BorderSizePixel = 0
        row.Text = "   " .. nm; row.TextColor3 = sel and TXT or TXT2
        row.Font = Enum.Font.Gotham; row.TextSize = 11; row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 11; row.Parent = cfgList
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
        row.MouseEnter:Connect(function() row.BackgroundColor3 = ROW_HOVER; row.TextColor3 = TXT end)
        row.MouseLeave:Connect(function()
            if nm ~= selectedConfig then row.BackgroundColor3 = ROW_BG; row.TextColor3 = TXT2 end
        end)
        row.MouseButton1Click:Connect(function()
            selectedConfig = nm
            cfgNameBox.Text = nm
            refreshConfigList()
            cfgFlash(loc("Выбран: ") .. nm, true)
        end)
        y = y + 22
    end
end

local function saveConfig()
    local nm = cfgNameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if nm == "" then nm = selectedConfig or "config" end
    nm = nm:gsub('[\\/:*?"<>|%c]', "")
    if nm == "" then nm = "config" end
    local file = CFG_DIR .. "/" .. nm .. ".json"
    local payload = {}
    for name, wv in pairs(widgetValues) do
        if type(name) == "string" and not RGB_NAMES[name] then
            payload[name] = wv.get()
        end
    end
    local bindsList = {}
    for key, b in pairs(binds) do
        if b and b.name then bindsList[#bindsList + 1] = { key = key, name = b.name } end
    end
    payload["__binds"] = bindsList
    payload["__friends"] = set.friends
    payload["__theme_primary"] = { r = theme.primary.r, g = theme.primary.g, b = theme.primary.b }
    payload["__theme_secondary"] = { r = theme.secondary.r, g = theme.secondary.g, b = theme.secondary.b }
    local ok, err = pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(CFG_DIR) then
            makefolder(CFG_DIR)
        end
        writefile(file, http:JSONEncode(payload))
    end)
    if ok then
        selectedConfig = nm
        cfgNameBox.Text = nm
        refreshConfigList()
    end
    cfgFlash(ok and (loc("Сохранено: ") .. nm) or (loc("Ошибка: ") .. tostring(err)), ok)
end

local function loadConfig()
    local nm = selectedConfig
    if not nm or nm == "" then
        nm = cfgNameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if nm == "" then cfgFlash(loc("Выберите конфиг в списке"), false) return end
    end
    nm = nm:gsub('[\\/:*?"<>|%c]', "")
    local file = CFG_DIR .. "/" .. nm .. ".json"
    local ok, data = pcall(function()
        if type(isfile) == "function" and not isfile(file) then error(loc("Конфиг не найден")) end
        return http:JSONDecode(readfile(file))
    end)
    if not ok then cfgFlash(loc("Ошибка: ") .. tostring(data), false); return end
    if type(data) ~= "table" then cfgFlash(loc("Ошибка: ") .. loc("пустой конфиг"), false); return end
    local loaded = 0
    for name, val in pairs(data) do
        if type(name) == "string" and name:sub(1,2) ~= "__" and not RGB_NAMES[name] then
            local wv = widgetValues[name]
            if wv and wv.set then
                pcall(function() wv.set(val) end)
                loaded = loaded + 1
            end
        end
    end
    if type(data["__friends"]) == "table" then
        local fr = {}
        for _, f in ipairs(data["__friends"]) do
            if type(f) == "string" then fr[#fr + 1] = f end
        end
        set.friends = fr
        pcall(refreshFriends)
    end
    if type(data["__theme_primary"]) == "table" then
        local t = data["__theme_primary"]
        theme.primary = { r = t.r or 60, g = t.g or 140, b = t.b or 255 }
    end
    if type(data["__theme_secondary"]) == "table" then
        local t = data["__theme_secondary"]
        theme.secondary = { r = t.r or 255, g = t.g or 70, b = t.b or 150 }
    end
    themeApply()
    if type(data["__binds"]) == "table" then
        for _, b in ipairs(data["__binds"]) do
            if b.key and b.key ~= "Q" then
                local wv = b.name and widgetValues[b.name]
                if wv and wv.toggle then
                    binds[b.key] = { fn = wv.toggle, name = b.name, state = wv.get }
                end
            end
        end
    end
    pcall(refreshBindHud)
    cfgFlash(loc("Загружено: ") .. loaded .. loc(" настроек"), true)
end

local function openConfigFolder()
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(CFG_DIR) then
            makefolder(CFG_DIR)
        end
    end)
    local done = false
    local paths = { CFG_DIR, "workspace/" .. CFG_DIR, "workspace\\" .. CFG_DIR }
    for _, p in ipairs(paths) do
        pcall(function()
            if os and os.execute then
                os.execute('explorer "' .. p .. '"')
                done = true
            end
        end)
        if done then break end
    end
    if not done then
        pcall(function()
            if type(openfolder) == "function" then openfolder(CFG_DIR); done = true end
        end)
    end
    cfgFlash(done and loc("Папка открыта") or (loc("Не удалось открыть папку (путь: ") .. CFG_DIR .. ")"), done)
end

makeCfgButton(78, loc("Сохранить конфиг"), saveConfig)
makeCfgButton(110, loc("Открыть папку"), openConfigFolder)
makeCfgButton(142, loc("Загрузить конфиг"), loadConfig)
refreshConfigList()
end

local function toggleMenu()
    MI.open = not MI.open
    if MI.open then
        sg.Enabled = true
        main.Position = MI.hidden
        ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = MI.pos}):Play()
    else
        local t = ts:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = MI.hidden})
        t:Play()
        t.Completed:Connect(function() sg.Enabled = false; main.Position = MI.pos end)
    end
end

closeBtn.MouseButton1Click:Connect(toggleMenu)

on(uis.InputBegan, function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Insert then toggleMenu() end
end)

-- ===== МОБИЛЬНАЯ КНОПКА (телефон: нет Insert) =====
do
if isMobile then
    local mGui = Instance.new("ScreenGui"); mGui.Name = "AnvilAimMobile"; mGui.ResetOnSpawn = false; mGui.IgnoreGuiInset = true; mGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mGui.DisplayOrder = 150
    local mSucc, _ = pcall(function() mGui.Parent = game:GetService("CoreGui") end)
    if not mSucc then pcall(function() mGui.Parent = player:WaitForChild("PlayerGui") end) end
    local mb = Instance.new("TextButton"); mb.Size = UDim2.new(0,58,0,58); mb.Position = UDim2.new(0,14,0.5,-29); mb.AnchorPoint = Vector2.new(0,0.5)
    mb.BackgroundColor3 = BG2; mb.BorderSizePixel = 0; mb.Text = "☰"; mb.TextColor3 = TXT; mb.Font = Enum.Font.GothamBold; mb.TextSize = 24; mb.ZIndex = 99; mb.Parent = mGui
    Instance.new("UICorner", mb).CornerRadius = UDim.new(0,14)
    local mStroke = Instance.new("UIStroke", mb); mStroke.Thickness = 1.6
    themeReg[#themeReg + 1] = { obj = mStroke, prop = "Color", check = function() return getAccent() end }
    local mLabel = Instance.new("TextLabel"); mLabel.Size = UDim2.new(1,0,0,14); mLabel.Position = UDim2.new(0,0,1,2); mLabel.BackgroundTransparency = 1; mLabel.Text = "MENU"; mLabel.TextColor3 = TXT2; mLabel.Font = Enum.Font.GothamBold; mLabel.TextSize = 9; mLabel.ZIndex = 100; mLabel.Parent = mb
    mb.MouseButton1Click:Connect(function() toggleMenu() end)
    local mDragOn = false; local mStart; local mPos
    mb.MouseButton1Down:Connect(function()
        mDragOn = true; mStart = uis:GetMouseLocation(); mPos = mb.Position
        local con; con = uis.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then mDragOn = false; con:Disconnect() end
        end)
    end)
    on(uis.InputChanged, function(inp)
        if mDragOn and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = uis:GetMouseLocation() - mStart
            mb.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + delta.X, mPos.Y.Scale, mPos.Y.Offset + delta.Y)
        end
    end)
end
end

-- ===== KEYBINDS HUD (из anvil.lua) =====
do
local kbGui = Instance.new("ScreenGui"); kbGui.Name = "AnvilAimKeybinds"; kbGui.ResetOnSpawn = false; kbGui.IgnoreGuiInset = true; kbGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; kbGui.DisplayOrder = 101
local succ2, _ = pcall(function() kbGui.Parent = game:GetService("CoreGui") end)
if not succ2 then pcall(function() kbGui.Parent = player:WaitForChild("PlayerGui") end) end
local kbFrame = Instance.new("Frame"); kbFrame.Size = UDim2.new(0,136,0,64); kbFrame.Position = UDim2.new(1,-148,0,12); kbFrame.BackgroundColor3 = BG; kbFrame.BorderSizePixel = 0; kbFrame.Active = true; kbFrame.Parent = kbGui
Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0,10)
local kbStroke = Instance.new("UIStroke", kbFrame); kbStroke.Color = STROKE; kbStroke.Transparency = 0.4; kbStroke.Thickness = 1
local kbTitle = Instance.new("TextButton"); kbTitle.Size = UDim2.new(1,0,0,22); kbTitle.Position = UDim2.new(0,8,0,4); kbTitle.BackgroundTransparency = 1; kbTitle.AutoButtonColor = false; kbTitle.Text = ""; kbTitle.ZIndex = 10; kbTitle.Parent = kbFrame
local kbTitleLbl = Instance.new("TextLabel"); kbTitleLbl.Size = UDim2.new(1,0,1,0); kbTitleLbl.BackgroundTransparency = 1; kbTitleLbl.Text = "Keybinds"; kbTitleLbl.TextColor3 = TXT; kbTitleLbl.Font = Enum.Font.GothamBold; kbTitleLbl.TextSize = 12; kbTitleLbl.TextXAlignment = Enum.TextXAlignment.Left; kbTitleLbl.TextStrokeTransparency = 0.88; kbTitleLbl.Parent = kbTitle

local kbDrag = false; local kbStart; local kbPos
kbTitle.MouseButton1Down:Connect(function()
    kbDrag = true; kbStart = uis:GetMouseLocation(); kbPos = kbFrame.Position
    local con; con = uis.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then kbDrag = false; con:Disconnect() end
    end)
end)
on(uis.InputChanged, function(inp)
    if kbDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = uis:GetMouseLocation() - kbStart
        kbFrame.Position = UDim2.new(kbPos.X.Scale, kbPos.X.Offset + delta.X, kbPos.Y.Scale, kbPos.Y.Offset + delta.Y)
    end
end)

local bindEntries = {}
refreshBindHud = function()
    for _, e in ipairs(bindEntries) do
        pcall(function() e.entry:Destroy() end)
    end
    bindEntries = {}
    local y = 27
    local function addEntry(key, name, stateFn)
        local entry = Instance.new("Frame"); entry.Size = UDim2.new(1,-16,0,18); entry.Position = UDim2.new(0,8,0,y); entry.BackgroundTransparency = 1; entry.Parent = kbFrame
        local keyBox = Instance.new("Frame"); keyBox.Size = UDim2.new(0,20,0,18); keyBox.BackgroundColor3 = INPUT_BG; keyBox.BorderSizePixel = 0; keyBox.Parent = entry
        Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,4)
        local ks = Instance.new("UIStroke", keyBox); ks.Color = STROKE; ks.Thickness = 1
        local kl = Instance.new("TextLabel"); kl.Size = UDim2.new(1,0,1,0); kl.BackgroundTransparency = 1; kl.Text = key; kl.TextColor3 = TXT; kl.Font = Enum.Font.GothamBold; kl.TextSize = 11; kl.TextStrokeTransparency = 0.92; kl.Parent = keyBox
        local nl = Instance.new("TextLabel"); nl.Size = UDim2.new(1,-24,1,0); nl.Position = UDim2.new(0,24,0,0); nl.BackgroundTransparency = 1; nl.Text = loc(name); nl.TextColor3 = TXT2; nl.Font = Enum.Font.Gotham; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left; nl.TextStrokeTransparency = 0.92; nl.Parent = entry
        bindEntries[#bindEntries+1] = {entry = entry, stroke = ks, state = stateFn}
        y = y + 20
    end
    addEntry("I", "Menu", function() return MI.open end)
    for key, b in pairs(binds) do
        if b and b.name then addEntry(key, b.name, b.state) end
    end
    kbFrame.Size = UDim2.new(0,136,0,y + 8)
end

local bindHudTick = 0
on(rs.Heartbeat, function(dt)
    bindHudTick = bindHudTick + dt
    if bindHudTick < 0.3 then return end
    bindHudTick = 0
    for _, e in ipairs(bindEntries) do
        e.stroke.Color = e.state() and GREEN or STROKE
    end
end)

-- default bind: Q -> Aimbot
binds["Q"] = {fn = function()
    if set.hold then
        keyDown = true
    else
        set.enabled = not set.enabled
    end
    pcall(refreshBindHud)
end, name = "Aimbot", state = function() return set.enabled end}

on(uis.InputEnded, function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then keyDown = false end
end)

refreshBindHud()
end

-- ===== WATERMARK =====
local wmGui = Instance.new("ScreenGui"); wmGui.Name = "AnvilAimWatermark"; wmGui.ResetOnSpawn = false; wmGui.IgnoreGuiInset = true; wmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; wmGui.DisplayOrder = 100
local wmSucc, _ = pcall(function() wmGui.Parent = game:GetService("CoreGui") end)
if not wmSucc then pcall(function() wmGui.Parent = player:WaitForChild("PlayerGui") end) end
local wm = Instance.new("Frame"); wm.Size = UDim2.new(0,230,0,28); wm.Position = UDim2.new(0.5,-115,0,12); wm.AnchorPoint = Vector2.new(0.5,0); wm.BackgroundColor3 = BG; wm.BackgroundTransparency = 0; wm.BorderSizePixel = 0; wm.Active = true; wm.Parent = wmGui
Instance.new("UICorner", wm).CornerRadius = UDim.new(0,8)
local wmStroke = Instance.new("UIStroke", wm); wmStroke.Color = STROKE; wmStroke.Transparency = 0.4; wmStroke.Thickness = 1
local wmLogo = Instance.new("ImageLabel"); wmLogo.Size = UDim2.new(0,20,0,20); wmLogo.Position = UDim2.new(0,5,0,4); wmLogo.BackgroundTransparency = 1; wmLogo.Image = loadRemoteImage("https://i.ibb.co/r2DjrFMR/1-Photoroom.png"); wmLogo.Parent = wm
local wmTxt = Instance.new("TextLabel"); wmTxt.BackgroundTransparency = 1; wmTxt.Size = UDim2.new(0,100,0,28); wmTxt.Position = UDim2.new(0,28,0,0); wmTxt.AutomaticSize = Enum.AutomaticSize.X; wmTxt.RichText = true; wmTxt.Text = "Anvil Premium"; wmTxt.TextColor3 = TXT; wmTxt.Font = Enum.Font.GothamBold; wmTxt.TextSize = 14; wmTxt.TextXAlignment = Enum.TextXAlignment.Left; wmTxt.TextYAlignment = Enum.TextYAlignment.Center; wmTxt.TextStrokeTransparency = 0.85; wmTxt.Parent = wm
local wmSub = Instance.new("TextLabel"); wmSub.BackgroundTransparency = 1; wmSub.Size = UDim2.new(0,300,0,28); wmSub.Position = UDim2.new(0,0,0,0); wmSub.AutomaticSize = Enum.AutomaticSize.X; wmSub.Text = ""; wmSub.TextColor3 = TXT; wmSub.Font = Enum.Font.Gotham; wmSub.TextSize = 13; wmSub.TextXAlignment = Enum.TextXAlignment.Left; wmSub.TextYAlignment = Enum.TextYAlignment.Center; wmSub.TextStrokeTransparency = 0.95; wmSub.Parent = wm
local wmDrag = Instance.new("TextButton"); wmDrag.Size = UDim2.new(1,0,1,0); wmDrag.BackgroundTransparency = 1; wmDrag.Text = ""; wmDrag.ZIndex = 5; wmDrag.Parent = wm
local wmDragOn = false; local wmDragged = false; local wmStart; local wmPos
wmDrag.MouseButton1Down:Connect(function()
    wmDragOn = true; wmDragged = true; wmStart = uis:GetMouseLocation(); wmPos = wm.Position
    local con; con = uis.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then wmDragOn = false; con:Disconnect() end
    end)
end)
on(uis.InputChanged, function(inp)
    if wmDragOn and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = uis:GetMouseLocation() - wmStart
        wm.Position = UDim2.new(wmPos.X.Scale, wmPos.X.Offset + delta.X, wmPos.Y.Scale, wmPos.Y.Offset + delta.Y)
    end
end)
local wmFrames = 0; local wmFpsT = 0; local wmFps = 0; local wmT = 0
local function buildShimmer(word, t, speed, stagger)
    local out = ""
    local y = Color3.fromRGB(255, 200, 60)
    local w2 = Color3.fromRGB(255, 255, 255)
    for i = 1, #word do
        local ph = t * speed + (i - 1) * stagger
        local k = (math.sin(ph) + 1) / 2
        local c = y:Lerp(w2, k)
        out = out .. string.format('<font color="#%02X%02X%02X">%s</font>', math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255), string.sub(word, i, i))
    end
    return out
end
on(rs.RenderStepped, function(dt)
    wmT = wmT + dt
    wmLogo.Position = UDim2.new(0, 5, 0, 4 + math.sin(wmT * 3) * 1.5)
    wmTxt.Text = "Anvil " .. buildShimmer("Premium", wmT, 2.0, 0.4)
    pcall(function() titleLbl.Text = "ANVIL " .. buildShimmer("PREMIUM", wmT, 2.0, 0.4) end)
    wmFrames = wmFrames + 1
    wmFpsT = wmFpsT + dt
    if wmFpsT >= 0.5 then
        wmFps = math.floor(wmFrames / wmFpsT)
        wmFrames = 0; wmFpsT = 0
        wmSub.Text = " " .. tostring(player.Name) .. " | " .. wmFps .. " FPS | " .. tostring(#players:GetPlayers())
        local subX = 30 + wmTxt.TextBounds.X
        pcall(function() wmSub.Position = UDim2.new(0, subX, 0, 0) end)
        if not wmDragged then
            local sw = subX + wmSub.TextBounds.X + 12
            pcall(function() wm.Size = UDim2.new(0, sw, 0, 28) end)
            pcall(function() wm.Position = UDim2.new(0.5, -sw / 2, wm.Position.Y.Scale, wm.Position.Y.Offset) end)
        end
    end
end)

-- ===== AIM LOGIC =====
local function isFriend(plr)
    local n = plr.Name:lower()
    for _, f in ipairs(set.friends) do
        if f == n then return true end
    end
    return false
end

local function getTargetModel(plr)
    if plr:IsA("Player") then return plr.Character end
    return plr
end

local LE_FACTION_KEYWORDS = {
    "police", "sheriff", "fbi", "bortac", "swat", "border",
    "homeland", "trooper", "marshal", "highway", "patrol",
    "military", "army", "navy", "marine", "soldier",
}

local function teamNameOf(plr)
    local t = plr.Team
    if t and t.Name ~= "" then return string.lower(t.Name) end
    local tc = plr.TeamColor
    if tc then return string.lower(tc.Name) end
    return ""
end

local function isLawEnforcement(n)
    for _, kw in ipairs(LE_FACTION_KEYWORDS) do
        if n:find(kw, 1, true) then return true end
    end
    return false
end

local function sameFaction(a, b)
    local na = teamNameOf(a)
    local nb = teamNameOf(b)
    if na == "" or nb == "" then return na == nb end
    if na == nb then return true end
    if isLawEnforcement(na) and isLawEnforcement(nb) then return true end
    return false
end

local function isEnemy(plr)
    local model = getTargetModel(plr)
    if not model then return false end
    if plr:IsA("Player") then
        if plr == player then return false end
        if isFriend(plr) then return false end
        if set.teamCheck then
            local pt = player.Team
            local ot = plr.Team
            if pt and ot and pt == ot then return false end
            if sameFaction(player, plr) then return false end
            local pc = player.TeamColor
            local oc = plr.TeamColor
            local neutral = BrickColor.new("Medium stone grey")
            if pc ~= neutral and oc ~= neutral and pc == oc then return false end
        end
        return true
    end
    return true
end

local wallCheckParams = RaycastParams.new()
wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude
local wallVisCache = {}
local function isVisibleModel(model, head)
    local from = camera.CFrame.Position
    local to = head.Position
    local dir = to - from
    if dir.Magnitude < 1 then return true end
    local filter = { model }
    local char = player.Character
    if char then table.insert(filter, char) end
    wallCheckParams.FilterDescendantsInstances = filter
    local res = workspace:Raycast(from, dir, wallCheckParams)
    return not res
end
local function isVisibleCached(model, head)
    local now = os.clock()
    local e = wallVisCache[model]
    if e and now - e.t < 0.12 then return e.v end
    local v = isVisibleModel(model, head)
    wallVisCache[model] = { t = now, v = v }
    return v
end

local function validHead(plr)
    if not plr then return nil end
    local model = getTargetModel(plr)
    if not model then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    local head = model:FindFirstChild("Head")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not head or not root then return nil end
    if (root.Position - camera.CFrame.Position).Magnitude > set.maxDist then return nil end
    if (head.Position - Vector3.zero).Magnitude < 1 then return nil end
    if set.wallCheck and not isVisibleCached(model, head) then return nil end
    return head
end

-- собрать всех ботов-пограничников (Model с Humanoid, не принадлежит игроку)
local botCache = {}
local botRefreshT = 0
local botPlayerSet = {}
local function refreshBots()
    botCache = {}
    if not set.aimBots then return end
    botPlayerSet = {}
    local ps = players:GetPlayers()
    for i = 1, #ps do
        local c = ps[i].Character
        if c then botPlayerSet[c] = true end
    end
    local plrChar = player.Character
    local camPos = camera.CFrame.Position
    local maxD = (set.maxDist or 120) + 200
    for _, desc in pairs(workspace:GetDescendants()) do
        if desc.ClassName == "Model" and desc ~= plrChar
            and not botPlayerSet[desc]
            and desc:FindFirstChild("Head")
            and desc:FindFirstChild("HumanoidRootPart") then
            local root = desc:FindFirstChild("HumanoidRootPart")
            if (root.Position - camPos).Magnitude <= maxD then
                local hum = desc:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    botCache[#botCache + 1] = { model = desc, head = desc:FindFirstChild("Head"), root = root, hum = hum }
                end
            end
        end
    end
end
on(rs.Heartbeat, function(dt)
    if not ((set.enabled or set.silentAim) and set.aimBots) then
        botRefreshT = 0
        botCache = {}
        return
    end
    local last = botRefreshT or 0
    last = last + dt
    botRefreshT = last
    if last < 5 then return end
    botRefreshT = 0
    refreshBots()
end)

-- Target Lock: держим одну цель, пока она не умрёт
local function hasWeapon()
    local char = player.Character
    if not char then return false end
    if char:FindFirstChildOfClass("Tool") then return true end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("BasePart") then
            local n = c.Name:lower()
            if n:find("weapon") or n:find("gun") or n:find("pistol") or n:find("rifle") or n:find("shotgun") or n:find("smg") then
                return true
            end
        end
    end
    return false
end

local lastAcquireT = 0
local function acquireTarget()
    if set.targetLock and lockTarget then
        local head = validHead(lockTarget)
        if head then return head end
        lockTarget = nil
    end
    local now = os.clock()
    if now - lastAcquireT < 0.07 then
        return lockTarget and validHead(lockTarget)
    end
    lastAcquireT = now
    local center = camera.ViewportSize / 2
    local best, bestScore = nil, math.huge
    local function score(target)
        local h = validHead(target)
        if not h then return end
        local vp = camera:WorldToViewportPoint(h.Position)
        local off = (Vector2.new(vp.X, vp.Y) - center).Magnitude
        
        -- НОВОЕ: в легит режиме используем legitFov
        local currentFov = set.legitMode and set.legitFov or set.fov
        
        if off <= currentFov and off < bestScore then
            best, bestScore = target, off
        end
    end
    local function scoreBot(b)
        local head = b.head
        local root = b.root
        local hum = b.hum
        if not head or not root then return end
        if not hum or hum.Health <= 0 then return end
        if (root.Position - camera.CFrame.Position).Magnitude > set.maxDist then return end
        if set.wallCheck and not isVisibleCached(b.model, head) then return end
        local vp = camera:WorldToViewportPoint(head.Position)
        local off = (Vector2.new(vp.X, vp.Y) - center).Magnitude
        local currentFov = set.legitMode and set.legitFov or set.fov
        if off <= currentFov and off < bestScore then
            best, bestScore = b.model, off
        end
    end
    for _, plr in pairs(players:GetPlayers()) do
        if isEnemy(plr) then score(plr) end
    end
    if set.aimBots then
        for _, b in ipairs(botCache) do
            scoreBot(b)
        end
    end
    if set.targetLock then lockTarget = best end
    return best and validHead(best)
end

-- движение мышкой (как человек, обходит античит)
local function mouseRel(dx, dy)
    if dx == 0 and dy == 0 then return end
    if mousemoverel then
        pcall(function() mousemoverel(dx, dy) end)
        return
    end
    pcall(function() game:GetService("VirtualInputManager"):SendMouseMoveRelative(dx, dy, false) end)
end

-- НОВОЕ: на телефоне нет мыши — крутим камеру напрямую
cameraAim = function(head, smooth)
    if not head then return end
    pcall(function()
        local k = math.clamp((smooth or 0.35) * 4, 0.05, 1)
        local goal = CFrame.lookAt(camera.CFrame.Position, head.Position)
        camera.CFrame = camera.CFrame:Lerp(goal, k)
    end)
end

-- ===== SILENT AIM (ПК + телефон: без видимого наведения) =====
acquireSilentTarget = function()
    local center = camera.ViewportSize / 2
    local best, bestScore = nil, math.huge
    local function scoreTarget(head)
        if not head then return end
        local d = (head.Position - camera.CFrame.Position).Magnitude
        if d > set.silentDist then return end
        local vp = camera:WorldToViewportPoint(head.Position)
        if vp.Z <= 0 then return end
        local off = (Vector2.new(vp.X, vp.Y) - center).Magnitude
        if off < bestScore then bestScore = off; best = head end
    end
    for _, plr in pairs(players:GetPlayers()) do
        if isEnemy(plr) then scoreTarget(validHead(plr)) end
    end
    if set.aimBots then
        for _, b in ipairs(botCache) do
            scoreTarget(validHead(b.model))
        end
    end
    return best
end

findWeapon = function()
    local char = player.Character
    if not char then return nil end
    local t = char:FindFirstChild("Tool")
    if t then return t end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") then return c end
    end
    return nil
end

silentShoot = function()
    if not set.silentAim then return end
    if sg.Enabled then return end
    if set.weaponCheck and not hasWeapon() then return end
    local head = acquireSilentTarget()
    if not head then return end
    local char = player.Character
    if not char then return end
    local weapon = findWeapon()
    if not weapon then return end

    local cam = camera.CFrame
    camera.CFrame = CFrame.lookAt(cam.Position, head.Position)

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hrpSave = hrp and hrp.CFrame
    if hrp then
        pcall(function()
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(head.Position.X, hrp.Position.Y, head.Position.Z))
        end)
    end

    pcall(function() weapon:Activate() end)
    local act = weapon:FindFirstChild("Activate")
    if act and act:IsA("RemoteEvent") then
        pcall(function() act:FireServer() end)
    end

    -- возвращаем мгновенно, до отрисовки следующего кадра — наводки не видно
    camera.CFrame = cam
    if hrp and hrpSave then
        pcall(function() hrp.CFrame = hrpSave end)
    end
end

on(uis.InputBegan, function(inp, gp)
    if gp then return end
    if sg.Enabled then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        pcall(silentShoot)
    elseif inp.UserInputType == Enum.UserInputType.Touch and inp.UserInputState == Enum.UserInputState.Begin then
        pcall(silentShoot)
    end
end)

-- FOV круг
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false; fovCircle.Thickness = 1; fovCircle.Radius = 0; fovCircle.Filled = false; fovCircle.Color = getAccent(); fovCircle.Transparency = 0.6

on(rs.RenderStepped, function(dt)
    -- НОВОЕ: используем FOV в зависимости от режима
    local currentFov = set.legitMode and set.legitFov or set.fov
    fovCircle.Radius = currentFov
    fovCircle.Position = camera.ViewportSize / 2
    fovCircle.Color = accentCache
    -- НОВОЕ: показываем круг только если showFov включен и аимбот включен
    fovCircle.Visible = set.enabled and set.showFov

    local active = set.enabled
    if set.hold then active = active and keyDown end
    if not active then
        lockTarget = nil
        return
    end
    if set.weaponCheck and not hasWeapon() then
        lockTarget = nil
        return
    end

    local target = acquireTarget()
    if target then
        pcall(function()
            local vp = camera:WorldToViewportPoint(target.Position)
            if vp.Z > 0 then
                local center = camera.ViewportSize / 2
                local delta = Vector2.new(vp.X, vp.Y) - center
                
                -- НОВОЕ: разное сглаживание для легит и обычного режима
                local currentSmooth = set.legitMode and set.legitSmooth or set.smooth
                local step = delta * currentSmooth
                
                -- НОВОЕ: в легит режиме ещё меньше максимальный шаг (более плавно)
                local maxStep = set.legitMode and 12 or 24
                if step.Magnitude > maxStep then step = step.Unit * maxStep end
                
                -- НОВОЕ: в легит режиме не останавливаемся так близко к цели
                local stopDist = set.legitMode and 5 or 2
                if delta.Magnitude < stopDist then step = Vector2.zero end
                
                if isMobile then
                    cameraAim(target, currentSmooth)
                else
                    mouseRel(step.X, step.Y)
                end
            end
        end)
    end
end)

-- поддержка Night Mode (игра может сбрасывать освещение) — применяем не каждый кадр, чтобы не лагало
local nightKeepT = 0
on(rs.Heartbeat, function(dt)
    if not set.night then return end
    nightKeepT = nightKeepT + dt
    if nightKeepT >= 1.5 then
        nightKeepT = 0
        pcall(applyNight)
    end
end)

-- ===== ESP (WH по командам, углы как в CS:GO) =====
local espObjs = {}

local function espColorFor(plr)
    if isFriend(plr) then return Color3.fromRGB(0, 200, 255) end
    if isEnemy(plr) then return accentCache end
    return Color3.fromRGB(60, 255, 90)
end

local WANTED_NAMES = {
    "wanted", "wantedlevel", "wanted_level", "розыск", "розыске",
    "преступ", "criminal", "crime", "warrant", "bounty", "outlaw",
    "stars", "звезд", "wl",
}

local CRIMINAL_TEAM_KW = { "criminal", "wanted", "outlaw", "bandit", "mafia", "gang", "преступ", "бандит", "мафи" }

local function wantedNameHit(name)
    local kn = string.lower(tostring(name or ""))
    if kn == "" then return false end
    if kn == "wl" or kn == "star" then return true end
    if string.find(kn, "star", 1, true) and not string.find(kn, "start", 1, true) then return true end
    for _, w in ipairs(WANTED_NAMES) do
        if w ~= "wl" and string.find(kn, w, 1, true) then return true end
    end
    return false
end

local function coerceWanted(v)
    if type(v) == "number" then
        return v > 0 and v or 0
    end
    if type(v) == "boolean" then
        return v and 1 or 0
    end
    if type(v) == "string" then
        local n = tonumber(v)
        if n then return n > 0 and n or 0 end
        local s = string.lower(v)
        if s == "true" or s == "yes" or s == "wanted" or s == "criminal" then return 1 end
    end
    return 0
end

local function wantedFromObj(obj)
    if not obj then return 0 end
    local ok, attrs = pcall(function() return obj:GetAttributes() end)
    if ok and attrs then
        for k, v in pairs(attrs) do
            if wantedNameHit(k) then
                local n = coerceWanted(v)
                if n > 0 then return n end
            end
        end
    end
    return 0
end

local function getWantedStars(plr)
    local n = wantedFromObj(plr)
    if n > 0 then return n end
    if plr:IsA("Player") then
        local tn = teamNameOf(plr)
        for _, w in ipairs(CRIMINAL_TEAM_KW) do
            if tn ~= "" and string.find(tn, w, 1, true) then return 1 end
        end
    end
    local ch = plr:IsA("Player") and plr.Character or plr
    if ch then
        n = wantedFromObj(ch)
        if n > 0 then return n end
        local limit = 0
        for _, d in ipairs(ch:GetDescendants()) do
            limit = limit + 1
            if limit > 250 then break end
            if d:IsA("ValueBase") and wantedNameHit(d.Name) then
                local okv, raw = pcall(function() return d.Value end)
                if okv then
                    local v = coerceWanted(raw)
                    if v > 0 then return v end
                end
            else
                local a = wantedFromObj(d)
                if a > 0 then return a end
            end
        end
    end
    if plr:IsA("Player") then
        local ls = plr:FindFirstChild("leaderstats")
        if ls then
            for _, d in ipairs(ls:GetChildren()) do
                if wantedNameHit(d.Name) then
                    local okv, raw = pcall(function() return d.Value end)
                    if okv then
                        local v = coerceWanted(raw)
                        if v > 0 then return v end
                    end
                end
            end
        end
    end
    return 0
end

local function makeEspObj()
    local lines = {}
    for _ = 1, 8 do
        local ln = Drawing.new("Line")
        ln.Visible = false
        ln.Thickness = 1.5
        ln.Color = Color3.new(1, 1, 1)
        lines[#lines + 1] = ln
    end
    local txt = Drawing.new("Text")
    txt.Visible = false
    txt.Center = true
    txt.Outline = true
    txt.Size = 13
    txt.Color = Color3.new(1, 1, 1)
    local hbBg = Drawing.new("Line")
    hbBg.Visible = false
    hbBg.Thickness = 5
    hbBg.Color = Color3.fromRGB(20, 20, 25)
    hbBg.Transparency = 0.25
    local hbFill = Drawing.new("Line")
    hbFill.Visible = false
    hbFill.Thickness = 3
    hbFill.Color = Color3.fromRGB(60, 255, 90)
    return { lines = lines, txt = txt, hbBg = hbBg, hbFill = hbFill }
end

local function hideEspObj(e)
    for i = 1, 8 do e.lines[i].Visible = false end
    e.txt.Visible = false
    e.hbBg.Visible = false
    e.hbFill.Visible = false
end

local function destroyEspObj(e)
    pcall(function()
        for i = 1, 8 do e.lines[i]:Remove() end
        e.txt:Remove()
        e.hbBg:Remove()
        e.hbFill:Remove()
    end)
end

clearAllEsp = function()
    for plr in pairs(espObjs) do
        destroyEspObj(espObjs[plr])
        espObjs[plr] = nil
    end
    espObjs = {}
end

on(players.PlayerRemoving, function(plr)
    local e = espObjs[plr]
    if e then
        destroyEspObj(e)
        espObjs[plr] = nil
    end
end)

local function clearEspFor(plr)
    local e = espObjs[plr]
    if e then
        destroyEspObj(e)
        espObjs[plr] = nil
    end
end

on(players.PlayerAdded, function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.1)
        clearEspFor(plr)
    end)
end)

do
    for _, plr in pairs(players:GetPlayers()) do
        plr.CharacterAdded:Connect(function()
            task.wait(0.1)
            clearEspFor(plr)
        end)
    end
end

local function updateEspObj(plr, c, slow)
    local root = c:FindFirstChild("HumanoidRootPart")
    local head = c:FindFirstChild("Head")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not root or not head or not hum or hum.Health <= 0 then
        return false
    end
    local camPos = camera.CFrame.Position
    local dist = (root.Position - camPos).Magnitude
    if dist > set.espRange then return false end

    local headPos = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
    local bottomPos = root.Position - Vector3.new(0, 3, 0)

    local hP, hOk = camera:WorldToViewportPoint(headPos)
    local bP, bOk = camera:WorldToViewportPoint(bottomPos)
    if not hOk or not bOk or hP.Z <= 0 or bP.Z <= 0 then return false end

    local height = math.abs(bP.Y - hP.Y)
    if height < 5 then return false end
    local width = height * 0.55
    local cx = (hP.X + bP.X) / 2
    local y1 = math.min(hP.Y, bP.Y)
    local y2 = math.max(hP.Y, bP.Y)
    local x1 = cx - width / 2
    local x2 = cx + width / 2
    local len = width * 0.22

    local e = espObjs[plr]
    if not e then e = makeEspObj(); espObjs[plr] = e end
    local L = e.lines
    L[1].From = Vector2.new(x1, y1); L[1].To = Vector2.new(x1 + len, y1)
    L[2].From = Vector2.new(x1, y1); L[2].To = Vector2.new(x1, y1 + len)
    L[3].From = Vector2.new(x2, y1); L[3].To = Vector2.new(x2 - len, y1)
    L[4].From = Vector2.new(x2, y1); L[4].To = Vector2.new(x2, y1 + len)
    L[5].From = Vector2.new(x1, y2); L[5].To = Vector2.new(x1 + len, y2)
    L[6].From = Vector2.new(x1, y2); L[6].To = Vector2.new(x1, y2 - len)
    L[7].From = Vector2.new(x2, y2); L[7].To = Vector2.new(x2 - len, y2)
    L[8].From = Vector2.new(x2, y2); L[8].To = Vector2.new(x2, y2 - len)
    for i = 1, 8 do
        L[i].Visible = true
    end

    if slow then
        e.lastCol = espColorFor(plr)
        for i = 1, 8 do L[i].Color = e.lastCol end
    end

    if set.espShowHp then
        local barX = x1 - 6
        e.hbBg.From = Vector2.new(barX, y2); e.hbBg.To = Vector2.new(barX, y1)
        e.hbBg.Visible = true
        if slow then
            e.lastPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        end
        local pct = e.lastPct or math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local hbH = (y2 - y1) * pct
        e.hbFill.From = Vector2.new(barX, y2); e.hbFill.To = Vector2.new(barX, y2 - hbH)
        if slow then
            e.hbFill.Color = pct > 0.6 and Color3.fromRGB(60, 255, 90) or pct > 0.3 and Color3.fromRGB(255, 210, 60) or Color3.fromRGB(255, 60, 60)
        end
        e.hbFill.Visible = true
    else
        e.hbBg.Visible = false
        e.hbFill.Visible = false
    end

    if slow then
        local wanted = getWantedStars(plr)
        local text = ""
        if set.espShowName then text = plr.Name end
        if wanted > 0 then
            if text ~= "" then text = text .. " " end
            text = "[WANTED] " .. text
        end
        if set.espShowDist then
            text = text .. " [" .. math.floor(dist) .. "m]"
        end
        e.lastText = text
        e.txt.Text = text
    end
    e.txt.Position = Vector2.new(cx, y1 - 16)
    if e.lastCol then e.txt.Color = e.lastCol end
    e.txt.Visible = e.lastText ~= nil and e.lastText ~= ""
    return true
end

local espSlowTick = 0
on(rs.RenderStepped, function(dt)
    if not set.esp then
        pcall(clearAllEsp)
        espSlowTick = 0
        return
    end
    local slow = false
    espSlowTick = espSlowTick + dt
    if espSlowTick >= 0.25 then
        espSlowTick = 0
        slow = true
    end
    for plr in pairs(espObjs) do
        if plr.Parent ~= players then
            local e = espObjs[plr]
            if e then destroyEspObj(e) end
            espObjs[plr] = nil
        end
    end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            pcall(function()
                local c = plr.Character
                local ok = c and updateEspObj(plr, c, slow)
                if not ok then
                    local e = espObjs[plr]
                    if e then hideEspObj(e) end
                end
            end)
        end
    end
end)

-- ===== RING FARM =====
local FARM_WPS = {
    { pos = Vector3.new(6820.724, 17.471, 20.620), name = "Покупка колец", click = true, buy5 = true, gui = BUY_KEYWORDS, part = BUY_PART_KEYWORDS },
    { pos = Vector3.new(6798.731, 18.142, 150.736), name = "Путь" },
    { pos = Vector3.new(103.269, 18.214, 135.413), name = "Путь" },
    { pos = Vector3.new(-105.790, 17.273, 511.164), name = "Путь" },
    { pos = Vector3.new(53.290, 17.273, 429.386), name = "Путь" },
    { pos = Vector3.new(51.163, 33.315, 558.917), name = "Путь" },
    { pos = Vector3.new(26.459, 33.313, 562.073), name = "Путь" },
    { pos = Vector3.new(28.872, 33.310, 428.789), name = "Путь" },
    { pos = Vector3.new(49.091, 33.307, 427.544), name = "Путь" },
    { pos = Vector3.new(48.322, 49.315, 560.991), name = "Путь" },
    { pos = Vector3.new(-81.914, 49.302, 431.736), name = "Сдача колец (sell)", click = true, gui = SELL_KEYWORDS, part = SELL_PART_KEYWORDS },
    { pos = Vector3.new(48.322, 49.315, 560.991), name = "Путь" },
    { pos = Vector3.new(49.091, 33.307, 427.544), name = "Путь" },
    { pos = Vector3.new(28.872, 33.310, 428.789), name = "Путь" },
    { pos = Vector3.new(26.459, 33.313, 562.073), name = "Путь" },
    { pos = Vector3.new(51.163, 33.315, 558.917), name = "Путь" },
    { pos = Vector3.new(53.290, 17.273, 429.386), name = "Путь" },
    { pos = Vector3.new(-105.790, 17.273, 511.164), name = "Путь" },
    { pos = Vector3.new(103.269, 18.214, 135.413), name = "Путь" },
    { pos = Vector3.new(6798.731, 18.142, 150.736), name = "Путь" },
    { pos = Vector3.new(6806.888, 17.497, -34.842), name = "Отмыв денег (launder)", click = true, gui = LAUNDER_KEYWORDS, part = LAUNDER_PART_KEYWORDS },
}

local MONA_WPS = {
    { pos = Vector3.new(6806.26, 17.42, 23.10), name = "Покупка Мона Лизы", click = true, buy5 = true, gui = MONA_KEYWORDS, part = MONA_PART_KEYWORDS },
    { pos = Vector3.new(6798.731, 18.142, 150.736), name = "Путь" },
    { pos = Vector3.new(103.269, 18.214, 135.413), name = "Путь" },
    { pos = Vector3.new(-105.790, 17.273, 511.164), name = "Путь" },
    { pos = Vector3.new(53.290, 17.273, 429.386), name = "Путь" },
    { pos = Vector3.new(51.163, 33.315, 558.917), name = "Путь" },
    { pos = Vector3.new(26.459, 33.313, 562.073), name = "Путь" },
    { pos = Vector3.new(28.872, 33.310, 428.789), name = "Путь" },
    { pos = Vector3.new(49.091, 33.307, 427.544), name = "Путь" },
    { pos = Vector3.new(48.322, 49.315, 560.991), name = "Путь" },
    { pos = Vector3.new(-81.914, 49.302, 431.736), name = "Сдача (sell)", click = true, gui = SELL_KEYWORDS, part = SELL_PART_KEYWORDS },
    { pos = Vector3.new(48.322, 49.315, 560.991), name = "Путь" },
    { pos = Vector3.new(49.091, 33.307, 427.544), name = "Путь" },
    { pos = Vector3.new(28.872, 33.310, 428.789), name = "Путь" },
    { pos = Vector3.new(26.459, 33.313, 562.073), name = "Путь" },
    { pos = Vector3.new(51.163, 33.315, 558.917), name = "Путь" },
    { pos = Vector3.new(53.290, 17.273, 429.386), name = "Путь" },
    { pos = Vector3.new(-105.790, 17.273, 511.164), name = "Путь" },
    { pos = Vector3.new(103.269, 18.214, 135.413), name = "Путь" },
    { pos = Vector3.new(6798.731, 18.142, 150.736), name = "Путь" },
    { pos = Vector3.new(6806.888, 17.497, -34.842), name = "Отмыв денег (launder)", click = true, gui = LAUNDER_KEYWORDS, part = LAUNDER_PART_KEYWORDS },
}

farmRunning = false
monaRunning = false

local groundRayParams
local function getGroundY(x, z, fromY)
    if not groundRayParams then
        groundRayParams = RaycastParams.new()
        groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
        groundRayParams.FilterDescendantsInstances = { player.Character or workspace }
    end
    -- Лучом сверху вниз с большой высоты (Y=500), чтобы гарантированно находить поверхность карты и не проваливаться под карту
    local ok, res = pcall(workspace.Raycast, workspace, Vector3.new(x, 500, z), Vector3.new(0, -1000, 0), groundRayParams)
    if ok and res and res.Position then return res.Position.Y end
    if fromY then
        local ok2, res2 = pcall(workspace.Raycast, workspace, Vector3.new(x, fromY + 50, z), Vector3.new(0, -200, 0), groundRayParams)
        if ok2 and res2 and res2.Position then return res2.Position.Y end
    end
    return nil
end

local BUY_KEYWORDS = { "buy fake diamond ring", "fake diamond ring", "buyfake", "diamondring", "buy diamond", "diamond ring", "ring" }
local RING_PROMPT_KW = { "ring", "diamond", "jewel", "seller", "market", "interact" }
local MONA_KEYWORDS = { "mona lisa", "monalisa" }
local MONA_PROMPT_KW = { "mona lisa", "monalisa", "mona lisa painting" }
local MONA_PART_KEYWORDS = { "mona lisa", "monalisa" }
local SELL_KEYWORDS = { "sell goods", "sellgoods", "sell goods", "goods", "sell" }
local LAUNDER_KEYWORDS = { "launder cash", "laundercash", "launder", "cash" }
local BUY_PART_KEYWORDS = { "buy", "fake", "diamond", "ring" }
local SELL_PART_KEYWORDS = { "sell", "goods" }
local LAUNDER_PART_KEYWORDS = { "launder", "cash", "wash" }

local SKIP_GUIS = { AnvilAimMenu = true, AnvilAimKeybinds = true, AnvilAimWatermark = true, AnvilLoader = true }

local function isButton(o)
    return (o:IsA("TextButton") or o:IsA("ImageButton")) and o.Visible and o.AbsoluteSize.X > 0
end

local function findGuiButton(keywords)
    local roots = {}
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if pg then roots[#roots + 1] = pg end
    roots[#roots + 1] = game:GetService("CoreGui")
    pcall(function()
        for _, o in ipairs(workspace:GetDescendants()) do
            if o:IsA("SurfaceGui") or o:IsA("BillboardGui") then roots[#roots + 1] = o end
        end
    end)
    for _, gui in ipairs(roots) do
        for _, btn in ipairs(gui:GetDescendants()) do
            if isButton(btn) then
                local top = btn:FindFirstAncestorOfClass("ScreenGui")
                if not (top and SKIP_GUIS[top.Name]) then
                    local t = string.lower(btn.Text or "")
                    for _, kw in ipairs(keywords) do
                        if string.find(t, kw, 1, true) then
                            return btn
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function pressButton(btn)
    if not btn or not btn.Visible then return false end
    local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
    local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if mousemoveabs then
            pcall(function() mousemoveabs(x, y) end)
        else
            pcall(function() vim:SendMouseMoveEvent(x, y, 0) end)
        end
        task.wait(0.05)
        if mouse1click then
            pcall(function() mouse1click() end)
        else
            pcall(function() vim:SendMouseButtonEvent(x, y, 0, true, Enum.UserInputType.MouseButton1) end)
            task.wait(0.15)
            pcall(function() vim:SendMouseButtonEvent(x, y, 0, false, Enum.UserInputType.MouseButton1) end)
        end
    end)
    return true
end

local function clickGuiBtn(keywords)
    return pressButton(findGuiButton(keywords))
end

local function facePart(part)
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera
    if not hrp or not part then return end
    local from = hrp.Position + Vector3.new(0, 1.5, 0)
    local target = part.Position + Vector3.new(0, 3, 0)
    pcall(function()
        local cf = CFrame.lookAt(from, target)
        cam.CFrame = cf
        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(target.X, hrp.Position.Y, target.Z))
    end)
end

local function clickButtonNear(pos, radius, clicks, quick, guiKeywords, partKeywords, skipGui)
    radius = radius or 120
    clicks = clicks or 1
    guiKeywords = guiKeywords or BUY_KEYWORDS
    partKeywords = partKeywords or BUY_PART_KEYWORDS
    local bestPart, bestDist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        local hit = nil
        if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
            hit = v.Parent
        elseif v:IsA("BasePart") then
            local n = string.lower(v.Name)
            for _, kw in ipairs(partKeywords) do
                if string.find(n, kw, 1, true) then hit = v break end
            end
        end
        if hit and hit:IsA("BasePart") then
            local d = (hit.Position - pos).Magnitude
            if d <= radius and d < bestDist then
                bestDist = d; bestPart = hit
            end
        end
    end
    local vim = game:GetService("VirtualInputManager")
    local det = bestPart and (bestPart:FindFirstChildOfClass("ClickDetector") or bestPart:FindFirstChildOfClass("ProximityPrompt"))
    local pressHold = quick and 0.25 or buyHold
    for _ = 1, clicks do
        if set.farmStop then return false end
        if bestPart then facePart(bestPart); task.wait(0.1) end
        if det then
            if det:IsA("ClickDetector") then
                if fireclickdetector then
                    pcall(function() fireclickdetector(det) end)
                end
                pcall(function() det.mouse1Click:FireServer() end)
                pcall(function() det.MouseClick:FireServer() end)
            elseif det:IsA("ProximityPrompt") then
                if fireproximityprompt then
                    pcall(function() fireproximityprompt(det) end)
                else
                    local kc = Enum.KeyCode.E
                    pcall(function()
                        if det.KeyboardKeyCode then kc = det.KeyboardKeyCode end
                        if kc == Enum.KeyCode.None then kc = Enum.KeyCode.E end
                    end)
                    pcall(function() vim:SendKeyEvent(true, kc, false, nil) end)
                    task.wait(pressHold)
                    pcall(function() vim:SendKeyEvent(false, kc, false, nil) end)
                end
            end
        elseif bestPart then
            local c = workspace.CurrentCamera
            local sp, onScreen = c:WorldToScreenPoint(bestPart.Position + Vector3.new(0, 3, 0))
            if onScreen then
                pcall(function()
                    if mouse1click then
                        pcall(function() mousemoveabs(sp.X, sp.Y) end)
                        task.wait(0.05)
                        pcall(function() mouse1click() end)
                    else
                        vim:SendMouseButtonEvent(sp.X, sp.Y, 0, true, Enum.UserInputType.MouseButton1)
                        task.wait(pressHold)
                        vim:SendMouseButtonEvent(sp.X, sp.Y, 0, false, Enum.UserInputType.MouseButton1)
                    end
                end)
            end
        end
        task.wait(0.3)
        if not skipGui then pcall(clickGuiBtn, guiKeywords) end
    end
    return true
end

local FIND_RING_NEEDLES = { "fake diamond ring", "fake diamond", "fake ring", "diamond ring", "diamond", "ring" }

local function findRingLabel()
    local pg = player:FindFirstChildOfClass("PlayerGui")
    local roots = { pg, game:GetService("CoreGui") }
    for _, needle in ipairs(FIND_RING_NEEDLES) do
        for _, gui in ipairs(roots) do
            if gui then
                for _, o in ipairs(gui:GetDescendants()) do
                    if (o:IsA("TextLabel") or o:IsA("TextButton")) and o.Visible then
                        local t = string.lower(o.Text or "")
                        if string.find(t, needle, 1, true) and not string.find(t, "sell", 1, true) then
                            return o
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function findRingBuyButton()
    local o = findRingLabel()
    if not o then return nil end
    local anc = o.Parent
    for i = 1, 4 do
        if not anc then break end
        local bb = anc:FindFirstChild("BuyButton")
        if bb and (bb:IsA("TextButton") or bb:IsA("ImageButton")) and bb.Visible then
            return bb
        end
        for _, b2 in ipairs(anc:GetChildren()) do
            if (b2:IsA("TextButton") or b2:IsA("ImageButton")) and b2.Visible and string.find(string.lower(b2.Name), "buy", 1, true) then
                return b2
            end
        end
        anc = anc.Parent
    end
    return nil
end

local function scrollIntoView(bb)
    pcall(function()
        local anc = bb.Parent
        for i = 1, 8 do
            if not anc then return end
            if anc:IsA("ScrollingFrame") then
                local targetY = bb.AbsolutePosition.Y - anc.AbsolutePosition.Y - anc.AbsoluteSize.Y / 2
                anc.CanvasPosition = Vector2.new(0, math.max(0, targetY))
                return
            end
            anc = anc.Parent
        end
    end)
end

local function ringBtnOnScreen(bb)
    local vp = workspace.CurrentCamera.ViewportSize
    local x = bb.AbsolutePosition.X + bb.AbsoluteSize.X / 2
    local y = bb.AbsolutePosition.Y + bb.AbsoluteSize.Y / 2
    return x >= 0 and x <= vp.X and y >= 0 and y <= vp.Y and bb.Visible
end

local function pressKey(kc)
    pcall(function()
        if keypress then
            pcall(function() keypress(kc) end)
            task.wait(0.12)
            pcall(function() keyrelease(kc) end)
        elseif keypressclick then
            pcall(function() keypressclick(kc) end)
        else
            local vim = game:GetService("VirtualInputManager")
            pcall(function() vim:SendKeyEvent(true, kc, false, nil) end)
            task.wait(0.12)
            pcall(function() vim:SendKeyEvent(false, kc, false, nil) end)
        end
    end)
end

local function promptMatches(p, kws)
    local txt, ot = "", ""
    pcall(function() txt = tostring(p.PromptText) end)
    pcall(function() ot = tostring(p.ObjectText) end)
    local s = p.Name .. " " .. txt .. " " .. ot
    local anc = p.Parent
    for i = 1, 4 do
        if not anc then break end
        s = s .. " " .. tostring(anc.Name)
        anc = anc.Parent
    end
    s = string.lower(s)
    for _, kw in ipairs(kws) do
        if string.find(s, kw, 1, true) then return true end
    end
    return false
end

local function findItemPrompt(pos, kws, radius)
    radius = radius or 40
    local matchAny, near = nil, {}
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local where = nil
            local part = p.Parent
            if part then
                if part:IsA("BasePart") then
                    where = part.Position
                else
                    local m = part:IsA("Model") and part or part:FindFirstAncestorOfClass("Model")
                    if m then pcall(function() where = m:GetPivot().Position end) end
                end
            end
            if promptMatches(p, kws) then
                if not matchAny then matchAny = p end
                if where and pos and (where - pos).Magnitude <= radius then
                    matchAny = p
                    break
                end
            elseif where and pos and (where - pos).Magnitude <= radius then
                near[#near + 1] = { p = p, d = (where - pos).Magnitude }
            end
        end
    end
    if matchAny then return matchAny end
    table.sort(near, function(a, b) return a.d < b.d end)
    return near[1] and near[1].p or nil
end

local function findRingPrompt(pos, radius)
    return findItemPrompt(pos, RING_PROMPT_KW, radius)
end

local function findMonaPrompt(pos, radius)
    return findItemPrompt(pos, MONA_PROMPT_KW, radius)
end

local function buyItem(pos, itemName, kws, statusLbl, count)
    count = count or 5
    local wasMenu = sg.Enabled
    if wasMenu then sg.Enabled = false end
    local keyE = Enum.KeyCode.E
    pcall(function() statusLbl.Text = loc("Статус: покупаем ") .. count .. loc(" шт") end)
    local p = findItemPrompt(pos, kws, 15)
    if not p then
        p = findItemPrompt(pos, kws, 40)
    end
    for i = 1, count do
        if set.farmStop then break end
        if p then
            pcall(function() fireproximityprompt(p) end)
        else
            pressKey(keyE)
        end
        pcall(function() statusLbl.Text = loc("Статус: куплено ") .. i .. "/" .. count end)
        task.wait(0.5)
    end
    task.wait(0.8)
    if not set.farmStop and p then
        pcall(function() fireproximityprompt(p) end)
    end
    if wasMenu then sg.Enabled = true end
    pcall(function() statusLbl.Text = loc("Статус: куплено, летим дальше") end)
end

local function buyRings(pos)
    buyItem(pos, "кольца", RING_PROMPT_KW, farmStatusLbl, 5)
end

local function buyMona(pos)
    buyItem(pos, "Мона Лизы", MONA_PROMPT_KW, monaStatusLbl, 5)
end

local pfs = game:GetService("PathfindingService")

local function setCharNoClip(on)
    local c = player.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not on end
    end
end

local function resetCharMotion()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new()
        hrp.AssemblyAngularVelocity = Vector3.new()
        hrp.Velocity = Vector3.new()
        hrp.RotVelocity = Vector3.new()
        local pos = hrp.Position
        local gy = getGroundY(pos.X, pos.Z, pos.Y + 2)
        if gy then pos = Vector3.new(pos.X, gy + 2.5, pos.Z) end
        hrp.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, 1))
    end)
end

function farmStopCleanup()
    set.farmStop = true
    farmRunning = false
    monaRunning = false
    polRunning = false
    farmTarget = nil
    policeTarget = nil
    pcall(resetCharMotion)
    task.wait(0.15)
    setCharNoClip(false)
    pcall(resetCharMotion)
    stopAntiAfk()
    pcall(function() farmStatusLbl.Text = loc("Статус: Ожидание") end)
    pcall(function() monaStatusLbl.Text = loc("Статус: Ожидание") end)
    pcall(function() polStatusLbl.Text = loc("Статус: Ожидание") end)
end

-- полёт с ноуклипом (как раньше): мелкие шаги к точке, прижимается к земле
local function smoothFlyTo(goal, speed)
    speed = speed or 140
    while true do
        if set.farmStop then return false end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local from = hrp.Position
        local dist = (goal - from).Magnitude
        if dist <= 2 then
            pcall(function()
                hrp.CFrame = CFrame.new(goal, goal + Vector3.new(0, 0, 1))
                hrp.Velocity = Vector3.new()
            end)
            return true
        end
        local step = math.min(dist, speed * 0.033)
        local nextPos = from + (goal - from).Unit * step
        local gy = getGroundY(nextPos.X, nextPos.Z, nextPos.Y + 2)
        if gy then
            nextPos = Vector3.new(nextPos.X, gy + 3, nextPos.Z)
        end
        pcall(function()
            hrp.CFrame = CFrame.new(nextPos, goal + Vector3.new(0, 0, 1))
            hrp.Velocity = Vector3.new()
        end)
        task.wait(0.033)
    end
end

-- ===== ANTI-AFK (для фарма: игра кикает за 20 мин бездействия) =====
local afkLast = 0
local afkCon = nil
local function startAntiAfk()
    if afkCon then return end
    afkLast = 0
    afkCon = rs.Heartbeat:Connect(function(dt)
        afkLast = afkLast + dt
        if afkLast < 60 then return end
        afkLast = 0
        pcall(function() game:GetService("VirtualUser"):CaptureController() end)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, nil) end)
        task.wait(0.08)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, nil) end)
    end)
end
local function stopAntiAfk()
    if afkCon then
        pcall(function() afkCon:Disconnect() end)
        afkCon = nil
    end
end

local function runFarmPass(wps, buyFn, statusLbl, speed)
    local char = player.Character
    if not char then return "nochar" end
    for _, wp in ipairs(wps) do
        if set.farmStop then return "stop" end
        farmTarget = wp.pos
        pcall(function() statusLbl.Text = loc("Статус: летим — ") .. wp.name end)
        local ok = smoothFlyTo(wp.pos, speed or 220)
        if set.farmStop then return "stop" end
        if not ok then return "nochar" end
        farmTarget = nil
        if wp.click then
            if wp.buy5 then
                pcall(buyFn, wp.pos)
            else
                pcall(function() statusLbl.Text = loc("Статус: нажимаем — ") .. wp.name end)
                pcall(function() clickButtonNear(wp.pos, 80, 1, false, wp.gui, wp.part) end)
            end
        end
        task.wait(0.5)
    end
    return "done"
end

local function farmLoop(flagGet, flagSet, wps, buyFn, statusLbl, speed)
    task.spawn(function()
        local ok, err = pcall(function()
            while flagGet() and not set.farmStop do
                local res = runFarmPass(wps, buyFn, statusLbl, speed)
                if res == "nochar" then
                    pcall(function() statusLbl.Text = loc("Статус: ожидание персонажа...") end)
                    local t = 0
                    while flagGet() and not set.farmStop and not player.Character and t < 30 do
                        task.wait(0.5)
                        t = t + 0.5
                    end
                    if not flagGet() or set.farmStop then break end
                    task.wait(1)
                    setCharNoClip(true)
                elseif res == "stop" then
                    break
                else
                    task.wait(0.5)
                end
            end
        end)
        if not ok and err then
            warn("[AnvilAim] farmLoop error: " .. tostring(err))
        end
        flagSet(false)
        farmTarget = nil
        setCharNoClip(false)
        stopAntiAfk()
        pcall(function() statusLbl.Text = loc("Статус: Ожидание") end)
        if not ok then pcall(farmStopCleanup) end
    end)
end

startRingFarm = function(speed)
    if farmRunning then return end
    if monaRunning then
        set.farmStop = true
        local t0 = os.clock()
        while monaRunning and os.clock() - t0 < 3 do task.wait(0.1) end
    end
    set.farmStop = false
    setCharNoClip(true)
    farmRunning = true
    startAntiAfk()
    pcall(resetMoneyBase)
    if not set.moneyTracker then pcall(setMoneyTracker, true) end
    farmLoop(function() return farmRunning end, function(v) farmRunning = v end, FARM_WPS, buyRings, farmStatusLbl, speed)
end

startMonaLisaFarm = function(speed)
    if monaRunning then return end
    if farmRunning then
        set.farmStop = true
        local t0 = os.clock()
        while farmRunning and os.clock() - t0 < 3 do task.wait(0.1) end
    end
    set.farmStop = false
    setCharNoClip(true)
    monaRunning = true
    startAntiAfk()
    pcall(resetMoneyBase)
    if not set.moneyTracker then pcall(setMoneyTracker, true) end
    farmLoop(function() return monaRunning end, function(v) monaRunning = v end, MONA_WPS, buyMona, monaStatusLbl, speed)
end

-- ===== POLICE EXP FARM =====
polRunning = false
policeActive = false
policeTarget = nil
policeDoneAt = {}

POLICE_TASER_KW = { "taser", "тайзер", "tazer", "электрошок" }
POLICE_CUFF_KW = { "наручник", "cuff", "handcuff", "задержать", "detain", "restrain" }
POLICE_ARREST_KW = { "посад", "arrest", "тюрьм", "заключ", "взять под" }
POLICE_AREA_CENTER = Vector3.new(3484.08, 17.04, 106.06)
POLICE_AREA_RADIUS = 300
POLICE_MAX_RANGE = 800

-- запретная зона: сюда нельзя лететь (респ цивилов/госников и т.п.)
FORBIDDEN_CENTER = nil
FORBIDDEN_RADIUS = 120
FORBIDDEN_ON = false

policeInArea = function(pos)
    local d = Vector3.new(pos.X - POLICE_AREA_CENTER.X, 0, pos.Z - POLICE_AREA_CENTER.Z).Magnitude
    return d <= POLICE_AREA_RADIUS
end

policeInForbidden = function(pos)
    if not FORBIDDEN_ON or not FORBIDDEN_CENTER then return false end
    local d = Vector3.new(pos.X - FORBIDDEN_CENTER.X, 0, pos.Z - FORBIDDEN_CENTER.Z).Magnitude
    return d <= FORBIDDEN_RADIUS
end

policeFindTarget = function(skip)
    local best, bestD = nil, math.huge
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local nowTime = os.clock()
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and not isFriend(plr) and not (skip and skip[plr]) then
            if not isLawEnforcement(teamNameOf(plr)) then
                local doneT = policeDoneAt and policeDoneAt[plr]
                if not (doneT and nowTime - doneT < 30) then
                    local ch = plr.Character
                    local root = ch and ch:FindFirstChild("HumanoidRootPart")
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local stars = getWantedStars(plr)
                        if stars and stars > 0 and not policeInForbidden(root.Position) then
                            local d = (myRoot and (root.Position - myRoot.Position).Magnitude) or 1e9
                            if d < bestD and d <= POLICE_MAX_RANGE then
                                bestD = d
                                best = { src = plr, root = root, hum = hum, stars = stars }
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

policeSlotMap = nil

policeNameHas = function(name, kws)
    local n = string.lower(tostring(name or ""))
    for _, w in ipairs(kws) do
        if string.find(n, w, 1, true) then return true end
    end
    return false
end

policeGetEquipped = function()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Tool")
end

POLICE_TASER_RANGE = 25
POLICE_TASER_HOLD = 12

policeEquipTool = function(kws)
    local cur = policeGetEquipped()
    if cur and policeNameHas(cur.Name, kws) then return cur end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local function take(tool)
        if not tool or not tool:IsA("Tool") then return nil end
        if hum then pcall(function() hum:EquipTool(tool) end) end
        return tool
    end
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and policeNameHas(t.Name, kws) then return take(t) end
        end
    end
    local bp = player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and policeNameHas(t.Name, kws) then return take(t) end
        end
    end
    return policeGetEquipped()
end

policeGetTargetVel = function(root, ch)
    local vel = Vector3.new()
    pcall(function() vel = root.AssemblyLinearVelocity end)
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if seat then
        pcall(function()
            local v = seat.AssemblyLinearVelocity
            if v.Magnitude > vel.Magnitude then vel = v end
            local m = seat:FindFirstAncestorOfClass("Model")
            if m then
                local pp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local v2 = pp.AssemblyLinearVelocity
                    if v2.Magnitude > vel.Magnitude then vel = v2 end
                end
            end
        end)
    end
    return vel
end

policeDist3 = function(a, b)
    return (a - b).Magnitude
end

policeLiveTarget = function(tgt)
    if not tgt then return nil end
    local src = tgt.src
    local ch = nil
    if src then
        if src:IsA("Player") then ch = src.Character else ch = src end
    end
    if not ch then return nil end
    local root = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
    local head = ch:FindFirstChild("Head") or root
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return nil end
    tgt.root = root
    tgt.head = head
    tgt.hum = hum
    tgt.char = ch
    return tgt
end

policeIsDown = function(hum, ch)
    if not hum then return false end
    if hum.PlatformStand then return true end
    local ok, st = pcall(function() return hum:GetState() end)
    if ok and st then
        local n = st.Name
        if n == "Physics" or n == "Ragdoll" or n == "FallingDown" or n == "PlatformStanding" then
            return true
        end
    end
    if ch then
        local okA, attrs = pcall(function() return ch:GetAttributes() end)
        if okA and attrs then
            for k, v in pairs(attrs) do
                local kn = string.lower(tostring(k))
                -- точные сигналы из probe:
                if kn == "is ragdolled" or kn == "isragdolled" then
                    if v then return true end
                elseif kn == "tased until" or kn == "taseduntil" then
                    local num = tonumber(v)
                    if num then
                        if num > os.time() then return true end
                    elseif v then
                        return true
                    end
                elseif (string.find(kn, "stun", 1, true) or string.find(kn, "tase", 1, true)
                    or string.find(kn, "ragdoll", 1, true) or string.find(kn, "cuff", 1, true)
                    or string.find(kn, "knock", 1, true) or string.find(kn, "electro", 1, true)) and v then
                    return true
                end
            end
        end
        local n = 0
        for _, d in ipairs(ch:GetDescendants()) do
            n = n + 1
            if n > 80 then break end
            if d:IsA("BoolValue") and d.Value then
                local dn = string.lower(d.Name)
                if string.find(dn, "stun", 1, true) or string.find(dn, "tase", 1, true)
                    or string.find(dn, "ragdoll", 1, true) or string.find(dn, "cuff", 1, true)
                    or string.find(dn, "knock", 1, true) or string.find(dn, "down", 1, true) or string.find(dn, "electro", 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

policeClickAim = function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    local x, y = vs.X / 2, vs.Y / 2
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if mousemoveabs then
            pcall(function() mousemoveabs(x, y) end)
        else
            pcall(function() vim:SendMouseMoveEvent(x, y, game) end)
        end
        if mouse1press and mouse1release then
            pcall(function() mouse1press() end)
            task.wait(0.04)
            pcall(function() mouse1release() end)
        elseif mouse1click then
            pcall(function() mouse1click() end)
        else
            pcall(function() vim:SendMouseButtonEvent(x, y, 0, true, game) end)
            task.wait(0.04)
            pcall(function() vim:SendMouseButtonEvent(x, y, 0, false, game) end)
        end
    end)
end

policeScreenPoint = function(worldPos)
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local ok, sp = pcall(function() return cam:WorldToScreenPoint(worldPos) end)
    if ok and sp and sp.Z > 0 then return sp end
    return nil
end

policeMoveMouseTo = function(x, y)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if mousemoveabs then
            pcall(function() mousemoveabs(x, y) end)
        else
            pcall(function() vim:SendMouseMoveEvent(x, y, game) end)
        end
    end)
end

-- упреждение по скорости цели (целится в голову; near — без упреждения, чтобы не мазать)
policeAimLead = function(tgt, dist)
    if not tgt or not tgt.root then return nil end
    local head = tgt.head or tgt.root
    local pos = head.Position
    local vel = policeGetTargetVel(tgt.root, tgt.char)
    local flight = math.max(0.04, math.min(0.3, (dist or 15) / 220))
    if vel.Magnitude > 12 then
        pos = pos + Vector3.new(vel.X, 0, vel.Z) * flight
    end
    return pos
end

-- повернуть персонажа лицом к точке + направить камеру точно в неё
policeAimAt = function(point)
    if not point then return false end
    pcall(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if hrp then
            local p = Vector3.new(point.X, hrp.Position.Y, point.Z)
            hrp.CFrame = CFrame.lookAt(hrp.Position, p)
        end
        if cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, point)
        end
    end)
    return true
end

policeFireTool = function(weapon, tgt, dist)
    if not weapon then return end
    local aimPos = policeAimLead(tgt, dist)
    if not aimPos then return end
    local cam = workspace.CurrentCamera
    local oldCamType = cam and cam.CameraType
    if cam then
        pcall(function() cam.CameraType = Enum.CameraType.Scriptable end)
    end
    local function lockCam()
        pcall(function()
            if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, aimPos) end
        end)
        policeAimAt(aimPos)
    end
    policeAimAt(aimPos)
    lockCam()
    -- маленькая пауза, чтобы игра увидела камеру и прицел встал в центр на цель
    task.wait(0.03)
    lockCam()
    local vs = cam and cam.ViewportSize
    local cx, cy = (vs and vs.X / 2) or 768, (vs and vs.Y / 2) or 400
    pcall(function() weapon:Activate() end)
    pcall(function()
        for _, o in ipairs(weapon:GetDescendants()) do
            local n = string.lower(o.Name)
            if o:IsA("RemoteEvent") and (string.find(n, "shoot", 1, true) or string.find(n, "fire", 1, true)
                or string.find(n, "tase", 1, true) or string.find(n, "activ", 1, true) or n == "use") then
                pcall(function() o:FireServer() end)
            end
        end
    end)
    -- клик строго в ЦЕНТР экрана = в прицел, который смотрит на цель
    pcall(function()
        if mouse1press and mouse1release then
            pcall(function() mouse1press() end)
            task.wait(0.04)
            pcall(function() mouse1release() end)
        elseif mouse1click then
            pcall(function() mouse1click() end)
        else
            local vim = game:GetService("VirtualInputManager")
            pcall(function() vim:SendMouseButtonEvent(cx, cy, 0, true, game) end)
            task.wait(0.04)
            pcall(function() vim:SendMouseButtonEvent(cx, cy, 0, false, game) end)
        end
    end)
    if cam and oldCamType then
        pcall(function() cam.CameraType = oldCamType end)
    end
end

policeHoldE = function(dur)
    dur = dur or 0.35
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if keypress then
            pcall(function() keypress(Enum.KeyCode.E) end)
            task.wait(dur)
            pcall(function() keyrelease(Enum.KeyCode.E) end)
        else
            pcall(function() vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil) end)
            task.wait(dur)
            pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil) end)
        end
    end)
end

-- перезарядка тазера: жмём R, вынимаем/надеваем заново (сбрасывает "пустой" стейт)
policeReloadTaser = function()
    if set.farmStop or not polRunning then return end
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if keypress then
            pcall(function() keypress(Enum.KeyCode.R) end)
            task.wait(0.5)
            pcall(function() keyrelease(Enum.KeyCode.R) end)
        else
            pcall(function() vim:SendKeyEvent(true, Enum.KeyCode.R, false, nil) end)
            task.wait(0.5)
            pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.R, false, nil) end)
        end
    end)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local tool = policeGetEquipped()
    if tool and policeNameHas(tool.Name, POLICE_TASER_KW) then
        pcall(function() tool.Parent = player:FindFirstChildOfClass("Backpack") end)
    end
    task.wait(0.2)
    policeEquipTool(POLICE_TASER_KW)
    task.wait(0.2)
    -- финальный R на всякий случай (если перезарядка по R)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if keypress then
            pcall(function() keypress(Enum.KeyCode.R) end)
            task.wait(0.3)
            pcall(function() keyrelease(Enum.KeyCode.R) end)
        else
            pcall(function() vim:SendKeyEvent(true, Enum.KeyCode.R, false, nil) end)
            task.wait(0.3)
            pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.R, false, nil) end)
        end
    end)
end

policeFirePromptsOn = function(model, pos, radius, kws)
    radius = radius or 12
    local fired = false
    local function consider(p, where)
        if not p then return end
        local okDist = true
        if pos and where then okDist = (where - pos).Magnitude <= radius end
        if not okDist then return end
        if kws and not promptMatches(p, kws) then return end
        if fireproximityprompt then
            pcall(function() fireproximityprompt(p) end)
        else
            policeHoldE(0.3)
        end
        fired = true
    end
    local function scan(root)
        if not root then return end
        for _, p in ipairs(root:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                local where = pos
                local part = p.Parent
                if part and part:IsA("BasePart") then where = part.Position end
                consider(p, where)
            elseif p:IsA("ClickDetector") and fireclickdetector then
                pcall(function() fireclickdetector(p) end)
                fired = true
            end
        end
    end
    scan(model)
    return fired
end

policeLastStepT = nil
policeStepChase = function(tgt, speed, holdDist)
    if set.farmStop or not polRunning then return "stop", math.huge end
    holdDist = holdDist or POLICE_TASER_HOLD
    tgt = policeLiveTarget(tgt)
    if not tgt then return "nochar", math.huge end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return "nochar", math.huge end
    local root = tgt.root
    local humT = tgt.hum
    if policeInForbidden(root.Position) then return "forbidden", math.huge end
    local look = (tgt.head or root).Position
    local from = hrp.Position
    local inVehicle = humT and humT.SeatPart ~= nil
    local now = os.clock()
    local dt = 0.03
    if policeLastStepT then
        dt = now - policeLastStepT
        if dt < 0.016 then dt = 0.016 end
        if dt > 0.05 then dt = 0.05 end
    end
    policeLastStepT = now
    local spd = speed or 220
    if spd < 190 then spd = 190 end
    if spd > 300 then spd = 300 end
    local maxStep = spd * dt
    if maxStep > 9 then maxStep = 9 end
    local vel = policeGetTargetVel(root, tgt.char)
    local goal = Vector3.new(root.Position.X, from.Y, root.Position.Z)
    if vel.Magnitude > 8 then
        goal = goal + Vector3.new(vel.X, 0, vel.Z) * 0.08
    end
    local delta = Vector3.new(goal.X - from.X, 0, goal.Z - from.Z)
    local distXZ = delta.Magnitude
    local nextPos = from
    if distXZ > holdDist and distXZ > 0.05 then
        local travel = distXZ - holdDist
        if travel > maxStep then travel = maxStep end
        nextPos = from + delta.Unit * travel
    end
    if inVehicle then
        -- цель в машине: не лезть на крышу, держаться на высоте её корпуса
        nextPos = Vector3.new(nextPos.X, root.Position.Y + 1, nextPos.Z)
    else
        local gy = getGroundY(nextPos.X, nextPos.Z, from.Y + 4)
        if gy then
            nextPos = Vector3.new(nextPos.X, gy + 3, nextPos.Z)
        else
            nextPos = Vector3.new(nextPos.X, math.max(from.Y, root.Position.Y, 17), nextPos.Z)
        end
    end
    local distNow = policeDist3(nextPos, root.Position)
    policeTarget = root.Position
    pcall(function()
        local cam = workspace.CurrentCamera
        local face = Vector3.new(look.X, nextPos.Y, look.Z)
        if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, look) end
        hrp.CFrame = CFrame.lookAt(nextPos, face)
        hrp.AssemblyLinearVelocity = Vector3.new()
        hrp.AssemblyAngularVelocity = Vector3.new()
        hrp.Velocity = Vector3.new()
    end)
    if distNow <= POLICE_TASER_RANGE then return "ok", distNow end
    return "chase", distNow
end

policeShoot = function(tgt, speed)
    local t0 = os.clock()
    local shots = 0
    local lastShot = 0
    while os.clock() - t0 < 20 do
        if set.farmStop or not polRunning then return false end
        tgt = policeLiveTarget(tgt)
        if not tgt then return false end
        if policeIsDown(tgt.hum, tgt.char) and shots >= 1 then return true end
        local st, dist = policeStepChase(tgt, speed or 400, 4)
        if st == "nochar" then return false end
        if st == "forbidden" then return false end
        dist = dist or math.huge
        local now = os.clock()
        if dist <= 12 and now - lastShot > 0.4 then
            lastShot = now
            local weapon = policeEquipTool(POLICE_TASER_KW)
            if weapon then policeFireTool(weapon, tgt, dist) end
            shots = shots + 1
            pcall(function()
                polStatusLbl.Text = loc("Статус: тайзер ") .. string.format("%.0f", dist) .. "m"
            end)
        elseif dist > 15 then
            pcall(function()
                polStatusLbl.Text = loc("Статус: догоняем ") .. string.format("%.0f", dist) .. "m"
            end)
        end
        tgt = policeLiveTarget(tgt)
        if tgt and policeIsDown(tgt.hum, tgt.char) and shots >= 1 then
            task.wait(0.15)
            return true
        end
        if shots >= 12 then return false end
        task.wait(0.03)
    end
    tgt = policeLiveTarget(tgt)
    return tgt ~= nil and policeIsDown(tgt.hum, tgt.char)
end

policeCuff = function(tgt, speed)
    if set.farmStop or not polRunning then return false end
    local weapon = policeEquipTool(POLICE_CUFF_KW)
    local t0 = os.clock()
    local ok = false
    while os.clock() - t0 < 8 do
        if set.farmStop or not polRunning then return false end
        tgt = policeLiveTarget(tgt)
        if not tgt then return false end
        policeStepChase(tgt, speed or 260, 3.2)
        weapon = policeEquipTool(POLICE_CUFF_KW)
        if weapon then policeFireTool(weapon, tgt, 3.2) end
        policeFirePromptsOn(tgt.char, tgt.root.Position, 14, POLICE_CUFF_KW)
        policeFirePromptsOn(tgt.char, tgt.root.Position, 10, nil)
        policeHoldE(0.35)
        if policeIsDown(tgt.hum, tgt.char) then ok = true end
        local attrsOk, attrs = pcall(function() return tgt.char:GetAttributes() end)
        if attrsOk and attrs then
            for k, v in pairs(attrs) do
                local kn = string.lower(tostring(k))
                if (string.find(kn, "cuff", 1, true) or string.find(kn, "arrest", 1, true)
                    or string.find(kn, "detain", 1, true)) and v then
                    return true
                end
            end
        end
        task.wait(0.08)
    end
    return ok
end

policeInteract = function(pos, kws, radius)
    local p = findItemPrompt(pos, kws, radius)
    if p then
        if fireproximityprompt then
            pcall(function() fireproximityprompt(p) end)
        else
            pressKey(Enum.KeyCode.E)
        end
        task.wait(0.4)
        return
    end
    pcall(function() clickButtonNear(pos, radius or 12, 1, false, kws, kws) end)
    task.wait(0.5)
end

policeFlyTo = function(tgt, speed)
    speed = math.min(math.max(speed or 240, 190), 300)
    local t0 = os.clock()
    while os.clock() - t0 < 30 do
        if set.farmStop or not polRunning then return "stop" end
        local st, dist = policeStepChase(tgt, speed, POLICE_TASER_HOLD)
        if st == "stop" then return "stop" end
        if st == "nochar" then return "nochar" end
        if st == "forbidden" then return "forbidden" end
        dist = dist or math.huge
        pcall(function()
            polStatusLbl.Text = loc("Статус: догоняем ") .. string.format("%.0f", dist) .. "m"
        end)
        if dist <= POLICE_TASER_HOLD + 2 then return "ok" end
        task.wait(0.03)
    end
    local _, dist = policeStepChase(tgt, speed, POLICE_TASER_HOLD)
    if dist and dist <= POLICE_TASER_RANGE then return "ok" end
    return "chase"
end

policeTask = function(tgt, speed)
    if set.farmStop or not polRunning then return "stop" end
    speed = math.min(math.max(speed or 240, 190), 300)
    tgt = policeLiveTarget(tgt)
    if not tgt then return "nochar" end
    local tname = tgt.src and tgt.src.Name
    pcall(function() polStatusLbl.Text = loc("Статус: летим — ") .. tostring(tname) end)
    local res = policeFlyTo(tgt, speed)
    if res == "stop" then return "stop" end
    if res == "nochar" then return "nochar" end
    if res == "forbidden" then
        pcall(function() polStatusLbl.Text = loc("Статус: запретная зона — скипаем ") .. tostring(tname) end)
        task.wait(1)
        return "skip"
    end
    if res == "chase" then
        pcall(function() polStatusLbl.Text = loc("Статус: не догнал — скипаем ") .. tostring(tname) end)
        task.wait(1)
        return "skip"
    end
    pcall(function() polStatusLbl.Text = loc("Статус: тайзер") end)
    local tased = policeShoot(tgt, speed)
    if set.farmStop or not polRunning then return "stop" end
    if not tased then
        pcall(function() polStatusLbl.Text = loc("Статус: тайзер повтор") end)
        tased = policeShoot(tgt, speed)
    end
    if set.farmStop or not polRunning then return "stop" end
    if not tased then
        pcall(function() polStatusLbl.Text = loc("Статус: тайзер не попал — скипаем ") .. tostring(tname) end)
        task.wait(1)
        return "skip"
    end
    pcall(function() polStatusLbl.Text = loc("Статус: наручники") end)
    local cuffed = policeCuff(tgt, speed)
    if set.farmStop or not polRunning then return "stop" end
    pcall(function() polStatusLbl.Text = loc("Статус: арест") end)
    local t1 = os.clock()
    while os.clock() - t1 < 4 do
        if set.farmStop or not polRunning then return "stop" end
        tgt = policeLiveTarget(tgt)
        if not tgt then break end
        policeStepChase(tgt, speed, 3.5)
        policeFirePromptsOn(tgt.char, tgt.root.Position, 16, POLICE_ARREST_KW)
        policeFirePromptsOn(tgt.char, tgt.root.Position, 12, nil)
        policeHoldE(0.4)
        task.wait(0.1)
    end
    pcall(function() polStatusLbl.Text = loc("Статус: перезарядка") end)
    policeReloadTaser()
    if tased or cuffed then return "done" end
    return "fail"
end

policeDoneAt = {}

policeLoop = function(speed)
    task.spawn(function()
        local ok, err = pcall(function()
            while polRunning and not set.farmStop do
                local plrP = policeFindTarget()
                if not plrP then
                    pcall(function() polStatusLbl.Text = loc("Статус: преступники не найдены") end)
                    task.wait(2)
                else
                    local res = policeTask(plrP, speed)
                    if res == "stop" then break end
                    if (res == "done" or res == "skip" or res == "fail") and plrP.src then
                        policeDoneAt[plrP.src] = os.clock()
                    end
                    task.wait(1)
                end
            end
        end)
        if not ok and err then warn("[AnvilAim] policeFarm error: " .. tostring(err)) end
        polRunning = false
        policeTarget = nil
        setCharNoClip(false)
        stopAntiAfk()
        pcall(function() polStatusLbl.Text = loc("Статус: Ожидание") end)
    end)
end

startPoliceFarm = function(speed)
    if polRunning then return end
    if farmRunning or monaRunning then
        set.farmStop = true
        local t0 = os.clock()
        while (farmRunning or monaRunning) and os.clock() - t0 < 3 do task.wait(0.1) end
    end
    set.farmStop = false
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if myRoot then
        POLICE_AREA_CENTER = myRoot.Position
    end
    setCharNoClip(true)
    polRunning = true
    startAntiAfk()
    policeLoop(speed)
end

stopPoliceFarm = function()
    set.farmStop = true
    polRunning = false
end

-- ===== ВИЗУАЛ (всегда включён): луч + кружок на цель фарма, чамс-аутлайн на персонаже =====
local visBeam = Drawing.new("Line")
visBeam.Color = getAccent(); visBeam.Thickness = 2; visBeam.Transparency = 0.55; visBeam.Visible = false
local visCircle = Drawing.new("Circle")
visCircle.Color = getAccent(); visCircle.Thickness = 3; visCircle.Filled = false; visCircle.Transparency = 0.4; visCircle.Radius = 30; visCircle.Visible = false
local visBeam2 = Drawing.new("Line")
visBeam2.Color = getAccent(); visBeam2.Thickness = 1; visBeam2.Transparency = 0.3; visBeam2.Visible = false

on(rs.RenderStepped, function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera
    local acc = accentCache
    visBeam.Color = acc; visBeam2.Color = acc; visCircle.Color = acc
    if hrp and farmTarget and cam then
        local p1 = cam:WorldToViewportPoint(hrp.Position)
        local p2 = cam:WorldToViewportPoint(farmTarget)
        if p1.Z > 0 and p2.Z > 0 then
            visBeam.From = Vector2.new(p1.X, p1.Y); visBeam.To = Vector2.new(p2.X, p2.Y); visBeam.Visible = true
            visBeam2.From = Vector2.new(p1.X, p1.Y); visBeam2.To = Vector2.new((p1.X + p2.X) / 2, (p1.Y + p2.Y) / 2); visBeam2.Visible = true
        else
            visBeam.Visible = false; visBeam2.Visible = false
        end
        local cp = cam:WorldToViewportPoint(Vector3.new(farmTarget.X, farmTarget.Y + 1, farmTarget.Z))
        if cp.Z > 0 then
            visCircle.Position = Vector2.new(cp.X, cp.Y); visCircle.Visible = true
        else
            visCircle.Visible = false
        end
    else
        visBeam.Visible = false; visBeam2.Visible = false; visCircle.Visible = false
    end
end)

-- ===== CHAMS =====
local chamsObjs = {}

local function chamsColorFor()
    local c = set.chamsColor or "Тема"
    if c == "Тема" then return accentCache end
    if c == "Красный" then return Color3.fromRGB(255, 60, 60) end
    if c == "Зелёный" then return Color3.fromRGB(60, 255, 90) end
    if c == "Голубой" then return Color3.fromRGB(0, 200, 255) end
    if c == "Жёлтый" then return Color3.fromRGB(255, 220, 60) end
    if c == "Белый" then return Color3.new(1, 1, 1) end
    if c == "Фиолетовый" then return Color3.fromRGB(180, 80, 255) end
    if c == "Оранжевый" then return Color3.fromRGB(255, 140, 30) end
    return Color3.fromRGB(255, 60, 60)
end

local function clearChamsFor(model)
    local e = chamsObjs[model]
    if e then
        pcall(function() e.high:Destroy() end)
        chamsObjs[model] = nil
    end
end

local function applyChamsTo(model)
    local want = set.chamsSelf and model == player.Character or set.chamsPlayers and model ~= player.Character
    if not want then clearChamsFor(model); return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then clearChamsFor(model); return end
    local e = chamsObjs[model]
    if not e then
        local h = Instance.new("Highlight")
        h.Name = "AnvilChams"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        pcall(function() h.Parent = model end)
        e = { high = h }
        chamsObjs[model] = e
    end
    local col = chamsColorFor()
    local alpha = set.chamsAlpha or 0
    if e.lastCol ~= col or e.lastAlpha ~= alpha then
        e.high.FillColor = col
        e.high.FillTransparency = alpha
        e.high.OutlineColor = col
        e.high.OutlineTransparency = 1
        e.lastCol = col
        e.lastAlpha = alpha
    end
end

applyChamsAll = function()
    for _, plr in pairs(players:GetPlayers()) do
        local c = plr.Character
        if c then applyChamsTo(c) end
    end
end

on(player.CharacterAdded, function()
    task.wait(0.5)
    pcall(applyChamsAll)
end)

do
    for _, plr in pairs(players:GetPlayers()) do
        plr.CharacterAdded:Connect(function()
            task.wait(0.1)
            pcall(applyChamsAll)
        end)
    end
end
on(players.PlayerRemoving, function(plr)
    if plr.Character then clearChamsFor(plr.Character) end
end)

-- Chams обновляем редко (не каждый кадр): только цвет (пульс) и появление новых персонажей.
-- ApplyChamsAll вызываем по троттлингу, чтобы не грузить рендер-поток.
local chamsTick = 0
local lastChamsCol = nil
on(rs.Heartbeat, function(dt)
    if not (set.chamsSelf or set.chamsPlayers) then
        for model in pairs(chamsObjs) do clearChamsFor(model) end
        chamsTick = 0
        return
    end
    chamsTick = chamsTick + dt
    if chamsTick < 0.25 then return end
    chamsTick = 0
    pcall(applyChamsAll)
end)

-- ===== NIGHT MODE =====
local nightApplied = {}
applyNight = function()
    local l = game:GetService("Lighting")
    pcall(function()
        local bri = set.nightBright or 0.6
        if nightApplied.brightness ~= bri then
            l.Brightness = bri
            nightApplied.brightness = bri
        end
        if not nightApplied.shadows then
            l.GlobalShadows = false
            nightApplied.shadows = true
        end
        if not nightApplied.fogEnd then
            l.FogEnd = 220
            nightApplied.fogEnd = true
        end
        if not nightApplied.ambient then
            l.Ambient = Color3.fromRGB(70, 75, 120)
            nightApplied.ambient = true
        end
        if not nightApplied.outdoor then
            l.OutdoorAmbient = Color3.fromRGB(85, 90, 140)
            nightApplied.outdoor = true
        end
        if not nightApplied.clock then
            l.ClockTime = 0.15
            nightApplied.clock = true
        end
        if not nightApplied.fogColor then
            l.FogColor = Color3.fromRGB(25, 28, 45)
            nightApplied.fogColor = true
        end
        if not nightApplied.diffuse then
            l.EnvironmentDiffuseScale = 0.7
            nightApplied.diffuse = true
        end
        if not nightApplied.specular then
            l.EnvironmentSpecularScale = 0.3
            nightApplied.specular = true
        end
        if not nightApplied.exposure then
            pcall(function() l.ExposureCompensation = 1.2 end)
            nightApplied.exposure = true
        end
    end)
end

toggleNightMode = function(v)
    set.night = v
    if v then
        nightApplied = {}
        pcall(applyNight)
    else
        nightApplied = {}
        local l = game:GetService("Lighting")
        pcall(function()
            l.GlobalShadows = true
            l.FogEnd = 100000
            l.Brightness = 1
            l.Ambient = Color3.new(1, 1, 1)
            l.OutdoorAmbient = Color3.fromRGB(148, 148, 148)
            l.EnvironmentDiffuseScale = 1
            l.EnvironmentSpecularScale = 1
            pcall(function() l.ExposureCompensation = 0 end)
        end)
    end
end

-- ===== MONEY TRACKER HUD =====
set.moneyTracker = false
moneyRef = nil
moneyBase = nil
mtGui = nil
mtPollCon = nil
mtMoney = nil
mtProfit = nil
mtTick = 0

function findMoneyValue()
    local found = nil
    pcall(function()
        local seen = {}
        local function scan(p, depth)
            if found or depth > 3 then return end
            if seen[p] then return end
            seen[p] = true
            for _, c in ipairs(p:GetChildren()) do
                if not found and (c:IsA("IntValue") or c:IsA("NumberValue") or c:IsA("IntConstrainedValue")) then
                    local n = string.lower(c.Name)
                    if n:find("money") or n:find("cash") or n:find("balance") or n:find("coin") or n:find("долл") or n:find("деньг") or n:find("баланс") then
                        found = c
                        return
                    end
                end
            end
            for _, c in ipairs(p:GetChildren()) do
                if not found and (c:IsA("Folder") or c:IsA("Model") or c.ClassName == "Configuration") then
                    scan(c, depth + 1)
                end
            end
        end
        local ls = player:FindFirstChild("leaderstats")
        if ls then scan(ls, 0) end
        if not found then scan(player, 0) end
    end)
    return found
end

function getMoneyNow()
    if not moneyRef or not moneyRef.Parent then
        moneyRef = findMoneyValue()
    end
    if not moneyRef then return nil end
    local ok, v = pcall(function() return tonumber(moneyRef.Value) end)
    return ok and v or nil
end

function buildMoneyHud()
    mtGui = Instance.new("ScreenGui"); mtGui.Name = "AnvilMoneyTracker"; mtGui.ResetOnSpawn = false; mtGui.IgnoreGuiInset = true; mtGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mtGui.DisplayOrder = 90
    local okP = pcall(function() mtGui.Parent = game:GetService("CoreGui") end)
    if not okP then pcall(function() mtGui.Parent = player:WaitForChild("PlayerGui") end) end
    local f = Instance.new("Frame"); f.Size = UDim2.new(0, 175, 0, 50); f.Position = UDim2.new(0.5, 122, 0, 48); f.BackgroundColor3 = BG; f.BackgroundTransparency = 0.15; f.BorderSizePixel = 0; f.Active = true; f.Parent = mtGui
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", f); st.Color = getAccent(); st.Thickness = 1; st.Transparency = 0.35
    local mk = Instance.new("TextLabel"); mk.Size = UDim2.new(1, -34, 0, 16); mk.Position = UDim2.new(0, 6, 0, 3); mk.BackgroundTransparency = 1; mk.Text = "Money Tracker"; mk.TextColor3 = getAccent(); mk.Font = Enum.Font.GothamBold; mk.TextSize = 11; mk.TextXAlignment = Enum.TextXAlignment.Left; mk.Parent = f
    mtMoney = Instance.new("TextLabel"); mtMoney.Size = UDim2.new(0.5, -6, 0, 16); mtMoney.Position = UDim2.new(0, 6, 0, 20); mtMoney.BackgroundTransparency = 1; mtMoney.Text = "$—"; mtMoney.TextColor3 = Color3.fromRGB(120, 255, 160); mtMoney.Font = Enum.Font.GothamBold; mtMoney.TextSize = 13; mtMoney.TextXAlignment = Enum.TextXAlignment.Left; mtMoney.Parent = f
    mtProfit = Instance.new("TextLabel"); mtProfit.Size = UDim2.new(0.5, -6, 0, 16); mtProfit.Position = UDim2.new(0.5, 2, 0, 20); mtProfit.BackgroundTransparency = 1; mtProfit.Text = "+$0"; mtProfit.TextColor3 = Color3.fromRGB(60, 255, 90); mtProfit.Font = Enum.Font.GothamBold; mtProfit.TextSize = 13; mtProfit.TextXAlignment = Enum.TextXAlignment.Left; mtProfit.Parent = f
end

setMoneyTracker = function(v)
    set.moneyTracker = v
    if v then
        moneyBase = nil
        moneyRef = nil
        buildMoneyHud()
        mtPollCon = rs.Heartbeat:Connect(function(dt)
            mtTick = mtTick + dt
            if mtTick < 1 then return end
            mtTick = 0
            pcall(function()
                local now = getMoneyNow()
                if not now then
                    mtMoney.Text = "—"
                    return
                end
                if moneyBase == nil then moneyBase = now end
                mtMoney.Text = "$" .. math.floor(now)
                local profit = now - moneyBase
                mtProfit.Text = (profit >= 0 and "+" or "-") .. "$" .. math.floor(math.abs(profit))
                mtProfit.TextColor3 = profit >= 0 and Color3.fromRGB(60, 255, 90) or Color3.fromRGB(255, 90, 90)
            end)
        end)
    else
        if mtPollCon then pcall(function() mtPollCon:Disconnect() end); mtPollCon = nil end
        if mtGui then pcall(function() mtGui:Destroy() end); mtGui = nil end
        moneyBase = nil
        moneyRef = nil
    end
end

resetMoneyBase = function()
    moneyBase = getMoneyNow()
end

-- ===== UNLOAD =====
unloadAll = function()
    unloaded = true
    set.enabled = false
    for _, c in pairs(potatoCons) do pcall(function() c:Disconnect() end) end
    potatoCons = {}
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
    connections = {}
    set.farmStop = true
    stopAntiAfk()
    if polRunning then pcall(stopPoliceFarm) end
    pcall(farmStopCleanup)
    pcall(setMoneyTracker, false)
    pcall(function() sg:Destroy() end)
    if set.night then pcall(toggleNightMode, false) end
    for model in pairs(chamsObjs) do clearChamsFor(model) end
    pcall(function() visBeam:Remove() end)
    pcall(function() visCircle:Remove() end)
    pcall(function() visBeam2:Remove() end)
    pcall(function()
        local k = game:GetService("CoreGui"):FindFirstChild("AnvilAimKeybinds")
        if k then k:Destroy() end
    end)
    pcall(function() fovCircle:Remove() end)
    pcall(closeBindWindow)
    pcall(function() local w = game:GetService("CoreGui"):FindFirstChild("AnvilAimWatermark"); if w then w:Destroy() end end)
    pcall(function()
        local m = game:GetService("CoreGui"):FindFirstChild("AnvilAimMobile")
        if m then m:Destroy() end
    end)
end
