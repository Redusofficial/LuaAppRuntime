local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HttpService = game:GetService("HttpService")
local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))

local PseudoHttp = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Services"):WaitForChild("PseudoHttp"))

type RequestOptions = {
    Url: string,
    Method: string,
    Headers: {[any]: any?},
    Body: string
}

local Overrides = {
    ["RequestInternal"] = {
        ["Method"] = function(self, Options: RequestOptions)
            return {
				Start = function(self, Callback: (boolean, {}) -> nil)
					print(Options)
                    local ResultData = PseudoHttp:Execute(
                        Options.Method or "GET", Options.Url,
                        Options.Headers or {},
                         Options.Body or ""
                    )

                    Callback(true, {
                        Body = ResultData.Body,
                        Headers = ResultData.Headers,
                        StatusCode = ResultData.StatusCode,
                        StatusMessage = ResultData.StatusCode == 200 and "OK" or "Not Found",
                        IsCached = false,
                        IsPrefetch = false,
                        Stats = {
                            DurationInQueue = 0,
                            DurationNameLookup = 0,
                            DurationConnect = 0,
                            DurationSSLHandshake = 0,
                            DurationMakeRequest = 0,
                            DurationReceiveResponse = 0,
                            RoundTripTime = 0,
                        }
                    })
                end
            }
        end
    }
}

local _HttpService = WrapperService:Create(HttpService)

_HttpService:Add(Overrides)

return _HttpService