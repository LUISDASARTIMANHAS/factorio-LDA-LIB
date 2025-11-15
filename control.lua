local lda = require("__LDA-LIB__/init")

-- Loga automaticamente todas as funções carregadas da lib
for name, value in pairs(lda.functions) do
    log("[LDA-LIB] função encontrada: " .. name)
end

-- Comando para listar funções no console do jogo
commands.add_command("lda-list", "Lista funções da lib LDA", function()
    if not storage.lda then
        game.print("[LDA] ERRO: storage.lda não foi inicializado.")
        return
    end

    for name,_ in pairs(storage.lda.functions) do
        game.print("[LDA] " .. name)
    end
end)

-- Expõe a lib para debug em /sc
storage.lda = lda
