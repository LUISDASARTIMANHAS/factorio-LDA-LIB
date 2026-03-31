local Module = {}
local controlGetModPath = require("utils.control-get-mod-path")

-- graphics/icons - icones de itens

function Module.createAutoplaceControl(name, order, tint, icon_size, icon_mipmaps)
    local path_main = controlGetModPath.getModPath()

    local icon_path = path_main .. "graphics/icons/" .. name .. ".png"
    return {
        type = "autoplace-control",
        name = name .. "-ore",
        localised_name = {"", "[entity=" .. name .. "] ", {"entity-name." .. name}},
        richness = true,
        order = "a-" .. order,
        category = "resource",
        icons = {
            {
                icon = icon_path .. ".png",
                tint = tint or nil
            }
        },
        icon_size = icon_size or 64,
        icon_mipmaps = icon_mipmaps or 4
    }
end

-- example
-- game autoplace-control
--   {
--     type = "autoplace-control",
--     name = "iron-ore",
--     localised_name = {"", "[entity=iron-ore] ", {"entity-name.iron-ore"}},
--     richness = true,
--     order = "a-a",
--     category = "resource"
--   }

return Module
