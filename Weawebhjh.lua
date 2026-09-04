local Soufiw = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosopjs/menuft/refs/heads/main/menu"))();
local Notification = Soufiw:CreateNotifier();
Soufiw:Loader({ Name = "Soufiw", Duration = 4 });
Notification:Notify({ Title = "Soufiw", Content = "Hello, " .. game.Players.LocalPlayer.DisplayName .. " Welcome back!", Icon = "clipboard" });

local Window = Soufiw.new({ Name = "Soufiw", Expire = "never" });

-- ===== КАСТОМНЫЙ КУРСОР =====
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")

pcall(function()
    mouse.Icon = "rbxasset://textures/GuiNone.png"
end)

local customCursor = Instance.new("ImageLabel")
customCursor.Size = UDim2.new(0, 32, 0, 32)
customCursor.BackgroundTransparency = 1
customCursor.Image = "rbxassetid://12743852986"
customCursor.ZIndex = 999
customCursor.Parent = game.CoreGui

local function updateCursor()
    local pos = uis:GetMouseLocation()
    customCursor.Position = UDim2.new(0, pos.X - 16, 0, pos.Y - 16)
end

uis.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateCursor()
    end
end)

game:GetService("RunService").RenderStepped:Connect(updateCursor)

pcall(function()
    local starterGui = game:GetService("StarterGui")
    starterGui:SetCore("MouseIconEnabled", false)
end)

print("Custom cursor enabled!")

local movement = Window:AddMenu({ Name = "movement", Icon = "cloud" });
local General = movement:AddSection({ Position = "left", Name = "GENERAL" });
local Visual = Window:AddMenu({ Name = "visual", Icon = "eye" });
local EspSection = Visual:AddSection({ Position = "left", Name = "ESP" });
local ChamsSection = Visual:AddSection({ Position = "right", Name = "CHAMS" });
local Aim = Window:AddMenu({ Name = "aim", Icon = "crosshair" });
local AimbotSection = Aim:AddSection({ Position = "left", Name = "AIMBOT" });
local SilentSection = Aim:AddSection({ Position = "right", Name = "SILENT AIM (not work:(" });
local Misc = Window:AddMenu({ Name = "misc", Icon = "cog" });
local PersonSection = Misc:AddSection({ Position = "left", Name = "PERSON" });
local CustomSection = Misc:AddSection({ Position = "right", Name = "CUSTOM" });

-- ===== ADONIS BYPASS =====
local function scanAndBypassAdonis()
    local found = false;
    local gcSuccess, gc = pcall(getgc, true);
    if not gcSuccess then gc = {} end;
    for _, obj in ipairs(game:GetDescendants()) do
        local name = obj.Name:lower()
        if name:match("adonis") then found = true break end
    end;
    if not found then
        for _, v in pairs(gc) do
            if type(v) == "table" then
                local indexInstance = rawget(v, "indexInstance")
                if type(indexInstance) == "table" and indexInstance[1] == "kick" then found = true break end;
                if rawget(v, "tvk") then found = true break end
            end
        end
    end;
    if found then
        Notification:Notify({ Title = "adonis detect", Content = "Anti-cheat (Adonis) detected. Bypass activated!", Icon = "shield", Duration = 5 })
        local function bypassKick()
            for k, v in pairs(getgc(true)) do
                pcall(function()
                    if type(v) == "table" and rawget(v, "indexInstance") then
                        local idx = rawget(v, "indexInstance")
                        if type(idx) == "table" and idx[1] == "kick" then
                            setreadonly(v, false)
                            v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
                        end
                    end
                end)
            end
        end;
        bypassKick()
        game:GetService("RunService").Heartbeat:Connect(bypassKick)
    else
        Notification:Notify({ Title = "Anti-Cheat Scan", Content = "Adonis anti-cheat not found or not working. Bypass not activated.", Icon = "info", Duration = 4 })
    end
end;
scanAndBypassAdonis()

-- ===== GENERAL FUNCTIONS =====
local noFallActive = false;
local noFallConnections = {};
General:AddToggle({
    Name = "No Fall Damage",
    Callback = function(state)
        local lp = game.Players.LocalPlayer;
        local rs = game:GetService("RunService");
        local hb = rs.Heartbeat;
        local rsd = rs.RenderStepped;
        local z = Vector3.zero;
        noFallActive = state;
        local function protectCharacter(character)
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end;
            local con = hb:Connect(function()
                if not hrp.Parent then con:Disconnect() return end;
                local v = hrp.AssemblyLinearVelocity;
                hrp.AssemblyLinearVelocity = z;
                rsd:Wait();
                hrp.AssemblyLinearVelocity = v
            end)
            table.insert(noFallConnections, con)
        end;
        if state then
            protectCharacter(lp.Character)
            local connAdded = lp.CharacterAdded:Connect(protectCharacter)
            table.insert(noFallConnections, connAdded)
        else
            for _, con in ipairs(noFallConnections) do con:Disconnect() end;
            noFallConnections = {}
        end
    end
})

-- ===== SPEEDHACK (2 метода) =====
local speedMethod = "WalkSpeed"
local currentSpeed = 16
local speedConnection = nil
local speedhackEnabled = false

local function applyCFrameSpeed(character, speed)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if speedMethod == "CFrame" and speed > 16 and speedhackEnabled then
        local moveSpeed = speed / 16
        local stepSize = 0.3 * moveSpeed
        local uis = game:GetService("UserInputService")
        
        speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not humanoid.Parent then 
                speedConnection:Disconnect()
                speedConnection = nil
                return 
            end
            
            local moveVector = Vector3.zero
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            forward = Vector3.new(forward.X, 0, forward.Z).Unit
            right = Vector3.new(right.X, 0, right.Z).Unit
            
            if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + forward end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - forward end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - right end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + right end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * stepSize
                hrp.CFrame = hrp.CFrame + moveVector
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            end
        end)
    end
end

local function applyWalkSpeed(character, speed)
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function applySpeed(character)
    if not character or not speedhackEnabled then return end
    
    if speedMethod == "WalkSpeed" then
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        applyWalkSpeed(character, currentSpeed)
    else
        applyWalkSpeed(character, 16)
        applyCFrameSpeed(character, currentSpeed)
    end
end

player.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if speedhackEnabled then
        applySpeed(character)
    end
end)

local speedToggle = General:AddToggle({
    Name = "Speedhack",
    Option = true,
    Callback = function(state)
        speedhackEnabled = state
        if state then
            applySpeed(player.Character)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            applyWalkSpeed(player.Character, 16)
        end
    end
})

General:AddSlider({
    Name = "Speed Value",
    Default = 16,
    Min = 1,
    Max = 256,
    Round = 0,
    Callback = function(value)
        currentSpeed = value
        local character = player.Character
        if character and speedhackEnabled then
            applySpeed(character)
        end
    end
})

speedToggle.Option:AddDropdown({
    Name = "Method",
    Default = "WalkSpeed",
    Values = {"WalkSpeed", "CFrame"},
    Callback = function(value)
        speedMethod = value
        local character = player.Character
        if character and speedhackEnabled then
            applySpeed(character)
        end
    end
})

-- ===== JUMPHACK =====
local currentJump = 50;
General:AddSlider({
    Name = "Jumphack",
    Default = 50,
    Min = 1,
    Max = 999,
    Round = 0,
    Callback = function(value)
        currentJump = value;
        local player = game.Players.LocalPlayer;
        local character = player.Character;
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then humanoid.JumpPower = value end
        end
    end
});
local function applyJump(character)
    if not character then return end;
    local humanoid = character:WaitForChild("Humanoid")
    if humanoid then humanoid.JumpPower = currentJump end
end;
game.Players.LocalPlayer.CharacterAdded:Connect(applyJump)

-- ===== INFINITE JUMP =====
local infJumpActive = false;
local infJumpConnection = nil;
General:AddToggle({
    Name = "Infinite Jump",
    Callback = function(state)
        local player = game.Players.LocalPlayer;
        infJumpActive = state;
        if state then
            local function autoJump()
                local character = player.Character;
                if not character then return end;
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Jump then humanoid:ChangeState("Jumping") end
            end;
            infJumpConnection = game:GetService("RunService").Heartbeat:Connect(autoJump)
        else
            if infJumpConnection then infJumpConnection:Disconnect(); infJumpConnection = nil end
        end
    end
})

-- ===== FLY =====
local flyActive = false;
local flyConnection = nil;
local flyBodyVelocity = nil;
local flyBodyGyro = nil;
local flySpeed = 50;
local flySpeedSlider = General:AddSlider({
    Name = "Fly Speed",
    Default = 50,
    Min = 1,
    Max = 200,
    Round = 0,
    Callback = function(value) flySpeed = value end
});
local function startFly(character)
    if not flyActive then return end;
    if not character then return end;
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end;
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end;
    humanoid.PlatformStand = true;
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 1e6;
    bv.Velocity = Vector3.zero;
    bv.Parent = hrp;
    flyBodyVelocity = bv;
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1, 1, 1) * 1e6;
    bg.Parent = hrp;
    flyBodyGyro = bg;
    local function updateFly()
        if not flyActive then return end;
        local camera = workspace.CurrentCamera;
        if not camera then return end;
        local camCF = camera.CFrame;
        local targetCF = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
        if flyBodyGyro then flyBodyGyro.CFrame = targetCF end;
        local forward = camCF.LookVector;
        local right = camCF.RightVector;
        local up = camCF.UpVector;
        local uis = game:GetService("UserInputService")
        local moveVector = Vector3.zero;
        if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + forward end;
        if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - forward end;
        if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - right end;
        if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + right end;
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + up end;
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - up end;
        if moveVector.Magnitude > 0 then moveVector = moveVector.Unit * flySpeed else moveVector = Vector3.zero end;
        if flyBodyVelocity then flyBodyVelocity.Velocity = moveVector end
    end;
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end;
    flyConnection = game:GetService("RunService").Heartbeat:Connect(updateFly)
end;
local function stopFly(character)
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end;
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end;
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end;
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end;
General:AddToggle({
    Name = "Fly",
    Callback = function(state)
        local player = game.Players.LocalPlayer;
        flyActive = state;
        if state then
            startFly(player.Character)
            player.CharacterAdded:Connect(function(character)
                if flyActive then startFly(character) end
            end)
        else
            stopFly(player.Character)
        end
    end
})

-- ===== AIRSWIM =====
local airSwimActive = false;
local airSwimConnection = nil;
local airSwimBodyVelocity = nil;
local airSwimBodyGyro = nil;
local airSwimSpeed = 30;
local airSwimCurrentVelocity = Vector3.zero;
local airSwimSpeedSlider = General:AddSlider({
    Name = "AirSwim Speed",
    Default = 30,
    Min = 1,
    Max = 100,
    Round = 0,
    Callback = function(value) airSwimSpeed = value end
});
local function startAirSwim(character)
    if not airSwimActive then return end;
    if not character then return end;
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end;
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end;
    humanoid.PlatformStand = false;
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 1e6;
    bv.Velocity = Vector3.zero;
    bv.Parent = hrp;
    airSwimBodyVelocity = bv;
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1, 1, 1) * 1e6;
    bg.Parent = hrp;
    airSwimBodyGyro = bg;
    local function updateAirSwim()
        if not airSwimActive then return end;
        local camera = workspace.CurrentCamera;
        if not camera then return end;
        local camCF = camera.CFrame;
        local targetCF = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
        if airSwimBodyGyro then airSwimBodyGyro.CFrame = targetCF end;
        local forward = camCF.LookVector;
        local right = camCF.RightVector;
        local up = camCF.UpVector;
        local uis = game:GetService("UserInputService")
        local moveVector = Vector3.zero;
        if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + forward end;
        if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - forward end;
        if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - right end;
        if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + right end;
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + up end;
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - up end;
        local targetVel = Vector3.zero;
        if moveVector.Magnitude > 0 then targetVel = moveVector.Unit * airSwimSpeed end;
        airSwimCurrentVelocity = airSwimCurrentVelocity + (targetVel - airSwimCurrentVelocity) * 0.08;
        if moveVector.Magnitude == 0 then
            airSwimCurrentVelocity = airSwimCurrentVelocity * 0.95;
            if airSwimCurrentVelocity.Magnitude < 0.05 then airSwimCurrentVelocity = Vector3.zero end
        end;
        if not uis:IsKeyDown(Enum.KeyCode.Space) and not uis:IsKeyDown(Enum.KeyCode.LeftShift) then
            airSwimCurrentVelocity = airSwimCurrentVelocity + Vector3.new(0, -0.2, 0)
        end;
        if airSwimBodyVelocity then airSwimBodyVelocity.Velocity = airSwimCurrentVelocity end
    end;
    if airSwimConnection then airSwimConnection:Disconnect(); airSwimConnection = nil end;
    airSwimConnection = game:GetService("RunService").Heartbeat:Connect(updateAirSwim)
end;
local function stopAirSwim(character)
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end;
    if airSwimBodyVelocity then airSwimBodyVelocity:Destroy(); airSwimBodyVelocity = nil end;
    if airSwimBodyGyro then airSwimBodyGyro:Destroy(); airSwimBodyGyro = nil end;
    if airSwimConnection then airSwimConnection:Disconnect(); airSwimConnection = nil end;
    airSwimCurrentVelocity = Vector3.zero
end;
General:AddToggle({
    Name = "AirSwim",
    Callback = function(state)
        local player = game.Players.LocalPlayer;
        if state then
            if flyActive then flyActive = false; stopFly(player.Character) end;
            airSwimActive = true;
            startAirSwim(player.Character);
            player.CharacterAdded:Connect(function(character)
                if airSwimActive then startAirSwim(character) end
            end)
        else
            airSwimActive = false;
            stopAirSwim(player.Character)
        end
    end
})

-- ===== NOCLIP =====
local noclipActive = false;
local noclipConnections = {};
local noclipCharAdded = nil;
local function setupNoclip(character)
    if not character or not noclipActive then return end;
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end;
    local conn = character.DescendantAdded:Connect(function(desc)
        if desc:IsA("BasePart") then desc.CanCollide = false end
    end)
    table.insert(noclipConnections, conn)
end;
local function restoreCollisions(character)
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end;
    for _, conn in ipairs(noclipConnections) do conn:Disconnect() end;
    noclipConnections = {}
end;
General:AddToggle({
    Name = "Noclip",
    Callback = function(state)
        local player = game.Players.LocalPlayer;
        noclipActive = state;
        if state then
            setupNoclip(player.Character)
            if not noclipCharAdded then
                noclipCharAdded = player.CharacterAdded:Connect(function(character)
                    setupNoclip(character)
                end)
            end
        else
            restoreCollisions(player.Character)
            if noclipCharAdded then noclipCharAdded:Disconnect(); noclipCharAdded = nil end
        end
    end
})

-- ===== ESP =====
local espSettings = { 
    box = false, 
    skeleton = false, 
    tracer = false, 
    hpbar = false, 
    name = false, 
    boxFill = false, 
    boxFillColor = Color3.fromRGB(0, 255, 0), 
    boxFillTrans = 0.5, 
    hpBarWidth = 6,
    teamCheck = false,
    visibleCheck = false
}
local espBoxColor = Color3.fromRGB(0, 255, 0);
local espBoxTransparency = 0;
local espBoxThickness = 2;
local espSkeletonColor = Color3.fromRGB(255, 255, 255);
local espSkeletonThickness = 2;
local espSkeletonTransparency = 0;
local espTracerColor = Color3.fromRGB(255, 255, 255);
local espTracerThickness = 2;
local espTracerTransparency = 0;
local espHpColor = Color3.fromRGB(0, 255, 0);
local espHpTransparency = 0;
local espNameColor = Color3.fromRGB(255, 255, 255);
local espNameSize = 16;
local espNameOutline = 1;
local espNameTransparency = 0;
local espRenderConnection = nil;
local espObjects = {};
local localPlayer = game.Players.LocalPlayer;

-- Функция проверки команды для ESP
local function isEspTeammate(player)
    if player == localPlayer then return true end
    if not espSettings.teamCheck then return false end
    local team = player.Team
    local myTeam = localPlayer.Team
    if team and myTeam and team == myTeam then
        return true
    end
    local char = player.Character
    if char then
        for _, tag in ipairs(char:GetChildren()) do
            if tag:IsA("ObjectValue") and tag.Name == "Team" then
                if tag.Value and tag.Value == localPlayer.Team then
                    return true
                end
            end
            if tag:IsA("StringValue") and tag.Name == "Team" then
                if tag.Value and tag.Value == tostring(localPlayer.Team) then
                    return true
                end
            end
        end
    end
    if player.Neutral then
        return true
    end
    return false
end

-- Функция проверки видимости для ESP
local function isEspTargetVisible(player)
    if not espSettings.visibleCheck then return true end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local camera = workspace.CurrentCamera
    if not camera then return false end
    local origin = camera.CFrame.Position
    local target = hrp.Position
    local direction = (target - origin).Unit
    local distance = (target - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = { char, camera, localPlayer.Character }
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    return result == nil
end

local function createEspObjects(player)
    if espObjects[player] then return end;
    local objs = {}
    objs.box = Drawing.new("Square")
    objs.box.Thickness = espBoxThickness;
    objs.box.Color = espBoxColor;
    objs.box.Filled = false;
    objs.box.Transparency = espBoxTransparency;
    objs.box.Visible = false
    objs.fill = Drawing.new("Square")
    objs.fill.Thickness = 0;
    objs.fill.Color = espSettings.boxFillColor;
    objs.fill.Filled = true;
    objs.fill.Transparency = espSettings.boxFillTrans;
    objs.fill.Visible = false
    objs.hpBg = Drawing.new("Square")
    objs.hpBg.Thickness = 0;
    objs.hpBg.Color = Color3.fromRGB(0, 0, 0);
    objs.hpBg.Filled = true;
    objs.hpBg.Transparency = 0.5;
    objs.hpBg.Visible = false
    objs.hpFill = Drawing.new("Square")
    objs.hpFill.Thickness = 0;
    objs.hpFill.Color = espHpColor;
    objs.hpFill.Filled = true;
    objs.hpFill.Transparency = 0;
    objs.hpFill.Visible = false
    objs.tracer = Drawing.new("Line")
    objs.tracer.Thickness = espTracerThickness;
    objs.tracer.Color = espTracerColor;
    objs.tracer.Transparency = espTracerTransparency;
    objs.tracer.Visible = false
    objs.name = Drawing.new("Text")
    objs.name.Color = espNameColor;
    objs.name.Size = espNameSize;
    objs.name.Center = true;
    objs.name.Outline = espNameOutline > 0;
    objs.name.OutlineColor = Color3.fromRGB(0, 0, 0);
    objs.name.Transparency = espNameTransparency;
    objs.name.Visible = false
    objs.skeleton = {}
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Thickness = espSkeletonThickness;
        line.Color = espSkeletonColor;
        line.Transparency = espSkeletonTransparency;
        line.Visible = false;
        table.insert(objs.skeleton, line)
    end
    espObjects[player] = objs
end;

local function clearPlayerObjects(player)
    local objs = espObjects[player]
    if objs then
        pcall(function()
            objs.box:Remove()
            objs.fill:Remove()
            objs.hpBg:Remove()
            objs.hpFill:Remove()
            objs.tracer:Remove()
            objs.name:Remove()
            for _, line in ipairs(objs.skeleton) do line:Remove() end
        end)
        espObjects[player] = nil
    end
end;

local function updateEsp()
    local camera = workspace.CurrentCamera;
    if not camera then return end;
    if not localPlayer or not localPlayer.Character then return end;
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end;

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player == localPlayer then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end;

        -- Team Check для ESP
        if isEspTeammate(player) then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end

        local character = player.Character;
        if not character then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end;

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end;

        -- Visible Check для ESP
        if not isEspTargetVisible(player) then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        if not hrp or not head then
            if espObjects[player] then clearPlayerObjects(player) end
            continue
        end;

        if not espObjects[player] then createEspObjects(player) end;
        local objs = espObjects[player];

        -- === ВЫЧИСЛЕНИЕ ГАБАРИТОВ ===
        local boxVisible = false;
        local boxMinX, boxMinY, boxWidth, boxHeight = 0, 0, 0, 0;

        if espSettings.box or espSettings.boxFill then
            local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge;
            local anyVisible = false;
            local parts = {}
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("BasePart") then table.insert(parts, child) end
            end;
            for _, part in ipairs(parts) do
                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    anyVisible = true;
                    local x, y = pos.X, pos.Y;
                    if x < minX then minX = x end;
                    if x > maxX then maxX = x end;
                    if y < minY then minY = y end;
                    if y > maxY then maxY = y end
                end
            end;
            if anyVisible then
                local padding = 5;
                minX = minX - padding;
                maxX = maxX + padding;
                minY = minY - padding;
                maxY = maxY + padding;
                boxWidth = math.max(10, maxX - minX);
                boxHeight = math.max(10, maxY - minY);
                boxMinX = minX;
                boxMinY = minY;
                boxVisible = true;
            end
        end

        -- === BOX ===
        if espSettings.box and boxVisible then
            objs.box.Position = Vector2.new(boxMinX, boxMinY);
            objs.box.Size = Vector2.new(boxWidth, boxHeight);
            objs.box.Thickness = espBoxThickness;
            objs.box.Transparency = espBoxTransparency;
            objs.box.Color = espBoxColor;
            objs.box.Visible = true
        else
            objs.box.Visible = false
        end

        -- === BOX FILL ===
        if espSettings.boxFill and boxVisible then
            objs.fill.Position = Vector2.new(boxMinX, boxMinY);
            objs.fill.Size = Vector2.new(boxWidth, boxHeight);
            objs.fill.Color = espSettings.boxFillColor;
            objs.fill.Transparency = espSettings.boxFillTrans;
            objs.fill.Visible = true
        else
            objs.fill.Visible = false
        end

        -- === HP BAR ===
        if espSettings.hpbar and boxVisible then
            local hp = humanoid.Health;
            local maxHp = humanoid.MaxHealth;
            local hpPercent = math.clamp(hp / maxHp, 0, 1);
            local barWidth = espSettings.hpBarWidth;
            local barHeight = boxHeight;
            local offset = 3;
            local x = boxMinX - offset - barWidth;
            local y = boxMinY;

            objs.hpBg.Position = Vector2.new(x, y);
            objs.hpBg.Size = Vector2.new(barWidth, barHeight);
            objs.hpBg.Transparency = 0.5;
            objs.hpBg.Visible = true;

            local fillHeight = barHeight * hpPercent;
            local fillY = y + (barHeight - fillHeight);
            objs.hpFill.Position = Vector2.new(x, fillY);
            objs.hpFill.Size = Vector2.new(barWidth, fillHeight);
            objs.hpFill.Color = espHpColor;
            objs.hpFill.Transparency = espHpTransparency;
            objs.hpFill.Visible = true
        else
            objs.hpBg.Visible = false;
            objs.hpFill.Visible = false
        end

        -- === TRACER ===
        if espSettings.tracer then
            local rootPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local bottom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y);
                local center = Vector2.new(rootPos.X, rootPos.Y);
                objs.tracer.From = bottom;
                objs.tracer.To = center;
                objs.tracer.Thickness = espTracerThickness;
                objs.tracer.Transparency = espTracerTransparency;
                objs.tracer.Color = espTracerColor;
                objs.tracer.Visible = true
            else
                objs.tracer.Visible = false
            end
        else
            objs.tracer.Visible = false
        end

        -- === NAME ===
        if espSettings.name then
            local headPos = head.Position
            local headScreen, onScreen = camera:WorldToViewportPoint(headPos)
            if onScreen then
                objs.name.Text = player.Name
                objs.name.Position = Vector2.new(headScreen.X, headScreen.Y - 25)
                objs.name.Color = espNameColor
                objs.name.Size = espNameSize
                objs.name.Outline = espNameOutline > 0
                objs.name.Transparency = espNameTransparency
                objs.name.Visible = true
            else
                objs.name.Visible = false
            end
        else
            objs.name.Visible = false
        end

        -- === SKELETON ===
        if espSettings.skeleton then
            pcall(function()
                local function findPart(character, names)
                    for _, name in ipairs(names) do
                        local part = character:FindFirstChild(name)
                        if part then return part end
                    end
                    return nil
                end;
                local function getScreenPos(part)
                    if not part then return nil end;
                    local pos, on = camera:WorldToViewportPoint(part.Position)
                    if on then return Vector2.new(pos.X, pos.Y) else return nil end
                end;
                local torso = findPart(character, { "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart" })
                if not torso then return end;
                local headPart = head;
                local leftArm = findPart(character, { "LeftArm", "LeftUpperArm" })
                local rightArm = findPart(character, { "RightArm", "RightUpperArm" })
                local leftLowerArm = findPart(character, { "LeftLowerArm" })
                local rightLowerArm = findPart(character, { "RightLowerArm" })
                local leftHand = findPart(character, { "LeftHand" })
                local rightHand = findPart(character, { "RightHand" })
                local leftLeg = findPart(character, { "LeftLeg", "LeftUpperLeg" })
                local rightLeg = findPart(character, { "RightLeg", "RightUpperLeg" })
                local leftLowerLeg = findPart(character, { "LeftLowerLeg" })
                local rightLowerLeg = findPart(character, { "RightLowerLeg" })
                local leftFoot = findPart(character, { "LeftFoot" })
                local rightFoot = findPart(character, { "RightFoot" })
                local pairs = {}
                local function addPair(a, b) if a and b then table.insert(pairs, { a, b }) end end;
                addPair(headPart, torso);
                addPair(torso, leftArm)
                addPair(torso, rightArm)
                addPair(torso, leftLeg)
                addPair(torso, rightLeg)
                addPair(leftArm, leftLowerArm)
                addPair(rightArm, rightLowerArm)
                addPair(leftLowerArm, leftHand)
                addPair(rightLowerArm, rightHand)
                addPair(leftLeg, leftLowerLeg)
                addPair(rightLeg, rightLowerLeg)
                addPair(leftLowerLeg, leftFoot)
                addPair(rightLowerLeg, rightFoot)
                for i = 1, #pairs do
                    local line = objs.skeleton[i]
                    if line then
                        local fromPos = getScreenPos(pairs[i][1])
                        local toPos = getScreenPos(pairs[i][2])
                        if fromPos and toPos then
                            line.From = fromPos;
                            line.To = toPos;
                            line.Thickness = espSkeletonThickness;
                            line.Transparency = espSkeletonTransparency;
                            line.Color = espSkeletonColor;
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end
                end;
                for i = #pairs + 1, 12 do
                    if objs.skeleton[i] then objs.skeleton[i].Visible = false end
                end
            end)
        else
            for _, line in ipairs(objs.skeleton) do line.Visible = false end
        end
    end
end;

local function startEsp()
    if espRenderConnection then return end;
    espRenderConnection = game:GetService("RunService").RenderStepped:Connect(updateEsp)
end;
local function stopEsp()
    if espRenderConnection then
        espRenderConnection:Disconnect();
        espRenderConnection = nil;
        for player, _ in pairs(espObjects) do clearPlayerObjects(player) end;
        espObjects = {}
    end
end;
local function updateEspState()
    local anyEnabled = espSettings.box or espSettings.skeleton or espSettings.tracer or espSettings.hpbar or espSettings.name or espSettings.boxFill;
    if anyEnabled then startEsp() else stopEsp() end
end;
game.Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then clearPlayerObjects(player) end
end);

-- === GUI НАСТРОЙКИ ESP ===
local boxToggle = EspSection:AddToggle({
    Name = "Box",
    Option = true,
    Callback = function(state)
        espSettings.box = state;
        updateEspState()
    end
});
boxToggle.Option:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        espBoxColor = value;
        for player, objs in pairs(espObjects) do objs.box.Color = value end
    end
});
boxToggle.Option:AddSlider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espBoxTransparency = value;
        for player, objs in pairs(espObjects) do objs.box.Transparency = value end
    end
});
boxToggle.Option:AddSlider({
    Name = "Thickness",
    Default = 2,
    Min = 1,
    Max = 5,
    Round = 0,
    Callback = function(value)
        espBoxThickness = value;
        for player, objs in pairs(espObjects) do objs.box.Thickness = value end
    end
});
boxToggle.Option:AddToggle({
    Name = "Fill",
    Callback = function(state)
        espSettings.boxFill = state;
        updateEspState()
    end
});
boxToggle.Option:AddColorPicker({
    Name = "Fill Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        espSettings.boxFillColor = value;
        for player, objs in pairs(espObjects) do objs.fill.Color = value end
    end
});
boxToggle.Option:AddSlider({
    Name = "Fill Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espSettings.boxFillTrans = value;
        for player, objs in pairs(espObjects) do objs.fill.Transparency = value end
    end
});

local skeletonToggle = EspSection:AddToggle({
    Name = "Skeleton",
    Option = true,
    Callback = function(state)
        espSettings.skeleton = state;
        updateEspState()
    end
});
skeletonToggle.Option:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        espSkeletonColor = value;
        for player, objs in pairs(espObjects) do
            for _, line in ipairs(objs.skeleton) do line.Color = value end
        end
    end});
skeletonToggle.Option:AddSlider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espSkeletonTransparency = value;
        for player, objs in pairs(espObjects) do
            for _, line in ipairs(objs.skeleton) do line.Transparency = value end
        end
    end
});
skeletonToggle.Option:AddSlider({
    Name = "Thickness",
    Default = 2,
    Min = 1,
    Max = 5,
    Round = 0,
    Callback = function(value)
        espSkeletonThickness = value;
        for player, objs in pairs(espObjects) do
            for _, line in ipairs(objs.skeleton) do line.Thickness = value end
        end
    end
});

local tracerToggle = EspSection:AddToggle({
    Name = "Tracer",
    Option = true,
    Callback = function(state)
        espSettings.tracer = state;
        updateEspState()
    end
});
tracerToggle.Option:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        espTracerColor = value;
        for player, objs in pairs(espObjects) do objs.tracer.Color = value end
    end
});
tracerToggle.Option:AddSlider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espTracerTransparency = value;
        for player, objs in pairs(espObjects) do objs.tracer.Transparency = value end
    end
});
tracerToggle.Option:AddSlider({
    Name = "Thickness",
    Default = 2,
    Min = 1,
    Max = 5,
    Round = 0,
    Callback = function(value)
        espTracerThickness = value;
        for player, objs in pairs(espObjects) do objs.tracer.Thickness = value end
    end
});

local hpToggle = EspSection:AddToggle({
    Name = "HP Bar",
    Option = true,
    Callback = function(state)
        espSettings.hpbar = state;
        updateEspState()
    end
});
hpToggle.Option:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        espHpColor = value;
        for player, objs in pairs(espObjects) do objs.hpFill.Color = value end
    end
});
hpToggle.Option:AddSlider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espHpTransparency = value;
        for player, objs in pairs(espObjects) do objs.hpFill.Transparency = value end
    end
});
hpToggle.Option:AddSlider({
    Name = "Width",
    Default = 6,
    Min = 1,
    Max = 20,
    Round = 0,
    Callback = function(value)
        espSettings.hpBarWidth = value;
    end
});

local nameToggle = EspSection:AddToggle({
    Name = "Name",
    Option = true,
    Callback = function(state)
        espSettings.name = state;
        updateEspState()
    end
});
nameToggle.Option:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        espNameColor = value;
        for player, objs in pairs(espObjects) do objs.name.Color = value end
    end
});
nameToggle.Option:AddSlider({
    Name = "Size",
    Default = 16,
    Min = 8,
    Max = 40,
    Round = 0,
    Callback = function(value)
        espNameSize = value;
        for player, objs in pairs(espObjects) do objs.name.Size = value end
    end
});
nameToggle.Option:AddSlider({
    Name = "Outline Thickness",
    Default = 1,
    Min = 0,
    Max = 3,
    Round = 0,
    Callback = function(value)
        espNameOutline = value;
        for player, objs in pairs(espObjects) do objs.name.Outline = value > 0 end
    end
});
nameToggle.Option:AddSlider({
    Name = "Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        espNameTransparency = value;
        for player, objs in pairs(espObjects) do objs.name.Transparency = value end
    end
});

-- TEAM CHECK ДЛЯ ESP
local espTeamCheck = EspSection:AddToggle({
    Name = "Team Check",
    Callback = function(state)
        espSettings.teamCheck = state;
        updateEspState()
    end
})

-- VISIBLE CHECK ДЛЯ ESP
local espVisibleCheck = EspSection:AddToggle({
    Name = "Visible Check",
    Callback = function(state)
        espSettings.visibleCheck = state;
        updateEspState()
    end
})

-- ===== CHAMS =====
local chamsEnabled = false;
local chamsColor = Color3.fromRGB(0, 255, 0);
local chamsStyle = "original";
local chamsFillTrans = 0.3;
local chamsOutlineTrans = 0.5;
local chamsVisibleCheck = false;
local chamsHighlights = {};
local chamsUpdateConnection = nil;

local function createHighlight(player)
    if not chamsEnabled then return nil end;
    local character = player.Character;
    if not character then return nil end;
    local highlight = Instance.new("Highlight")
    highlight.FillColor = chamsColor;
    highlight.OutlineColor = chamsColor;
    highlight.FillTransparency = chamsFillTrans;
    highlight.OutlineTransparency = chamsOutlineTrans;
    highlight.Parent = character;
    if chamsVisibleCheck then highlight.Enabled = false else highlight.Enabled = true end;
    return highlight
end;

local function applyChams(player)
    if not chamsEnabled then return end;
    if chamsHighlights[player] then chamsHighlights[player]:Destroy(); chamsHighlights[player] = nil end;
    local h = createHighlight(player);
    if h then chamsHighlights[player] = h end
end;

local function clearChams()
    for _, h in pairs(chamsHighlights) do h:Destroy() end;
    chamsHighlights = {}
end;

local function updateChams()
    clearChams();
    if chamsEnabled then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then applyChams(player) end
        end
    end
end;

local function applyStyle(style)
    if style == "original" then chamsFillTrans = 0.3; chamsOutlineTrans = 0.5
    elseif style == "flat" then chamsFillTrans = 0.3; chamsOutlineTrans = 1
    elseif style == "forcefield" then chamsFillTrans = 0.5; chamsOutlineTrans = 0.3
    elseif style == "bubble" then chamsFillTrans = 0.8; chamsOutlineTrans = 0.9
    elseif style == "glow" then chamsFillTrans = 0.1; chamsOutlineTrans = 0.3 end;
    updateChams()
end;

local function isPlayerVisible(player)
    local character = player.Character;
    if not character then return false end;
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end;
    local camera = workspace.CurrentCamera;
    if not camera then return false end;
    local origin = camera.CFrame.Position;
    local target = hrp.Position;
    local direction = (target - origin).Unit;
    local distance = (target - origin).Magnitude;
    local raycastParams = RaycastParams.new();
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist;
    raycastParams.FilterDescendantsInstances = { character, camera };
    local result = workspace:Raycast(origin, direction * distance, raycastParams);
    return result == nil
end;

local function updateChamsVisibility()
    if not chamsVisibleCheck then
        for _, h in pairs(chamsHighlights) do if h then h.Enabled = true end end
        return
    end;
    for player, h in pairs(chamsHighlights) do
        if h and h.Parent then
            local visible = isPlayerVisible(player);
            h.Enabled = visible
        end
    end
end;

local function startVisibilityUpdate()
    if chamsUpdateConnection then return end;
    chamsUpdateConnection = game:GetService("RunService").Heartbeat:Connect(updateChamsVisibility)
end;

local function stopVisibilityUpdate()
    if chamsUpdateConnection then chamsUpdateConnection:Disconnect(); chamsUpdateConnection = nil end
end;

local function onPlayerAdded(player)
    if player == localPlayer then return end;
    player.CharacterAdded:Connect(function()
        if chamsEnabled then applyChams(player) end
    end)
end;

for _, player in ipairs(game.Players:GetPlayers()) do onPlayerAdded(player) end;
game.Players.PlayerAdded:Connect(onPlayerAdded);
game.Players.PlayerRemoving:Connect(function(player)
    if chamsHighlights[player] then chamsHighlights[player]:Destroy(); chamsHighlights[player] = nil end
end);

ChamsSection:AddToggle({
    Name = "Enable",
    Callback = function(state)
        chamsEnabled = state;
        if state then
            updateChams();
            if chamsVisibleCheck then startVisibilityUpdate()
            else
                for _, h in pairs(chamsHighlights) do if h then h.Enabled = true end end
            end
        else
            clearChams(); stopVisibilityUpdate()
        end
    end
});
ChamsSection:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        chamsColor = value;
        for _, h in pairs(chamsHighlights) do h.FillColor = value; h.OutlineColor = value end
    end
});
ChamsSection:AddSlider({
    Name = "Fill Transparency",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        chamsFillTrans = value;
        for _, h in pairs(chamsHighlights) do h.FillTransparency = value end
    end
});
ChamsSection:AddSlider({
    Name = "Outline Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        chamsOutlineTrans = value;
        for _, h in pairs(chamsHighlights) do h.OutlineTransparency = value end
    end
});
ChamsSection:AddDropdown({
    Name = "Style",
    Default = "original",
    Values = { "original", "flat", "forcefield", "bubble", "glow" },
    Callback = function(value)
        chamsStyle = value;
        applyStyle(value)
    end
});
ChamsSection:AddToggle({
    Name = "Visible Check",
    Callback = function(state)
        chamsVisibleCheck = state;
        if state then
            startVisibilityUpdate();
            updateChamsVisibility()
        else
            stopVisibilityUpdate();
            for _, h in pairs(chamsHighlights) do if h then h.Enabled = true end end
        end
    end
})

-- ===== AIMBOT =====
local aimbotEnabled = false
local aimbotFOV = 30
local aimbotSmoothness = 1
local aimbotHitbox = "Head"
local aimbotMode = "camera"
local aimbotConnection = nil
local fovCircle = nil
local customCursor = nil
local uis = game:GetService("UserInputService")
local fovColor = Color3.new(1, 1, 1)
local fovTransparency = 0.5
local teamCheckEnabled = true
local aimbotVisibleCheck = false
local isMouseHeld = false
local cursorPos = Vector2.new(0, 0)
local cursorVelocity = Vector2.new(0, 0)
local cursorDamping = 0.85
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

local function moveMouse(pos)
    pcall(function()
        if mouse.Move then
            mouse.Move(pos)
            return
        end
    end)
    pcall(function()
        if mousemoverel then
            local current = uis:GetMouseLocation()
            local delta = pos - current
            mousemoverel(delta.X, delta.Y)
            return
        end
    end)
    pcall(function()
        local syn = getrenv and getrenv().synapse
        if syn and syn.mouse_move then
            syn.mouse_move(pos)
            return
        end
    end)
end

local function isTeammate(player)
    if player == localPlayer then return true end
    if teamCheckEnabled then
        local team = player.Team
        local myTeam = localPlayer.Team
        if team and myTeam and team == myTeam then
            return true
        end
        local char = player.Character
        if char then
            for _, tag in ipairs(char:GetChildren()) do
                if tag:IsA("ObjectValue") and tag.Name == "Team" then
                    if tag.Value and tag.Value == localPlayer.Team then
                        return true
                    end
                end
                if tag:IsA("StringValue") and tag.Name == "Team" then
                    if tag.Value and tag.Value == tostring(localPlayer.Team) then
                        return true
                    end
                end
            end
        end
        if player.Neutral then
            return true
        end
    end
    return false
end

local function isAimbotTargetVisible(player)
    if not aimbotVisibleCheck then return true end
    local char = player.Character
    if not char then return false end
    local camera = workspace.CurrentCamera
    if not camera then return false end

    local targetPart = nil
    if aimbotHitbox == "Head" then
        targetPart = char:FindFirstChild("Head")
    elseif aimbotHitbox == "Torso" then
        targetPart = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    if not targetPart then
        targetPart = char:FindFirstChild("HumanoidRootPart")
    end
    if not targetPart then return false end

    local origin = camera.CFrame.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit
    local distance = (target - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = { char, camera, localPlayer.Character }
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    return result == nil
end

local function createFOVCircle()
    if fovCircle then fovCircle:Remove(); fovCircle = nil end
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 2
    fovCircle.Color = fovColor
    fovCircle.Filled = false
    fovCircle.Transparency = fovTransparency
    fovCircle.Radius = 50
    fovCircle.Visible = true
    return fovCircle
end

local function createCustomCursor()
    if customCursor then customCursor:Remove(); customCursor = nil end
    customCursor = Drawing.new("Image")
    customCursor.Data = "rbxassetid://6031094979"
    customCursor.Size = Vector2.new(32, 32)
    customCursor.Visible = true
    return customCursor
end

local function getAimPoint()
    if aimbotMode == "cursor" then
        return uis:GetMouseLocation()
    else
        local camera = workspace.CurrentCamera
        if not camera then return Vector2.new(0, 0) end
        return Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end
end

local function updateFOVCircle()
    if not aimbotEnabled then
        if fovCircle then fovCircle.Visible = false end
        if customCursor then customCursor.Visible = false end
        return
    end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local center = getAimPoint()
    local radius = aimbotFOV * (camera.ViewportSize.X / 360)
    if not fovCircle then createFOVCircle() end
    fovCircle.Position = Vector2.new(center.X, center.Y)
    fovCircle.Radius = math.clamp(radius, 10, 1000)
    fovCircle.Color = fovColor
    fovCircle.Transparency = fovTransparency
    fovCircle.Visible = true

    if aimbotMode == "cursor" then
        if not customCursor then createCustomCursor() end
        customCursor.Position = center - Vector2.new(16, 16)
        customCursor.Visible = true
    else
        if customCursor then customCursor.Visible = false end
    end
end

local function getHitboxScreenPosition(player, hitbox)
    local char = player.Character
    if not char then return nil end
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local targetPart = nil
    if hitbox == "Head" then
        targetPart = char:FindFirstChild("Head")
    elseif hitbox == "Torso" then
        targetPart = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    elseif hitbox == "Random" then
        local parts = {}
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then table.insert(parts, part) end
        end
        if #parts > 0 then targetPart = parts[math.random(#parts)] end
    end
    if not targetPart then
        targetPart = char:FindFirstChild("HumanoidRootPart")
    end
    if not targetPart then return nil end
    local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return nil end
    return Vector2.new(pos.X, pos.Y)
end

local function getClosestEnemyInFOV()
    local aimPoint = getAimPoint()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local maxDist = aimbotFOV * (camera.ViewportSize.X / 360)
    local bestPlayer = nil
    local bestScore = math.huge
    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player == localPlayer then continue end
        if isTeammate(player) then continue end
        if not isAimbotTargetVisible(player) then continue end

        local char = player.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local screenPos = getHitboxScreenPosition(player, aimbotHitbox)
        if not screenPos then continue end

        local dist = (screenPos - aimPoint).Magnitude
        if dist >= maxDist then continue end

        local score = dist
        if localRoot then
            local worldDist = (hrp.Position - localRoot.Position).Magnitude
            score = score + worldDist * 0.05
        end

        if score < bestScore then
            bestScore = score
            bestPlayer = player
        end
    end
    return bestPlayer
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        input.UserInputType == Enum.UserInputType.MouseButton2 then
        isMouseHeld = true
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        input.UserInputType == Enum.UserInputType.MouseButton2 then
        isMouseHeld = false
    end
end

uis.InputBegan:Connect(onInputBegan)
uis.InputEnded:Connect(onInputEnded)

local function aimbotLoop()
    if not aimbotEnabled then return end

    updateFOVCircle()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local target = getClosestEnemyInFOV()

    if aimbotMode == "cursor" then
        if not isMouseHeld then return end

        if target then
            local targetScreenPos = getHitboxScreenPosition(target, aimbotHitbox)
            if targetScreenPos then
                local currentMousePos = uis:GetMouseLocation()
                local delta = targetScreenPos - cursorPos
                local dist = delta.Magnitude

                if dist > 1 then
                    local speed = 1 / (aimbotSmoothness + 0.5)
                    local step = delta * math.min(speed, 0.3)
                    cursorVelocity = cursorVelocity * cursorDamping + step * (1 - cursorDamping)
                    cursorPos = cursorPos + cursorVelocity

                    local viewport = camera.ViewportSize
                    cursorPos = Vector2.new(
                        math.clamp(cursorPos.X, 0, viewport.X),
                        math.clamp(cursorPos.Y, 0, viewport.Y)
                    )

                    local mouseDelta = targetScreenPos - currentMousePos
                    if mouseDelta.Magnitude > 1 then
                        local mouseSpeed = 1 / (aimbotSmoothness + 0.5)
                        local mouseStep = mouseDelta * math.min(mouseSpeed, 0.3)
                        local newMousePos = currentMousePos + mouseStep
                        newMousePos = Vector2.new(
                            math.clamp(newMousePos.X, 0, viewport.X),
                            math.clamp(newMousePos.Y, 0, viewport.Y)
                        )
                        moveMouse(newMousePos)
                    end
                end
            end
        else
            local currentMousePos = uis:GetMouseLocation()
            local delta = currentMousePos - cursorPos
            if delta.Magnitude > 1 then
                cursorPos = cursorPos + delta * 0.1
                cursorVelocity = cursorVelocity * 0.9
            else
                cursorPos = currentMousePos
                cursorVelocity = Vector2.new(0, 0)
            end
        end

    else
        if target then
            local targetPos = nil
            local char = target.Character
            if char then
                if aimbotHitbox == "Head" then
                    local head = char:FindFirstChild("Head")
                    if head then
                        targetPos = head.Position
                    else
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then targetPos = hrp.Position end
                    end
                elseif aimbotHitbox == "Torso" then
                    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    if torso then
                        targetPos = torso.Position
                    else
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then targetPos = hrp.Position end
                    end
                elseif aimbotHitbox == "Random" then
                    local parts = {}
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then table.insert(parts, part) end
                    end
                    if #parts > 0 then
                        targetPos = parts[math.random(#parts)].Position
                    else
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then targetPos = hrp.Position end
                    end
                end
                if not targetPos then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then targetPos = hrp.Position end
                end
            end
            if targetPos then
                local localChar = localPlayer.Character
                if localChar then
                    local root = localChar:FindFirstChild("HumanoidRootPart")
                    if root then
                        local currentCF = camera.CFrame
                        local lookAt = CFrame.new(root.Position, targetPos)
                        local speed = 1 / (aimbotSmoothness + 0.5)
                        camera.CFrame = currentCF:Lerp(lookAt, speed)
                    end
                end
            end
        end
    end
end

local function toggleAimbot(state)
    aimbotEnabled = state
    if state then
        if not aimbotConnection then
            aimbotConnection = game:GetService("RunService").RenderStepped:Connect(aimbotLoop)
        end
        local camera = workspace.CurrentCamera
        if camera then
            cursorPos = uis:GetMouseLocation()
        end
        updateFOVCircle()
        cursorVelocity = Vector2.new(0, 0)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
        if fovCircle then fovCircle.Visible = false end
        if customCursor then customCursor.Visible = false end
        cursorVelocity = Vector2.new(0, 0)
    end
end

local function updateAimbotSettings()
    if aimbotEnabled then updateFOVCircle() end
end

local aimbotToggle = AimbotSection:AddToggle({
    Name = "Enable",
    Option = true,
    Callback = function(state)
        toggleAimbot(state)
    end
})
aimbotToggle.Option:AddSlider({
    Name = "FOV",
    Default = 30,
    Min = 1,
    Max = 360,
    Round = 0,
    Callback = function(value)
        aimbotFOV = value
        updateAimbotSettings()
    end
})
aimbotToggle.Option:AddSlider({
    Name = "Smoothness",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Round = 1,
    Callback = function(value)
        aimbotSmoothness = value
    end
})
aimbotToggle.Option:AddDropdown({
    Name = "Hitbox",
    Default = "Head",
    Values = { "Head", "Torso", "Random" },
    Callback = function(value)
        aimbotHitbox = value
    end
})
aimbotToggle.Option:AddDropdown({
    Name = "Mode",
    Default = "camera",
    Values = { "camera", "cursor" },
    Callback = function(value)
        aimbotMode = value
        if value == "cursor" then
            local camera = workspace.CurrentCamera
            if camera then
                cursorPos = uis:GetMouseLocation()
            end
            cursorVelocity = Vector2.new(0, 0)
        end
        updateAimbotSettings()
    end
})
aimbotToggle.Option:AddColorPicker({
    Name = "FOV Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        fovColor = value
        if fovCircle then fovCircle.Color = value end
    end
})
aimbotToggle.Option:AddSlider({
    Name = "FOV Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Round = 2,
    Callback = function(value)
        fovTransparency = value
        if fovCircle then fovCircle.Transparency = value end
    end
})

-- TEAM CHECK
local teamCheck = AimbotSection:AddToggle({
    Name = "Team Check",
    Callback = function(state)
        teamCheckEnabled = state
    end
})

-- VISIBLE CHECK
local aimbotVisCheck = AimbotSection:AddToggle({
    Name = "Visible Check",
    Callback = function(state)
        aimbotVisibleCheck = state
    end
})

-- ===== PREDICTION (УПРЕЖДЕНИЕ) =====
local predictionEnabled = false
local predictionMultiplier = 0.5

local function getPredictedPosition(player)
    local char = player.Character
    if not char then return nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local targetPart = nil
    if aimbotHitbox == "Head" then
        targetPart = char:FindFirstChild("Head") or hrp
    elseif aimbotHitbox == "Torso" then
        targetPart = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
    else
        targetPart = hrp
    end
    if not targetPart then return nil end

    local velocity = hrp.AssemblyLinearVelocity
    local currentPos = targetPart.Position

    local camera = workspace.CurrentCamera    if not camera then return currentPos end

    local origin = camera.CFrame.Position
    local distance = (currentPos - origin).Magnitude
    local predictionTime = math.clamp(distance / 150, 0.05, 0.8) * predictionMultiplier

    return currentPos + velocity * predictionTime
end

-- Переопределяем getClosestEnemyInFOV
local oldGetClosest = getClosestEnemyInFOV
getClosestEnemyInFOV = function()
    local aimPoint = getAimPoint()
    local camera = workspace.CurrentCamera
    if not camera then return nil end

    local maxDist = aimbotFOV * (camera.ViewportSize.X / 360)
    local bestPlayer = nil
    local bestScore = math.huge
    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player == localPlayer then continue end
        if isTeammate(player) then continue end
        if not isAimbotTargetVisible(player) then continue end

        local char = player.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local targetPos = nil
        if predictionEnabled then
            targetPos = getPredictedPosition(player)
        end

        if not targetPos then
            local targetPart = nil
            if aimbotHitbox == "Head" then
                targetPart = char:FindFirstChild("Head")
            elseif aimbotHitbox == "Torso" then
                targetPart = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            end
            if not targetPart then targetPart = hrp end
            if not targetPart then continue end

            targetPos = targetPart.Position
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
        if not onScreen then continue end

        screenPos = Vector2.new(screenPos.X, screenPos.Y)
        local dist = (screenPos - aimPoint).Magnitude
        if dist >= maxDist then continue end

        local score = dist
        if localRoot then
            local worldDist = (hrp.Position - localRoot.Position).Magnitude
            score = score + worldDist * 0.05
        end

        if score < bestScore then
            bestScore = score
            bestPlayer = player
        end
    end
    return bestPlayer
end

-- Добавляем Prediction в AIMBOT
local predictionToggle = AimbotSection:AddToggle({
    Name = "Prediction",
    Callback = function(state)
        predictionEnabled = state
    end
})

AimbotSection:AddSlider({
    Name = "Prediction Speed",
    Default = 0.5,
    Min = 0.1,
    Max = 2,
    Round = 1,
    Callback = function(value)
        predictionMultiplier = value
    end
})

-- ===== SILENT AIM (not work) =====
SilentSection:AddToggle({ Name = "Enable (not implemented)" })
SilentSection:AddSlider({ Name = "FOV", Default = 30, Min = 1, Max = 360, Round = 0 })
SilentSection:AddDropdown({ Name = "Hitbox", Default = "Head", Values = { "Head", "Torso", "Random" } })

-- ===== MISC =====
local fovChangerEnabled = false
local fovValue = 70
local camera = workspace.CurrentCamera

local function applyFOV(value)
    pcall(function()
        if camera then
            camera.FieldOfView = value
        end
    end)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(camera, "FieldOfView", value)
        end
    end)
    pcall(function()
        if setfflag then
            setfflag("FOV", value)
        end
    end)
    pcall(function()
        local mt = getrawmetatable and getrawmetatable(camera)
        if mt and mt.__index then
            local oldIndex = mt.__index
            mt.__index = function(t, k)
                if k == "FieldOfView" then
                    return value
                end
                return oldIndex(t, k)
            end
        end
    end)
    pcall(function()
        if camera then
            camera:SetAttribute("FOV", value)
        end
    end)
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam:SetAttribute("FieldOfView", value)
        end
    end)
    pcall(function()
        local player = game.Players.LocalPlayer
        if player then
            player:SetAttribute("FOV", value)
        end
    end)
end

local fovUpdateConnection = nil
local function startFOVUpdate()
    if fovUpdateConnection then return end
    fovUpdateConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if fovChangerEnabled then
            applyFOV(fovValue)
        end
    end)
end

local function stopFOVUpdate()
    if fovUpdateConnection then
        fovUpdateConnection:Disconnect()
        fovUpdateConnection = nil
    end
end

PersonSection:AddToggle({
    Name = "FOV Changer",
    Callback = function(state)
        fovChangerEnabled = state
        if state then
            applyFOV(fovValue)
            startFOVUpdate()
        else
            stopFOVUpdate()
            applyFOV(70)
        end
    end
})

PersonSection:AddSlider({
    Name = "FOV Value",
    Default = 70,
    Min = 1,
    Max = 120,
    Round = 0,
    Callback = function(value)
        fovValue = value
        if fovChangerEnabled then
            applyFOV(value)
        end
    end
})

-- ===== FAKE JUMP (PERSON SECTION) =====
local fakeJumpActive = false
local originalJumpPower = 50
local fakeJumpConnection = nil
local fakeJumpInputConnection = nil
local fakeJumpHeartbeatConnection = nil
local player = game.Players.LocalPlayer
local lastY = 0
local isFalling = false

local function applyFakeJump(character)
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if fakeJumpActive and originalJumpPower == 50 then
        originalJumpPower = humanoid.JumpPower
    end

    if fakeJumpActive then
        humanoid.JumpPower = originalJumpPower
    else
        humanoid.JumpPower = math.abs(originalJumpPower)
    end
end

local function teleportToGround(character)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local origin = hrp.Position
    local direction = Vector3.new(0, -1, 0)
    local result = workspace:Raycast(origin, direction * 100, raycastParams)
    
    if result then
        local groundY = result.Position.Y + 3.5
        local newPos = Vector3.new(hrp.Position.X, groundY, hrp.Position.Z)
        hrp.CFrame = CFrame.new(newPos)
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
    end
end

local function toggleFakeJump(state)
    fakeJumpActive = state
    local character = player.Character

    if state then
        applyFakeJump(character)

        if not fakeJumpConnection then
            fakeJumpConnection = player.CharacterAdded:Connect(function(newChar)
                applyFakeJump(newChar)
            end)
        end

        lastY = 0
        isFalling = false
        if not fakeJumpHeartbeatConnection then
            fakeJumpHeartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not fakeJumpActive then return end
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local humanoid = char:FindFirstChild("Humanoid")
                if not humanoid then return end
                
                local currentY = hrp.Position.Y
                local velocityY = hrp.AssemblyLinearVelocity.Y
                
                if humanoid:GetState() == Enum.HumanoidStateType.Jumping or 
                   humanoid:GetState() == Enum.HumanoidStateType.Freefall or
                   humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                    
                    if velocityY < 0 and currentY < lastY then
                        teleportToGround(char)
                        humanoid:ChangeState("Landed")
                    end
                end
                
                lastY = currentY
            end)
        end

        local uis = game:GetService("UserInputService")
        if not fakeJumpInputConnection then
            fakeJumpInputConnection = uis.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.Space and fakeJumpActive then
                    local char = player.Character
                    if char then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Jump then
                            humanoid:ChangeState("Jumping")
                        end
                    end
                end
            end)
        end

    else
        if fakeJumpConnection then
            fakeJumpConnection:Disconnect()
            fakeJumpConnection = nil
        end
        if fakeJumpInputConnection then
            fakeJumpInputConnection:Disconnect()
            fakeJumpInputConnection = nil
        end
        if fakeJumpHeartbeatConnection then
            fakeJumpHeartbeatConnection:Disconnect()
            fakeJumpHeartbeatConnection = nil
        end

        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = math.abs(originalJumpPower)
            end
        end
        originalJumpPower = 50
    end
end

PersonSection:AddToggle({
    Name = "Fake Jump",
    Callback = function(state)
        toggleFakeJump(state)
    end
})

-- ===== ANTI AIM (MISC) =====
local AntiAimSection = Misc:AddSection({ Position = "center", Name = "ANTI AIM" })

local spinBotActive = false
local spinBotConnection = nil
local spinSpeed = 50

local function toggleSpinBot(state)
    spinBotActive = state
    
    if state then
        if not spinBotConnection then
            spinBotConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if not character then return end
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local humanoid = character:FindFirstChild("Humanoid")
                if not humanoid or humanoid.Health <= 0 then return end
                
                local currentCF = hrp.CFrame
                local rotation = CFrame.Angles(0, math.rad(spinSpeed), 0)
                hrp.CFrame = currentCF * rotation
            end)
        end
    else
        if spinBotConnection then
            spinBotConnection:Disconnect()
            spinBotConnection = nil
        end
    end
end

AntiAimSection:AddToggle({
    Name = "Spin Bot",
    Callback = function(state)
        toggleSpinBot(state)
    end
})

AntiAimSection:AddSlider({
    Name = "Spin Speed",
    Default = 50,
    Min = 1,
    Max = 360,
    Round = 0,
    Callback = function(value)
        spinSpeed = value
    end
})

-- ===== CUSTOM ANIMATIONS =====
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run = 656118852,
        Walk = 656121766,
        Jump = 656117878,
        Fall = 656115606,
        Swim = 656119721,
        SwimIdle = 656121397,
        Climb = 656114359,
        Idle = {656117400, 656118341, 886742569}
    },
    Robot = {
        Run = 616091570,
        Walk = 616095330,
        Jump = 616090535,
        Fall = 616087089,
        Swim = 616092998,
        SwimIdle = 616094091,
        Climb = 616086039,
        Idle = {616088211, 616089559, 885531463}
    },
    Levitation = {
        Run = 616010382,
        Walk = 616013216,
        Jump = 616008936,
        Fall = 616005863,
        Swim = 616011509,
        SwimIdle = 616012453,
        Climb = 616003713,
        Idle = {616006778, 616008087, 886862142}
    },
    Stylish = {
        Run = 616140816,
        Walk = 616146177,
        Jump = 616139451,
        Fall = 616134815,
        Swim = 616143378,
        SwimIdle = 616144772,
        Climb = 616133594,
        Idle = {616136790, 616138447, 886888594}
    },
    Bubbly = {
        Run = 910025107,
        Walk = 910034870,
        Jump = 910016857,
        Fall = 910001910,
        Swim = 910028158,
        SwimIdle = 910030921,
        Climb = 909997997,
        Idle = {910004836, 910009958, 1018536639}
    },
    Cartoon = {
        Run = 742638842,
        Walk = 742640026,
        Jump = 742637942,
        Fall = 742637151,
        Swim = 742639220,
        SwimIdle = 742639812,
        Climb = 742636889,
        Idle = {742637544, 742638445, 885477856}
    },
}

local currentAnimPack = "Zombie"
local customAnimationsEnabled = false

local function waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

local function setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

local function stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

local function ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

local function ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i = 1, n do
        ensureAnim(idleFolder, "Animation" .. i)
    end
end

local function pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

local ATTR_LAST = "AnimPack_Last"
local applying = false

local function applyPack(packName)
    if applying then return false end
    applying = true

    local pack = PACKS[packName]
    if not pack then
        warn("Unknown pack:", packName)
        applying = false
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()
    local animate = waitForAnimate(char)
    if not animate then
        warn("Animate not found")
        applying = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    stopAllTracks(hum)

    local runObj   = ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    setAnim(walkObj,  pick(pack, "WalkAnim", "Walk"))
    setAnim(runObj,   pick(pack, "RunAnim", "Run"))
    setAnim(jumpObj,  pick(pack, "JumpAnim", "Jump"))
    setAnim(fallObj,  pick(pack, "FallAnim", "Fall"))
    setAnim(climbObj, pick(pack, "ClimbAnim", "Climb"))

    setAnim(swimObj,      pick(pack, "Swim"))
    setAnim(swimIdleObj,  pick(pack, "SwimIdle") or pick(pack, "Swim"))

    if idleFolder then
        local a1 = pick(pack, "Animation1")
        local a2 = pick(pack, "Animation2")

        if a1 or a2 then
            ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then setAnim(a, pack.Idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    pcall(function() player:SetAttribute(ATTR_LAST, packName) end)

    applying = false
    return true
end

player.CharacterAdded:Connect(function()
    task.wait(0.6)
    local saved = player:GetAttribute(ATTR_LAST)
    if type(saved) == "string" and saved ~= "" and PACKS[saved] then
        applyPack(saved)
    end
end)

CustomSection:AddToggle({
    Name = "Custom Animations",
    Callback = function(state)
        customAnimationsEnabled = state
        if state then
            local character = player.Character
            if character then
                local saved = player:GetAttribute(ATTR_LAST)
                if type(saved) == "string" and saved ~= "" and PACKS[saved] then
                    applyPack(saved)
                else
                    applyPack("Zombie")
                end
            end
        else
            applyPack("Cartoon")
        end
    end
})

CustomSection:AddDropdown({
    Name = "Animation Pack",
    Default = "Zombie",
    Values = {"Zombie", "Ninja", "Cartoon", "Robot", "Levitation", "Stylish", "Bubbly", "Astronaut", "Vampire", "Werewolf", "Superhero", "Mage", "Elder", "Toy", "Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Catwalk Glam", 'Wicked "Dancing Through Life"', "No Boundaries", "NFL", "Amazon Unboxed"},
    Callback = function(value)
        currentAnimPack = value
        if customAnimationsEnabled then
            local character = player.Character
            if character then
                applyPack(value)
            end
        end
    end
})

CustomSection:AddLabel({
    Name = "Анимации видны всем игрокам!"
})

-- ===== AUTOSAVE (ЧЕРЕЗ ИНЖЕКТОР) =====
local placeId = game.PlaceId or 0
local saveKey = "Soufiw_Settings_" .. placeId

print("[AutoSave] Запуск для PlaceId:", placeId)

local function saveSettings()
    local settings = {
        speedhack = speedhackEnabled,
        speedValue = currentSpeed,
        speedMethod = speedMethod,
        noFall = noFallActive,
        jumphack = currentJump,
        infJump = infJumpActive,
        fly = flyActive,
        flySpeed = flySpeed,
        airSwim = airSwimActive,
        airSwimSpeed = airSwimSpeed,
        noclip = noclipActive,
        espBox = espSettings.box,
        espSkeleton = espSettings.skeleton,
        espTracer = espSettings.tracer,
        espHpbar = espSettings.hpbar,
        espName = espSettings.name,
        espTeamCheck = espSettings.teamCheck,
        espVisibleCheck = espSettings.visibleCheck,
        espBoxColor = {espBoxColor.R*255, espBoxColor.G*255, espBoxColor.B*255},
        espBoxTransparency = espBoxTransparency,
        espBoxThickness = espBoxThickness,
        espSkeletonColor = {espSkeletonColor.R*255, espSkeletonColor.G*255, espSkeletonColor.B*255},
        espSkeletonTransparency = espSkeletonTransparency,
        espSkeletonThickness = espSkeletonThickness,
        espTracerColor = {espTracerColor.R*255, espTracerColor.G*255, espTracerColor.B*255},
        espTracerTransparency = espTracerTransparency,
        espTracerThickness = espTracerThickness,
        espHpColor = {espHpColor.R*255, espHpColor.G*255, espHpColor.B*255},
        espHpTransparency = espHpTransparency,
        espHpBarWidth = espSettings.hpBarWidth,
        espNameColor = {espNameColor.R*255, espNameColor.G*255, espNameColor.B*255},
        espNameSize = espNameSize,
        espNameOutline = espNameOutline,
        espNameTransparency = espNameTransparency,
        chamsEnabled = chamsEnabled,
        chamsColor = {chamsColor.R*255, chamsColor.G*255, chamsColor.B*255},
        chamsStyle = chamsStyle,
        chamsFillTrans = chamsFillTrans,
        chamsOutlineTrans = chamsOutlineTrans,
        chamsVisibleCheck = chamsVisibleCheck,
        aimbotEnabled = aimbotEnabled,
        aimbotFOV = aimbotFOV,
        aimbotSmoothness = aimbotSmoothness,
        aimbotHitbox = aimbotHitbox,
        aimbotMode = aimbotMode,
        fovColor = {fovColor.R*255, fovColor.G*255, fovColor.B*255},
        fovTransparency = fovTransparency,
        teamCheckEnabled = teamCheckEnabled,
        aimbotVisibleCheck = aimbotVisibleCheck,
        predictionEnabled = predictionEnabled,
        predictionMultiplier = predictionMultiplier,
        fovChangerEnabled = fovChangerEnabled,
        fovValue = fovValue,
        fakeJump = fakeJumpActive,
        spinBot = spinBotActive,
        spinSpeed = spinSpeed,
        customAnimations = customAnimationsEnabled,
        currentAnimPack = currentAnimPack,
    }
    
    getgenv()[saveKey] = settings
    print("[AutoSave] Сохранено для PlaceId:", placeId)
end

local function loadSettings()
    local settings = getgenv()[saveKey]
    if not settings then
        print("[AutoSave] Настроек не найдено")
        return
    end
    
    print("[AutoSave] Настройки загружены для PlaceId:", placeId)
    
    speedhackEnabled = settings.speedhack or false
    currentSpeed = settings.speedValue or 16
    speedMethod = settings.speedMethod or "WalkSpeed"
    noFallActive = settings.noFall or false
    currentJump = settings.jumphack or 50
    infJumpActive = settings.infJump or false
    flyActive = settings.fly or false
    flySpeed = settings.flySpeed or 50
    airSwimActive = settings.airSwim or false
    airSwimSpeed = settings.airSwimSpeed or 30
    noclipActive = settings.noclip or false
    espSettings.box = settings.espBox or false
    espSettings.skeleton = settings.espSkeleton or false
    espSettings.tracer = settings.espTracer or false
    espSettings.hpbar = settings.espHpbar or false
    espSettings.name = settings.espName or false
    espSettings.teamCheck = settings.espTeamCheck or false
    espSettings.visibleCheck = settings.espVisibleCheck or false
    
    if settings.espBoxColor then
        espBoxColor = Color3.fromRGB(settings.espBoxColor[1], settings.espBoxColor[2], settings.espBoxColor[3])
    end
    espBoxTransparency = settings.espBoxTransparency or 0
    espBoxThickness = settings.espBoxThickness or 2
    
    if settings.espSkeletonColor then
        espSkeletonColor = Color3.fromRGB(settings.espSkeletonColor[1], settings.espSkeletonColor[2], settings.espSkeletonColor[3])
    end
    espSkeletonTransparency = settings.espSkeletonTransparency or 0
    espSkeletonThickness = settings.espSkeletonThickness or 2
    
    if settings.espTracerColor then
        espTracerColor = Color3.fromRGB(settings.espTracerColor[1], settings.espTracerColor[2], settings.espTracerColor[3])
    end
    espTracerTransparency = settings.espTracerTransparency or 0
    espTracerThickness = settings.espTracerThickness or 2
    
    if settings.espHpColor then
        espHpColor = Color3.fromRGB(settings.espHpColor[1], settings.espHpColor[2], settings.espHpColor[3])
    end
    espHpTransparency = settings.espHpTransparency or 0
    espSettings.hpBarWidth = settings.espHpBarWidth or 6
    
    if settings.espNameColor then
        espNameColor = Color3.fromRGB(settings.espNameColor[1], settings.espNameColor[2], settings.espNameColor[3])
    end
    espNameSize = settings.espNameSize or 16
    espNameOutline = settings.espNameOutline or 1
    espNameTransparency = settings.espNameTransparency or 0
    
    chamsEnabled = settings.chamsEnabled or false
    if settings.chamsColor then
        chamsColor = Color3.fromRGB(settings.chamsColor[1], settings.chamsColor[2], settings.chamsColor[3])
    end
    chamsStyle = settings.chamsStyle or "original"
    chamsFillTrans = settings.chamsFillTrans or 0.3
    chamsOutlineTrans = settings.chamsOutlineTrans or 0.5
    chamsVisibleCheck = settings.chamsVisibleCheck or false
    
    aimbotEnabled = settings.aimbotEnabled or false
    aimbotFOV = settings.aimbotFOV or 30
    aimbotSmoothness = settings.aimbotSmoothness or 1
    aimbotHitbox = settings.aimbotHitbox or "Head"
    aimbotMode = settings.aimbotMode or "camera"
    if settings.fovColor then
        fovColor = Color3.fromRGB(settings.fovColor[1], settings.fovColor[2], settings.fovColor[3])
    end
    fovTransparency = settings.fovTransparency or 0.5
    teamCheckEnabled = settings.teamCheckEnabled or true
    aimbotVisibleCheck = settings.aimbotVisibleCheck or false
    predictionEnabled = settings.predictionEnabled or false
    predictionMultiplier = settings.predictionMultiplier or 0.5
    
    fovChangerEnabled = settings.fovChangerEnabled or false
    fovValue = settings.fovValue or 70
    fakeJumpActive = settings.fakeJump or false
    spinBotActive = settings.spinBot or false
    spinSpeed = settings.spinSpeed or 50
    
    customAnimationsEnabled = settings.customAnimations or false
    currentAnimPack = settings.currentAnimPack or "Zombie"
end

loadSettings()

game:GetService("RunService").Heartbeat:Connect(function()
    saveSettings()
end)

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    saveSettings()
end)

pcall(function()
    game:GetService("TeleportService").TeleportInitiated:Connect(function()
        saveSettings()
    end)
end)

pcall(function()
    game:BindToClose(function()
        saveSettings()
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F5 then
        saveSettings()
        Notification:Notify({ Title = "AutoSave", Content = "Settings saved!", Icon = "clipboard", Duration = 2 })
    end
end)

print("[AutoSave] Готово! Настройки сохраняются через инжектор.")
