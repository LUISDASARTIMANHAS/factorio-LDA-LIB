local functionRegistry = require("runtime.function-registry")
local Module = {}

function Module.register()
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