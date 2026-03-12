-- LightHub: Final Stable Edition (Blacklist Powered)
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local ts = game:GetService("TeleportService")
local hs = game:GetService("HttpService")
local uis = game:GetService("UserInputService")

-- ESKİ PANELİ TEMİZLE
if player.PlayerGui:FindFirstChild("LightHub_Final") then player.PlayerGui.LightHub_Final:Destroy() end

-- KARA LİSTE MOTORU (Hafıza)
if not _G.VisitedServers then _G.VisitedServers = {} end
if not table.find(_G.VisitedServers, game.JobId) then
    table.insert(_G.VisitedServers, game.JobId)
end

-- UI KURULUMU
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "LightHub_Final"; sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Name = "Main"; main.Size = UDim2.new(0, 200, 0, 245)
main.Position = UDim2.new(0.02, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.Active = true; main.Draggable = true
Instance.new("UICorner", main)

-- LN BUTONU
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 45, 0, 45); openBtn.Position = UDim2.new(0, 5, 0.5, -22)
openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); openBtn.Text = "LN"
openBtn.TextColor3 = Color3.fromRGB(255, 200, 0); openBtn.Font = "FredokaOne"
openBtn.TextSize = 22; openBtn.Visible = false; openBtn.Active = true; openBtn.Draggable = true
Instance.new("UICorner", openBtn)
openBtn.MouseButton1Click:Connect(function() main.Visible = true; openBtn.Visible = false end)

-- BAŞLIK
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", header)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0); title.Position = UDim2.new(0.1, 0, 0, 0)
title.Text = "LIGHTHUB"; title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.Font = "FredokaOne"; title.TextSize = 14; title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- KONTROLLER
local function makeCtrl(txt, x, color, func)
    local b = Instance.new("TextButton", header)
    b.Size = UDim2.new(0, 22, 0, 22); b.Position = UDim2.new(1, x, 0.5, -11)
    b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "FredokaOne"; b.TextSize = 12; Instance.new("UICorner", b); b.MouseButton1Click:Connect(func)
end
makeCtrl("-", -55, Color3.fromRGB(45, 45, 45), function() main.Visible = false; openBtn.Visible = true end)
makeCtrl("X", -28, Color3.fromRGB(200, 50, 50), function() sg:Destroy() end)

-- BUTONLAR
local function addBtn(txt, color, y, func)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0, 180, 0, 38); b.Position = UDim2.new(0.5, -90, 0, y)
    b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "FredokaOne"; b.TextSize = 13; Instance.new("UICorner", b); b.MouseButton1Click:Connect(func); return b
end

-- SERVER HOP (ULTIMATE BLACKLIST)
local hopBtn = addBtn("SERVER HOP", Color3.fromRGB(120, 0, 255), 50, function() end)
hopBtn.MouseButton1Click:Connect(function()
    hopBtn.Text = "Searching..."
    local api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&cursor="..math.random(1,5000)
    local success, res = pcall(function() return hs:JSONDecode(game:HttpGet(api)) end)
    
    if success and res.data then
        local candidates = {}
        for _, srv in pairs(res.data) do
            -- Filtre: Aynı ID olmasın + Ziyaret edilmiş olmasın + 3-7 kişi arası olsun
            if tostring(srv.id) ~= tostring(game.JobId) and not table.find(_G.VisitedServers, srv.id) then
                if srv.playing >= 3 and srv.playing <= 7 then
                    table.insert(candidates, srv.id)
                end
            end
        end
        
        if #candidates > 0 then
            local target = candidates[math.random(1, #candidates)]
            table.insert(_G.VisitedServers, target)
            hopBtn.Text = "Teleporting..."
            ts:TeleportToPlaceInstance(game.PlaceId, target, player)
        else
            hopBtn.Text = "No New Servers!"
            task.wait(1)
            hopBtn.Text = "SERVER HOP"
            ts:Teleport(game.PlaceId, player)
        end
    else
        ts:Teleport(game.PlaceId, player)
    end
end)

addBtn("REJOIN", Color3.fromRGB(0, 150, 100), 95, function()
    ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

addBtn("RESET (F4)", Color3.fromRGB(180, 80, 0), 140, function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
end)

addBtn("EXIT (F5)", Color3.fromRGB(200, 0, 0), 185, function()
    game:Shutdown()
end)

-- KISAYOLLAR
uis.InputBegan:Connect(function(key, typing)
    if typing then return end
    if key.KeyCode == Enum.KeyCode.F4 then 
        if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
    elseif key.KeyCode == Enum.KeyCode.F5 then game:Shutdown() end
end)
