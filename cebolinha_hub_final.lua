-- ╔══════════════════════════════════════════════════════════════╗
-- ║           CEBOLINHA HUB — Desenvolvido por POCOYO.JS         ║
-- ║              Sistema de Key: PandaDevelopment                ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ── CONFIGURAÇÕES ────────────────────────────────────────────────────
local PROXY_URL    = "https://cebolinha-hub-blox.vercel.app/api/validatekey"
local GETKEY_URL   = "https://new.pandadevelopment.net/getkey/chsystem"
local DISCORD_URL  = "https://discord.gg/z5DhUvEx6Z"
local SAVE_PATH    = "CebolinhaHub/key.txt"
-- URL onde o cebolinha_hub.lua está hospedado (GitHub raw do seu repo)
local SCRIPT_URL   = "https://raw.githubusercontent.com/Dev-pocoyoJS/CEBOLINHA-HUB-BLOX/main/cebolinha_hub.lua"
-- Token interno (deve bater com _cebKey dentro do cebolinha_hub.lua)
local CEb_KEY      = "4a97ed579acec503682c7e74e4c9365e"

-- ── SERVIÇOS ─────────────────────────────────────────────────────────
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer

-- ── HWID ─────────────────────────────────────────────────────────────
local function getHWID()
    if rconsoleinfo then return tostring(rconsoleinfo()):sub(1, 32) end
    local exec = "unknown"
    if identifyexecutor then exec = identifyexecutor() end
    return HttpService:UrlEncode(tostring(LocalPlayer.UserId) .. exec):sub(1, 32)
end

local HWID      = getHWID()
local AccountID = tostring(LocalPlayer.UserId)

-- ── KEY SALVA ────────────────────────────────────────────────────────
local function loadSavedKey()
    if not readfile or not isfile then return "" end
    if not isfolder("CebolinhaHub") then makefolder("CebolinhaHub") end
    if isfile(SAVE_PATH) then
        return readfile(SAVE_PATH):gsub("%s+", "")
    end
    return ""
end

local function saveKey(k)
    if not writefile then return end
    if not isfolder("CebolinhaHub") then makefolder("CebolinhaHub") end
    writefile(SAVE_PATH, k)
end

local function clearKey()
    if not writefile then return end
    if not isfolder("CebolinhaHub") then makefolder("CebolinhaHub") end
    writefile(SAVE_PATH, "")
end

-- ── VALIDAR KEY ──────────────────────────────────────────────────────
local function validateKey(key)
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url     = PROXY_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({
                key     = key,
                action  = "validate",
                hwid    = HWID,
                account = AccountID
            })
        })
    end)

    if not ok or not res then return false, "Erro de conexão" end

    local data
    pcall(function() data = HttpService:JSONDecode(res.Body) end)
    if not data then return false, "Resposta inválida" end

    if data.valid == true then
        return true, data.expire or "Lifetime", data.premium and "✦ Premium" or "Free"
    end
    return false, data.note or "Key inválida"
end

-- ── CORES ────────────────────────────────────────────────────────────
local C = {
    BG       = Color3.fromRGB(8,  13,  9),
    CARD     = Color3.fromRGB(12, 20, 14),
    INPUT    = Color3.fromRGB(15, 26, 17),
    GREEN    = Color3.fromRGB(0,  220, 80),
    GREEN2   = Color3.fromRGB(0,  170, 60),
    GREENDIM = Color3.fromRGB(0,  80,  35),
    RED      = Color3.fromRGB(255, 70, 70),
    TEXT     = Color3.fromRGB(180, 240, 200),
    MUTED    = Color3.fromRGB(60,  110, 75),
}

-- ── UI DE KEY ────────────────────────────────────────────────────────
local function buildKeyUI()
    pcall(function()
        local old = LocalPlayer.PlayerGui:FindFirstChild("CebolinhaKeyUI")
        if old then old:Destroy() end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name           = "CebolinhaKeyUI"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    sg.Parent         = LocalPlayer.PlayerGui

    local backdrop = Instance.new("Frame")
    backdrop.Size                   = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 0.4
    backdrop.BorderSizePixel        = 0
    backdrop.Parent                 = sg

    local card = Instance.new("Frame")
    card.Size             = UDim2.new(0, 400, 0, 370)
    card.Position         = UDim2.new(0.5, -200, 0.5, -185)
    card.BackgroundColor3 = C.CARD
    card.BorderSizePixel  = 0
    card.Parent           = backdrop
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color        = C.GREEN
    stroke.Transparency = 0.75

    -- Linha topo
    local topline = Instance.new("Frame")
    topline.Size             = UDim2.new(1, 0, 0, 2)
    topline.BackgroundColor3 = C.GREEN
    topline.BorderSizePixel  = 0
    topline.Parent           = card
    Instance.new("UICorner", topline).CornerRadius = UDim.new(0, 2)

    -- Ícone
    local icon = Instance.new("TextLabel")
    icon.Size                   = UDim2.new(0, 58, 0, 58)
    icon.Position               = UDim2.new(0.5, -29, 0, 16)
    icon.BackgroundColor3       = Color3.fromRGB(10, 25, 13)
    icon.Text                   = "🥬"
    icon.TextSize               = 26
    icon.Font                   = Enum.Font.Gotham
    icon.BorderSizePixel        = 0
    icon.Parent                 = card
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 14)
    local iconS = Instance.new("UIStroke", icon)
    iconS.Color = C.GREEN; iconS.Transparency = 0.55

    -- Título
    local title = Instance.new("TextLabel")
    title.Size                   = UDim2.new(1, 0, 0, 26)
    title.Position               = UDim2.new(0, 0, 0, 82)
    title.BackgroundTransparency = 1
    title.Text                   = "CEBOLINHA HUB"
    title.TextColor3             = C.GREEN
    title.TextSize               = 20
    title.Font                   = Enum.Font.GothamBold
    title.Parent                 = card

    local sub = Instance.new("TextLabel")
    sub.Size                   = UDim2.new(1, 0, 0, 16)
    sub.Position               = UDim2.new(0, 0, 0, 108)
    sub.BackgroundTransparency = 1
    sub.Text                   = "Insira sua key para continuar"
    sub.TextColor3             = C.MUTED
    sub.TextSize               = 12
    sub.Font                   = Enum.Font.Gotham
    sub.Parent                 = card

    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(0.85, 0, 0, 1)
    sep.Position         = UDim2.new(0.075, 0, 0, 134)
    sep.BackgroundColor3 = C.GREENDIM
    sep.BorderSizePixel  = 0
    sep.Parent           = card

    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(0.85, 0, 0, 14)
    lbl.Position               = UDim2.new(0.075, 0, 0, 144)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = "SUA KEY"
    lbl.TextColor3             = C.GREEN
    lbl.TextSize               = 10
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Parent                 = card

    local inputFrame = Instance.new("Frame")
    inputFrame.Size             = UDim2.new(0.85, 0, 0, 46)
    inputFrame.Position         = UDim2.new(0.075, 0, 0, 161)
    inputFrame.BackgroundColor3 = C.INPUT
    inputFrame.BorderSizePixel  = 0
    inputFrame.Parent           = card
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 10)
    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = C.GREEN; inputStroke.Transparency = 0.6

    local input = Instance.new("TextBox")
    input.Size               = UDim2.new(1, -16, 1, 0)
    input.Position           = UDim2.new(0, 8, 0, 0)
    input.BackgroundTransparency = 1
    input.Text               = ""
    input.PlaceholderText    = "PANDA-XXXX-XXXX-XXXX-XXXX"
    input.TextColor3         = C.TEXT
    input.PlaceholderColor3  = C.MUTED
    input.TextSize           = 13
    input.Font               = Enum.Font.Code
    input.ClearTextOnFocus   = false
    input.Parent             = inputFrame

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size                   = UDim2.new(0.85, 0, 0, 30)
    statusLbl.Position               = UDim2.new(0.075, 0, 0, 212)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text                   = ""
    statusLbl.TextColor3             = C.RED
    statusLbl.TextSize               = 12
    statusLbl.Font                   = Enum.Font.Gotham
    statusLbl.TextWrapped            = true
    statusLbl.Parent                 = card

    local btnValidate = Instance.new("TextButton")
    btnValidate.Size             = UDim2.new(0.85, 0, 0, 44)
    btnValidate.Position         = UDim2.new(0.075, 0, 0, 246)
    btnValidate.BackgroundColor3 = C.GREEN
    btnValidate.Text             = "✓   VALIDAR KEY"
    btnValidate.TextColor3       = Color3.fromRGB(5, 15, 8)
    btnValidate.TextSize         = 14
    btnValidate.Font             = Enum.Font.GothamBold
    btnValidate.BorderSizePixel  = 0
    btnValidate.AutoButtonColor  = false
    btnValidate.Parent           = card
    Instance.new("UICorner", btnValidate).CornerRadius = UDim.new(0, 10)

    local btnGetKey = Instance.new("TextButton")
    btnGetKey.Size             = UDim2.new(0.41, 0, 0, 36)
    btnGetKey.Position         = UDim2.new(0.075, 0, 0, 302)
    btnGetKey.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
    btnGetKey.Text             = "🔑  Obter Key"
    btnGetKey.TextColor3       = C.GREEN
    btnGetKey.TextSize         = 12
    btnGetKey.Font             = Enum.Font.GothamSemibold
    btnGetKey.BorderSizePixel  = 0
    btnGetKey.AutoButtonColor  = false
    btnGetKey.Parent           = card
    Instance.new("UICorner", btnGetKey).CornerRadius = UDim.new(0, 9)
    local gkS = Instance.new("UIStroke", btnGetKey)
    gkS.Color = C.GREEN; gkS.Transparency = 0.4

    local btnDiscord = Instance.new("TextButton")
    btnDiscord.Size             = UDim2.new(0.41, 0, 0, 36)
    btnDiscord.Position         = UDim2.new(0.485, 0, 0, 302)
    btnDiscord.BackgroundColor3 = Color3.fromRGB(10, 12, 30)
    btnDiscord.Text             = "💬  Discord"
    btnDiscord.TextColor3       = Color3.fromRGB(120, 150, 255)
    btnDiscord.TextSize         = 12
    btnDiscord.Font             = Enum.Font.GothamSemibold
    btnDiscord.BorderSizePixel  = 0
    btnDiscord.AutoButtonColor  = false
    btnDiscord.Parent           = card
    Instance.new("UICorner", btnDiscord).CornerRadius = UDim.new(0, 9)
    local dcS = Instance.new("UIStroke", btnDiscord)
    dcS.Color = Color3.fromRGB(80, 100, 220); dcS.Transparency = 0.4

    local footer = Instance.new("TextLabel")
    footer.Size                   = UDim2.new(1, 0, 0, 14)
    footer.Position               = UDim2.new(0, 0, 0, 350)
    footer.BackgroundTransparency = 1
    footer.Text                   = "DEV: POCOYO.JS  •  Blox Fruits"
    footer.TextColor3             = C.GREENDIM
    footer.TextSize               = 10
    footer.Font                   = Enum.Font.Gotham
    footer.Parent                 = card

    -- Carrega key salva no campo
    local saved = loadSavedKey()
    if saved ~= "" then input.Text = saved end

    -- Hover
    btnValidate.MouseEnter:Connect(function()
        TweenService:Create(btnValidate, TweenInfo.new(0.12), {BackgroundColor3 = C.GREEN2}):Play()
    end)
    btnValidate.MouseLeave:Connect(function()
        TweenService:Create(btnValidate, TweenInfo.new(0.12), {BackgroundColor3 = C.GREEN}):Play()
    end)

    local resolved   = false
    local resolveKey = nil

    btnGetKey.MouseButton1Click:Connect(function()
        local url = GETKEY_URL .. "?hwid=" .. HttpService:UrlEncode(HWID)
        pcall(function() setclipboard(url) end)
        statusLbl.TextColor3 = C.GREEN
        statusLbl.Text       = "✓ Link copiado! Cole no navegador."
    end)

    btnDiscord.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_URL) end)
        statusLbl.TextColor3 = Color3.fromRGB(120, 150, 255)
        statusLbl.Text       = "✓ Link do Discord copiado!"
    end)

    btnValidate.MouseButton1Click:Connect(function()
        if resolved then return end
        local key = input.Text:gsub("%s+", "")
        if key == "" then
            statusLbl.TextColor3 = C.RED
            statusLbl.Text       = "⚠ Cole uma key válida!"
            return
        end

        btnValidate.Text             = "⏳  Validando..."
        btnValidate.BackgroundColor3 = C.GREEN2
        btnValidate.Active           = false
        statusLbl.Text               = ""

        task.spawn(function()
            local valid, msg1, msg2 = validateKey(key)

            if valid then
                saveKey(key)
                inputStroke.Color        = C.GREEN
                inputStroke.Transparency = 0
                statusLbl.TextColor3     = C.GREEN
                local expStr = (msg1 ~= "Lifetime") and ("Expira: " .. msg1) or "♾ Vitalício"
                statusLbl.Text           = "✓ Key válida!  " .. expStr .. "  |  " .. (msg2 or "")
                btnValidate.Text         = "✓   ACESSO LIBERADO"

                task.wait(1.2)
                resolved = true
                pcall(function() sg:Destroy() end)
                if resolveKey then resolveKey(key) end
            else
                inputStroke.Color        = C.RED
                inputStroke.Transparency = 0
                statusLbl.TextColor3     = C.RED
                statusLbl.Text           = "✗ " .. (msg1 or "Key inválida")
                btnValidate.Text         = "✓   VALIDAR KEY"
                btnValidate.BackgroundColor3 = C.GREEN
                btnValidate.Active       = true
            end
        end)
    end)

    return function(cb) resolveKey = cb end
end

-- ── INICIAR O HUB ────────────────────────────────────────────────────
local function startHub()
    -- Gera token de segurança para o _cebVerify() do script principal
    local token = tostring(math.random(100000, 999999)) .. tostring(os.time())
    local expected = HttpService:UrlEncode(token .. CEb_KEY)

    _G.__cebToken = token
    _G.__cebSign  = expected
    _G.__cebTime  = os.time()

    -- Analytics PandaDev (não bloqueia)
    task.spawn(function()
        pcall(function()
            HttpService:RequestAsync({
                Url     = PROXY_URL,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode({ action = "execution" })
            })
        end)
    end)

    -- Executa o script principal (cebolinha_hub.lua completo)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)

    if not ok then
        warn("❌ Erro ao carregar o script: " .. tostring(err))
    end
end

-- ── FLUXO PRINCIPAL ──────────────────────────────────────────────────
local savedKey = loadSavedKey()

if savedKey ~= "" then
    print("🔑 Verificando key salva...")
    local valid, msg1, msg2 = validateKey(savedKey)

    if valid then
        print("✓ Key válida | " .. tostring(msg1) .. " | " .. tostring(msg2))
        startHub()
    else
        print("✗ Key inválida: " .. tostring(msg1))
        clearKey()
        local onValid = buildKeyUI()
        onValid(function()
            task.wait(0.3)
            startHub()
        end)
    end
else
    local onValid = buildKeyUI()
    onValid(function()
        task.wait(0.3)
        startHub()
    end)
end
