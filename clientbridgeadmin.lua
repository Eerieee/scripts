local Players = game:GetService("Players"); local LP = Players.LocalPlayer; local prefix = "`"

-- [ ADMINS ] --

local Admins = {
    [3357571494] = true,
    [2651420804] = true,
    [104248828] = true,
    [936940543] = true,
}

-- [ VARIABLES ] --

local Variables = {
    Spinning = false
}

-- [ GET PLAYER ] --

GetPlayer = function(Name)
    for a,b in ipairs(game.Players:GetPlayers()) do
        if b.Name:sub(1, Name:len()):lower() == Name:lower() then
            return b
        end
    end
end

-- [ COMMANDS ] --

local CMDS = {
    ["kill"] = function()
        local C = LP.Character
        if C and C:FindFirstChild("Humanoid") then
            C.Humanoid.Health = 0
        end
    end,
    ["jump"] = function()
        local C = LP.Character
        if C and C:FindFirstChild("Humanoid") then
            C.Humanoid.Jump = true
        end
    end,
    ["sit"] = function()
        local C = LP.Character
        if C and C:FindFirstChild("Humanoid") then
            C.Humanoid.Sit = true
        end
    end,
    ["chat"] = function(Sender, Full)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(tostring(Full), "All")
    end,
    ["bring"] = function(Sender, Full)
        local C = LP.Character
        if C and C:FindFirstChild("HumanoidRootPart") then
            C.HumanoidRootPart.CFrame = Sender.Character.HumanoidRootPart.CFrame
        end
    end,
    ["spin"] = function(Sender, Full)
        Spinning = true
    end,
    ["unspin"] = function(Sender, Full)
        Spinning = false
    end,
}

-- [ RS ] --

game:GetService("RunService").RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and Spinning == true then
        LP.Character:FindFirstChild("HumanoidRootPart").CFrame = LP.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.Angles(0, math.rad(1.5), 0)
    end
end)

-- [ IS ADMIN ] --

function Chatted(Player, msg)
    if Player and Admins[Player.UserId] then
        local SPLIT = string.split(msg, " ")
        if SPLIT[1] and string.sub(SPLIT[1], 1, 1) == prefix then
            print("is prefix")
            local Command = string.sub(SPLIT[1], 2, #SPLIT[1]); print(Command)
            if SPLIT[2] and CMDS[Command] then
                if (SPLIT[2] and GetPlayer(SPLIT[2]) == LP) or (SPLIT[2] and string.lower(SPLIT[2]) == "all") then
                    local full = string.sub(msg, 1 + #Command + 1 + #SPLIT[2] + 1)
                    CMDS[Command](Player, full)
                end
            end
        end
    end
end

local DefaultChatSystemChatEvents = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents");
if (not DefaultChatSystemChatEvents) then return; end
local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering", 5);
if (not OnMessageDoneFiltering) then return; end
if (typeof(OnMessageDoneFiltering) ~= "Instance" or OnMessageDoneFiltering.ClassName ~= "RemoteEvent") then return; end

OnMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
        if (type(messageData) ~= "table") then return; end
        local plr = game.Players:FindFirstChild(messageData.FromSpeaker);
        local raw = messageData.Message
        if (not plr or not raw or plr == LocalPlayer) then return; end

        if (messageData.OriginalChannel == "Team") then
            raw = "/team " .. raw
        else
            local whisper = string.match(messageData.OriginalChannel, "To (.+)");
            if (whisper) then
                raw = string.format("/w %s %s", whisper, raw);
            end
        end

        Chatted(plr, raw);
    end);
