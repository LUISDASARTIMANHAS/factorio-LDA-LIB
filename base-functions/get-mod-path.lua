-- get-mod-path.lua
-- @return string Caminho formatado do mod atual, ex: "__LDA-LIB__/"

--- get-mod-path.lua
--- @return string Caminho formatado do mod chamador
local function getModPath()
    if not data or not data.mod_name then
        error("getModPath só pode ser usado no data stage.")
    end

    return "__" .. data.mod_name .. "__/"
end

return getModPath