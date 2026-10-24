local Module = {}

function Module.initialize(apiRegistry)
    storage.lda = storage.lda or {}
    storage.lda.function_names = {}

    for name in pairs(apiRegistry) do
        log("[LDA-LIB] função encontrada: " .. name)
        table.insert(storage.lda.function_names, name)
    end

    table.sort(storage.lda.function_names)
end

function Module.getFunctionNames()
    if not storage.lda or not storage.lda.function_names then
        return nil
    end

    return storage.lda.function_names
end

return Module