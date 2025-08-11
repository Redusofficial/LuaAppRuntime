export type ResponseData = {
    Data: string,
    Headers: {[string]: any?},
    StatusCode: number
}

local HttpService = game:GetService("HttpService")

local Response = {}

function Response.new(Data: string?, StatusCode: number?, Headers: {}?): ResponseData
    local self = {}
    
    self.Data = Data or ""
    self.StatusCode = StatusCode or 200
    self.Headers = Headers or {}

    return self
end

function Response:Status(Code: number)
    return Response.new(nil, Code)
end

function Response:Json(Data: {[any]: any?})
    return Response.new(HttpService:JSONEncode(Data), 200)
end

return Response