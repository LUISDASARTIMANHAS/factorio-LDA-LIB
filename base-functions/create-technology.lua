local controlGetModPath = require("utils.control-get-mod-path")
local techUtil = require("utils.tech-util")
local Module = {}
-- graphics/technology - icones de pesquisa


-- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
-- @param ingredients tabela de pacotes cientificos necessarios para a pesquisa (ex: "energy-matrix").
-- @param unlocks tabela de receitasa a desbloquear tecnologia (ex: "processor").
-- @param prerequisites tabela de pre requisitos necessarios para pesquisar essa pesquisa (ex: "tech-dyston-sphere-program").
function Module.createTechnology(
    name,
    ingredients,
    prerequisitesList,
    unlocksList,
    time,
    pack_count,
    isUpgrade,
    icon_size)
    local path_main = controlGetModPath.getModPath()

    local technology = {
        type = "technology",
        name = name,
        icon = path_main .. "graphics/technology/" .. name .. ".png",
        icon_size = icon_size or 64,
        icon_mipmaps = 4,
        prerequisites = prerequisitesList,
        effects = techUtil.createEffectsUnlocksRecipes(unlocksList),
        unit = {
            count = pack_count or 100,
            time = time or 30,
            ingredients = ingredients
        },
        order = "a-b-c" .. name,
        upgrade = isUpgrade or false
    }
    return technology
end

-- example return
--   {
--     type = "technology",
--     name = "physical-projectile-damage-2",
--     icons = util.technology_icon_constant_damage(physical_projectile_damage_1_icon),
--     effects =
--     {
--       {
--         type = "ammo-damage",
--         ammo_category = "bullet",
--         modifier = 0.1
--       },
--       {
--         type = "turret-attack",
--         turret_id = "gun-turret",
--         modifier = 0.1
--       },
--       {
--         type = "ammo-damage",
--         ammo_category = "shotgun-shell",
--         modifier = 0.1
--       }
--     },
--     prerequisites = {"physical-projectile-damage-1", "logistic-science-pack"},
--     unit =
--     {
--       count = 100 * 2,
--       ingredients =
--       {
--         {"automation-science-pack", 1},
--         {"logistic-science-pack", 1}
--       },
--       time = 30
--     },
--     upgrade = true
--   }

return Module
