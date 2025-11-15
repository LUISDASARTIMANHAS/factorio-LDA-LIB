--- Utilitário para detectar automaticamente o nome do mod atual
--- Funciona exclusivamente no data stage (data.lua, data-updates.lua, data-final-fixes.lua)
--- Uso:
---     local path_main = require("generic-functions.get-mod-path")()
---
--- @return string Caminho formatado do mod atual, ex: "__LDA-LIB__/"

local function getModPath()
    -- Obtém o path interno enviado pelo Factorio ao carregar o módulo
    local current_path = (... or "")

    -- Extrai o nome do mod do padrão "__MOD__/subfolder/file.lua"
    --- @type string|nil
    local mod_name = current_path:match("__([^/]+)__")

    if not mod_name then
        error("get-mod-path.lua: Não foi possível detectar o nome do mod automaticamente.")
    end

    return "__" .. mod_name .. "__/"
end

return getModPath