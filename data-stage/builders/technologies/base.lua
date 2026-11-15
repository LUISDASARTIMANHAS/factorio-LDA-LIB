local techUtil = require("shared.tech-util")
local utils = require("shared.control-utils")

local Module = {}

--- Cria um protótipo base genérico de tecnologia (TechnologyPrototype).
--- Raiz de herança para tecnologias tradicionais (pesquisa por packs) e por gatilhos (triggers).
---
--- Usage:
--- ```lua
--- local tech = LDA.createBaseTechnology({
---     name = "advanced-automation",
---     prerequisites = {"automation"},
---     unlocks = {"assembling-machine-2"}
--- })
--- ```
---
--- @param params table Configurações da tecnologia
--- @return table TechnologyPrototype
function Module.createBaseTechnology(params)
    if type(params) ~= "table" or not params.name then
        error("[LDA-LIB] [createBaseTechnology] Parâmetro 'name' é obrigatório.")
    end

    local name = params.name
    local icon_path = params.icon or (not params.icons and utils.resolveAssetPath("technology", name .. "-256x256") or nil)

    local effects = params.effects
    if params.unlocks then
        effects = techUtil.createEffectsUnlocksRecipes(params.unlocks)
    end

    local tech_data = {
        type = "technology",
        name = name,
        icon = icon_path,
        icons = params.icons,
        icon_size = params.icon_size or 256,
        icon_mipmaps = params.icon_mipmaps or 4,
        prerequisites = params.prerequisites,
        effects = effects,
        order = params.order or ("a-b-c" .. name),
        upgrade = params.upgrade or false
    }

    if params.unit then
        tech_data.unit = params.unit
    end

    if params.research_trigger then
        tech_data.research_trigger = params.research_trigger
    end

    if params.extra and type(params.extra) == "table" then
        utils.tableMerge(tech_data, params.extra, true)
    end

    return tech_data
end

return Module
