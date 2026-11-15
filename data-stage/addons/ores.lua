-- Addon: Ores Demonstration
-- Demonstração prática do uso de createOre e createOreItem para Factorio 2.0+ / 2.1+.
-- Recursos adicionados:
-- 1. Bauxita (Alumínio)
-- 2. Família do Lítio (Espodumênio, Lepidolita, Petalita, Ambligonita, Montebrasita)
-- 3. Família do Zinco (Esfalerita, Smithsonita, Hemimorfita, Willemita, Wurtzita, Zincita, Franklinita, Marmatita)

local createOre = require("data-stage.builders.base.create-ore").createOre
local createOreItem = require("data-stage.builders.base.create-ore-item").createOreItem

-- Helper local para gerar ícones tintados sobre a base de minério do Factorio
local function makeOreIcon(tint, base_icon)
    local icon_file = base_icon or "__base__/graphics/icons/iron-ore.png"
    return {
        {
            icon = icon_file,
            icon_size = 64,
            icon_mipmaps = 4,
            tint = tint
        }
    }
end

-- 1. BAUXITA (Minério principal de Alumínio)

-- Bauxita: Rocha sedimentar rica em hidróxidos de alumínio e óxidos de ferro (tom terracota).
local bauxite_tint = {r = 0.85, g = 0.45, b = 0.25, a = 1.0}
data:extend(
    createOre({
        name = "bauxite",
        stack_size = 100,
        order = "b[bauxite]",
        icons = makeOreIcon(bauxite_tint, "__base__/graphics/icons/copper-ore.png"),
        icon_size = 64,
        map_color = {0.85, 0.45, 0.25},
        mining_time = 1.0,
        mining_visualisation_tint = bauxite_tint,
        base_density = 12,
        regular_rq_factor_multiplier = 1.15
    })
)

-- 2. FAMÍLIA DO LÍTIO (Lithium)

-- Recurso Primário no Terreno: Espodumênio (Principal fonte de lítio no Brasil - Vale do Jequitinhonha/MG)
local spodumene_tint = {r = 0.80, g = 0.92, b = 0.85, a = 1.0}
data:extend(
    createOre({
        name = "spodumene",
        stack_size = 100,
        order = "c[lithium]-a[spodumene]",
        icons = makeOreIcon(spodumene_tint),
        icon_size = 64,
        map_color = {0.80, 0.92, 0.85},
        mining_time = 1.5,
        mining_visualisation_tint = spodumene_tint,
        base_density = 10,
        fuel_categories = {"chemical"},
        fuel_value = "1.5MJ"
    })
)

-- Sub-minérios de Lítio (Criados com createOreItem para refino, processamento e beneficiamento)

-- Lepidolita: Tipo de mica rica em lítio (tonalidade lilás/rosada)
data:extend({
    createOreItem({
        name = "lepidolite",
        stack_size = 100,
        order = "c[lithium]-b[lepidolite]",
        icons = makeOreIcon({r = 0.85, g = 0.55, b = 0.85, a = 1.0}),
        icon_size = 64,
        fuel_categories = {"chemical"},
        fuel_value = "1.2MJ",
        weight = 50
    })
})

-- Petalita: Mineral histórico onde o lítio foi descoberto pela primeira vez (vítreo/claro)
data:extend({
    createOreItem({
        name = "petalite",
        stack_size = 100,
        order = "c[lithium]-c[petalite]",
        icons = makeOreIcon({r = 0.93, g = 0.96, b = 0.96, a = 1.0}),
        icon_size = 64,
        fuel_categories = {"chemical"},
        fuel_value = "1.0MJ",
        weight = 50
    })
})

-- Ambligonita: Aluminossilicato/fosfato com lítio em sua composição (tom leitoso/creme)
data:extend({
    createOreItem({
        name = "amblygonite",
        stack_size = 100,
        order = "c[lithium]-d[amblygonite]",
        icons = makeOreIcon({r = 0.95, g = 0.92, b = 0.78, a = 1.0}),
        icon_size = 64,
        fuel_categories = {"chemical"},
        fuel_value = "1.4MJ",
        weight = 50
    })
})

-- Montebrasita: Isomorfo da ambligonita com alto teor de lítio (tom amarelado pálido)
data:extend({
    createOreItem({
        name = "montebrasite",
        stack_size = 100,
        order = "c[lithium]-e[montebrasite]",
        icons = makeOreIcon({r = 0.88, g = 0.86, b = 0.72, a = 1.0}),
        icon_size = 64,
        fuel_categories = {"chemical"},
        fuel_value = "1.4MJ",
        weight = 50
    })
})

-- 3. FAMÍLIA DO ZINCO (Zinc)

-- Recurso Primário no Terreno: Esfalerita / Blenda (ZnS - Sulfeto de zinco, principal minério no mundo)
local sphalerite_tint = {r = 0.45, g = 0.35, b = 0.25, a = 1.0}
data:extend(
    createOre({
        name = "sphalerite",
        stack_size = 100,
        order = "d[zinc]-a[sphalerite]",
        icons = makeOreIcon(sphalerite_tint),
        icon_size = 64,
        map_color = {0.45, 0.35, 0.25},
        mining_time = 1.2,
        mining_visualisation_tint = sphalerite_tint,
        base_density = 10
    })
)

-- Smithsonita: Carbonato de zinco (ZnCO3 - tonalidade verde-turquesa característica)
data:extend({
    createOreItem({
        name = "smithsonite",
        stack_size = 100,
        order = "d[zinc]-b[smithsonite]",
        icons = makeOreIcon({r = 0.30, g = 0.75, b = 0.70, a = 1.0}),
        icon_size = 64,
        weight = 50
    })
})

-- Hemimorfita / Calamina: Silicato hidratado de zinco (Zn4Si2O7(OH)2·H2O - azul celeste suave)
data:extend({
    createOreItem({
        name = "hemimorphite",
        stack_size = 100,
        order = "d[zinc]-c[hemimorphite]",
        icons = makeOreIcon({r = 0.50, g = 0.72, b = 0.90, a = 1.0}),
        icon_size = 64,
        weight = 50
    })
})

-- Willemita: Silicato de zinco (Zn2SiO4 - verde fluorescente)
data:extend({
    createOreItem({
        name = "willemite",
        stack_size = 100,
        order = "d[zinc]-d[willemite]",
        icons = makeOreIcon({r = 0.60, g = 0.88, b = 0.35, a = 1.0}),
        icon_size = 64,
        weight = 50
    })
})

-- Wurtzita: Sulfeto de zinco polimorfo da esfalerita ((Zn,Fe)S - castanho avermelhado)
data:extend({
    createOreItem({
        name = "wurtzite",
        stack_size = 100,
        order = "d[zinc]-e[wurtzite]",
        icons = makeOreIcon({r = 0.55, g = 0.30, b = 0.20, a = 1.0}),
        icon_size = 64,
        weight = 50
    })
})

-- Zincita: Óxido de zinco (ZnO - vermelho alaranjado vivo)
data:extend({
    createOreItem({
        name = "zincite",
        stack_size = 100,
        order = "d[zinc]-f[zincite]",
        icons = makeOreIcon({r = 0.90, g = 0.38, b = 0.20, a = 1.0}),
        icon_size = 64,
        weight = 50
    })
})

-- Franklinita: Óxido de zinco, ferro e manganês (ZnFe2O4 - preto metálico)
data:extend({
    createOreItem({
        name = "franklinite",
        stack_size = 100,
        order = "d[zinc]-g[franklinite]",
        icons = makeOreIcon({r = 0.25, g = 0.25, b = 0.28, a = 1.0}),
        icon_size = 64,
        weight = 60
    })
})

-- Marmatita: Variedade de esfalerita rica em ferro ((Zn,Fe)S - preto opaco)
data:extend({
    createOreItem({
        name = "marmatite",
        stack_size = 100,
        order = "d[zinc]-h[marmatite]",
        icons = makeOreIcon({r = 0.20, g = 0.18, b = 0.18, a = 1.0}),
        icon_size = 64,
        weight = 55
    })
})
