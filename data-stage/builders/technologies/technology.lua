local BaseTechnology = require("data-stage.builders.technologies.base")

local Module = {}

--- Cria um protótipo de Tecnologia tradicional baseada em pacotes científicos (Research Unit).
--- Herda a implementação de BaseTechnology.createBaseTechnology.
---
--- Usage:
--- ```lua
--- local tech = LDA.createTechnology(
---     "automation",
---     { {"automation-science-pack", 1} },
---     {},
---     {"electronic-circuit"},
---     10, 10
--- )
--- ```
---
--- @param name string O nome da tecnologia (ex: "sphere-program", "electromagnetism").
--- @param ingredients table Pacotes científicos necessários para a pesquisa.
--- @param prerequisitesList table|nil Lista de pré-requisitos necessários.
--- @param unlocksList table|nil Lista de receitas desbloqueadas.
--- @param time number|nil Tempo de cada ciclo de pesquisa em segundos (padrão: 30).
--- @param pack_count number|nil Quantidade total de pacotes por ciclo (padrão: 100).
--- @param isUpgrade boolean|nil Se a tecnologia é um upgrade contínuo.
--- @return table TechnologyPrototype
function Module.createTechnology(
    name,
    ingredients,
    prerequisitesList,
    unlocksList,
    time,
    pack_count,
    isUpgrade
)
    return BaseTechnology.createBaseTechnology({
        name = name,
        prerequisites = prerequisitesList,
        unlocks = unlocksList,
        unit = {
            count = pack_count or 100,
            time = time or 30,
            ingredients = ingredients
        },
        order = "a-b-c" .. name,
        upgrade = isUpgrade or false
    })
end

return Module
