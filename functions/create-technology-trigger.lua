local controlGetModPath = require("utils.control-get-mod-path")
local techUtil = require("utils.tech-util")

local Module = {}
-- graphics/technology - icones de pesquisa

-- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
-- @param unlocks tabela de receitasa a desbloquear tecnologia (ex: "processor").
-- @param prerequisites tabela de pre requisitos necessarios para pesquisar essa pesquisa (ex: "tech-dyston-sphere-program").
function Module.createTechnologyTrigger(name, unlocksList, prerequisitesList, research_trigger,icon_size)
    local path_main = controlGetModPath.getModPath()

    local technologyTrigger ={
        type = "technology",
        name = name,
        icon = path_main .. "graphics/technology/" .. name .. ".png",
        icon_size = icon_size or 64,
        icon_mipmaps = 4,
        prerequisites = prerequisitesList,
        effects = techUtil.createEffectsUnlocksRecipes(unlocksList),
        -- so e permitido 1 trigger
        research_trigger = research_trigger,
        order = "a-b-" .. name
    }
    return technologyTrigger
end

-- example
-- {
--     type = "technology",
--     name = "steam-power",
--     icon = "__base__/graphics/technology/steam-power.png",
--     icon_size = 256,
--     effects =
--     {
--       {
--         type = "unlock-recipe",
--         recipe = "pipe"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "pipe-to-ground"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "offshore-pump"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "boiler"
--       },
--       {
--         type = "unlock-recipe",
--         recipe = "steam-engine"
--       }
--     },
--     research_trigger =
--     {
--       type = "craft-item",
--       item = "iron-plate",
--       count = 50
--     }
--   },

return Module
