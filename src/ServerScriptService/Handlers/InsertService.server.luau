local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local LoadAssetRemote = ReplicatedStorage.Remotes.InsertServiceLoadAsset

local CacheFolder = ReplicatedStorage.InsertServiceCache

LoadAssetRemote.OnServerInvoke = function(Player: Player, assetId: number)
    if CacheFolder:FindFirstChild(tostring(assetId)) then
        return CacheFolder:FindFirstChild(tostring(assetId))
    end

    local Asset = InsertService:LoadAsset(assetId)

    Asset.Parent = CacheFolder

    return Asset
end