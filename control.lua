-- Carrega a lib uma única vez (permitido)
local lda = require("__LDA-LIB__/init")

-- Garante que lda.functions exista
lda.functions = lda.functions or {}

-- Gera lista serializável de funções
storage.lda = storage.lda or {
    function_names = {}
}

-- Limpa e registra novamente o estado
storage.lda.function_names = {}

for name, _ in pairs(lda.functions) do
    log("[LDA-LIB] função encontrada: " .. name)
    table.insert(storage.lda.function_names, name)
end

-- Comando para listar funções no console do jogo
commands.add_command("lda-list", "Lista funções da lib LDA", function()
    if not storage.lda or not storage.lda.function_names then
        game.print("[LDA] Nenhuma função carregada.")
        return
    end

    for _, name in ipairs(storage.lda.function_names) do
        game.print("[LDA] " .. name)
    end
end)

game.print("[LDA-LIB] LOADED LIB.");