local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local createItem = require("data-stage.builders.base.create-item")

function Module.createBlockItem(name, subgroup, stack_size, icon_size, pick_sound, drop_sound)
    local resolved_stack = stack_size or 1
    return createItem.createBaseItem({
        name = name,
        subgroup = subgroup or "production",
        order = "a[" .. name .. "]",
        stack_size = resolved_stack,
        weight = resolved_stack / 2,
        icon_size = icon_size or 128,
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = pick_sound or item_sounds.mechanical_inventory_pickup,
        drop_sound = drop_sound or item_sounds.mechanical_inventory_move,
        place_result = name
    })
end

-- example
-- {
--     type = "item",
--     name = "assembling-machine-1",
--     icon = "__base__/graphics/icons/assembling-machine-1.png",
--     subgroup = "production-machine",
--     color_hint = { text = "1" },
--     order = "a[assembling-machine-1]",
--     inventory_move_sound = item_sounds.mechanical_inventory_move,
--     pick_sound = item_sounds.mechanical_inventory_pickup,
--     drop_sound = item_sounds.mechanical_inventory_move,
--     place_result = "assembling-machine-1",
--     stack_size = 50,
--     random_tint_color = item_tints.iron_rust
--   },
return Module
