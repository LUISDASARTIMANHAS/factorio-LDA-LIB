--- LDA-LIB - Init
--- Carrega automaticamente todas as funções da lib de forma modular.

local LDA = {}

--- Log formatado
-- @param msg string
local function log_debug(msg)
    if settings.startup["lda-lib-debug"] and settings.startup["lda-lib-debug"].value then
        log("[LDA-LIB]: " .. msg)
    end
end

--- Importa todas as funções de um diretório dentro do mod.
-- @param path string Caminho para a pasta
-- @return table Tabela com os módulos carregados
local function import_directory(path)
    local modules = {}

    -- Obtém todos os arquivos da pasta
    for _, file in pairs(require("util").get_file_list(path)) do
        local module_name = file:gsub("%.lua$", "")
        local file_path = path .. "/" .. module_name

        local ok, module = pcall(require, file_path)

        if ok then
            modules[module_name] = module
            log_debug("Carregado: " .. file_path)
        else
            log("ERRO ao carregar módulo " .. file_path .. ": " .. module)
        end
    end

    return modules
end

-- Carrega todas as funções genéricas
LDA.generic = import_directory("generic-functions")

-- Carrega funções avançadas
LDA.fn = import_directory("functions")

script.on_init(function()
    log_debug("Inicializado LDA-LIB")
end)

return LDA