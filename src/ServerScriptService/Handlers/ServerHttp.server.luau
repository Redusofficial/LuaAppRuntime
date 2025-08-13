local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local HttpGetRemote = ReplicatedStorage.Remotes.HttpGet

HttpGetRemote.OnServerInvoke = function(Player: Player, Url: string)
    local Body = HttpService:GetAsync(Url:gsub("roblox.com", "roproxy.com"))

    return Body
end