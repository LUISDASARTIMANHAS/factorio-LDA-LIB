-- get-mod-path.lua
-- @return string Caminho formatado do mod atual, ex: "__LDA-LIB__/"

local function getModPath()
    local info = debug.getinfo(2, "S")

    if not info or not info.source then
        error("get-mod-path.lua: não foi possível obter o source do módulo.")
    end

    -- Exemplo de info.source:
    -- "@__LDA-LIB__/base-functions/get-mod-path.lua"
    local mod_name = info.source:match("@__([^/]+)__")

    if not mod_name then
        error("get-mod-path.lua: não foi possível detectar o nome do mod a partir de debug.getinfo.")
    end

    return "__" .. mod_name .. "__/"
end

return getModPath