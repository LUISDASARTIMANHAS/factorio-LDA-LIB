-- get-mod-path.lua
local Module = {}
Module.basePath = nil

-- @return string Caminho formatado do mod atual, ex: "__LDA-LIB__/"
--- get-mod-path.lua
--- @return string Caminho formatado do mod chamador
function Module.getModPath()
    local path = Module.basePath  -- agora é global para biblioteca inteira
    -- caso o mod dependente não tenha definido o setBasePath
    if path == nil then
        error("path não definido! por favor defina o caminho do mod logo abaixo da importação dele por exemplo: \n local LDA = require('__LDA-LIB__/init') \n local PATH = LDA.setBasePath('__Quantum-Teleporter__/')")
    end

    if not path then
        error("getModPath só pode ser usado no data stage.")
    end

    return "__" .. path .. "__/"
end

--- Define o caminho base do mod chamador
-- @param path string Caminho ex.: "Quantum-Teleporter"
-- @return string Retorna o mesmo path
function Module.setBasePath(path)
    Module.basePath = path
    return "__" .. path .. "__/"
end

return Module