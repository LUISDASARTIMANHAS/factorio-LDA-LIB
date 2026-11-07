# Construtores de Protótipos (Data Stage)

Este documento detalha todos os construtores de protótipos da **LDA-LIB** para o estágio `data` do Factorio (executados em `data.lua`, `data-updates.lua` ou `data-final-fixes.lua`).

Todas as funções retornam tabelas no formato do Factorio prontas para serem passadas a `data:extend(...)`.

---

## Sumário

1. [Itens Básicos](#1-itens-básicos)
   - [LDA.createItem](#ldacreateitem)
   - [LDA.createBlockItem](#ldacreateblockitem)
   - [LDA.createEquipmentItem](#ldacreateequipmentitem)
   - [LDA.createItemSearch](#ldacreateitemsearch)
2. [Fluidos e Gases](#2-fluidos-e-gases)
   - [LDA.createFluid](#ldacreatefluid)
   - [LDA.createGas](#ldacreategas)
3. [Grupos e Subgrupos](#3-grupos-e-subgrupos)
   - [LDA.createItemGroup](#ldacreateitemgroup)
4. [Receitas e Combos](#4-receitas-e-combos)
   - [LDA.createRecipe](#ldacreaterecipe)
   - [LDA.createGenericRecipe](#ldacreategenericrecipe)
   - [LDA.formatResultsList](#ldaformatresultslist)
   - [LDA.createItemWithRecipe](#ldacreateitemwithrecipe)
   - [LDA.createFluidWithRecipe](#ldacreatefluidwithrecipe)
   - [LDA.createBlockItemWithRecipe](#ldacreateblockitemwithrecipe)
   - [LDA.createEquipmentItemWithRecipe](#ldacreateequipmentitemwithrecipe)
5. [Máquinas Especializadas](#5-máquinas-especializadas)
   - [LDA.createAssemblerItemWithRecipe](#ldacreateassembleritemwithrecipe)
   - [LDA.createSmeltingItemWithRecipe](#ldacreatesmeltingitemwithrecipe)
   - [LDA.createChemicalPlantItemWithRecipe](#ldacreatechemicalplantitemwithrecipe)
   - [LDA.createBiochamberItemWithRecipe](#ldacreatebiochamberitemwithrecipe)
   - [LDA.createThrowInWaterItemWithRecipe](#ldacreatethrowinwateritemwithrecipe)
6. [Recursos de Terreno e Minérios](#6-recursos-de-terreno-e-minérios)
   - [LDA.createAutoplaceControl](#ldacreateautoplacecontrol)
   - [LDA.createResource](#ldacreateresource)
   - [LDA.createOre](#ldacreateore)
7. [Entidades e Estruturas](#7-entidades-e-estruturas)
   - [LDA.createEntity](#ldacreateentity)
   - [LDA.createAccumulator](#ldacreateaccumulator)
8. [Tecnologias e Gatilhos](#8-tecnologias-e-gatilhos)
   - [LDA.createTechnology](#ldacreatetechnology)
   - [LDA.createTechnologyTrigger](#ldacreatetechnologytrigger)
   - [LDA.createTechnologyCraftEntityTrigger](#ldacreatetechnologycraftentitytrigger)
   - [LDA.createTechnologyMineEntityTrigger](#ldacreatetechnologymineentitytrigger)

---

## 1. Itens Básicos

### `LDA.createItem`
Cria um protótipo de item comum (`type = "item"`). O ícone é buscado automaticamente em `graphics/icons/<name>.png`.

```lua
-- Exemplo 1: Item padrão
local lingote = LDA.createItem(
    "meu-lingote",           -- Nome do item
    "intermediate-product",  -- Subgrupo do inventário
    200                      -- stack_size
)
data:extend({ lingote })

-- Exemplo 2: Item com variações visuais (pictures)
local semente = LDA.createItem(
    "semente-rara",
    "raw-resource",
    100,
    LDA.utils.getSequentialPictureList("__meu-mod__/graphics/icons/semente-rara", 1, 4, 64, 0.5, 4)
)
data:extend({ semente })
```

### `LDA.createBlockItem`
Cria um item com a propriedade `place_result` apontando para a entidade de mesmo nome, permitindo colocar máquinas ou estruturas no mapa.

```lua
local bloco_montadora = LDA.createBlockItem(
    "minha-super-montadora",  -- Nome do item e da entidade a ser posicionada
    "production-machine",     -- Subgrupo
    50                        -- stack_size
)
data:extend({ bloco_montadora })
```

### `LDA.createEquipmentItem`
Cria um item com a propriedade `place_as_equipment_result`, usado para carregar equipamentos em armaduras e veículos.

```lua
local item_equip = LDA.createEquipmentItem(
    "bateria-portatil-mk3",  -- Nome do equipamento associado
    "equipment",             -- Subgrupo
    10                       -- Peso (weight)
)
data:extend({ item_equip })
```

### `LDA.createItemSearch`
Cria itens do tipo ferramenta de ciência (`tool`), usados como frascos de pesquisa em laboratórios.

```lua
local pack_ciencia = LDA.createItemSearch(
    "quantum-science-pack",  -- Nome (ícone em graphics/icons/<name>.png)
    200                      -- stack_size
)
data:extend({ pack_ciencia })
```

---

## 2. Fluidos e Gases

### `LDA.createFluid`
Cria um líquido com capacidade térmica e cores de fluxo. Ícone em `graphics/icons/fluid/<name>.png`.

```lua
local bio_liquido = LDA.createFluid(
    "bio-liquido",  -- Nome
    "2kJ"           -- Capacidade térmica (heat_capacity)
)
data:extend({ bio_liquido })
```

### `LDA.createGas`
Cria uma variante de fluido configurada como gás (`auto_barrel = false`, temperatura máxima de até 5000 °C). Ícone em `graphics/icons/gas/<name>.png`.

```lua
local gas_plasma = LDA.createGas(
    "plasma-gas",  -- Nome
    "0.5kJ"        -- Capacidade de calor
)
data:extend({ gas_plasma })
```

---

## 3. Grupos e Subgrupos

### `LDA.createItemGroup`
Cria uma categoria principal (`item-group`) com ícone em `graphics/item-group/<name>.png` e registra os subgrupos informados.

```lua
local categorias = LDA.createItemGroup(
    "meu-mod-categoria",   -- Nome do grupo
    "z-mod",               -- Ordem
    64,                    -- Tamanho do ícone
    {
        "materiais-basicos",
        "maquinas-avancadas",
        { name = "combustiveis", order = "meu-mod-combustiveis" }
    }
)
data:extend(categorias)
```

---

## 4. Receitas e Combos

### `LDA.createRecipe`
Cria uma receita avulsa independente.

```lua
local receita = LDA.createRecipe(
    "icons",               -- Subpasta de graphics/ ("icons", "entities", "fluid", etc.)
    "circuito-supercondutor",
    "advanced-crafting",   -- Categoria de máquina
    5.0,                   -- Tempo em segundos
    {
        {type = "item", name = "electronic-circuit", amount = 5},
        {type = "item", name = "copper-cable", amount = 10}
    },
    {
        {type = "item", name = "circuito-supercondutor", amount = 1}
    },
    {"minha-tecnologia"},  -- Techs que desbloqueiam
    false                  -- Desbloqueada por padrão?
)
data:extend({ receita })
```

### `LDA.createGenericRecipe`
Cria rapidamente um par `{item, recipe}` básico consumindo 1 placa de ferro para testes rápidos ou itens provisórios:

```lua
local combo_rapido = LDA.createGenericRecipe("peça-prototipo")
data:extend(combo_rapido)
```

### `LDA.formatResultsList`
Converte e normaliza tabelas parciais ou strings para o formato oficial de resultados de receitas:

```lua
local formatados = LDA.formatResultsList({
    "iron-plate",
    "liquid-biofuel",
    {name = "copper-cable", amount = 5}
})
```

### `LDA.createItemWithRecipe`
Gera o item e a receita simultaneamente em uma única chamada.

```lua
local combo_item = LDA.createItemWithRecipe(
    "placa-composta",
    "intermediate-product",
    100,
    "crafting",
    2.5,
    {{type = "item", name = "steel-plate", amount = 2}},
    {{type = "item", name = "placa-composta", amount = 1}},
    {"compostos-avancados"},
    false
)
data:extend(combo_item)
```

### `LDA.createFluidWithRecipe`
Cria o fluido e sua receita de produção química ou refinaria:

```lua
local combo_fluido = LDA.createFluidWithRecipe(
    "solucao-acida-forte",
    "1kJ",
    "chemistry",
    4.0,
    {
        {type = "fluid", name = "sulfuric-acid", amount = 20},
        {type = "item", name = "sulfur", amount = 2}
    },
    {
        {type = "fluid", name = "solucao-acida-forte", amount = 20}
    },
    {"quimica-avancada"},
    false
)
data:extend(combo_fluido)
```

### `LDA.createBlockItemWithRecipe`
Cria o item de estrutura (que posiciona entidade) e sua receita:

```lua
local combo_bloco = LDA.createBlockItemWithRecipe(
    "painel-solar-mk2",
    "production-machine",
    50,
    "advanced-crafting",
    10.0,
    {
        {type = "item", name = "solar-panel", amount = 1},
        {type = "item", name = "advanced-circuit", amount = 5}
    },
    {
        {type = "item", name = "painel-solar-mk2", amount = 1}
    },
    {"energia-solar-2"},
    false
)
data:extend(combo_bloco)
```

### `LDA.createEquipmentItemWithRecipe`
Cria o item de equipamento de armadura e sua receita:

```lua
local combo_equip = LDA.createEquipmentItemWithRecipe(
    "gerador-escudo-mk3",
    "equipment",
    20, -- peso
    "advanced-crafting",
    15.0,
    {
        {type = "item", name = "energy-shield-mk2-equipment", amount = 2},
        {type = "item", name = "processing-unit", amount = 10}
    },
    {
        {type = "item", name = "gerador-escudo-mk3", amount = 1}
    },
    {"escudos-militares"},
    false
)
data:extend(combo_equip)
```

---

## 5. Máquinas Especializadas

### `LDA.createAssemblerItemWithRecipe`
```lua
local produto = LDA.createAssemblerItemWithRecipe(
    "engrenagem-reforcada",
    2.0,
    2,
    {{type = "item", name = "steel-plate", amount = 1}},
    200,
    {"mecanica-avancada"},
    false
)
data:extend(produto)
```

### `LDA.createSmeltingItemWithRecipe`
```lua
local lingote = LDA.createSmeltingItemWithRecipe(
    "lingote-titanio",
    6.4,
    1,
    {{type = "item", name = "iron-ore", amount = 5}},
    "smelting",
    {"metalurgia-titanio"},
    false
)
data:extend(lingote)
```

### `LDA.createChemicalPlantItemWithRecipe`
```lua
local quimico = LDA.createChemicalPlantItemWithRecipe(
    "catalisador-sintetico",
    5.0,
    1,
    {
        {type = "item", name = "copper-plate", amount = 2},
        {type = "fluid", name = "petroleum-gas", amount = 30}
    },
    100,
    {"petroquimica-avancada"},
    false
)
data:extend(quimico)
```

### `LDA.createBiochamberItemWithRecipe`
```lua
local bio = LDA.createBiochamberItemWithRecipe(
    "enzima-cultivada",
    8.0,
    1,
    {{type = "item", name = "wood", amount = 10}},
    100,
    {"biotecnologia"},
    false
)
data:extend(bio)
```

### `LDA.createThrowInWaterItemWithRecipe`
Cria receitas que reagem quando o jogador joga insumos na água:

```lua
local alga = LDA.createThrowInWaterItemWithRecipe(
    "alga-cultivada",
    5.0,
    2,
    {{type = "item", name = "wood", amount = 1}},
    200,
    50,  -- Quantidade de água
    {"cultivo-aquatico"},
    false
)
data:extend(alga)
```

---

## 6. Recursos de Terreno e Minérios

### `LDA.createAutoplaceControl`
Cria o controle da interface de geração de mapa para o minério:

```lua
local controle = LDA.createAutoplaceControl(
    "titanium",
    "b",
    {r = 0.8, g = 0.8, b = 1.0},
    128
)
data:extend({ controle })
```

### `LDA.createResource`
Cria o minério físico depositado sobre os tiles do mapa:

```lua
local recurso = LDA.createResource(
    "titanium",
    "b",
    "stone-particle",
    {
        mining_time = 1.5,
        map_color = {0.3, 0.4, 0.7}
    },
    {
        base_density = 12,
        regular_rq_factor_multiplier = 1.15
    }
)
data:extend({ recurso })
```

### `LDA.createOre`
Gera de uma só vez a trinca: item, controle de autoplace e entidade de recurso mineral:

```lua
local minerio = LDA.createOre(
    "titanium",  -- Gera "titanium-ore"
    100,         -- stack_size
    nil,         -- fuel_category
    nil,         -- fuel_value
    "b"          -- Ordem
)
data:extend(minerio)
```

---

## 7. Entidades e Estruturas

### `LDA.createEntity`
Cria um protótipo de entidade base (como painel solar modular) com colisão e camadas visuais:

```lua
local solar = LDA.createEntity(
    "solar-panel",
    "painel-solar-avancado",
    "energy",
    50
)
data:extend({ solar })
```

### `LDA.createAccumulator`
Cria acumuladores elétricos com suporte a retenção estrita de scripts (`output_flow_limit = "0kW"`):

```lua
local acumulador = LDA.createAccumulator({
    name = "bateria-estacionaria-mk2",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1.0, -1.0}, {1.0, 1.0}},
    buffer_capacity = "20MJ",
    input_flow_limit = "2MW",
    output_flow_limit = "2MW",
    max_health = 300,
    resistances = {
        LDA.utils.createResistance("electric", 100),
        LDA.utils.createResistance("fire", 80)
    }
})
data:extend({ acumulador })
```

---

## 8. Tecnologias e Gatilhos

### `LDA.createTechnology`
Cria pesquisas laboratoriais padrão com custo de frascos de ciência e tempo:

```lua
local tecnologia = LDA.createTechnology(
    "pesquisa-titanio",
    {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
    },
    {"steel-processing"},
    {"lingote-titanio", "placa-composta"},
    30,
    150,
    false
)
data:extend({ tecnologia })
```

### `LDA.createTechnologyTrigger`
Cria pesquisas desbloqueadas por gatilho (`research_trigger`), recurso nativo do Factorio 2.0:

```lua
local tech_trigger = LDA.createTechnologyTrigger(
    "descoberta-terrestre",
    {"radar-mk2"},
    {"automation"},
    {
        type = "build-entity",
        entity = "radar"
    }
)
data:extend({ tech_trigger })
```

### `LDA.createTechnologyCraftEntityTrigger`
```lua
local tech_craft = LDA.createTechnologyCraftEntityTrigger(
    "mestre-fundicao",
    {"receita-avancada"},
    {"pesquisa-titanio"},
    "lingote-titanio",
    50
)
data:extend({ tech_craft })
```

### `LDA.createTechnologyMineEntityTrigger`
```lua
local tech_mine = LDA.createTechnologyMineEntityTrigger(
    "primeiro-contato",
    {"analise-organica"},
    {},
    "alien-artifact"
)
data:extend({ tech_mine })
```
