local apiRegistry = require("api.registry")
local functionRegistry = require("runtime.function-registry")
local commands = require("runtime.commands")

storage.lda = storage.lda or {function_names = {}}

script.on_init(function()
    functionRegistry.initialize(apiRegistry)
    game.print("[LDA-LIB] LOADED LIB.")
end)

commands.register()