--- LDA-LIB: Settings
--- Configurações iniciais para habilitar ou desabilitar logs de debug da biblioteca.

data:extend({
    {
        type = "bool-setting",
        name = "lda-lib-debug",
        setting_type = "startup",
        default_value = true,
        order = "a",
        localised_name = {"mod-setting-name.lda-lib-debug"},
        localised_description = {"mod-setting-description.lda-lib-debug"}
    }
})
