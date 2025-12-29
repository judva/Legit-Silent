S, E = pcall(function()
    if _G.Stepped then
        _G.Stepped:Disconnect()
    end
    if _G.InputBegan then
        _G.InputBegan:Disconnect()
    end
end)

if S then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Silent Aim",
        Text = "Silent Aim was reset, Mode: Natural Release",
        Duration = 3
    })

    _G.Stepped = nil
    _G.InputBegan = nil
end

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Playground = (game.PlaceId == 4923146720)
local IsInFooting = false
local IsCameraLocked = false
local OriginalCameraType = nil

local GetRootPart = function()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChild("HumanoidRootPart") 
        or Char:FindFirstChild("UpperTorso") 
        or Char:FindFirstChild("Torso")
end

local HL = Instance.new("Highlight")
HL.Enabled = false
HL.Adornee = Player.Character
HL.FillColor = Color3.fromRGB(25, 255, 25)
HL.OutlineColor = Color3.fromRGB(0, 255, 0)
HL.Parent = game:GetService("CoreGui")

local Goals = {} do
    for _, Obj in next, game:GetDescendants() do
        if Obj.Name == "Goal" and Obj:IsA("BasePart") then
            table.insert(Goals, Obj)
        elseif Obj.Name == "Part" and Obj:IsA("BasePart") and Obj.Size == Vector3.new(5, 1, 5) then
            table.insert(Goals, Obj)
        end
    end
end

local Shuffled, Selected do
    for _, Garbage in next, getgc(true) do
        if type(Garbage) == "function" and getinfo(Garbage)["name"] == "selected1" then
            Selected = Garbage
        elseif type(Garbage) == "table" and rawget(Garbage, "1") and rawget(Garbage, "1") ~= true then
            Shuffled = Garbage
        end
    end
end

local Clicker do
    if Playground == false then
        Clicker = getupvalue(Selected, 3)
    else
        Clicker = getupvalue(Selected, 5)
    end
end

local GetClock = function()
    local OldClock = getupvalue(Selected, 3)
    local NewClock = OldClock + 1
    
    setupvalue(Selected, 3, NewClock)
    
    return NewClock
end

local GetKeyFromKeyTable = function()
    local Keys = getupvalue(Selected, 4)
    
    if Playground == true then
        return "Shotta_"
    elseif type(Keys[1]) == "string" then
        return Keys[1]
    end
    
    return "Shotta"
end

local RemoveKeyFromKeyTable = function()
    local StartTime = tick()
    
    repeat task.wait() until Player.Character == nil or Player.Character:FindFirstChild("Basketball") == nil or StartTime - tick() > 1.5
    
    if Player.Character == nil or StartTime - tick() > 1.5 then
        return print("Didnt remove key")
    end
    
    local Keys = getupvalue(Selected, 4)
    
    if type(Keys) == "table" then
        print("Removed key")
        table.remove(Keys, 1)
        setupvalue(Selected, 4, Keys)
    end
end

local GetRandomizedTable = function(TorsoPosition, ShootPosition)
    local UnrandomizedArgs = {
        X1 = TorsoPosition.X,
        Y1 = TorsoPosition.Y,
        Z1 = TorsoPosition.Z,
        X2 = ShootPosition.X,
        Y2 = ShootPosition.Y,
        Z2 = ShootPosition.Z
    }
    
    local RandomizedArgs = {
        UnrandomizedArgs[Shuffled["1"]],
        UnrandomizedArgs[Shuffled["2"]],
        UnrandomizedArgs[Shuffled["3"]],
        UnrandomizedArgs[Shuffled["4"]],
        UnrandomizedArgs[Shuffled["5"]],
        UnrandomizedArgs[Shuffled["6"]],
    }
    
    return RandomizedArgs
end

local GetGoal = function()
    local Distance, Goal = 9e9
    
    for _, Obj in next, Goals do
        local Magnitude = (Player.Character.Torso.Position - Obj.Position).Magnitude
        
        if Distance > Magnitude then
            Distance = Magnitude
            Goal = Obj
        end
    end
    
    return Goal
end

local GetDistance = function()
    local Goal = GetGoal()
    local TorsoPosition = Player.Character.Torso.Position
    
    return (TorsoPosition - Goal.Position).Magnitude
end

local GetDirection = function(Position)
    return (Position - Player.Character.Torso.Position).Unit
end

local GetMoveDirection = function()
    local Direction = Player.Character.Humanoid.MoveDirection * 1.8
    
    if UIS:IsKeyDown(Enum.KeyCode.S) == true and UIS:IsKeyDown(Enum.KeyCode.W) == true then
        Direction = Player.Character.Humanoid.MoveDirection * 0.5
    elseif UIS:IsKeyDown(Enum.KeyCode.S) == true and UIS:IsKeyDown(Enum.KeyCode.W) == false then
        Direction = Player.Character.Humanoid.MoveDirection * 0.8
    elseif UIS:IsKeyDown(Enum.KeyCode.S) == false and UIS:IsKeyDown(Enum.KeyCode.W) == true then
        Direction = Player.Character.Humanoid.MoveDirection * 1.2
    end
        
    return Direction
end

local GetBasketball = function()
    return Player.Character:FindFirstChildOfClass("Folder")
end

local InFootingCheck = function()
    local Distance = GetDistance()
    local Basketball = GetBasketball()
    
    local Power do 
        if Basketball ~= nil then
            Power = Basketball.PowerValue.Value
        else
            IsInFooting = false
            return
        end
    end
    
    if Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        if Power == 75 or Power == 100 then
            Distance = Distance - 1
        else
            Distance = Distance - 3
        end
    end
    
    if Power == 75 then
        if Distance > 57 and Distance < 61 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 80 then
        if Distance > 57 and Distance < 64 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 85 then
        if Distance > 57 and Distance < 70 then
            IsInFooting = true
        else
            IsInFooting = false
            end
    elseif Power == 90 then
        if Distance > 57 and Distance < 74 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 95 then
        if Distance > 57 and Distance < 82 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 100 then
        if Distance > 57 and Distance < 87 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power < 75 then
        IsInFooting = false
    end
end

local GetArc = function()
    local Distance = GetDistance()
    local Basketball = GetBasketball()
    
    local Arc = nil
    
    local Power do
        if Basketball ~= nil then
            Power = Basketball.PowerValue.Value
        else
            return
        end
    end
    
    if Power == 75 then
        if Distance > 57 and Distance < 58.5 then
            Arc = 52
        elseif Distance > 58.5 and Distance < 59.5 then
            Arc = 48
        elseif Distance > 59.5 and Distance < 60.5 then
            Arc = 44
        elseif Distance > 60.5 and Distance < 61 then
            Arc = 41
        end
    elseif Power == 80 then
        if Distance > 57 and Distance < 58.5 then
            Arc = 72
        elseif Distance > 58.5 and Distance < 61 then
            Arc = 68
        elseif Distance > 61 and Distance < 63.5 then
            Arc = 64
        elseif Distance > 63.5 and Distance < 65 then
            Arc = 58
        elseif Distance > 65 and Distance < 69 then
            Arc = 52
        end
    elseif Power == 85 then
        if Distance > 57 and Distance < 60 then
            Arc = 83
        elseif Distance > 60 and Distance < 63.5 then
            Arc = 80
        elseif Distance > 63.5 and Distance < 67 then
            Arc = 77
        elseif Distance > 67 and Distance < 70 then
            Arc = 72
        elseif Distance > 70 and Distance < 74 then
            Arc = 62
        end
    elseif Power == 90 then
        if Distance > 57 and Distance < 60 then
            Arc = 98
        elseif Distance > 60 and Distance < 63.5 then
            Arc = 94
        elseif Distance > 63.5 and Distance < 67 then
            Arc = 90
        elseif Distance > 67 and Distance < 70 then
            Arc = 87
        elseif Distance > 70 and Distance < 74 then
            Arc = 82
        elseif Distance > 74 and Distance < 77 then
            Arc = 74
        elseif Distance > 77 and Distance < 79 then
            Arc = 66
        end
    elseif Power == 95 then
        if Distance > 57 and Distance < 59 then
            Arc = 118
        elseif Distance > 59 and Distance < 62 then
            Arc = 114
        elseif Distance > 62 and Distance < 65 then
            Arc = 110
        elseif Distance > 65 and Distance < 68 then
            Arc = 106
        elseif Distance > 68 and Distance < 71 then
            Arc = 102
        elseif Distance > 71 and Distance < 74 then
            Arc = 98
        elseif Distance > 74 and Distance < 77 then
            Arc = 94
        elseif Distance > 77 and Distance < 80 then
            Arc = 89
        elseif Distance > 80 and Distance < 82 then
            Arc = 68
        elseif Distance > 82 and Distance < 86 then
            Arc = 62
        end
    elseif Power == 100 then
        if Distance > 57 and Distance < 62 then
            Arc = 128
        elseif Distance > 62 and Distance < 66 then
            Arc = 124
        elseif Distance > 66 and Distance < 70 then
            Arc = 120
        elseif Distance > 70 and Distance < 74 then
            Arc = 116
        elseif Distance > 74 and Distance < 77 then
            Arc = 112
        elseif Distance > 77 and Distance < 80 then
            Arc = 108
        elseif Distance > 80 and Distance < 83 then
            Arc = 104
        elseif Distance > 83 and Distance < 86 then
            Arc = 98
        elseif Distance > 86 and Distance < 89 then
            Arc = 86
        elseif Distance > 89 and Distance < 93 then
            Arc = 68
        end
    end
    
    if Playground == true and Arc ~= nil then
        Arc = Arc - 5
    end
    
    return Arc
end

local SmoothCameraToTarget = function(TargetPosition)
    if IsCameraLocked then return end
    
    IsCameraLocked = true
    OriginalCameraType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    
    local StartCFrame = Camera.CFrame
    local HeadPosition = Player.Character.Head.Position
    
    local LookTarget = TargetPosition + Vector3.new(0, 3, 0)
    local TargetCFrame = CFrame.new(HeadPosition, LookTarget)
    
    local Duration = 0.35
    local StartTime = tick()
    
    local Connection
    Connection = RS.RenderStepped:Connect(function()
        local Elapsed = tick() - StartTime
        local Alpha = math.min(Elapsed / Duration, 1)
        local EasedAlpha = 1 - math.pow(1 - Alpha, 3)
        
        if Player.Character and Player.Character:FindFirstChild("Head") then
            local CurrentHeadPos = Player.Character.Head.Position
            local CurrentTargetCFrame = CFrame.new(CurrentHeadPos, LookTarget)
            
            Camera.CFrame = StartCFrame:Lerp(CurrentTargetCFrame, EasedAlpha)
        end
        
        if Alpha >= 1 then
            Connection:Disconnect()
            
            task.wait(0.15)
            
            Camera.CameraType = OriginalCameraType or Enum.CameraType.Custom
            IsCameraLocked = false
        end
    end)
end

local GetVelocityCompensation = function()
    local RootPart = GetRootPart()
	if not RootPart then return Vector3.new(0,0,0) end -- so it works on pg
	local Velocity = RootPart.AssemblyLinearVelocity
    local IsJumping = Player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall

    local Compensation = Vector3.new(
        Velocity.X * 0.12,
        IsJumping and math.clamp(Velocity.Y * 0.08, -0.3, 0.8) or 0,
        Velocity.Z * 0.12
    )
    
    return Compensation
end
getgenv().Shoot = function()
    local Goal = GetGoal()
    local Arc = GetArc()
    local MoveDirection = GetMoveDirection()
    local VelocityComp = GetVelocityCompensation()

    local TorsoPosition = Player.Character.Torso.Position
  
    local TargetPosition = Goal.Position + Vector3.new(0, Arc, 0) + MoveDirection + VelocityComp
    local MissChance = math.random(1, 100)
    local NaturalVariance = Vector3.new(0, 0, 0)
    
    if MissChance <= 10 then
        NaturalVariance = Vector3.new(
            math.random(-25, 25) / 100,
            math.random(-15, 15) / 100,
            math.random(-25, 25) / 100
        )
    else
        NaturalVariance = Vector3.new(
            math.random(-5, 5) / 100,
            math.random(-3, 3) / 100,
            math.random(-5, 5) / 100
        )
    end
    
    local Hit = TargetPosition + NaturalVariance
    local Direction = (Hit - TorsoPosition).Unit
    local RandomizedArgs = GetRandomizedTable(TorsoPosition, Direction)
    
    local Basketball = GetBasketball()
    local Key = GetKeyFromKeyTable()
    
    if Playground == true then
        local Clock = GetClock()
        Key = Key .. Clock
    end
   
    SmoothCameraToTarget(Goal.Position)
    
    Clicker:FireServer(Basketball, Basketball.PowerValue.Value, RandomizedArgs, Key)
    
    if GetBasketball() ~= nil then
        RemoveKeyFromKeyTable()
    end
end

_G.InputBegan = UIS.InputBegan:Connect(function(Key, GPE)
    if not GPE and Key.KeyCode == Enum.KeyCode.X and Player.Character and Player.Character:FindFirstChild("Basketball") and IsInFooting then
        if Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.26)
        end
        
        Shoot()
    end
end)

_G.Stepped = RS.Stepped:Connect(function()
    InFootingCheck()
    
    if IsInFooting then
        HL.Enabled = true
    else
        HL.Enabled = false
    end
    
    if HL.Adornee.Parent == nil and Player.Character then
        HL.Adornee = Player.Character
    end
end)
