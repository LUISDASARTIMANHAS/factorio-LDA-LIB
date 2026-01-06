-- throw-in-water.lua
-- Este arquivo define a entidade Assembling Machine customizada para o processo de "Throw In Water".
local utils = require("utils.control-utils")
local utilsEnergySource = require("utils.control-energy-sources")
local utilsAnimations = require("utils.control-animations")
local controlCreateBlocItemWithRecipe = require("generic-functions.create-block-item-with-recipe")
local controlGetModPath = require("utils.control-get-mod-path")
local controlCreateItemWithRecipe = require("generic-functions.create-item-with-recipe")
local PATH = controlGetModPath.setBasePath("LDA-LIB")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

-- __base__/sound/world/water/waterlap
data:extend(
    {
        {
            type = "assembling-machine",
            name = "throw-in-water",
            -- Gráficos e Ícones
            icon = PATH .. "graphics/entities/throw-in-water.png",
            icon_size = 512,
            icon_mipmaps = 2,
            -- Propriedades Físicas e de Mineração
            minable = {mining_time = 20, result = "throw-in-water"}, -- Adicione um item resultado se for minável
            max_health = 99999999, -- Saúde alta, conforme seu exemplo
            -- Configurações de Crafting
            crafting_speed = 1.0, -- Reduzido para 1.0 (mais realista para uma reação natural)
            ingredient_count = 2,
            off_when_no_fluid_recipe = true,
            -- *** CHAVE ***: Categoria de Receita Customizada
            crafting_categories = {"throw-in-water"},
            -- ALTERAÇÃO CRUCIAL AQUI: energy_usage deve ser > 0
            -- O custo energético da eletrólise da água é alto, exigindo cerca de 50-55 kWh de eletricidade para produzir 1 kg de hidrogênio, com um valor teórico de ~39,4 kWh/kg (HHV), mas perdas reais aumentam isso, com foco em tecnologias como PEM e Alcalina para melhorar a eficiência e reduzir o custo por kg de H₂, visando metas como US$ 1/kg até 2030.
            energy_usage = "55kW",
            energy_source = utilsEnergySource.createElectricEnergySource(
                "secondary-input",
                nil,
                "55kW",
                "55kW",
                0,
                false,
                false
            ),
            -- Poluição e Efeitos
            allowed_effects = {"pollution"},
            -- x_max = 1.2, y_max = 1.2 (automático)
            collision_box = utils.createBoundingBox(1.2),
            -- x_max = 1.5, y_max = 1.5 (automático)
            selection_box = utils.createBoundingBox(1.5),
            -- x_max = 1.5, y_max = 1.5 (automático)
            drawing_box = utils.createBoundingBox(1.5),
            -- Destruição e Resistências
            resistances = utils.getFullResistance(),
            corpse = "assembling-machine-2-remnants", -- Usando remanescentes do Factorio base
            dying_explosion = "assembling-machine-2-explosion",
            -- Módulos
            module_specification = utils.createModuleSpec(0),
            -- Flags
            flags = {"placeable-neutral", "placeable-player", "player-creation"},
            placeable_by = {item = "throw-in-water", count = 1}, -- Certifique-se de definir o item
            -- Animação
            animation = utilsAnimations.createAnimation(
                utilsAnimations.createAnimationLayer(PATH .. "graphics/entities/throw-in-water", 512, 512)
            ),
            picture = {
                layers = {
                    utilsAnimations.createAnimationLayer(
                        PATH .. "graphics/entities/throw-in-water",
                        512,
                        512,
                        nil,
                        {0, -0.015625}
                    ),
                    utilsAnimations.createAnimationLayer(
                        PATH .. "graphics/entities/throw-in-water",
                        512,
                        512,
                        nil,
                        {0.3125, 0.203125},
                        true
                    ),
                }
            },
            -- Sons
            close_sound = {utils.getAudio("__base__/sound/world/waterlap", 1)},
            open_sound = {utils.getAudio("__base__/sound/world/waterlap", 1)},
            working_sound = {
                sound = {utils.getAudio("__LDA-LIB__/audios/water", 1)},
                fade_in_ticks = 4,
                audible_distance_modifier = 0.5,
                fade_out_ticks = 20
            },
            -- Sons de Impacto de Veículo
            vehicle_impact_sound = utils.getSequentialAudioList(
                "__base__/sound/world/water/waterlap-", -- Nome base do arquivo
                1, -- Começa no 2 (car-metal-impact-2.ogg)
                10, -- Termina no 6 (car-metal-impact-6.ogg)
                0.5 -- Volume (opcional, mas bom manter)
            )
        }
    }
)

-- Nota de Segurança: A Categoria de Receita e o Item de Colocação também devem ser definidos!
-- 1. Definição da Categoria de Receita (Obrigatório para que as receitas funcionem)
data:extend(
    {
        {
            type = "recipe-category",
            name = "throw-in-water"
        }
    }
)

-- Definição do Item de Colocação (Obrigatório, senão a entidade não pode ser colocada)
-- Assumimos que o item tem o mesmo nome da entidade
data:extend(
    controlCreateBlocItemWithRecipe.createBlockItemWithRecipe(
        "throw-in-water", -- nome do item
        "production-machine",
        1,
        "crafting",
        60,
        -- ingredientes
        {
            {type = "item", name = "water-barrel", amount = 10}
        },
        -- results
        {
            {type = "item", name = "throw-in-water", amount = 1}
        },
        nil,
        true,
        nil,
        512,
        utils.getAudio("__LDA-LIB__/audios/water-bubbles"),
        utils.getAudio("__LDA-LIB__/audios/water-bubbles")
    )
)
-- duplicação de sementes
data:extend(
    controlCreateItemWithRecipe.createItemWithRecipe(
        "yumako-seed-x2",
        "agriculture-processes",
        5,
        "throw-in-water",
        5,
        -- ingredients
        {
            {type = "item", name = "yumako-seed", amount = 1},
            {type = "item", name = "nutrients", amount = 2}
        },
        -- results
        {
            {type = "item", name = "yumako-seed", amount = 2}
        },
        nil,
        true,
        utils.getSequentialPictureList(PATH .. "graphics/icons/yumako-seed-x2-", 1, 4, 64, 0.5, 4)
    )
)
