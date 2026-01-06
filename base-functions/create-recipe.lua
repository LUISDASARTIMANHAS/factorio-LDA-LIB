local Module = {}
local controlGetModPath = require("utils.control-get-mod-path")


-- @param typeIcon {string} concatena pastas com base no tipo do item, ex "graphics/typeIcon/name.png"
function Module.createRecipe(typeIcon, name, crafted_in, time, ingredients, results,alternative_unlock_methods,enabled,pictures)
    local path_main = controlGetModPath.getModPath()
    for _, v in ipairs(ingredients) do
        if v.type ~= "item" and v.type ~= "fluid" then
            error("Tipo de ingrediente inválido: '" .. tostring(v.type) .. "' em " .. name)
        end
    end
    for _, v in ipairs(results) do
        if v.type ~= "item" and v.type ~= "fluid" then
            error("Tipo de resultado inválido: '" .. tostring(v.type) .. "' em " .. name)
        end
    end

    local icon_path = path_main .. "graphics/" .. typeIcon .. "/" .. name .. ".png"

    local item_data = {
        type = "recipe",
        name =  name,
        category = crafted_in,
        enabled = enabled or false,
        energy_required = time,
        icon = icon_path,
        ingredients = ingredients,
        results = results,
        maximum_productivity = 2,
        allow_quality = true,
        always_show_madein = true,
        allowed_module_categories = {"productivity", "speed"},
        alternative_unlock_methods = alternative_unlock_methods
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
--      {
--             type = "recipe",
--             name = "iron-ore",
--             category = "advanced-crafting",
--             enabled = false,
--             energy_required = 120,
--             ingredients = {
--                 {type = "item", name = "supercapacitor", amount = 4096},
--                 {type = "item", name = "tungsten-plate", amount = 256},
--                 {type = "item", name = "carbon-fiber", amount = 64},
--                 {type = "item", name = "quantum-processor", amount = 256}
--             },
--             results = {
--                 {type = "item", name = "quantum-teleporter-equipment", amount = 1}
--             },
--             alternative_unlock_methods = {"Quantum-Teleporter"}
--         }
return Module
