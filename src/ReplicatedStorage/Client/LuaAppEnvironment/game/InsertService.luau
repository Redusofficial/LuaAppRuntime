local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local WrapperService = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("wrapperservice"))

local LoadAssetRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("InsertServiceLoadAsset")
local CacheFolder = ReplicatedStorage:WaitForChild("InsertServiceCache")

local Overrides = {
    ["LoadAsset"] = {
        ["Method"] = function(self, assetId: number): any
            if CacheFolder:FindFirstChild(tostring(assetId)) then
                return CacheFolder:FindFirstChild(tostring(assetId)):Clone()
            end

            local Result = LoadAssetRemote:InvokeServer(assetId)

            return Result:Clone()
        end
    }
}

local _InsertService = WrapperService:Create(InsertService)

_InsertService:Add(Overrides)

return _InsertService