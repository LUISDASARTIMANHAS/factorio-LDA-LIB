local functionRegistry = require("runtime.function-registry")
local Module = {}

function Module.register()
    if not commands or not commands.add_command then return end

    -- Protege contra registro duplicado caso o comando já exista no ambiente global do Factorio
    if commands.commands and commands.commands["lda-list"] then
        return
    end

    commands.add_command("lda-list", "Lista funções da lib LDA", function()
        local functionNames = functionRegistry.getFunctionNames()
        if not functionNames then
            game.print("[LDA] Nenhuma função carregada.")
            return
        end

        for _, name in ipairs(functionNames) do
            game.print("[LDA] " .. name)
        end
    end)
end

return Module