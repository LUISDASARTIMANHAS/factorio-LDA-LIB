local Module = {}
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local controlGetModPath = require("utils.control-get-mod-path")
local utils = require("utils.control-utils")
-- stone-brick
-- subgroup = terrain 

-- wood,coal,iron-ore
-- subgroup = raw-resource

-- iron-plate, copper-plate
-- subgroup = raw-material

-- copper-cable,iron-stick,iron-gear-wheel
-- subgroup = intermediate-product

-- wooden-chest,
-- subgroup = storage

-- stone-furnace
-- subgroup = rawsmelting-machine

-- burner-mining-drill,electric-mining-drill
-- subgroup = extraction-machine

-- burner-inserter,inserter
-- subgroup = inserter

-- pipe,small-electric-pole
-- subgroup = energy-pipe-distribution

-- boiler,steam-engine
-- subgroup = energy

-- radar
-- subgroup = defensive-structure

-- small-lamp
-- subgroup = circuit-network

-- assembling-machine-1
-- subgroup = production-machine

-- red-wire,green-wire
-- subgroup = spawnables

-- repair-pack,automation-science-pack
-- subgroup = tool

-- car
-- subgroup = transport


--- Cria um protótipo de Item (ItemPrototype).
-- @param name (string) Nome único do item (e.g., "iron-gear-wheel").
-- @param subgroup (string, optional) Subgrupo do menu de crafting. Padrão: "basic-crafting".
-- @param stack_size (uint16, optional) Tamanho da pilha. Padrão: 100.
-- @param pictures (array[SpritePath], optional) Lista de sprites/pictures (impede o uso de icon_size).
-- @return (table) ItemPrototype
function Module.createItem(name, subgroup, stack_size, pictures)
    -- Assumindo que controlGetModPath.getModPath() está acessível.
    local path_main = controlGetModPath.getModPath()
    local icon_path = path_main .. "graficos/itens/" .. name .. ".png"
    
    -- 1. Cria a tabela base com campos comuns
    local item_data = {
        type = "item",
        name = name,
        icon = icon_path,
        subgroup = subgroup or "basic-crafting",
        order = "b[".. (subgroup or "basic-crafting") .. "]-a[" .. name .. "item" .. "]",
        
        -- Detalhes visuais e de som
        color_hint = {text = "1"},
        inventory_move_sound = item_sounds.metal_small_inventory_move,
        pick_sound = item_sounds.metal_small_inventory_pickup,
        drop_sound = item_sounds.metal_small_inventory_move,
        random_tint_color = item_tints.iron_rust,
        
        -- Detalhes de empilhamento/peso
        stack_size = stack_size or 100,
        weight = (stack_size or 100) / 2, -- O peso deve ser baseado no stack_size final
        ingredient_to_weight_coefficient = 0.28,
    }

    -- 2. Adiciona 'pictures' e decide sobre 'icon_size'
    if pictures and #pictures > 0 then
        -- Se 'pictures' existe e tem elementos, adiciona 'pictures' e NÃO adiciona 'icon_size'
        item_data.pictures = pictures
        -- item_data.icon_size é omitido
    else
        -- Se 'pictures' é nulo, vazio ou não foi fornecido, adiciona 'icon_size'
        item_data.icon_size = 128
        -- item_data.pictures é omitido (ou será nil, mas Factorio prefere omitir)
        item_data.pictures = nil -- Garante que a chave pictures não vá com nil se for o caso
    end
    
    return item_data
end

-- example
-- {
--     type = "item",
--     name = "electronic-circuit",
--     icon = "__base__/graphics/icons/electronic-circuit.png",
--     subgroup = "intermediate-product",
--     color_hint = { text = "1" },
--     order = "b[circuits]-a[electronic-circuit]",
--     inventory_move_sound = item_sounds.electric_small_inventory_move,
--     pick_sound = item_sounds.electric_small_inventory_pickup,
--     drop_sound = item_sounds.electric_small_inventory_move,
--     stack_size = 200,
--     ingredient_to_weight_coefficient = 0.28
--   },

return Module
