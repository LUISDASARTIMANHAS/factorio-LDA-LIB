local apiRegistry = require("api.registry")
local apiModules = require("api.modules")
local publicApi = {}

for name, definition in pairs(apiRegistry) do
    local module = apiModules[definition.module]
    publicApi[name] = definition.member and module[definition.member] or module
end

return publicApi
