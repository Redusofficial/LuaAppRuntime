local Http = {}

local Routing = require(script:WaitForChild("Router"))
local UrlParser = require(script:WaitForChild("Url"))
local Response = require(script:WaitForChild("Response"))

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

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
    return Response:Json(require(script:WaitForChild("SortsData")))
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