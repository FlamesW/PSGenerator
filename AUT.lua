--[[ PS Generator Settings~
shared.Settings = {Account = "Account_Name",Enabled = true,Cooldown = 15,AntiAFK = true, -- // Dont touch~
    Webhook = "Webhook_Link_Here",
};
--]]

repeat task.wait(0.1) until game:IsLoaded();

local cloneref = cloneref or function(o) return o end;
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));
local HttpService = cloneref(game:GetService("HttpService"));
local VirtualUser = cloneref(game:GetService("VirtualUser"));
local Players = cloneref(game:GetService("Players"));

if Players.LocalPlayer.Name ~= shared.Settings.Account then return end;

shared.SendData = function(msg)
    local Link = shared.Settings.Webhook;
    local Type = http_request or request;

    if not Type or not Link then return end;

    local Data = {
        ["content"] = "A New Private Server Code Just Dropped!~",
        ["embeds"] = {{
            ["title"] = "Private Server Generator~",
            ["description"] = "**Generated Code:** ```"..msg.."```\n**"..os.date("%d/%m/%Y - %I:%M:%S %p").."**";
            ["type"] = "rich",
            ["color"] = 0x000000,
        }},
    };

    pcall(function()
        Type({Url = Link,Body = HttpService:JSONEncode(Data),Method = "POST",Headers = {["content-type"] = "application/json"}});
    end)
end

if not shared.__LOADED then shared.__LOADED = true;
    if shared.AntiAFK == true then
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController();VirtualUser:ClickButton2(Vector2.new());
        end)
    end

    while shared.Settings.Enabled == true do
        local args = {
            "GenerateCode",
            {}
        }

        local KnitServices = ReplicatedStorage.ReplicatedModules.KnitPackage.Knit.Services;
        local GeneratePS = KnitServices.PrivateCodeService.RF.Invoke;

        local Succ,Res = pcall(function()
            return GeneratePS:InvokeServer(unpack(args));
        end)

        if Succ then
            if Res == nil then
                shared.SendData("You need PS Gamepass.");
            elseif Res == "CodeDebounce" then
                shared.SendData("You are on cooldown brah~");
            else
                shared.SendData(Res);
            end
        else
            shared.SendData("Code Generation failed~");
        end
        task.wait(shared.Settings.Cooldown);
    end
end
