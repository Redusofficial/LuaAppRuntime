local process = require("@lune/process")

print("Building LuaAppRuntime")

local BuildResult = process.exec("rojo", {
    "build",
    "--output", 
    "./output/ProjectBuild.rbxl",
    "default.project.json"
})

if BuildResult then
  print(BuildResult.stdout)
else
  print(BuildResult.stderr)
end