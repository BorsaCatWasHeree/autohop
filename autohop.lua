-- Xeno MEGA CLIENT V5 (Guaranteed Hop & Anti-Full)
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local ts = game:GetService("TeleportService")
local http = game:GetService("HttpService")

if pGui:FindFirstChild("XenoMegaClient") then pGui.XenoMegaClient:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "XenoMegaClient"
sg.Parent = pGui
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 160)
main.Position = UDim2.new(1, -210, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true 
main.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local function createBtn(name, text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.BuilderSansBold
    btn.Parent = main
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local btn1 = createBtn("RejoinBtn", "REJOIN", UDim2.new(0, 10, 0, 10), Color3.fromRGB(40, 40, 40))
local btn2 = createBtn("HopBtn", "SERVER HOP", UDim2.new(0, 10, 0, 60), Color3.fromRGB(0, 100, 255))

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 1, -30)
status.Text = "Status: Stable ✅"
status.TextColor3 = Color3.fromRGB(0, 255, 150)
status.BackgroundTransparency = 1
status.TextSize = 12
status.Font = Enum.Font.BuilderSansMedium
status.Parent = main

-- REJOIN: Oyundan çık-gir yapmanın en hızlı yolu
btn1.MouseButton1Click:Connect(function()
    btn1.Text = "REJOINING..."
    ts:Teleport(game.PlaceId, player)
    task.delay(3, function() btn1.Text = "REJOIN" end)
end)

-- SERVER HOP: Boş yer garantili sistem
btn2.MouseButton1Click:Connect(function()
    btn2.Text = "SEARCHING..."
    status.Text = "Status: Scanning Deep..."
    
    -- Rastgele bir sayfa seçerek dolu serverlardan kaçıyoruz
    local cursor = ""
    local page = math.random(1, 3) -- İlk 3 sayfadan birine rastgele bak
    
    for i = 1, page do
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local success, res = pcall(function() return http:JSONDecode(game:HttpGet(url)) end)
        if success and res.data then
            if i == page then
                -- Bu sayfadaki serverları karıştır ve birini seç
                for _, s in pairs(res.data) do
                    -- En az 2 kişilik boş yer olanları tercih et (Garanti olsun)
                    if s.playing < (s.maxPlayers - 2) and s.id ~= game.JobId then
                        btn2.Text = "FOUND! HOPPING..."
                        ts:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                        task.delay(3, function() btn2.Text = "SERVER HOP" end)
                        return
                    end
                end
            end
            cursor = res.nextPageCursor
        else
            break
        end
    end
    
    -- Eğer derin tarama başarısız olursa, her ihtimale karşı rastgele at:
    ts:Teleport(game.PlaceId)
    task.delay(3, function() btn2.Text = "SERVER HOP" end)
end)

-- Anti-AFK (VirtualUser Stabilize)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
