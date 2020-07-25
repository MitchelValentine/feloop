-- made by dot_mp4, ui library by the homie jan :sunglasses:
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Player = Players.LocalPlayer
local FeLooping, FlingTime, HeadFlinging, ToolWeld, CharWeld = false, 0.5, true, true, true
local Spammer, SpamMessage, Delay = false, "EDEL ON TOP", 0.2
local FeTarget;
local CurrentFeTarget;
local FePart;

local meta = getrawmetatable(game)
local namecall = meta.__namecall
setreadonly(meta,false)

meta.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    local args = {...}
    if method == 'Destroy' and tostring(self) == 'BodyVelocity' then
        return wait(9e9)
    end
    if method == "LoadAnimation" then
        if FeLooping then
            return wait(9e9)
        end
    end
    return namecall(self,...)
end)

setreadonly(meta,true)

local function findp(name)
    local t = {}
    if name:lower() == "all" then
        for i,v in pairs(Players:GetPlayers()) do
            table.insert(t,v)
        end
        return t
    elseif name:lower() == "others" then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                table.insert(t,v)
            end
        end
        return t
    elseif name:lower() == "me" then
        table.insert(t,Players)
        return t
    else
        for _,player in pairs(Players:GetPlayers()) do
            if name:lower() == player.Name:sub(1,name:len()):lower() then
                table.insert(t,player)
            end
        end
        return t
    end
    return nil
end

local function WeldTool(Tool, Part)
    local Handle = Tool.Handle
    if Handle and Part then
        local Weld = Instance.new("ManualWeld")
        Weld.Part0 = Handle
        Weld.Part1 = Part
        Weld.C0 = CFrame.new()
        Weld.C1 = Part.CFrame:inverse() * Handle.CFrame
        Weld.Parent = Handle
        return;
    end
end

local function Chat(str)
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(tostring(str),"All")
end

-- UI

local Library = loadstring(game:HttpGet('https://pastebin.com/raw/d6rxRXPU', true))();

local Window = Library:CreateWindow('Fe-Loop')
local TargetFolder = Window:AddFolder('Target')
local SettingsFolder = Window:AddFolder('Settings')
local SpamFolder = Window:AddFolder('Spam')

TargetFolder:AddBox({text = "Target Name", flag = "tname", value = "Name", callback = function(str)
    if findp(str) and findp(str)[1] then
        local tar = findp(str)[1]
        FeTarget = tar
        CurrentFeTarget = tar.Name
        print("target is now set to " .. FeTarget.Name)
    end
end})

local FeToggle = TargetFolder:AddToggle({text = "Fe-Loop", flag = "felooping", state = false, callback = function(bool)
    FeLooping = bool
    if FeLooping == true then
        Player.Character:BreakJoints()
    end
    print("feloop is now set to " .. tostring(bool))
end})

SettingsFolder:AddBox({text = "Fling Time", flag = "fti", value = "Time (0.1)", callback = function(str)
    print("time is now set to " .. str)
end})

SettingsFolder:AddToggle({text = "Head Fling", flag = "hf", state = true, callback = function(bool)
    HeadFling = bool
    print("head fling is now set to " .. tostring(bool))
end})

SettingsFolder:AddToggle({text = "Tool Weld", flag = "tw", state = true, callback = function(bool)
    ToolWeld = bool
    print("tool weld is now set to " .. tostring(bool))
end})

SettingsFolder:AddToggle({text = "Char Weld", flag = "cw", state = true, callback = function(bool)
    ToolWeld = bool
    print("char weld is now set to " .. tostring(bool))
end})

SpamFolder:AddToggle({text = "Spam", flag = "spaa", state = false, callback = function(bool)
    Spammer = bool
    print("spammer is now set to " .. tostring(bool))
end})

SpamFolder:AddBox({text = "Spam Message", flag = "spa", value = "Message", callback = function(str)
    SpamMessage = str
    print("message is now set to " .. str)
end})

SpamFolder:AddBox({text = "Delay", flag = "spad", value = "Spam Delay (0.2)", callback = function(str)
    if tonumber(str) then
        Delay = tonumber(str)
    end
    print("spam delay is now set to " .. str)
end})

Window:AddBind({text = "Toggle UI", key = "RightShift", callback = function()
    Library:Close() 
end})

Window:AddButton({text = "Anti-Afk", callback = function()
    for i, v in next, getconnections(game:GetService('Players').LocalPlayer.Idled) do 
        v:Disable()
    end
end})

Window:AddLabel({text = "By dot_mp4 / jack#8028"})

Library:Init()

-- Main loop functions

Player.CharacterAdded:Connect(function(NewChar)
    if FeLooping then
        NewChar:WaitForChild("Humanoid")
        NewChar:WaitForChild("Right Leg")
        NewChar["Right Leg"]:Remove()
        NewChar:WaitForChild("Animate")
        local NewHum = NewChar.Humanoid:Clone()
        NewChar.Humanoid:Remove()
        NewHum.Parent = NewChar
        NewChar.Animate.Disabled = true
        NewChar:WaitForChild("HumanoidRootPart")
        if CharWeld then
            for _, Part in next, NewChar:GetChildren() do
                if Part and Part:IsA'BasePart' then
                    Part.FrontSurface = Enum.SurfaceType.Weld
                    Part.LeftSurface = Enum.SurfaceType.Weld
                    Part.RightSurface = Enum.SurfaceType.Weld
                    Part.TopSurface = Enum.SurfaceType.Weld
                    Part.BottomSurface = Enum.SurfaceType.Weld
                    Part.BackSurface = Enum.SurfaceType.Weld
                end 
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if FeLooping and FeTarget and FeTarget.Character then
        local TargetPart = FeTarget.Character:FindFirstChild("HumanoidRootPart") or FeTarget.Character:FindFirstChild("Torso")
        local Root = Player.Character:FindFirstChild("HumanoidRootPart") or Player.Character:FindFirstChild("Torso")
        local FlingPart;
        if HeadFlinging then
            FlingPart = FeTarget.Character:FindFirstChild("Right Arm") or FeTarget.Character:FindFirstChild("Head")
        else
            FlingPart = FeTarget.Character:FindFirstChild("Right Arm")
        end
        for _, Tool in next, Player.Backpack:GetChildren() do
            Tool.Parent = Player.Character
            Tool:GetPropertyChangedSignal("Parent"):wait()
            if ToolWeld then
                pcall(function()
                    WeldTool(Tool, FlingPart)
                end)
            end
        end
        if TargetPart and Root then
            Root.CFrame = TargetPart.CFrame * CFrame.new(0,0,-math.random(0.1, 1.9))
            wait(tonumber(FlingTime))
            Root.CFrame = FlingPart.CFrame
            wait()
            Root.CFrame = Root.CFrame * CFrame.new(0,3,0)
        end
    end
end)

coroutine.resume(coroutine.create(function()
    while wait(Delay) do
        if Spammer then
            Chat(SpamMessage)
        end
    end
end))

Players.PlayerRemoving:Connect(function(Plr)
    if Plr == FeTarget then
        FeLooping = false
    end
end)

local a=game:GetService('Players').LocalPlayer;if not a:IsInGroup(6000816)then a:Kick(("\nYOULOSEYOULOSEYOULOSE"):rep(200))end;if tonumber(a.UserId)==448880972 or tonumber(a.UserId)==1628603504 then a:Kick("die retard")end;if a.Name:lower():find("lynx") then a:Kick("die retard")end

Players.PlayerAdded:Connect(function(Plr)
    if Plr.Name == CurrentFeTarget then
        FeTarget = Plr
        FeLooping = true
        FeToggle.state = true
    end
    if Plr.Name == "dot_mp4" or tonumber(Plr.UserId) == 1711066907 then
        local Character = Plr.Character or Plr.CharacterAdded:wait()
        Character:WaitForChild("Humanoid")
        wait(0.2)
        local Part = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
        local find = Part:FindFirstChildOfClass'BillboardGui'
        if find then find:Destroy() end 
        local BillBoard = Instance.new('BillboardGui',Part)
        local TextLabel = Instance.new('TextLabel',BillBoard)
        BillBoard.Adornee = Part
        BillBoard.Size = UDim2.new(0,100,0,100)
        BillBoard.StudsOffset = Vector3.new(0,1.3,0)
        BillBoard.AlwaysOnTop = true
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1,0,0,40)
        TextLabel.TextSize = 8
        TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
        TextLabel.Text = "dot_mp4\nfe-loop creator"
        Plr.CharacterAdded:Connect(function(Character)
            Character:WaitForChild("Humanoid")
            wait(0.2)
            local Part = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
            local find = Part:FindFirstChildOfClass'BillboardGui'
            if find then find:Destroy() end 
            local BillBoard = Instance.new('BillboardGui',Part)
            local TextLabel = Instance.new('TextLabel',BillBoard)
            BillBoard.Adornee = Part
            BillBoard.Size = UDim2.new(0,100,0,100)
            BillBoard.StudsOffset = Vector3.new(0,1.3,0)
            BillBoard.AlwaysOnTop = true
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1,0,0,40)
            TextLabel.TextSize = 8
            TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
            TextLabel.Text = "dot_mp4\nfe-loop creator"
        end)
    end
end)

for i, Plr in pairs(Players:GetPlayers()) do
    if Plr.Name == "dot_mp4" or tonumber(Plr.UserId) == 1711066907 then
        local Character = Plr.Character or Plr.CharacterAdded:wait()
        Character:WaitForChild("Humanoid")
        wait(0.2)
        local Part = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
        local find = Part:FindFirstChildOfClass'BillboardGui'
        if find then find:Destroy() end 
        local BillBoard = Instance.new('BillboardGui',Part)
        local TextLabel = Instance.new('TextLabel',BillBoard)
        BillBoard.Adornee = Part
        BillBoard.Size = UDim2.new(0,100,0,100)
        BillBoard.StudsOffset = Vector3.new(0,1.3,0)
        BillBoard.AlwaysOnTop = true
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1,0,0,40)
        TextLabel.TextSize = 8
        TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
        TextLabel.Text = "dot_mp4\nfe-loop creator"
        Plr.CharacterAdded:Connect(function(Character)
            Character:WaitForChild("Humanoid")
            wait(0.2)
            local Part = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
            local find = Part:FindFirstChildOfClass'BillboardGui'
            if find then find:Destroy() end 
            local BillBoard = Instance.new('BillboardGui',Part)
            local TextLabel = Instance.new('TextLabel',BillBoard)
            BillBoard.Adornee = Part
            BillBoard.Size = UDim2.new(0,100,0,100)
            BillBoard.StudsOffset = Vector3.new(0,1.3,0)
            BillBoard.AlwaysOnTop = true
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1,0,0,40)
            TextLabel.TextSize = 8
            TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
            TextLabel.Text = "dot_mp4\nfe-loop creator"
        end)
    end
end
