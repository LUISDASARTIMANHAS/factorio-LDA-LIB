# LDA-LIB Usage Guide

## Instalação

1. Copie a pasta `LDA-LIB` para a pasta `mods` do Factorio.
2. Ative o mod no gerenciador de mods.
3. Certifique-se de que as dependências estão ativadas: `base >= 2.0.0` e `flib`.

## Configuração básica

No seu mod, carregue a biblioteca e defina o caminho base para os assets:

```lua
local LDA = require('__LDA-LIB__/init')
LDA.setBasePath('Seu-Mod-Nome')
```

O `setBasePath` garante que a biblioteca encontre seus arquivos de imagem e som.

## Exemplo mínimo de `data.lua`

```lua
local LDA = require('__LDA-LIB__/init')
LDA.setBasePath('Seu-Mod-Nome')

-- Exemplo de criação de item e receita
LDA.createItemWithRecipe(
    'meu-item',
    'intermediate-product',
    100,
    'advanced-crafting',
    10,
    {
        {type = 'item', name = 'iron-plate', amount = 5}
    },
    {
        {type = 'item', name = 'meu-item', amount = 1}
    },
    {'my-tech'},
    false,
    {
        icon = '__Meu-Mod__/graphics/icons/meu-item.png',
        icon_size = 64
    }
)
```

## Criando itens específicos por categoria de máquina

### Montadora (`advanced-crafting`)

```lua
LDA.createAssemblerItemWithRecipe(
    'meu-produto-montadora',
    15,
    1,
    {{type = 'item', name = 'steel-plate', amount = 10}},
    100,
    {'my-advanced-tech'},
    false
)
```

### Chemical plant (`chemistry`)

```lua
LDA.createChemicalPlantItemWithRecipe(
    'meu-produto-quimico',
    20,
    1,
    {{type = 'item', name = 'plastic-bar', amount = 5}},
    100,
    {'my-chemistry-tech'},
    false
)
```

### Biochamber (`organic`)

```lua
LDA.createBiochamberItemWithRecipe(
    'meu-produto-bio',
    30,
    1,
    {{type = 'item', name = 'alien-artifact', amount = 2}},
    100,
    {'my-organic-tech'},
    false
)
```

### Fornalha (`smelting`)

```lua
LDA.createSmeltingItemWithRecipe(
    'meu-produto-fundicao',
    10,
    1,
    {{type = 'item', name = 'iron-ore', amount = 10}},
    100,
    {'my-smelting-tech'},
    false
)
```

## Receita "jogar na água"

```lua
LDA.createThrowInWaterItemWithRecipe(
    'semente-aqua',
    20,
    1,
    {{type = 'item', name = 'wood', amount = 10}},
    200,
    50,
    {'my-water-tech'},
    false
)
```

## Tecnologias com gatilhos especiais

### Desbloquear ao fabricar um item

```lua
LDA.createTechnologyCraftEntityTrigger(
    'tech-craft-trigger',
    {'my-recipe'},
    {'science-pack-1'},
    'my-item',
    50
)
```

### Desbloquear ao minerar uma entidade

```lua
LDA.createTechnologyMineEntityTrigger(
    'tech-mine-trigger',
    {'my-recipe'},
    {'advanced-electronics'},
    'my-entity'
)
```

## Ferramentas úteis

- Use `/lda-list` no console do jogo para listar todas as funções expostas.
- Ative `lda-lib-debug` em `Configurações → Mods → Startup` para ver logs adicionais.

## Recomendações de assets

Mantenha sua estrutura de assets organizada:

- `graphics/icons`
- `graphics/entities`
- `graphics/technology`
- `audios`
- `locale`

## Utilidades de Runtime (`control.lua`)

Para lógica de scripts, eventos e manipulação de jogo durante a partida, importe o módulo de runtime:

```lua
local LDARuntime = require("__LDA-LIB__/runtime.init")

-- Exemplo: Manipular jogador em evento
script.on_event(defines.events.on_player_created, function(event)
    local player = LDARuntime.player.get(event.player_index)
    if player then
        -- Entregar itens com segurança (com opção de cair no chão se cheio)
        LDARuntime.player.give(player, "iron-plate", 100, {spill_if_full = true})
        
        -- Notificação e som
        LDARuntime.player.notify(player, "Itens iniciais recebidos!", "utility/achievement_unlocked")
        
        -- Texto flutuante
        LDARuntime.player.flyingText(player, "Bem-vindo!", {color = {r=0, g=1, b=0}})
    end
end)

-- Exemplo: Interagir com entidades e mundo
script.on_event(defines.events.on_built_entity, function(event)
    local entity = event.entity
    if LDARuntime.entity.isValid(entity) then
        -- Obter posição e formatar tag GPS para chat
        local pos = LDARuntime.entity.getPosition(entity)
        local gps = LDARuntime.world.formatGps(pos, entity.surface)
        
        -- Buscar entidades ao redor
        local vizinhos = LDARuntime.world.findEntitiesInRadius(entity.surface, pos, 15, {
            type = "inserter"
        })
    end
end)
```

### Módulos disponíveis no Runtime:
- `LDARuntime.player`: `get`, `give`, `remove`, `hasItem`, `getItemCount`, `teleport`, `flyingText`, `notify`, `getGps`, `getPosition`, `getSurface`.
- `LDARuntime.entity`: `isValid`, `getHealth`, `setHealth`, `heal`, `damage`, `getEnergy`, `setEnergy`, `insert`, `remove`, `destroy`, `reviveGhost`, `isGhost`.
- `LDARuntime.world`: `getSurface`, `findEntitiesInRadius`, `findEntitiesInBox`, `findFreePosition`, `spawnEntity`, `setTile`, `setTiles`, `getTile`, `createExplosion`, `teleportEntity`, `formatGps`, `getDistance`.
- `LDARuntime.item`: `isValid`, `toTable`, `canFit`, `getEmptySlotCount`, `transfer`, `spill`, `findOnGround`, `collectFromGround`, `getStackSize`, `getSubgroup`.

## Observações

- A biblioteca é pensada para ser utilizada como dependência em outros mods, não como um mod de jogo direto.
- As funções de utilidade em `LDA.utils`, `LDA.utilsEnergySource`, `LDA.utilsAmbientEffects` e `LDA.utilsAnimations` ajudam a construir protótipos mais complexos.
