if getgenv().Multifarm then return end
getgenv().Multifarm = true

if LPH_OBFUSCATED == nil then
    local assert = assert
    local type   = type
    local G      = getgenv()
    local function encnum(toEncrypt, ...)
        assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
        return toEncrypt
    end
    local function encstr(toEncrypt, ...)
        assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
        return toEncrypt
    end
    local function jit(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
        return f
    end
    local function novirt(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
        return f
    end
    local function noupv(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
        return f
    end
    local function crash(...)
        assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
        game:Shutdown()
        while true do end
    end
    rawset(G, "LPH_ENCNUM",        encnum)
    rawset(G, "LPH_NUMENC",        encnum)
    rawset(G, "LPH_ENCSTR",        encstr)
    rawset(G, "LPH_STRENC",        encstr)
    rawset(G, "LPH_JIT",           jit)
    rawset(G, "LPH_JIT_MAX",       jit)
    rawset(G, "LPH_NO_VIRTUALIZE", novirt)
    rawset(G, "LPH_NO_UPVALUES",   noupv)
    rawset(G, "LPH_CRASH",         crash)
end

local LoadStart = os.clock()

local ok, val = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/k7gi/poopo/refs/heads/main/thegoat.lua"))()
end)

if not ok or val ~= "ImKindaGay" then
    return
end

repeat task.wait() until game:IsLoaded()
if not game:GetService("Players").LocalPlayer.Character then
    game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
end

local fireproximityprompt = fireproximityprompt
local Players             = cloneref(game:GetService("Players")) or game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local LogService          = cloneref(game:GetService("LogService"))
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local MemoryStoreService  = cloneref(game:GetService("MemoryStoreService")) or game:GetService("MemoryStoreService")
local Workspace           = game:GetService("Workspace")
local TeleportService     = game:GetService("TeleportService")
local RPC             = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RPC")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")

local Player         = Players.LocalPlayer
repeat task.wait() until Player.Character
local PlayerGui      = Player:WaitForChild("PlayerGui")
local Character      = Player.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

local function GetHumanoid()
    local c = Player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function EquipTool(tool)
    local h = GetHumanoid()
    if h and tool then h:EquipTool(tool) end
end
local function UnequipTools()
    local h = GetHumanoid()
    if h then h:UnequipTools() end
end
local tableFind
tableFind = table.find or function(t, v)
    for i = 1, #t do
        if t[i] == v then return i end
    end
end
local Random = Random.new()

if getgenv().AutoRejoinerEnabled then
    task.spawn(function()
        local IntroUI = PlayerGui:WaitForChild("IntroUI", 30)
        if not IntroUI then return end
        local SurfaceGui = IntroUI:FindFirstChild("SurfaceGui")
        if not SurfaceGui then return end
        local Frame = SurfaceGui:FindFirstChild("Frame")
        if not Frame then return end
        local PlayButton = Frame:FindFirstChild("Play")
        if not PlayButton then return end
        task.wait(15)
        repeat
            pcall(function()
                getconnections(PlayButton.MouseButton1Click)[1]:Fire()
            end)
            task.wait(0.25)
        until not PlayerGui:FindFirstChild("IntroUI")
    end)
end

print("doing emulator...")

local function AntiTamperBypass()
    pcall(function()
        local function disableFileCheck()
            local prompts = {
                game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"),
                game:GetService("CoreGui"):FindFirstChild("KickMessage"),
                game:GetService("CoreGui"):FindFirstChild("ErrorMessage"),
            }
            for _, prompt in pairs(prompts) do
                if prompt then prompt:Destroy() end
            end
            local CoreGui = game:GetService("CoreGui")
            CoreGui.ChildAdded:Connect(function(child)
                if child.Name == "RobloxPromptGui" or child.Name == "KickMessage" then
                    task.wait(0.1)
                    child:Destroy()
                end
            end)
        end

        local function spoofClientInfo()
            if not game:FindFirstChild("Client") then
                local fake = Instance.new("Folder")
                fake.Name = "Client"
                fake.Parent = game
            end
            local client = game:FindFirstChild("Client")
            if client then
                local version = Instance.new("StringValue")
                version.Name = "Version"
                version.Value = "0.628.0.628"
                version.Parent = client
            end
            if not game:FindFirstChild("Platform") then
                local platform = Instance.new("StringValue")
                platform.Name = "Platform"
                platform.Value = "Windows"
                platform.Parent = game
            end
        end

        local function bypassPropertyCheck()
            if not sethiddenproperty then
                sethiddenproperty = function(obj, prop, value) end
            end
            pcall(function()
                sethiddenproperty(game, "LoggingEnabled", false)
                sethiddenproperty(game, "DebugEnabled", false)
                sethiddenproperty(game, "ScriptLogging", false)
                sethiddenproperty(game, "ClientLogging", false)
            end)
            pcall(function()
                if setfflag then
                    setfflag("DebugEnabled", "false")
                    setfflag("LoggingEnabled", "false")
                    setfflag("ScriptLogging", "false")
                    setfflag("ClientLogging", "false")
                    setfflag("TelemetryEnabled", "false")
                    setfflag("AnalyticsEnabled", "false")
                end
            end)
        end

        local function cleanMemoryTraces()
            if getgc then
                local old = getgc
                getgc = function(...) return {} end
            end
            if getreg then
                local old = getreg
                getreg = function() return {} end
            end
            if getfenv then
                local old = getfenv
                getfenv = function() return _G end
            end
            for i = 1, 50 do
                _G["_ANTI_TAMPER_" .. i] = math.random()
            end
            for i = 1, 30 do
                _G["_SYS_" .. i] = math.random()
            end
        end

        local function spoofNetwork()
            local Stats = game:GetService("Stats")
            if Stats and Stats.Network then
                local ping = Stats.Network:FindFirstChild("ServerStatsItem")
                if ping then
                    ping:GetPropertyChangedSignal("Value"):Connect(function()
                        if ping.Value < 30 then 
                            ping.Value = math.random(45, 120) 
                        end
                        if ping.Value > 200 then 
                            ping.Value = math.random(45, 120) 
                        end
                    end)
                end
            end
        end

        local function spoofRemote()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvents then
                for _, remote in pairs(remoteEvents:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        local old = remote.FireServer
                        remote.FireServer = function(self, ...)
                            task.wait(math.random(30, 80) / 1000)
                            if old then return old(self, ...) end
                        end
                    end
                end
            end
        end

        local function bypassExecutorDetection()
            if getexecutorname then
                local old = getexecutorname
                getexecutorname = function() return "Unknown" end
            end
            if getidentity then
                local old = getidentity
                getidentity = function() return 1 end
            end
            if getthreadidentity then
                local old = getthreadidentity
                getthreadidentity = function() return 1 end
            end
            if syn then
                syn = {
                    protect_gui = function() end,
                    crypt = {
                        encrypt = function() return "dummy" end,
                        decrypt = function() return "dummy" end
                    },
                    request = function() end,
                }
            end
        end

        disableFileCheck()
        spoofClientInfo()
        bypassPropertyCheck()
        cleanMemoryTraces()
        spoofNetwork()
        spoofRemote()
        bypassExecutorDetection()
    end)
end
AntiTamperBypass()

local function AntiTamperMobile()
    pcall(function()
        -- Detection executor mobile
        local function detectMobileExecutors()
            local suspicious = 0
            pcall(function()
                local TweenService = game:GetService("TweenService")
                if TweenService and TweenService.Name ~= "TweenService" then
                    suspicious = suspicious + 1
                    warn("[ANTI-TAMPER] Delta-like behavior detected (TweenService renamed)")
                end
            end)
            pcall(function()
                local LogService = game:GetService("LogService")
                if LogService then
                    LogService.MessageOut:Connect(function(msg, msgType)
                        if msg:find("Depricated & Drop Support on") then
                            suspicious = suspicious + 1
                            warn("[ANTI-TAMPER] Vega X detected")
                        end
                        if msg == "Launching Old Evon GUI" then
                            suspicious = suspicious + 1
                            warn("[ANTI-TAMPER] Evon detected")
                        end
                    end)
                end
            end)
            pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                ReplicatedStorage.ChildAdded:Connect(function(child)
                    if child.Name == "OSEBackground" and child:IsA("Frame") then
                        suspicious = suspicious + 1
                        warn("[ANTI-TAMPER] Trigon Evo detected")
                    end
                end)
            end)
            return suspicious
        end

        -- Bait untuk remote spy
        local function setupBait()
            local bait = setmetatable({}, {
                __index = function()
                    warn("[ANTI-TAMPER] Bait index triggered - Remote Spy detected!")
                    return nil
                end,
                __tostring = function()
                    warn("[ANTI-TAMPER] Bait tostring triggered - Remote Spy detected!")
                    return ""
                end
            })
            local remote = Instance.new("RemoteEvent")
            pcall(function()
                remote:FireServer(bait)
            end)
        end

        -- Cek __namecall integrity
        local function checkNamecall()
            local mt = getrawmetatable(game)
            local originalNamecall = mt.__namecall
            task.spawn(function()
                while task.wait(5) do
                    if mt.__namecall ~= originalNamecall then
                        warn("[ANTI-TAMPER] __namecall changed - Hook detected!")
                    end
                end
            end)
        end

        -- Stack consistency check
        local function stackCheck()
            local ok, err = pcall(function()
                error("STACK_TEST")
            end)
            if type(err) ~= "string" then
                warn("[ANTI-TAMPER] Abnormal error object - Executor interference detected!")
            end
        end
        task.spawn(function()
            while task.wait(10) do
                stackCheck()
            end
        end)

        -- GCINFO spoof untuk mobile
        if gcinfo then
            local oldGcInfo = gcinfo
            gcinfo = function()
                return math.random(35, 75)
            end
        end

        detectMobileExecutors()
        setupBait()
        checkNamecall()
    end)
end
AntiTamperMobile()

local function HyphonBypassUltimate()
    pcall(function()
        -- GCINFO SPOOF
        local gcHistory = {}
        local gcIndex = 1
        for i = 1, 50 do
            gcHistory[i] = math.random(35, 75)
        end
        local function getUltimateGcInfo()
            local val = gcHistory[gcIndex]
            gcIndex = gcIndex + 1
            if gcIndex > #gcHistory then
                gcIndex = 1
                for i = 1, #gcHistory do
                    gcHistory[i] = gcHistory[i] + math.random(-3, 3)
                    if gcHistory[i] < 30 then gcHistory[i] = 30 end
                    if gcHistory[i] > 80 then gcHistory[i] = 80 end
                end
            end
            return val
        end

        gcinfo = function()
            return getUltimateGcInfo()
        end

        -- COLLECTGARBAGE SPOOF
        if collectgarbage then
            local oldCollect = collectgarbage
            collectgarbage = function(...)
                if ... == "count" then
                    return getUltimateGcInfo()
                end
                return oldCollect(...)
            end
        end

        -- HYPHON HANDLER KILLER (event-based)
        local function killHyphonHandlers()
            local CoreGui = game:GetService("CoreGui")
            local handlers = {
                CoreGui:FindFirstChild("HyphonHandler"),
                CoreGui:FindFirstChild("AntiCheatHandler"),
                CoreGui:FindFirstChild("GCInfoHandler"),
                CoreGui:FindFirstChild("HyperionHandler"),
                CoreGui:FindFirstChild("ByfronHandler"),
            }
            for _, handler in pairs(handlers) do
                if handler then 
                    handler:Destroy() 
                end
            end
            CoreGui.ChildAdded:Connect(function(child)
                local names = {"HyphonHandler","AntiCheatHandler","GCInfoHandler","HyperionHandler","ByfronHandler"}
                for _, name in pairs(names) do
                    if child.Name == name then
                        task.wait(0.1)
                        child:Destroy()
                    end
                end
            end)
        end
        killHyphonHandlers()

        -- REMOTE SPOOF (per remote)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents then
            for _, remote in pairs(remoteEvents:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    local old = remote.FireServer
                    remote.FireServer = function(self, ...)
                        task.wait(math.random(15, 60) / 1000)
                        if old then return old(self, ...) end
                    end
                end
            end
        end

        -- MEMORY TRACE KILLER
        if getgc then
            local old = getgc
            getgc = function(...) return {} end
        end
        if getreg then
            local old = getreg
            getreg = function() return {} end
        end
        if getfenv then
            local old = getfenv
            getfenv = function() return _G end
        end

        -- EXECUTOR BYPASS (redundant but safe)
        if getexecutorname then
            getexecutorname = function() return "Unknown" end
        end
        if getidentity then
            getidentity = function() return 1 end
        end
        if getthreadidentity then
            getthreadidentity = function() return 1 end
        end

        -- DISABLE LOGGING
        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(game, "LoggingEnabled", false)
                sethiddenproperty(game, "DebugEnabled", false)
                sethiddenproperty(game, "ScriptLogging", false)
                sethiddenproperty(game, "ClientLogging", false)
                sethiddenproperty(game, "TelemetryEnabled", false)
            end)
        end
        if setfflag then
            setfflag("DebugEnabled", "false")
            setfflag("LoggingEnabled", "false")
            setfflag("ScriptLogging", "false")
            setfflag("ClientLogging", "false")
            setfflag("TelemetryEnabled", "false")
            setfflag("AnalyticsEnabled", "false")
        end

        -- MEMORY OBFUSCATION
        for i = 1, 100 do
            _G["_BYPASS_" .. i] = math.random()
        end

        -- SPOOF NETWORK PING
        local Stats = game:GetService("Stats")
        if Stats and Stats.Network then
            local ping = Stats.Network:FindFirstChild("ServerStatsItem")
            if ping then
                ping:GetPropertyChangedSignal("Value"):Connect(function()
                    if ping.Value < 30 then ping.Value = math.random(45, 120) end
                    if ping.Value > 200 then ping.Value = math.random(45, 120) end
                end)
            end
        end

        -- SELF REPAIR (heartbeat)
        game:GetService("RunService").Heartbeat:Connect(function()
            if gcinfo then
                gcinfo = function()
                    return getUltimateGcInfo()
                end
            end
        end)

    end)
end
HyphonBypassUltimate()

task.spawn(function()
    local gcHistory = {}
    for i = 1, 50 do
        gcHistory[i] = math.random(35, 75)
    end
    local gcIndex = 1
    local function getUltimateGcInfo()
        local val = gcHistory[gcIndex]
        gcIndex = gcIndex + 1
        if gcIndex > #gcHistory then
            gcIndex = 1
            for i = 1, #gcHistory do
                gcHistory[i] = gcHistory[i] + math.random(-3, 3)
                if gcHistory[i] < 30 then gcHistory[i] = 30 end
                if gcHistory[i] > 80 then gcHistory[i] = 80 end
            end
        end
        return val
    end

    while true do
        task.wait(15)
        pcall(function()
            if gcinfo then
                gcinfo = function()
                    return getUltimateGcInfo()
                end
            end

            local CoreGui = game:GetService("CoreGui")
            local handlerNames = {"HyphonHandler","AntiCheatHandler","GCInfoHandler","HyperionHandler","ByfronHandler"}
            for _, name in pairs(handlerNames) do
                local h = CoreGui:FindFirstChild(name)
                if h then h:Destroy() end
            end

            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvents then
                for _, remote in pairs(remoteEvents:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        local old = remote.FireServer
                        remote.FireServer = function(self, ...)
                            task.wait(math.random(15, 60) / 1000)
                            if old then return old(self, ...) end
                        end
                    end
                end
            end
        end)
    end
end)

pcall(function()
    if not filtergc then return end

    local Players             = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local ReplicatedStorage   = cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
    local MemoryStoreService  = cloneref and cloneref(game:GetService("MemoryStoreService")) or game:GetService("MemoryStoreService")
    local Workspace           = game:GetService("Workspace")
    local Client = Players.LocalPlayer
    local genv   = getgenv()

    local hyphonCode = [[
        local Players             = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
        local ReplicatedStorage   = cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
        local MemoryStoreService  = cloneref and cloneref(game:GetService("MemoryStoreService")) or game:GetService("MemoryStoreService")
        local Workspace           = game:GetService("Workspace")
        local Client = Players.LocalPlayer
        local genv   = getgenv()

        genv.Hyphon_2102     = filtergc("function", { StartLine = 2102, IgnoreExecutor = true }, true)
        genv.Hyphon_2247     = filtergc("function", { StartLine = 2247, Source = debug.info(genv.Hyphon_2102, "s"), IgnoreExecutor = true }, true)
        genv.Hyphon_2846     = filtergc("function", { StartLine = 2846, Source = debug.info(genv.Hyphon_2102, "s"), IgnoreExecutor = true }, true)
        genv.Hyphon_fake_dec = filtergc("function", { StartLine = 1097, Source = debug.info(genv.Hyphon_2102, "s"), IgnoreExecutor = true }, true)
        genv.Hyphon_Encode   = debug.getupvalue(genv.Hyphon_2102, 1)
        genv.Hyphon_Decode   = debug.getupvalue(genv.Hyphon_2102, 21)
        genv.Hyphon_Script   = nil

        for _, Object in pairs(getnilinstances()) do
            if Object:IsA("Script") and Object.Name:len() == 32 then
                genv.Hyphon_Script = Object
                break
            end
        end

        if not genv.Hyphon_2102     then Client:Kick("Emulator : Hyphon_2102 not found!")     task.wait(9e9) end
        if not genv.Hyphon_2247     then Client:Kick("Emulator : Hyphon_2247 not found!")     task.wait(9e9) end
        if not genv.Hyphon_2846     then Client:Kick("Emulator : Hyphon_2846 not found!")     task.wait(9e9) end
        if not genv.Hyphon_fake_dec then Client:Kick("Emulator : Hyphon_fake_dec not found!") task.wait(9e9) end
        if not genv.Hyphon_Script   then Client:Kick("Emulator : Hyphon_Script not found!")   task.wait(9e9) end

        local Emulator_Data = {
            Emulator_Set = false,
            Hyphon_Check = {
                ["Tick"]              = nil,
                ["Hyphon_Check"]      = MemoryStoreService:FindFirstChild("Hyphon_Check"),
                ["Handshake_Version"] = tostring(debug.getupvalue(genv.Hyphon_2846, 42)) .. "Handshake_V5",
            },
            RemoteFunction = {
                ["Tick"]           = nil,
                ["RemoteFunction"] = debug.getupvalue(genv.Hyphon_2247, 6),
                ["Token One"]      = nil,
                ["Token Two"]      = nil,
                ["Current Number"] = nil,
                ["Token Three"]    = nil,
                ["Token Four"]     = nil,
                ["Tablets"]        = {[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil,[6]=nil},
                ["SSL"]            = nil,
                ["LuaFunction"]    = nil,
            },
        }

        local Hyphon_Check = nil
        Hyphon_Check = hookfunction(Emulator_Data.Hyphon_Check["Hyphon_Check"].FireServer, newcclosure(function(self, ...)
            Emulator_Data.Hyphon_Check["Tick"] = tick()
            return Hyphon_Check(self, ...)
        end))

        local RemoteFunction = nil
        RemoteFunction = hookfunction(Emulator_Data.RemoteFunction["RemoteFunction"].InvokeServer, newcclosure(function(self, ...)
            local Arguments = table.pack(...)
            Emulator_Data.RemoteFunction["Tick"] = tick()
            if not Emulator_Data.Emulator_Set and type(Arguments[1]) == "table" and Arguments[1][1] ~= nil then
                Emulator_Data.RemoteFunction["Token One"]      = Arguments[1][1]
                Emulator_Data.RemoteFunction["Token Two"]      = Arguments[1][2]
                Emulator_Data.RemoteFunction["Current Number"] = genv.Hyphon_Decode(Arguments[1][4])
                Emulator_Data.RemoteFunction["Token Three"]    = Arguments[1][6]
                Emulator_Data.RemoteFunction["Token Four"]     = Arguments[1][11]
                if type(Arguments[1][12]) == "table" and Arguments[1][12]["Tablets"] ~= nil then
                    Emulator_Data.RemoteFunction["Tablets"] = Arguments[1][12]["Tablets"]
                end
                if type(Arguments[1][13]) == "table" then
                    Emulator_Data.RemoteFunction["SSL"]         = Arguments[1][13]["SSL"]
                    Emulator_Data.RemoteFunction["LuaFunction"] = Arguments[1][13]["LuaFunction"]
                end
            end
            return RemoteFunction(self, ...)
        end))

        repeat task.wait() until (Emulator_Data.Hyphon_Check["Tick"] and Emulator_Data.RemoteFunction["Tick"])
        genv.Emulator_Set = true

        local OldBit32 = nil
        OldBit32 = hookfunction(bit32.bxor, newcclosure(function(...)
            if not checkcaller() then
                if getcallingscript() == genv.Hyphon_Script then
                    return task.wait(9e9)
                end
            end
            return OldBit32(...)
        end))

        pcall(function()
            local Wrapped_Functions = filtergc("function", {
                Upvalues  = {"Attempted function hijacking detected. Logged."},
                Constants = {":P"}
            })
            for _, Function in pairs(Wrapped_Functions) do
                local Upvalues = debug.getupvalues(Wrapped_Functions)
                if #Upvalues == 20 then
                    for _, Upvalue in pairs(Upvalues) do
                        if typeof(Upvalue) == "function" and islclosure(Upvalue) then
                            Upvalues = debug.getupvalues(Upvalue)
                            if #Upvalues == 17 then
                                hookfunction(Function, newcclosure(function() end))
                            end
                        end
                    end
                end
            end
        end)

        task.spawn(function() while task.wait(9)  do Emulator_Data.RemoteFunction["Tablets"][1] = tick() Emulator_Data.RemoteFunction["Tablets"][2] = tick() end end)
        task.spawn(function() while task.wait(10) do Emulator_Data.RemoteFunction["Tablets"][3] = tick() end end)
        task.spawn(function() while task.wait(4)  do Emulator_Data.RemoteFunction["Tablets"][4] = tick() end end)

        for _, Object in pairs(ReplicatedStorage:GetChildren()) do
            if Object:IsA("Folder") and Object.Name:len() <= 4 then
                local RF = Object:FindFirstChildOfClass("RemoteFunction")
                RF.OnClientInvoke = function(...)
                    local Arguments = table.pack(...)
                    if Arguments[1] ~= nil then
                        Emulator_Data.RemoteFunction["Token Two"] = genv.Hyphon_Decode(Arguments[1])
                    end
                    Emulator_Data.RemoteFunction["Current Number"] = -1
                    local Table = {
                        debug.getupvalue(genv.Hyphon_2102, 26),
                        genv.Hyphon_Encode("Hyphon-," .. tostring(math.random(242, 789) .. "{ Date (Data: " .. tostring(math.random(1, 9)) .. ")")),
                        genv.Hyphon_fake_dec(Arguments[3], tostring(Client.UserId)),
                        debug.getupvalue(genv.Hyphon_2102, 29)(),
                        genv.Hyphon_Encode(tostring(Workspace:GetServerTimeNow())),
                        {
                            CI = genv.Hyphon_Encode(tostring(tick())),
                            TL = Emulator_Data.RemoteFunction["Tablets"],
                            LS = #tostring(debug.getupvalue(genv.Hyphon_2102, 37)) + game.PlaceVersion
                        }
                    }
                    return table.unpack(Table)
                end
            end
        end

        task.spawn(function()
            local function DoRemoteFunction()
                local RF = Emulator_Data.RemoteFunction["RemoteFunction"]
                Emulator_Data.RemoteFunction["Current Number"] += 1
                Emulator_Data.RemoteFunction["Tablets"][5] = (tick() - .5)
                Emulator_Data.RemoteFunction["Tablets"][6] = tick()
                RF:InvokeServer({
                    Emulator_Data.RemoteFunction["Token One"],
                    Emulator_Data.RemoteFunction["Token Two"],
                    nil,
                    [4]  = genv.Hyphon_Encode(tostring(Emulator_Data.RemoteFunction["Current Number"])),
                    [5]  = debug.getupvalue(genv.Hyphon_2247, 12)("_1") .. "__index",
                    [6]  = Emulator_Data.RemoteFunction["Token Three"],
                    [7]  = debug.getupvalue(genv.Hyphon_2247, 20),
                    [8]  = genv.Hyphon_Encode(tostring(os.time())),
                    [9]  = tick(),
                    [10] = debug.getupvalue(genv.Hyphon_2247, 23)[debug.getupvalue(genv.Hyphon_2247, 24)],
                    [11] = Emulator_Data.RemoteFunction["Token Four"],
                    [12] = { ["CurrentTick"] = genv.Hyphon_Encode(tostring(tick())), ["Tablets"] = Emulator_Data.RemoteFunction["Tablets"] },
                    [13] = { ["LuaFunction"] = Emulator_Data.RemoteFunction["LuaFunction"], ["SSL"] = Emulator_Data.RemoteFunction["SSL"], ["Metatable code"] = genv.Hyphon_Encode("nil") },
                })
            end
            task.wait(35 - (tick() - Emulator_Data.RemoteFunction["Tick"]))
            while true do task.spawn(DoRemoteFunction) task.wait(35) end
        end)

        task.spawn(function()
            local function DoHyphonCheck()
                local HC = Emulator_Data.Hyphon_Check["Hyphon_Check"]
                local HV = Emulator_Data.Hyphon_Check["Handshake_Version"]
                HC:FireServer(tick(), HV)
                task.wait(.1)
                HC:FireServer()
            end
            task.wait(9 - (tick() - Emulator_Data.Hyphon_Check["Tick"]))
            while true do task.spawn(DoHyphonCheck) task.wait(9) end
        end)

        genv.HyphonReady = true
    ]]

    loadstring(hyphonCode)()
end)

-- Tunggu HyphonReady maksimal 15 detik biar tidak stuck
do
    local timeout = 15
    local start = os.clock()
    while HyphonReady ~= true and (os.clock() - start) < timeout do
        task.wait(0.1)
    end
    if HyphonReady ~= true then
        warn("[Masgal]] HyphonReady timeout. Lanjut tanpa emulator.")
        getgenv().HyphonReady = true
    end
end

repeat task.wait() until HyphonReady == true

local Configuration = {
    Main_Settings = {
        ["Autofarming"]       = false,
        ["Auto Anti Death"]   = true,
        ["Auto Rejoiner"]     = true,
        ["Performance Saver"] = false,
    },
    Statistics = {
        ["Times Rejoined"]    = 0,
        ["Runtime"]           = 0,
        ["Cash Made"]         = 0,
        ["Chips Fed"]         = 0,
        ["Cards Swiped"]      = 0,
        ["Marshmallows Sold"] = 0,
    },
    Goal_Settings = {
        ["Enabled"]       = false,
        ["Target Amount"] = 250000,
    },
    Webhook_Settings = {
        ["Send Webhooks"]     = false,
        ["Webhook Intervals"] = 5,
        ["Webhook Url"]       = "",
    },
    State = {
        ["Status"]      = "Idle",
        ["BikeSitting"] = false,
        ["BikeSpawned"] = false,
        ["IsHealing"]   = false,
        ["Apartment"]   = nil,
    },

}

local Locations = {
    SafeZone      = Vector3.new(-478.840, 24.000,  389.200),
    HotChipsMan   = Vector3.new( -41.000,  3.000,  -25.000),
    FakeID        = Vector3.new(217.841, 4.727, -331.714),
    BuyMarsh      = Vector3.new(510.817, 4.581, 601.048),
    BuyPotato     = Vector3.new(-759.197, 3.489, -194.846),
    ApplyForCard  = Vector3.new( -49.210,  4.000, -310.810),
    CollectCard   = Vector3.new( -39.090,  5.392, -329.700),
    SkiMask       = Vector3.new(-366.980,  3.528, -320.630),
    Healing       = Vector3.new(-769.000,  6.000,  654.000),
    Clipboard     = Vector3.new(-477.803, 4.855, -435.559),
    PotatoCutter  = Vector3.new(-456.320,  3.870, -466.840),
    PlasticBagLab = Vector3.new(-456.280,  3.654, -472.670),
    FlourBowl     = Vector3.new(-494.640,  3.579, -518.580),
}

local Labatory = Workspace.Map.Locations["The Laboratory"]

local Stove, CookPrompt, StoveTimer
local AvailablePot, PotPrompt, PotTimer

for _, Object in pairs(getgc(true)) do
    if typeof(Object) == "table" and typeof(rawget(Object, "Homeless")) == "table" then
        if rawget(Object.Homeless, "MaxDistance") then
            Object.Homeless.MaxDistance = 9e9
        end
    end
end

local function GetCommaValue(n)
    local s = tostring(math.floor(n))
    while true do
        local result, count = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = result
        if count == 0 then break end
    end
    return s
end

local function FormatRuntime(seconds)
    return string.format("%02d:%02d:%02d",
        math.floor(seconds / 3600),
        math.floor((seconds % 3600) / 60),
        seconds % 60
    )
end

local function GetCurrentCashAmount()
    local ok, n = pcall(function()
        return tonumber((PlayerGui.Main.Money.Amount.Text:gsub("%D+", ""))) or 0
    end)
    return (ok and n) or 0
end

local function GetCurrentCash()
    local n = GetCurrentCashAmount()
    if n > 0 then return "$" .. GetCommaValue(n) end
    return "N/A"
end

local function GetCharName()
    local ok, result = pcall(function()
        return Player.Character.Head:WaitForChild("NameTag", 5).MainFrame.NameLabel.Text
    end)
    return (ok and result) or "N/A"
end

local function GetETA()
    if not Configuration.Goal_Settings["Enabled"] then return "N/A" end
    local runtime    = Configuration.Statistics["Runtime"]
    local cashMade   = Configuration.Statistics["Cash Made"]
    if runtime <= 0 or cashMade <= 0 then return "N/A" end
    local remaining = Configuration.Goal_Settings["Target Amount"] - GetCurrentCashAmount()
    if remaining <= 0 then return "Goal Reached" end
    return FormatRuntime(math.floor(remaining / (cashMade / runtime)))
end

local function WaitForReady()
    repeat task.wait() until Configuration.Main_Settings["Autofarming"]
end

local function DoRejoin()
    if not Configuration.Main_Settings["Auto Rejoiner"] then return end
    Configuration.Main_Settings["Autofarming"] = false
    Configuration.Statistics["Times Rejoined"] += 1
    queue_on_teleport([[
        queue_on_teleport("task.wait(30)\ngetgenv().AutoRejoinerEnabled = true\nloadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/94f566f0-8827-4dde-ad58-b6a2d73cfde8.lua"))()

")
    ]])
    TeleportService:Teleport(10179538382)
end

-- ============================================================
-- FUNGSI AUTOFARM (sama seperti sebelumnya, tidak diubah)
-- ============================================================

local function ScavengeInventory()
    UnequipTools()
    local Backpack = Player:WaitForChild("Backpack")    
    local Potato, Flour, Water, Gelatin, SugarBlockBag = 0, 0, 0, 0, 0
    for _, Object in next, Backpack:GetChildren() do
        if Object.Name == "Potato"          then Potato       += 1 end
        if Object.Name == "Flour"           then Flour        += 1 end
        if Object.Name == "Water"           then Water        += 1 end
        if Object.Name == "Gelatin"         then Gelatin      += 1 end
        if Object.Name == "Sugar Block Bag" then SugarBlockBag += 1 end
    end
    return Potato, Flour, Water, Gelatin, SugarBlockBag
end

local function FindAvailableApartments()
    local Available, Owned = {}, {}
    local Apartments       = { "WH1", "BH3", "BH2", "BH4", "BH1", "LT1" }
    local CasinoApartments = { "Home 1", "Home 2", "Home 3", "Home 4" }
    for _, Object in next, Workspace:WaitForChild("Map").APTS:GetChildren() do
        if Object:IsA("Model") and (table.find(Apartments, tostring(Object)) or table.find(CasinoApartments, tostring(Object))) then
            local Board = Object:FindFirstChild("Board", true)
            if Board then
                local Text = Board.name.SurfaceGui.TextLabel.Text
                if Text == "VACANT" then
                    table.insert(Available, Object)
                elseif Text == Player.Name then
                    table.insert(Owned, Object)
                end
            end
        end
    end
    if #Owned >= 1 then return Owned, "Owned" end
    return Available, "Not Owned"
end

local function FindAvailableATMs()
    for _, ATM in next, Workspace:WaitForChild("Map").ATMS:GetChildren() do
        if ATM:FindFirstChild("ATMScreen").Transparency == 0 then
            return ATM
        end
    end
end

local function FindAvailableHomeless()
    local Available = {}
    for _, Object in next, Workspace.Folders.HomelessPeople:GetChildren() do
        if Object:IsA("Model") then
            local Leg = Object:FindFirstChild("RightLowerLeg")
            if Leg and math.floor(Leg.Rotation.X) == 90 then
                table.insert(Available, Object)
            end
        end
    end
    return Available
end

local function SpawnAndSitOnBike()
    local BikeName     = string.format("%s's Car", Player.Name)
    local ExistingBike = Workspace:FindFirstChild(BikeName)

    if ExistingBike and ExistingBike:FindFirstChild("DriveSeat") and ExistingBike.DriveSeat.Occupant then
        Configuration.State["Status"] = "Already on bike"
        Configuration.State["BikeSitting"] = true
        Configuration.State["BikeSpawned"] = true
        return true
    end

    Configuration.State["Status"] = "Spawning bike..."
    local Bike = Workspace:FindFirstChild(BikeName)

    if not Bike then
        RPC:FireServer(buffer.fromstring("\001"), "Spawn", "DirtBike")
        local SpawnStart = os.clock()
        repeat task.wait(0.1) until Workspace:FindFirstChild(BikeName) or (os.clock() - SpawnStart) > 4
        Bike = Workspace:FindFirstChild(BikeName)
    end

    if not Bike then
        Configuration.State["Status"] = "Bike not found!"
        return false
    end

    local DriveSeat = Bike:WaitForChild("DriveSeat")

    Configuration.SpawningBike = true

    UnequipTools()
    Configuration.State["RespawnPending"] = true
    HumanoidRootPart.CFrame = CFrame.new(67^2, 10^10, 67^2)
    Player.CharacterAdded:Wait()
    Character        = Player.Character
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local TargetCFrame = DriveSeat.CFrame * CFrame.new(3, 1, 0)
    task.wait(2)
    for _ = 1, 5 do
        HumanoidRootPart.CFrame = TargetCFrame
        task.wait(0.05)
    end
    task.wait(2.5)

    Configuration.SpawningBike = false

    if (HumanoidRootPart.Position - Bike:FindFirstChildWhichIsA("Part", true).Position).Magnitude > 25 then
        Configuration.State["RespawnPending"] = false
        Configuration.State["Status"] = "Failed to teleport to bike!"
        return false
    end

    local Prompt = DriveSeat:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not Prompt then
        local Attachment = DriveSeat:FindFirstChild("Attachment")
        if Attachment then Prompt = Attachment:FindFirstChild("ProximityPrompt") end
    end

    if Prompt then
        Prompt.HoldDuration          = 0
        Prompt.RequiresLineOfSight   = false
        Prompt.MaxActivationDistance = 9e9
        fireproximityprompt(Prompt)
    end

    task.wait(1)
    Configuration.State["RespawnPending"] = false
    Configuration.State["Status"]      = "Sitting on bike!"
    Configuration.State["BikeSitting"] = true
    Configuration.State["BikeSpawned"] = true
    return true
end

local function DirtBikeTeleport(TargetPosition)
    local c = Player.Character
    if not c then return false end

    local h = c:FindFirstChild("Humanoid")
    if not h then return false end

    if not h.SeatPart then
        Configuration.State["Status"] = "Not on bike, re-sitting..."
        if not SpawnAndSitOnBike() then return false end
        task.wait(0.3)
    end

    local DriveSeat = h.SeatPart
    if not DriveSeat or DriveSeat.Name ~= "DriveSeat" then return false end

    local Vehicle = DriveSeat.Parent
    if not Vehicle then return false end

    Vehicle:PivotTo(CFrame.new(TargetPosition))
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = false end
    end
    task.wait(0.51)
    for _, Object in pairs(Vehicle:GetDescendants()) do
        if Object:IsA("BasePart") then Object.Anchored = true end
    end

    return true
end

local function cekDarah(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    
    hum.HealthChanged:Connect(function(hp)
        if not Configuration.Main_Settings["Auto Anti Death"] then return end
        if Configuration.State["RespawnPending"] then return end
        
        if hp > 0 and hp < 95 then
            Configuration.State["Status"] = "Taking damage, teleporting to safe zone!"
            DirtBikeTeleport(Locations.Healing)

        end
    end)
end

if Player.Character then
    cekDarah(Player.Character)
end

local function StartMarshmallowFarm()
    WaitForReady()
    Configuration.State["Status"] = "Finding an apartment..."
    local Apartments, Ownership = FindAvailableApartments()
    if #Apartments == 0 then
        Configuration.State["Status"] = "No apartment available"
        return false
    end

    local Apartment = Ownership == "Owned" and Apartments[1] or Apartments[Random:NextInteger(1, #Apartments)]
    local IsHome    = tostring(Apartment):match("Home")
    if IsHome then
        Configuration.State["Apartment"] = Workspace.Map.Locations.Apartments:FindFirstChild(tostring(Apartment))
    else
        Configuration.State["Apartment"] = Workspace.Map.Houses:FindFirstChild(tostring(Apartment))
    end


    if Ownership == "Not Owned" then
        local Board  = Apartment:FindFirstChild("Board", true)
        local Prompt = Board.backboard.ProximityPrompt
        Prompt.MaxActivationDistance = 9e9
        WaitForReady()
        DirtBikeTeleport(Board.backboard.Position)
        Configuration.State["Status"] = "Purchasing apartment..."
        fireproximityprompt(Prompt)
        task.wait(2)
        local BoardText = Board.name.SurfaceGui.TextLabel.Text
        if BoardText ~= tostring(Player) then
            return StartMarshmallowFarm()
        end
    end

    local Lock       = Apartment.Door.DoorLock
    local KnobPrompt = Apartment.Door.Interact.Attachment.ProximityPrompt

    if math.abs(Lock.Part.Rotation.Y) > 5 and math.abs(Lock.Part.Rotation.Y - 90) > 5 then
        WaitForReady()
        KnobPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "Closing door..."
        task.wait(0.5)
        local CloseAttempts = 0
        repeat
            fireproximityprompt(KnobPrompt)
            task.wait(1)
            CloseAttempts += 1
        until math.abs(Lock.Part.Rotation.Y) < 5 or CloseAttempts >= 10
        task.wait(0.5)
    end

    if Lock.Part.Rotation.X ~= 90 then
        WaitForReady()
        local LockPrompt = Lock.Part.ProximityPrompt
        LockPrompt.MaxActivationDistance = 9e9
        DirtBikeTeleport(Lock.Part.Position)
        Configuration.State["Status"] = "Locking door..."
        task.wait(0.5)
        local LockAttempts = 0
        repeat
            fireproximityprompt(LockPrompt)
            task.wait(0.5)
            LockAttempts += 1
        until Lock.Part.Rotation.X == 90 or LockAttempts >= 10
        if Lock.Part.Rotation.X ~= 90 then
            return StartMarshmallowFarm()
        end
    end

    Configuration.State["Status"] = "Apartment secured"
    return true
end

local function PurchaseMarshmallowIngredients()
    WaitForReady()
    local _, _, Water, Gelatin, SugarBlockBag = ScavengeInventory()
    if Water >= 1 and Gelatin >= 1 and SugarBlockBag >= 1 then
        return true
    end
    local MarshRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    DirtBikeTeleport(Locations.BuyMarsh)
    Configuration.State["Status"] = "Buying ingredients..."
    task.wait(0.5)
    if Water < 1         then MarshRemote:FireServer("Water")           task.wait(0.5) end
    if Gelatin < 1       then MarshRemote:FireServer("Gelatin")         task.wait(0.5) end
    if SugarBlockBag < 1 then MarshRemote:FireServer("Sugar Block Bag") task.wait(0.5) end
    return true
end

local function PourWater()
    WaitForReady()
    local AptObj = Configuration.State["Apartment"]
    if tostring(AptObj):match("Home") then
        Stove = AptObj:FindFirstChild("Cooking Pot")
    else
        Stove = AptObj:WaitForChild("Interior"):FindFirstChild("Cooking Pot")
    end
    CookPrompt = Stove:FindFirstChild("Attachment").ProximityPrompt
    StoveTimer  = Stove:FindFirstChild("Timer").TextLabel

    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "Pouring water..."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Water"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Water")
        or PlayerGui:WaitForChild("Main").BasicNotification.TextTransparency == 0
        or Safety >= 10
    local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
    if notif == "You do not have permission to cook in this apartment." then
        return false
    end
    return true
end

local function AddSugarAndGelatin()
    WaitForReady()
    Configuration.State["Status"] = "Adding sugar..."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Sugar Block Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag")
        or Safety >= 5

    Configuration.State["Status"] = "Adding gelatin..."
    Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Gelatin"))
        DirtBikeTeleport(Stove.Position)
        fireproximityprompt(CookPrompt)
        task.wait(1)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Gelatin")
        or PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Let")
        or Safety >= 5
end

local function BagMarshmallowAndSell()
    WaitForReady()
    Configuration.State["Status"] = "Waiting for marshmallow..."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until StoveTimer and StoveTimer.Text == "0"
    DirtBikeTeleport(Stove.Position)
    Configuration.State["Status"] = "Bagging marshmallow..."
    repeat
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Empty Bag"))
        task.wait(0.5)
        fireproximityprompt(CookPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
    until Player:WaitForChild("Backpack"):FindFirstChild("Small Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Medium Marshmallow Bag")
        or Player:WaitForChild("Backpack"):FindFirstChild("Large Marshmallow Bag")

    repeat WaitForReady() DirtBikeTeleport(Locations.BuyMarsh) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")

    Configuration.State["Status"] = "Selling marshmallow..."
    local LamontBell   = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Lamont Bell")
    local LamontPrompt = LamontBell.UpperTorso.ProximityPrompt
    UnequipTools()
    for _, Object in next, Player:WaitForChild("Backpack"):GetChildren() do
        if tostring(Object):find("Marshmallow") then
            WaitForReady()
            DirtBikeTeleport(Locations.BuyMarsh)
            EquipTool(Player:WaitForChild("Backpack"):FindFirstChild(tostring(Object)))
            task.wait(0.5)
            fireproximityprompt(LamontPrompt)
            task.wait(0.5)
        end
    end
    Configuration.Statistics["Marshmallows Sold"] += 1
end

local function BuySkiMask()
    WaitForReady()
    local CurrentChar = Player.Character
    if not CurrentChar then return end
    if CurrentChar:FindFirstChild("White Ski Mask") then
        return
    end

    if not Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask") then
        Configuration.State["Status"] = "Buying ski mask..."
        local SkiMaskRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
        DirtBikeTeleport(Locations.SkiMask)
        task.wait(0.5)
        repeat
            SkiMaskRemote:FireServer("White Ski Mask")
            task.wait(0.5)
        until Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask")
    end

    EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask"))
    task.wait(0.05)
    RPC:FireServer(buffer.fromstring("\005"), Player.Character:WaitForChild("White Ski Mask"))
    task.wait(0.05)
    UnequipTools()
end

local function PurchasePotatoIngredients()
    WaitForReady()
    local Potato, Flour = ScavengeInventory()
    if Potato >= 1 and Flour >= 1 then
        return true
    end
    local PotatoRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StorePurchase")
    Configuration.State["Status"] = "Buying potato ingredients..."
    DirtBikeTeleport(Locations.BuyPotato)
    task.wait(0.5)
    if Flour < 1  then PotatoRemote:FireServer("Flour")  task.wait(0.5) end
    if Potato < 1 then PotatoRemote:FireServer("Potato") task.wait(0.5) end
    return true
end

local function StartPotatoJob()
    WaitForReady()
    local Clipboard       = Labatory.Prompts.Clipboard
    local ClipboardPrompt = Clipboard.ProximityPrompt
    ClipboardPrompt.MaxActivationDistance = 9e9
    DirtBikeTeleport(Locations.Clipboard)
    Configuration.State["Status"] = "Claiming potato task..."
    task.wait(0.5)
    local Attempts = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.Clipboard)
        task.wait(0.25)
        fireproximityprompt(ClipboardPrompt)
        task.wait(0.5)
        Attempts += 1
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Task:")
        or PlayerGui:WaitForChild("Main").BasicNotification.Text == "You have already began your task."
end

local function CutPotato()
    WaitForReady()
    local PotatoCutter = Labatory["Cutting Boards"]:FindFirstChild("Potato Cutter").Model.Union
    local CutterPrompt = PotatoCutter.Attachment.ProximityPrompt
    CutterPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "Cutting potato..."
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PotatoCutter)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Potato"))
        task.wait(0.25)
        fireproximityprompt(CutterPrompt)
        task.wait(0.5)
        UnequipTools()
        task.wait(0.25)
        local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Potato")
        or notif == "You are at the wrong step."
        or Safety >= 20
end

local function BagPotato()
    WaitForReady()
    local PlasticBag = Labatory.Prompts["Plastic Bag"]
    local BagPrompt  = PlasticBag.Attachment.ProximityPrompt
    BagPrompt.MaxActivationDistance = 9e9
    Configuration.State["Status"] = "Bagging potato..."
    if Player:WaitForChild("Backpack"):FindFirstChild("Potato") then
        return
    end
    local Safety = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.PlasticBagLab)
        task.wait(0.25)
        fireproximityprompt(BagPrompt)
        task.wait(0.5)
        Safety += 1
        if Safety >= 15 then
            break
        end
    until PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Head")
end

local function MixFlourAndPotato()
    WaitForReady()
    local Bowl       = Labatory.Bowls:FindFirstChildOfClass("UnionOperation") or Labatory.Bowls:FindFirstChildWhichIsA("BasePart")
    if not Bowl then
        Configuration.State["Status"] = "Bowl not found!"
        return false
    end
    local BowlPrompt = Bowl:FindFirstChildWhichIsA("ProximityPrompt") or Bowl:FindFirstChild("Attachment"):FindFirstChild("ProximityPrompt")
    BowlPrompt.MaxActivationDistance = 9e9
    BowlPrompt.HoldDuration = 0
    BowlPrompt.RequiresLineOfSight = false
    Configuration.State["Status"] = "Mixing flour and potato..."
    local Safety = 0
    repeat
        WaitForReady()
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Flour"))
        task.wait(0.25)
        DirtBikeTeleport(Bowl.Position)
        task.wait(0.25)
        fireproximityprompt(BowlPrompt)
        task.wait(0.5)
        UnequipTools()
        Safety += 1
        if Safety >= 10 then
            DirtBikeTeleport(Locations.FlourBowl)
            WaitForReady()
            fireproximityprompt(BowlPrompt)
            task.wait(0.5)
            UnequipTools()
        end
    until not Player:WaitForChild("Backpack"):FindFirstChild("Flour") or Safety >= 15
    task.wait(3.5)
end

local function CookPotatoChips()
    WaitForReady()
    Configuration.State["Status"] = "Starting cook..."
    AvailablePot = nil

    for _, Object in next, Labatory.Pots:GetChildren() do
        if AvailablePot then break end
        if Object:IsA("UnionOperation") then
            DirtBikeTeleport(Object.Position)
            task.wait(0.3)
            fireproximityprompt(Object.ProximityPrompt)
            task.wait(1)
            local Notif = PlayerGui:WaitForChild("Main").BasicNotification
            if Notif.TextTransparency == 0 then
                if Notif.Text:find("120 seconds") then
                    AvailablePot = Object
                    PotTimer     = Object.Timer.TextLabel
                    PotPrompt    = Object.ProximityPrompt
                end
                if Notif.Text:find("in use") then
                    repeat task.wait() until Notif.TextTransparency == 1
                end
            end
        end
    end

    if not AvailablePot then
        for _, Object in next, Labatory.Pots:GetChildren() do
            if AvailablePot then break end
            if Object:IsA("UnionOperation") then
                DirtBikeTeleport(Object.Position)
                task.wait(0.3)
                fireproximityprompt(Object.ProximityPrompt)
                task.wait(1)
                local Notif = PlayerGui:WaitForChild("Main").BasicNotification
                if Notif.TextTransparency == 0 and Notif.Text:find("120 seconds") then
                    AvailablePot = Object
                    PotTimer     = Object.Timer.TextLabel
                    PotPrompt    = Object.ProximityPrompt
                end
            end
        end
    end

    return AvailablePot ~= nil
end

local function ClaimPotatoChipsAndSell()
    WaitForReady()
    Configuration.State["Status"] = "Waiting for chips..."
    DirtBikeTeleport(Locations.SafeZone)
    repeat task.wait() until PotTimer and PotTimer.Text == "0"

    Configuration.State["Status"] = "Claiming from pot..."
    repeat
        WaitForReady()
        DirtBikeTeleport(AvailablePot.Position)
        fireproximityprompt(PotPrompt)
        task.wait(0.5)
    until Player:WaitForChild("Backpack"):FindFirstChild("Potato Chips")

    Configuration.State["Status"] = "Converting to hot chips..."
    repeat WaitForReady() DirtBikeTeleport(Locations.HotChipsMan) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")

    local PoorGuy       = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Poor Guy")
    local PoorGuyPrompt = PoorGuy.UpperTorso.ProximityPrompt
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.HotChipsMan)
        fireproximityprompt(PoorGuyPrompt)
        UnequipTools()
        task.wait(0.05)
    until Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips")

    task.wait(3)

    Configuration.State["Status"] = "Giving chips to homeless..."
    local AvailableHomeless = FindAvailableHomeless()
    if #AvailableHomeless == 0 then return false end

    for _, HomelessRef in next, AvailableHomeless do
        if not Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips") then break end
        local HomelessName = tostring(HomelessRef)
        repeat WaitForReady() DirtBikeTeleport(HomelessRef:FindFirstChild("UpperTorso").Position) task.wait(0.05)
        until Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local Homeless   = Workspace:WaitForChild("Folders").HomelessPeople:FindFirstChild(HomelessName)
        local UpperTorso = Homeless:FindFirstChild("UpperTorso")
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Hot Chips"))
        task.wait(0.25)
        fireproximityprompt(UpperTorso.ProximityPrompt)
        task.wait(0.5)
        UnequipTools()
    end

    Configuration.Statistics["Chips Fed"] += 1
    return true
end

local function PurchaseFakeID()
    WaitForReady()
    Configuration.State["Status"] = "Buying fake ID..."
    repeat WaitForReady() DirtBikeTeleport(Locations.FakeID) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")

    local FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
    local BuyIDPrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityPrompt
    repeat
        WaitForReady()
        repeat DirtBikeTeleport(Locations.FakeID) task.wait(0.05)
        until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
        FakeIDSeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("FakeIDSeller")
        BuyIDPrompt  = FakeIDSeller.UpperTorso.Attachment.ProximityPrompt
        DirtBikeTeleport(Locations.FakeID)
        local SkiMask = Player.Character and Player.Character:FindFirstChild("White Ski Mask")
            or Player:WaitForChild("Backpack"):FindFirstChild("White Ski Mask")
        if SkiMask then
            EquipTool(SkiMask)
            task.wait(0.25)
        end
        fireproximityprompt(BuyIDPrompt)
        UnequipTools()
        task.wait(4)
    until Player:WaitForChild("Backpack"):FindFirstChild("Fake ID")
end

local function ApplyForCard()
    WaitForReady()
    Configuration.State["Status"] = "Applying for credit card..."
    repeat DirtBikeTeleport(Locations.ApplyForCard) task.wait(0.05)
    until Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Bank Teller")

    local BankTeller = Workspace:WaitForChild("Folders").NPCs:FindFirstChild("Bank Teller")
    local BankPrompt = BankTeller.UpperTorso.Attachment.ProximityPrompt
    local Safety     = 0
    repeat
        WaitForReady()
        DirtBikeTeleport(Locations.ApplyForCard)
        EquipTool(Player:WaitForChild("Backpack"):FindFirstChild("Fake ID"))
        task.wait(0.5)
        fireproximityprompt(BankPrompt)
        task.wait(0.5)
        UnequipTools()
        Safety += 1
    until not Player:WaitForChild("Backpack"):FindFirstChild("Fake ID") or Safety >= 15

    if Safety >= 15 then
        WaitForReady()
        Configuration.State["Status"] = "Claiming card early..."
        local Card       = Workspace:WaitForChild("CardPickup")
        local CardPrompt = Card.Attachment.ProximityPrompt
        for _ = 1, 10 do
            DirtBikeTeleport(Card.Position)
            fireproximityprompt(CardPrompt)
            task.wait(0.05)
            UnequipTools()
        end
    end
end

local function ClaimAndUseCard()
    WaitForReady()

    local function HasCard()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack and backpack:FindFirstChild("Card") then return true end
        local char = Player.Character
        if char and char:FindFirstChild("Card") then return true end
        return false
    end

    if HasCard() then
        Configuration.State["Status"] = "Card already owned, going to ATM..."
    else
        Configuration.State["Status"] = "Teleporting to card pickup..."
        DirtBikeTeleport(Locations.CollectCard)
        task.wait(1)
        local Card = Workspace:FindFirstChild("CardPickup")
        if not Card then
            for _, obj in next, Workspace:GetDescendants() do
                if obj.Name == "CardPickup" then Card = obj; break end
            end
        end
        if not Card then
            Configuration.State["Status"] = "CardPickup not found!"
            return false
        end
        local CardPrompt
        if Card:FindFirstChild("Attachment") then
            CardPrompt = Card.Attachment:FindFirstChildWhichIsA("ProximityPrompt")
        end
        if not CardPrompt then
            CardPrompt = Card:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        if not CardPrompt then
            Configuration.State["Status"] = "Card prompt not found!"
            return false
        end
        CardPrompt.MaxActivationDistance = 9e9
        CardPrompt.HoldDuration = 0
        CardPrompt.RequiresLineOfSight = false
        local Safety = 0
        repeat
            WaitForReady()
            DirtBikeTeleport(Card:GetPivot().Position or Card.Position)
            task.wait(0.25)
            fireproximityprompt(CardPrompt)
            task.wait(0.5)
            Safety += 1
        until HasCard()
            or PlayerGui:WaitForChild("Main").BasicNotification.Text:find("not on the wait list")
            or Safety >= 15

        if not HasCard()
            and PlayerGui:WaitForChild("Main").BasicNotification.Text:find("not on the wait list") then
            Configuration.State["Status"] = "Not on wait list, skipping."
            return false
        end
    end

    if not HasCard() then
        Configuration.State["Status"] = "No card to use."
        return false
    end

    repeat
        local AvailableATM = FindAvailableATMs()
        if not AvailableATM then
            Configuration.State["Status"] = "No available ATM."
            return false
        end

        local ATMPrompt = AvailableATM.Attachment:FindFirstChildWhichIsA("ProximityPrompt")
        if not ATMPrompt then
            Configuration.State["Status"] = "ATM prompt not found."
            return false
        end
        ATMPrompt.MaxActivationDistance = 9e9
        ATMPrompt.HoldDuration = 0
        ATMPrompt.RequiresLineOfSight = false
        WaitForReady()
        Configuration.State["Status"] = "Using card at ATM..."
        local OldATM = PlayerGui:FindFirstChild("ATM")
        if OldATM then OldATM:Destroy() end
        repeat
            WaitForReady()
            DirtBikeTeleport(AvailableATM.Position)
            fireproximityprompt(ATMPrompt)
            task.wait(0.05)
        until PlayerGui:FindFirstChild("ATM")
        EquipTool(Player:FindFirstChild("Backpack"):FindFirstChild("Card"))
        task.wait(0.5)
        replicatesignal(PlayerGui:WaitForChild("ATM").Frame.Swipe.MouseButton1Click)
        Configuration.State["Status"] = "Swiping card..."
        task.wait(0.5)
        UnequipTools()
    until not HasCard()
    Configuration.Statistics["Cards Swiped"] += 1
end

local AutofarmRunning = false

local function MainAutofarmController()
    if AutofarmRunning then return end
    AutofarmRunning = true

    while Configuration.Main_Settings["Autofarming"] do
        WaitForReady()

        BuySkiMask()

        local ApartmentOk = StartMarshmallowFarm()
        if not ApartmentOk then task.wait(5) continue end

        PurchaseMarshmallowIngredients()

        local WaterOk = PourWater()
        if not WaterOk then
            repeat StartMarshmallowFarm() WaterOk = PourWater() until WaterOk
        end

        PurchasePotatoIngredients()
        StartPotatoJob()
        CutPotato()
        BagPotato()
        MixFlourAndPotato()
        CookPotatoChips()

        PurchaseFakeID()
        ApplyForCard()

        AddSugarAndGelatin()

        Configuration.State["Status"] = "Waiting for card approval..."
        local cardApproved = false
        repeat
            task.wait()
            local notif = PlayerGui:WaitForChild("Main").BasicNotification.Text
            if notif:find("successful") or notif:find("30 seconds") then
                cardApproved = true
            end
        until cardApproved or PlayerGui:WaitForChild("Main").TaskUpdate.TextLabel.Text:match("Bag")

        if cardApproved then
            Configuration.State["Status"] = "Making marshmallow while card spawns..."
            BagMarshmallowAndSell()
            Configuration.State["Status"] = "Taking card..."
            DirtBikeTeleport(Locations.CollectCard)
            task.wait(0.5)
            ClaimAndUseCard()
        end
        ClaimPotatoChipsAndSell()

        AvailablePot = nil
        PotPrompt    = nil
        PotTimer     = nil
        Stove        = nil
        CookPrompt   = nil
        StoveTimer   = nil
    end

    AutofarmRunning = false
end

local function SendWebhook()
    if Configuration.Webhook_Settings["Webhook Url"] == "" then return end

    local charName    = GetCharName()
    local currentCash = GetCurrentCash()
    local runtime     = Configuration.Statistics["Runtime"]

    local payload = HttpService:JSONEncode({
        username = "Autofarm Webhook",
        embeds = {{
            title = "Autofarm Webhook : ||" .. Player.Name .. "|| : " .. charName,
            color = 65280,
            fields = {
                { name = "[ 💳 ] Cards Swiped",      value = GetCommaValue(Configuration.Statistics["Cards Swiped"]),      inline = true },
                { name = "[ 🍟 ] Chips Fed",          value = GetCommaValue(Configuration.Statistics["Chips Fed"]),          inline = true },
                { name = "[ 🧂 ] Marshmallows Sold",  value = GetCommaValue(Configuration.Statistics["Marshmallows Sold"]), inline = true },
                { name = "[ 💰 ] Cash Made",          value = GetCommaValue(Configuration.Statistics["Cash Made"]),          inline = true },
                { name = "[ 💸 ] Current Cash",       value = currentCash,                                                   inline = true },
                { name = "[ 🕐 ] Autofarm Runtime",   value = FormatRuntime(runtime),                                        inline = true },
                { name = "[ ⌛ ] ETA Until Goal",     value = GetETA(),                                                      inline = true },
                { name = "[ 🔄️ ] Times Rejoined",    value = GetCommaValue(Configuration.Statistics["Times Rejoined"]),    inline = true },
            },
        }},
    })

    local req = syn and syn.request or http and http.request or request
    pcall(req, {
        Url     = Configuration.Webhook_Settings["Webhook Url"],
        Method  = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body    = payload,
    })
end

task.spawn(function()
    local timer = 0
    while task.wait(1) do
        if Configuration.Webhook_Settings["Send Webhooks"] and Configuration.Webhook_Settings["Webhook Url"] ~= "" then
            timer = timer + 1
            local interval = Configuration.Webhook_Settings["Webhook Intervals"] * 60
            if timer >= interval then
                timer = 0
                task.spawn(SendWebhook)
                print("[Webhook] Terkirim otomatis setiap", Configuration.Webhook_Settings["Webhook Intervals"], "menit")
            end
        else
            timer = 0
        end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasgalUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = cloneref(game:GetService("CoreGui"))

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 310)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Masgal V3"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -30, 0.5, -14)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local function createLabel(text, yPos, fontSize)
    fontSize = fontSize or 13
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = fontSize
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = mainFrame
    return label
end

local statusLabel = createLabel("📌 Status: Idle", 40)
local runtimeLabel = createLabel("⏰ Runtime: 00:00:00", 65)
local cashMadeLabel = createLabel("💰 Cash Made: $0", 90)
local currentCashLabel = createLabel("💵 Current Cash: $0", 115)
local chipsLabel = createLabel("🍟 Chips Fed: 0", 140)
local cardsLabel = createLabel("💳 Cards Swiped: 0", 165)
local marshLabel = createLabel("🧂 Marshmallows Sold: 0", 190)

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -20, 0, 36)
startBtn.Position = UDim2.new(0, 10, 0, 225)
startBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
startBtn.Text = "START"
startBtn.TextSize = 14
startBtn.Font = Enum.Font.GothamBold
startBtn.BorderSizePixel = 1
startBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = startBtn

local toggled = false
startBtn.MouseButton1Click:Connect(function()
    toggled = not toggled
    Configuration.Main_Settings["Autofarming"] = toggled
    startBtn.Text = toggled and "STOP" or "START"
    startBtn.BackgroundColor3 = toggled and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(255, 255, 255)
    startBtn.TextColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    if toggled then
        task.spawn(function()
            repeat task.wait(0.5) until SpawnAndSitOnBike() or not Configuration.Main_Settings["Autofarming"]
            if Configuration.Main_Settings["Autofarming"] then
                MainAutofarmController()
            end
        end)
    end
end)

task.spawn(function()
    print("[UI] Loop update dimulai...")
    local StartTime = os.clock()
    task.wait(2)
    local StartCash = GetCurrentCashAmount()
    print("[UI] StartCash =", StartCash)

    while task.wait(1) do
        local success, err = pcall(function()
            local Elapsed = math.floor(os.clock() - StartTime)
            local currentCash = GetCurrentCashAmount()
            local CashMade = currentCash - StartCash

            Configuration.Statistics["Runtime"] = Elapsed
            Configuration.Statistics["Cash Made"] = CashMade

            statusLabel.Text = "📌 Status: " .. (Configuration.State["Status"] or "Idle")
            runtimeLabel.Text = "⏰ Runtime: " .. string.format("%02d:%02d:%02d",
                math.floor(Elapsed / 3600),
                math.floor((Elapsed % 3600) / 60),
                Elapsed % 60
            )
            local cashMadeStr = (CashMade < 0 and "-" or "") .. GetCommaValue(math.abs(CashMade))
            cashMadeLabel.Text = "💰 Cash Made: " .. cashMadeStr
            currentCashLabel.Text = "💵 Current Cash: " .. GetCurrentCash()
            chipsLabel.Text = "🍟 Chips Fed: " .. GetCommaValue(Configuration.Statistics["Chips Fed"])
            cardsLabel.Text = "💳 Cards Swiped: " .. GetCommaValue(Configuration.Statistics["Cards Swiped"])
            marshLabel.Text = "🧂 Marshmallows Sold: " .. GetCommaValue(Configuration.Statistics["Marshmallows Sold"])
        end)
        if not success then
            warn("[UI ERROR] Loop update:", err)
        end
    end
end)

task.spawn(function()
    local LastCash       = 0
    local LastCashTime   = os.clock()
    local LastStatus     = ""
    local LastStatusTime = os.clock()
    task.wait(60)
    LastCash   = GetCurrentCashAmount()
    LastStatus = Configuration.State["Status"]
    while task.wait(30) do
        if not Configuration.Main_Settings["Autofarming"] then
            LastCashTime   = os.clock()
            LastStatusTime = os.clock()
            LastCash       = GetCurrentCashAmount()
            LastStatus     = Configuration.State["Status"]
            continue
        end
        local now         = os.clock()
        local currentCash = GetCurrentCashAmount()
        local currentStatus = Configuration.State["Status"]
        if currentCash ~= LastCash then
            LastCash     = currentCash
            LastCashTime = now
        end
        if currentStatus ~= LastStatus then
            LastStatus     = currentStatus
            LastStatusTime = now
        end
        if (now - LastCashTime) >= 300 or (now - LastStatusTime) >= 300 then
            DoRejoin()
            return
        end
    end
end)

local function ConnectDeathHandler(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    humanoid.Died:Connect(function()
        if Configuration.State["RespawnPending"] then return end
        if Configuration.Main_Settings["Autofarming"] and Configuration.Main_Settings["Auto Rejoiner"] then
            task.wait(3)
            DoRejoin()
        end
    end)
end

ConnectDeathHandler(Player.Character)
Player.CharacterAdded:Connect(ConnectDeathHandler)

Player.Idled:Connect(function()
    if Configuration.Main_Settings["Autofarming"] then
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)
