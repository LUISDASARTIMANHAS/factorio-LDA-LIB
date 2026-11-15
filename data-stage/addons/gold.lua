
-- Addon: Gold Demonstration
--
-- Demonstração prática do uso de createOre e createOreItem
-- para Factorio 2.0+ / 2.1+.
--
-- Recursos adicionados:
--
-- 1. Ouro nativo (Au)
-- 2. Electrum (Au,Ag)
-- 3. Calaverita (AuTe2)
-- 4. Silvanita (AuAgTe4)
-- 5. Petzita (Ag3AuTe2)
-- 6. Krennerita (Au1-xAgxTe2)
-- 7. Maldonita (Au2Bi)
-- 8. Aurostibita (AuSb2)


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


-- 1. OURO NATIVO (Minério principal de Ouro)


-- Ouro nativo: Ouro metálico encontrado naturalmente,
-- frequentemente associado a pequenas quantidades de prata e cobre.

local native_gold_tint = {
    r = 1.00,
    g = 0.78,
    b = 0.15,
    a = 1.0
}

data:extend(
    createOre({
        name = "native_gold",
        stack_size = 100,
        order = "e[gold]-a[native-gold]",
        icons = makeOreIcon(
            native_gold_tint,
            "__base__/graphics/icons/copper-ore.png"
        ),
        icon_size = 64,
        map_color = {1.00, 0.78, 0.15},
        mining_time = 1.5,
        mining_visualisation_tint = native_gold_tint,
        base_density = 8,
        regular_rq_factor_multiplier = 1.2
    })
)


-- 2. ELECTRUM (Liga natural de Ouro e Prata)


-- Electrum: Liga natural de ouro e prata.
-- Sua tonalidade varia entre amarelo-pálido e branco-dourado,
-- dependendo da concentração de prata.

data:extend({
    createOreItem({
        name = "electrum",
        stack_size = 100,
        order = "e[gold]-b[electrum]",
        icons = makeOreIcon({
            r = 0.88,
            g = 0.85,
            b = 0.68,
            a = 1.0
        }),
        icon_size = 64,
        weight = 50
    })
})


-- 3. CALAVERITA (AuTe2)


-- Calaverita: Telureto de ouro.
-- Apresenta coloração amarelo-latão ou branco-prateado.

data:extend({
    createOreItem({
        name = "calaverite",
        stack_size = 100,
        order = "e[gold]-c[calaverite]",
        icons = makeOreIcon({
            r = 0.88,
            g = 0.76,
            b = 0.38,
            a = 1.0
        }),
        icon_size = 64,
        weight = 50
    })
})


-- 4. SILVANITA (AuAgTe4)


-- Silvanita: Telureto de ouro e prata.
-- Seus cristais podem apresentar padrões característicos
-- semelhantes a letras ou símbolos.

data:extend({
    createOreItem({
        name = "sylvanite",
        stack_size = 100,
        order = "e[gold]-d[sylvanite]",
        icons = makeOreIcon({
            r = 0.78,
            g = 0.73,
            b = 0.62,
            a = 1.0
        }),
        icon_size = 64,
        weight = 50
    })
})


-- 5. PETZITA (Ag3AuTe2)


-- Petzita: Telureto rico em prata e ouro.
-- Possui brilho metálico escuro, variando entre cinza-aço e preto.

data:extend({
    createOreItem({
        name = "petzite",
        stack_size = 100,
        order = "e[gold]-e[petzite]",
        icons = makeOreIcon({
            r = 0.38,
            g = 0.39,
            b = 0.42,
            a = 1.0
        }),
        icon_size = 64,
        weight = 55
    })
})


-- 6. KRENNERITA (Au1-xAgxTe2)


-- Krennerita: Telureto de ouro com presença variável de prata.
-- Possui estrutura cristalina diferente da calaverita,
-- com tonalidade branco-prateada a amarelo-latão.

data:extend({
    createOreItem({
        name = "krennerite",
        stack_size = 100,
        order = "e[gold]-f[krennerite]",
        icons = makeOreIcon({
            r = 0.78,
            g = 0.75,
            b = 0.65,
            a = 1.0
        }),
        icon_size = 64,
        weight = 50
    })
})


-- 7. MALDONITA (Au2Bi)


-- Maldonita: Liga natural rara de ouro e bismuto.
-- Quando recém-fraturada apresenta coloração branco-prateada,
-- podendo escurecer e adquirir tonalidades acobreadas.

data:extend({
    createOreItem({
        name = "maldonite",
        stack_size = 100,
        order = "e[gold]-g[maldonite]",
        icons = makeOreIcon({
            r = 0.58,
            g = 0.43,
            b = 0.39,
            a = 1.0
        }),
        icon_size = 64,
        weight = 55
    })
})


-- 8. AUROSTIBITA (AuSb2)


-- Aurostibita: Antimoneto de ouro.
-- Mineral raro de coloração cinza-chumbo,
-- encontrado em determinados depósitos hidrotermais.

data:extend({
    createOreItem({
        name = "aurostibite",
        stack_size = 100,
        order = "e[gold]-h[aurostibite]",
        icons = makeOreIcon({
            r = 0.34,
            g = 0.36,
            b = 0.40,
            a = 1.0
        }),
        icon_size = 64,
        weight = 60
    })
})