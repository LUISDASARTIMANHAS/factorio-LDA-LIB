local apiRegistry = require("api.registry")
local functionRegistry = require("runtime.function-registry")
local commands = require("runtime.commands")

local player = require("runtime.modules.player")
local entity = require("runtime.modules.entity")
local world = require("runtime.modules.world")
local item = require("runtime.modules.item")
local network = require("runtime.modules.network")
local gui = require("runtime.modules.gui")
local equipment_grid = require("runtime.modules.equipment_grid")

local Runtime = {
    player = player,
    entity = entity,
    world = world,
    item = item,
    network = network,
    gui = gui,
    equipment_grid = equipment_grid,
    commands = commands
}

if storage then
    storage.lda = storage.lda or {function_names = {}}
end

-- Registra comandos e lifecycle hooks apenas quando o runtime é executado diretamente pelo mod LDA-LIB.
-- Quando importado por mods consumidores como biblioteca (ex: require("__LDA-LIB__/runtime.init")),
-- não executamos script.on_init (para não sobrescrever o handler do mod) nem commands.register()
-- incondicionalmente no top-level (evitando colisão "A script command already exists with the name: lda-list").
local is_own_mod = script and script.mod_name == "LDA-LIB"

if is_own_mod then
    if script then
        script.on_init(function()
            functionRegistry.initialize(apiRegistry)
            if game then
                game.print("[LDA-LIB] LOADED LIB.")
            end
        end)
    end

    commands.register()
end

if remote and not remote.interfaces["LDA-LIB"] then
    remote.add_interface("LDA-LIB", {
        player_give = player.give,
        player_remove = player.remove,
        player_teleport = player.teleport,
        player_flying_text = player.flyingText,
        player_notify = player.notify,
        entity_heal = entity.heal,
        entity_damage = entity.damage,
        entity_destroy = entity.destroy,
        world_spawn_entity = world.spawnEntity,
        world_find_in_radius = world.findEntitiesInRadius,
        world_set_tile = world.setTile,
        item_transfer = item.transfer,
        item_spill = item.spill,
        item_collect = item.collectFromGround,
        network_register = network.register,
        network_unregister = network.unregister,
        network_get = network.get,
        network_get_all = network.getAll,
        network_set_name = network.setName,
        network_set_metadata = network.setMetadata,
        network_find_free_spawn_position = network.findFreeSpawnPosition,
        network_cleanup = network.cleanup,
        network_count = network.count,
        gui_find_element_by_name = gui.findElementByName,
        gui_create_window = gui.createWindow,
        gui_close_window = gui.closeWindow,
        gui_get_window = gui.getWindow,
        gui_toggle_window = gui.toggleWindow,
        gui_create_energy_bar = gui.createEnergyBar,
        gui_update_energy_bar = gui.updateEnergyBar,
        gui_format_energy = gui.formatEnergy,
        gui_format_power = gui.formatPower,
        equipment_grid_get_energy = equipment_grid.getEnergy,
        equipment_grid_get_max_energy = equipment_grid.getMaxEnergy,
        equipment_grid_has_energy = equipment_grid.hasEnergy,
        equipment_grid_drain_energy = equipment_grid.drainEnergy,
        equipment_grid_add_energy = equipment_grid.addEnergy,
        equipment_grid_get_grid = equipment_grid.getGrid
    })
end

return Runtime
