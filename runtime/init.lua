local apiRegistry = require("api.registry")
local functionRegistry = require("runtime.function-registry")
local commands = require("runtime.commands")

local player = require("runtime.modules.player")
local entity = require("runtime.modules.entity")
local world = require("runtime.modules.world")
local item = require("runtime.modules.item")

local Runtime = {
    player = player,
    entity = entity,
    world = world,
    item = item
}

if storage then
    storage.lda = storage.lda or {function_names = {}}
end

if script then
    script.on_init(function()
        functionRegistry.initialize(apiRegistry)
        if game then
            game.print("[LDA-LIB] LOADED LIB.")
        end
    end)
end

commands.register()

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
        item_collect = item.collectFromGround
    })
end

return Runtime
