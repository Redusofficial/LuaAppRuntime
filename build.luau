local DateTime = require("@lune/datetime")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

print("Building LuaAppRuntime")

local Start = DateTime.now().unixTimestampMillis

local ProjectBuildPath = "./build/ProjectBuild.rbxl"
local OutputPath = "./build/LuaAppRuntime.rbxl"

local InjectCode = '_G.Env(getfenv())'

local ReplaceCode = {
  {"OverlayNativeInput = true,", ""},
  {"OverlayNativeInput = true;", ""},
  {
    "self.connection\x20=\x20event:Connect(callback)",
    [[
    if not event then
      return
    end
    self.connection = event:Connect(callback)
    ]]
  }
}

local BuildResult = process.exec("rojo", {
    "build",
    "--output", 
    ProjectBuildPath,
    "default.project.json"
})

if BuildResult.ok then
  print(BuildResult.stdout)
else
  return warn(`Failed to build:\n{BuildResult.stderr}`)
end

print("Applying Patches to", ProjectBuildPath)

local PlaceFile = fs.readFile(ProjectBuildPath)
local game = roblox.deserializePlace(PlaceFile)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _, Child in ReplicatedStorage:FindFirstChild("Children"):GetChildren() do
    Child.Parent = ReplicatedStorage
end

ReplicatedStorage:FindFirstChild("Children"):Destroy()

for _, Module: ModuleScript in ReplicatedStorage.Services:GetDescendants() do
    if not Module:IsA("ModuleScript") then
      continue
    end

    Module.Source = InjectCode .. "\n" .. Module.Source

    for _, Replacement in ReplaceCode do
      if string.find(Module.Source, "self.connection\x20=\x20event:Connect(callback)") then
        print(Module.Name)
      end
      Module.Source = string.gsub(Module.Source, Replacement[1], Replacement[2])
    end
end

local LuaAppRuntime = roblox.serializePlace(game)
fs.writeFile(OutputPath, LuaAppRuntime)

print(`Built LuaAppRuntime in {DateTime.now().unixTimestampMillis - Start}ms`)