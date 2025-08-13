local Http = {}

local Routing = require(script:WaitForChild("Router"))
local UrlParser = require(script:WaitForChild("Url"))
local Response = require(script:WaitForChild("Response"))
local Static = require(script.Static)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local HttpGetRemote: RemoteFunction = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HttpGet")

local Router = Routing.new()

Router:get("/v2/stream-notifications/unread-count", function(request)
    return Response:Json({
        unreadNotifications = 0
    })
end)

Router:get("//user/get-friendship-count", function(request)
    return Response:Json({
        success = true,
        message = "Success",
        count = 0
    })
end)

Router:get("/v1/users/:userid/friends", function(request)
    local Success, Friends = pcall(function()
        return Players:GetFriendsAsync(request.Params.userid):GetCurrentPage()
    end)

    if not Success then
        return Response:Json({data = {}})
    end

    local Data = {}

    for _, Friend in Friends do
        table.insert(Data, {
            isOnline = Friend.IsOnline,
            name = Friend.Username,
            id = Friend.Id,
            description = nil,
            created = "0001-01-01T06:00:00Z",
            isBanned = false,
            isDeleted = false,
            displayName = Friend.DisplayName
        })
    end

    return Response:Json({
        data = Data
    })
end)

Router:get("/v1/games/sorts", function(request)
    return Response:Json(Static.GAME_SORTS)
end)

Router:get("/v2/chat-settings", function(request)
    return Response:Json({
        chatEnabled = true,
        isActiveChatUser = true,
        isConnectTabEnabled = true
    })
end)

Router:post("/v1/presence/users", function(request)
    local Data = {}

    local RequestData = HttpService:JSONDecode(request.Data)

    for _, UserId in RequestData.userIds do
        table.insert(Data, {
            userPresenceType = 1,
            lastLocation = "Website",
            placeId = nil,
            rootPlaceId = nil,
            gameId = nil,
            universeId = nil,
            userId = UserId
        })
    end

    return Response:Json({
        userPresences = Data
    })
end)

Router:get("/v1/avatar-rules", function(request)
    return Response:Json(Static.AVATAR_RULES)
end)

Router:get("/v1/avatar", function(request)
    local Result = HttpGetRemote:InvokeServer(`https://avatar.roblox.com/v1/users/{LocalPlayer.UserId}/avatar`)

    return Response:Data(Result)
end)

Router:post("/v1/avatar/set-body-colors", function(request)
    return Response:Json({
        success = true,
        avatar_hash = ""
    })
end)

Router:post("/v1/avatar/set-player-avatar-type", function(request)
    return Response:Json({
        success = true,
        avatar_hash = ""
    })
end)

Router:post("/v1/avatar/set-wearing-assets", function(request)
	return Response:Json({
		success = true,
		avatar_hash = ""
	})
end)

Router:post("/v1/avatar/set-scales", function(request)
	return Response:Json({
		success = true,
		avatar_hash = ""
	})
end)

Router:get("/v1/users/:userid/outfits", function(request)
	local Result = HttpGetRemote:InvokeServer(`https://avatar.roblox.com/v1/users/{request.Params.userid}/outfits?page={request.Url.query.page}&itemsPerPage={request.Url.query.itemsPerPage}&outfitType=Avatar`)

	return Response:Data(Result)
end)

Router:get("/v1/outfits/:outfitid/details", function(request)
	local Result = HttpGetRemote:InvokeServer(
		`https://avatar.roblox.com/v1/outfits/{request.Params.outfitid}/details`
	)

	return Response:Data(Result)
end)

function Http:Execute(Method: string, Url: string, Headers: {}, Data: string): Response.ResponseData
    print(Method, Url, Data)
    local Parsed = UrlParser.parse(Url, {
        ["query"] = {}
    })

    local Success, Data: Response.ResponseData = Router:execute(Method, Parsed.path, {
        ["Url"] = Parsed,
        ["Headers"] =  Headers,
        ["Data"] = Data
    })

    if not Success then
        return Response:Status(404)
    end
    
    return Data
end

return Http