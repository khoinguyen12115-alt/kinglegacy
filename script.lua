repeat task.wait() until game:IsLoaded()
task.wait(2)

local PlaceID = 4520749081
local secondPlaceID = 6381829480
if game.PlaceId == not PlaceID or game.PlaceId == not secondPlaceID then return end

local _version = "1.6.63"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))() 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local Lighting = game.Lighting
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local droppedFruit = workspace.AllDroppedFruit
local spawnedFruit = workspace.AllspawnDF

-- Wait for character
local function updateHumanoidRootPart()
    CharacterModel = workspace.PlayerCharacters:FindFirstChild(LocalPlayer.Name)
    if CharacterModel then HumanoidRootPart = CharacterModel:WaitForChild("HumanoidRootPart") end
end

updateHumanoidRootPart()

-- Autofarm

local function autoHaki()
    local haki = CharacterModel.Services.Haki
    local hakiEvent = game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Armament")

    if haki.Value == 0 then hakiEvent:FireServer() end

    haki.Changed:Connect(function(hakiValue) 
        if hakiValue == 0 then hakiEvent:FireServer() end
    end)
end

local function autoKen()
    local kenOpen = CharacterModel.Services.KenOpen
    local kenHaki = CharacterModel.Services.KenHaki
    local kenEvent = game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("KenEvent")

    if not kenOpen.value then kenEvent:InvokeServer() end    

    kenHaki.Changed:Connect(function(kenValue)
        if (kenValue == 1 or kenValue == 8) and not kenOpen.Value then kenEvent:InvokeServer() end  
    end)
end

-- FruitCollector
local fruitStoreValue = LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("FruitStore")
local success, fruitsInStorage = pcall(function()
    return HttpService:JSONDecode(fruitStoreValue.Value)
end)

if not success then
    warn("Failed to decode FruitStore JSON!")
    fruitsInStorage = {}
end

fruitStoreValue.Changed:Connect(function(newValue)
    fruitsInStorage = HttpService:JSONDecode(newValue)
end)

local fruitConnections = {} -- To store ChildAdded connections for cleanup

local function gotoFruit(fruit)
    if not fruit then return end

    local originalCFrame = HumanoidRootPart.CFrame
    HumanoidRootPart.CFrame = fruit.WorldPivot + Vector3.new(0, 1, 0)
    task.wait(0.75)
    HumanoidRootPart.CFrame = originalCFrame
end

local function isNotInStorage(fruit)
    return fruit and fruitsInStorage[fruit.Name] == nil
end

local function collectExistingFruits()
    for _, fruit in pairs(droppedFruit:GetChildren()) do
        if isNotInStorage(fruit) then
            gotoFruit(fruit)
        end
    end
    for _, fruit in pairs(spawnedFruit:GetChildren()) do
        if isNotInStorage(fruit) then
            gotoFruit(fruit)
        end
    end
end


-- Function to enable auto-collection
local function enableAutoCollect()
    -- Disconnect any existing connections first
    for _, conn in pairs(fruitConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    fruitConnections = {}

    local function onNewFruit(child)
        if isNotInStorage(child) then
            gotoFruit(child)
        end
    end

    table.insert(fruitConnections, droppedFruit.ChildAdded:Connect(onNewFruit))
    table.insert(fruitConnections, spawnedFruit.ChildAdded:Connect(onNewFruit))
end

-- Function to disable auto-collection
local function disableAutoCollect()
    for _, conn in pairs(fruitConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    fruitConnections = {}
end

-- Handle character respawn (important!)
LocalPlayer.CharacterAdded:Connect(function(newChar)
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- Teleport

local seaOneIsland = {
    ["Starter Island"] = Vector3.new(-2172, 91, -4271),
    ["Pirate Island"] = Vector3.new(-832, 66, -3302),
    ["Soldier Town"] = Vector3.new(-2379, 76, -2759),
    ["Shark Island"] = Vector3.new(-857, 38, -1403),
    ["Chef Ship"] = Vector3.new(-4157, 70, -3061),
    ["Snow Island"] = Vector3.new(-5302, 72, -1419),
    ["Desert Island"] = Vector3.new(-2718, 73, -768),
    ["Skyland"] = Vector3.new(-4202, 472, 1262),
    ["Bubbleland"] = Vector3.new(1362, 117, 943),
    ["Lobby Island"] = Vector3.new(-1239, 16, 1837),
    ["Zombie Island"] = Vector3.new(-2585, 316, 3801),
    ["War Island"] = Vector3.new(1933, 55, -2031),
    ["Fishland"] = Vector3.new(-1156, 5, 6163),
    ["Stone Arena"] = Vector3.new(4404, 106, -3729),
    ["Stone Rain Sea"] = Vector3.new(1789, 340, -5207),
    ["Dungeon Island"] = Vector3.new(-4483, 19, -5880)
}

local seaOneIslandOptions = {
    "Starter Island",
    "Pirate Island",
    "Soldier Town",
    "Shark Island",
    "Chef Ship",
    "Snow Island",
    "Desert Island",
    "Skyland",
    "Bubbleland",
    "Lobby Island",
    "Zombie Island",
    "War Island",
    "Fishland",
    "Stone Arena",
    "Stone Rain Sea",
    "Dungeon Island",
}

local seaTwoIsland = {
    ["Japan"] = Vector3.new(-4899, 92, 185),
    ["Skull Island"] = Vector3.new(-5993, 419, 7225),
    ["Desert"] = Vector3.new(1250, 77, 912),
    ["Loaf Island"] = Vector3.new(-514, 179, 8215),
    ["Shred Endangering"] = Vector3.new(-364, 284, -2703),
    ["Soldier Head Quater"] = Vector3.new(-9710, 111, 892),
    ["Skull Pirate Island"] = Vector3.new(-9338, 145, -5179),
    ["Flore"] = Vector3.new(6588, 485, -3120),
    ["Unkown Island 1"] = Vector3.new(2952, 87, -4933),
    ["Awake Fruit"] = Vector3.new(-4418, 81, 2103),
    ["Dugeon Island"] = Vector3.new(-2471, 56, -1582),
    ["Mirror Room"] = Vector3.new(30366, 107, 93597),
}

local seaTwoIslandOptions = {
    "Japan",
    "Skull Island",
    "Desert",
    "Loaf Island",
    "Shred Endangering",
    "Soldier Head Quater",
    "Skull Pirate Island",
    "Flore",
    "Awake Fruit",
    "Dugeon Island",
    "Mirror Room",
} 

local function teleportIslandDropdownUpdate() 
    local localSea

    if game.PlaceId == PlaceID 
    then localSea = seaOneIslandOptions
    else localSea = seaTwoIslandOptions end

return localSea
end

local localSea = {} 
if game.PlaceId == PlaceID then localSea = seaOneIsland
else localSea = seaTwoIsland end

local function teleportIslandOption(option)
    local selected = option

    local pos = localSea[selected]
    if pos and HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0,2.5,0)
    end   
end

-- Vision

local kenConnections = {}  

local function kenClearVision()
    local blur = Lighting:WaitForChild("Blur")
    local kenColor = Lighting:WaitForChild("KenColor")
        
    blur.Enabled = false
    kenColor.Enabled = false
end 

local function enableKenClearVision()
    for _, conn in pairs(kenConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    kenConnections = {}    

    kenClearVision()

    table.insert(kenConnections, Lighting.ChildAdded:Connect(function(child)
            if child and child.Name == "KenColor" then kenClearVision() end
    end))
end

local function disableKenClearVision()
    for _, conn in pairs(kenConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    kenConnections = {}    
    
    local kenColor = Lighting:FindFirstChild("KenColor")
    local blur = Lighting:WaitForChild("Blur")
    
    if kenColor then 
        blur.Enabled = true
        kenColor.Enabled = true    
    end
end

local function bossHighlight()
    local bossFolder = workspace.Monster.Boss

    local function highlight(boss)
        local highlight = Instance.new("Highlight", boss)
        highlight.Name = "bossHighlight"
        highlight.FillColor = Color3.fromRGB(255,223,0)
        highlight.FillTransparency = .5
        highlight.OutlineColor = Color3.fromRGB(255,223,0)
        highlight.OutlineTransparency = 0
        highlight.Adornee = boss

        local name = Instance.new("BillboardGui", boss)
        name.Name = "bossName"
        name.MaxDistance = 25000
        name.Active = true
        name.AlwaysOnTop = true
        name.ExtentsOffset = Vector3.new(0,2.5,0)
        name.Size = UDim2.new(0, 200, 0, 15)
        name.ZIndexBehavior = "Sibling"

        local nameText = Instance.new("TextLabel", name)
        nameText.Position = UDim2.new(0.5, 0, 0.5, 0)
        nameText.Text = boss.Name
        nameText.BackgroundTransparency = 1
        nameText.Size = UDim2.new(1, 0, 1, 0)
        nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameText.TextScaled = true
        nameText.TextSize = 14
        nameText.TextStrokeTransparency = 0
        nameText.TextWrapped = true
        nameText.AnchorPoint = Vector2.new(0.5, 0.5)
        nameText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

    end

    for _, boss in pairs(bossFolder:GetChildren()) do
        if boss:FindFirstChild("bossHighlight") then return end
        highlight(boss)
    end

    bossFolder.ChildAdded:Connect(function (boss)
        if boss:FindFirstChild("bossHighlight") then return end
        highlight(boss)
    end)
end

-- New character

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) 

    CharacterModel = workspace.PlayerCharacters:FindFirstChild(LocalPlayer.Name)
    print("new model")
    updateHumanoidRootPart()
    autoKen()
    autoHaki()
end)

-- Gui

local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open", 
    Author = "by ag_ma_ir",
    Folder = "MySuperHub",

    Transparent = true,
    Resizable = true,
    BackgroundImageTransparency = 0.42,    

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
        end,
    },    

})
Window:SetToggleKey(Enum.KeyCode.B)

Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = false,
    Draggable = true,
})

-- Stats Tab

local Stats = Window:Tab({Title = "Stats", Locked = false,})

local statsParagraph = Stats:Paragraph({Title = "Stats", Locked = false,})

local untilParagraph = Stats:Paragraph({Title = "Second Sea", Desc, Locked = false,})
ReplicatedStorage:GetAttributeChangedSignal("GhostShipSpawnText"):Connect(function()
local untilSeaMonster = ReplicatedStorage:GetAttribute("SeaMonsterSpawnText")    
local untilGhostShip = ReplicatedStorage:GetAttribute("GhostShipSpawnText") 

if untilSeaMonster and untilGhostShip then untilParagraph:SetDesc("Sea King: ".. untilSeaMonster .. " | Ghost Ship: " .. untilGhostShip) end
end)

-- Autofarm Tab

local Autofarm = Window:Tab({Title = "Autofarm", Locked = false,})

local function enableAutoFarm()
    Farm = task.spawn(function()
        local pos = workspace.Monster.Boss["Elite Skeleton [Lv. 3100]"].HumanoidRootPart.CFrame

        while true do
            local args = {"SW_Avalon_M1",{MouseHit = pos}}
            game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction"):InvokeServer(unpack(args))
            
            HumanoidRootPart.CFrame = pos + Vector3.new(0,13,0)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        end        
    end)

end 
local function disableAutoFarm()
    task.cancel(Farm)
    HumanoidRootPart.CFrame = Vector3.new(0,20,0)
    HumanoidRootPart.Anchored = false
end

local autofarmToggle = Autofarm:Toggle({
    Title = "Autofarm",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        if state then enableAutoFarm() else disableAutoFarm() end
    end
})

local autoHakiToggle = Autofarm:Toggle({
    Title = "AutoHaki",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        task.spawn(autoHaki)
    end
})

local autoKenToggle = Autofarm:Toggle({
    Title = "AutoKen",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        task.spawn(autoKen)
    end
})

-- Fruit Tab

local FruitCollector = Window:Tab({Title = "FruitCollector", Locked = false,})

local collectExistingFruitsButton = FruitCollector:Button({
    Title = "Get Existing Fruits",
    Locked = false,
    Callback = function()
        collectExistingFruits()
    end
})

local getNewFruitToggle = FruitCollector:Toggle({
    Title = "Get New Fruit",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        if state then
            enableAutoCollect()
        else
            disableAutoCollect()
        end
    end
})

-- Teleport Tab

local teleport = Window:Tab({Title = "Teleport", Locked = false,})

local islandTeleportDropdown = teleport:Dropdown({
    Title = "Teleport to Island",
    Values = teleportIslandDropdownUpdate(),
    Value = "Teleport to Island",
    SearchBarEnabled = true,
    Callback = function(option) 
        teleportIslandOption(option)
    end
})

local teleportSK = teleport:Button({
    Title = "Teleport to Sea King",
    Locked = false,
    Callback = function()
        local SK = workspace.SeaMonster.SeaKing
        HumanoidRootPart.CFrame = SK.HumanoidRootPart.CFrame + Vector3.new(250,280,250)
    end
})

local teleportGS = teleport:Button({
    Title = "Teleport to Ghost Ship",
    Locked = false,
    Callback = function()
        local GS = workspace.GhostMonster["Ghost Ship"]
        HumanoidRootPart.CFrame = GS.HumanoidRootPart.CFrame + Vector3.new(250,280,250)
    end
})
local teleportHD = teleport:Button({
    Title = "Teleport to Hydra",
    Locked = false,
    Callback = function()
        local HD = workspace.SeaMonster.HydraSeaKing
        HumanoidRootPart.CFrame = HD.HumanoidRootPart.CFrame + Vector3.new(250,280,250)
    end
})

-- Chest Tab

local chest = Window:Tab({Title = "Chest", Locked = false,})

local buyKeyInput = chest:Input({
    Title = "Buy Copper 1~10 Key ",
    Type = "Input", -- or "Textarea"
    Value = 0,
    Callback = function(input) 
    if input then
        local Event = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.BuyKey
        Event:InvokeServer("Copper Key",tonumber(input))
    end
    end
}) 

local autoBuyKey = chest:Toggle({
    Title = "Auto Buy Key",
    Locked = false,
    Type = "Toggle",
    Value = false, 
    Callback = function(state)
    local keyStock = game:GetService("Players").LocalPlayer.PlayerStats.KeyStocks
    keyStock.Changed:Connect(function(newValue)
        print(newValue)
        if newValue:match('%"Copper Key"%s*:%s*(%d+)') == "10" then
            local Event = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.BuyKey
            Event:InvokeServer("Copper Key",10)
            print("Key Bought")
        end
    end)
    end
})

local selectKeyDropdown = chest:Dropdown({
    Title = "Select Key",
    Values = {
        "Copper Key",
        "Iron Key",
        "Gold Key",
        "Platinum Key",
        "Diamond Key",
    },
    Desc,
    Value = "Key",
    Callback = function(option) 
        SelectedKey = option
    end
})
local function ownKeyUpdater()
    local material = HttpService:JSONDecode(LocalPlayer.PlayerStats.Material.Value)

    local Copper = material["Copper Key"] or 0
    local Iron = material["Iron Key"] or 0
    local Gold = material["Gold Key"] or 0
    local Platinum = material["Platinum Key"] or 0
    local Diamond = material["Diamond Key"] or 0
    local keys = string.format(
        "Copper Key: %d\nIron Key: %d\nGold Key: %d\nPlatinum Key: %d\nDiamond Key: %d",
        Copper, Iron, Gold, Platinum, Diamond
    )
    selectKeyDropdown:SetDesc(keys)
end ownKeyUpdater()
LocalPlayer.PlayerStats.Material.Changed:Connect(ownKeyUpdater)

local openOneChestButton = chest:Button({
    Title = "Open 1 Chest",
    Locked = false,
    Callback = function()
    local Event = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.UseKey
    Event:InvokeServer(
        SelectedKey,
        "Open1"
    )
    end
})

local openTenChestButton = chest:Button({
    Title = "Open 10 Chest",
    Locked = false,
    Callback = function()
    local Event = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.UseKey
    Event:InvokeServer(
        SelectedKey,
        "Open10"
    )
    end
})


-- Vision Tab
 
local vision = Window:Tab({Title = "Vision", Locked = false,})

local kenClearVisionToggle = vision:Toggle({
    Title = "Ken Clear Vision",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        if state then enableKenClearVision() else disableKenClearVision() end
    end
})

local bossHighlightToggle = vision:Toggle({
    Title = "Boss Highlight",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        task.spawn(bossHighlight)
    end
})
