# Utilitários de Runtime (Control Stage / LDARuntime.*)

Este documento documenta detalhadamente todos os módulos de **Runtime** da **LDA-LIB** para o estágio de controle do jogo (`control.lua`).

Para carregar a suíte de runtime no seu `control.lua`:

```lua
local LDARuntime = require("__LDA-LIB__/runtime.init")
```

---

## Sumário

1. [Jogador (`LDARuntime.player`)](#1-jogador-ldaruntimeplayer)
2. [Entidades (`LDARuntime.entity`)](#2-entidades-ldaruntimeentity)
3. [Mundo e Superfície (`LDARuntime.world`)](#3-mundo-e-superfície-ldaruntimeworld)
4. [Itens e Inventários (`LDARuntime.item`)](#4-itens-e-inventários-ldaruntimeitem)
5. [Rede de Entidades Persistida (`LDARuntime.network`)](#5-rede-de-entidades-persistida-ldaruntimenetwork)
6. [Interface Gráfica Padronizada (`LDARuntime.gui`)](#6-interface-gráfica-padronizada-ldaruntimegui)
7. [Grade de Equipamentos e Baterias (`LDARuntime.equipment_grid`)](#7-grade-de-equipamentos-e-baterias-ldaruntimeequipment_grid)

---

## 1. Jogador (`LDARuntime.player`)

Utilitários para validação, inspeção e entrega segura de itens ao jogador:

```lua
script.on_event(defines.events.on_player_created, function(event)
    -- Obtém o jogador por índice, nome ou userdata com validação
    local player = LDARuntime.player.get(event.player_index)
    if not LDARuntime.player.isValid(player) then return end

    -- Obter character, coordenadas, superfície e tag GPS
    local character = LDARuntime.player.getCharacter(player)
    local pos = LDARuntime.player.getPosition(player)     -- {x = ..., y = ...}
    local surface = LDARuntime.player.getSurface(player)
    local gps = LDARuntime.player.getGps(player)          -- "[gps=0.0,0.0,nauvis]"

    -- Verificar e remover itens
    local qtd = LDARuntime.player.getItemCount(player, "iron-plate")
    if LDARuntime.player.hasItem(player, "wood", 5) then
        LDARuntime.player.remove(player, "wood", 5)
    end

    -- Entregar itens com opção de cair no chão se o inventário estiver cheio
    LDARuntime.player.give(player, "firearm-magazine", 50, {spill_if_full = true})

    -- Teleportar jogador
    LDARuntime.player.teleport(player, {x = 10, y = 20}, "nauvis")

    -- Feedback visual e áudio
    LDARuntime.player.flyingText(player, "Bem-vindo!", {color = {r=0, g=1, b=0}})
    LDARuntime.player.notify(player, "Kit inicial entregue!", "utility/achievement_unlocked")
end)
```

---

## 2. Entidades (`LDARuntime.entity`)

Utilitários para manipulação segura de vida, energia, itens e ciclos de vida de entidades:

```lua
script.on_event(defines.events.on_built_entity, function(event)
    local entity = event.entity
    if not LDARuntime.entity.isValid(entity) then return end

    -- Propriedades físicas e de time
    local health = LDARuntime.entity.getHealth(entity)
    local surface = LDARuntime.entity.getSurface(entity)
    local force = LDARuntime.entity.getForce(entity)
    local box = LDARuntime.entity.getBoundingBox(entity)

    -- Alterar vida ou curar
    LDARuntime.entity.setHealth(entity, 150)
    LDARuntime.entity.heal(entity, 50)
    LDARuntime.entity.damage(entity, 20, "enemy", "fire")

    -- Manipular energia interna da máquina (Joules)
    local energia = LDARuntime.entity.getEnergy(entity)
    LDARuntime.entity.setEnergy(entity, energia + 500000)

    -- Inserir e remover itens da entidade
    LDARuntime.entity.insert(entity, "coal", 10)
    LDARuntime.entity.remove(entity, "coal", 2)

    -- Fantasmas de construção (ghosts)
    if LDARuntime.entity.isGhost(entity) then
        local resultado = LDARuntime.entity.reviveGhost(entity)
    end

    -- Destruição segura
    -- LDARuntime.entity.destroy(entity, {die = false, raise_destroy = true})
end)
```

---

## 3. Mundo e Superfície (`LDARuntime.world`)

Funções de navegação espacial, detecção de colisões, tiles e criação de entidades:

```lua
-- Resolução de superfície
local surface = LDARuntime.world.getSurface("nauvis")

-- Distância euclidiana e tag GPS
local dist = LDARuntime.world.getDistance({x = 0, y = 0}, {x = 30, y = 40})
local gps = LDARuntime.world.formatGps({x = 15.5, y = -22.3}, surface)

-- Busca de entidades em raio ou caixa
local montadoras = LDARuntime.world.findEntitiesInRadius(surface, {x = 0, y = 0}, 20, {
    type = "assembling-machine"
})

local caixas = LDARuntime.world.findEntitiesInBox(surface, {{-10, -10}, {10, 10}}, {
    type = "container"
})

-- Posição livre para colocar estrutura sem colidir
local pos_livre = LDARuntime.world.findFreePosition(surface, "assembling-machine-1", {x = 5, y = 5}, 15)

-- Spawn de entidade simplificado
local nova_torre = LDARuntime.world.spawnEntity(surface, "gun-turret", pos_livre, {
    force = "player",
    direction = defines.direction.north
})

-- Leitura e alteração de tiles (em lote ou unitário)
local nome_tile = LDARuntime.world.getTile(surface, {x = 0, y = 0})
LDARuntime.world.setTile(surface, {x = 0, y = 0}, "concrete")
LDARuntime.world.setTiles(surface, {
    {name = "refined-concrete", position = {x = 1, y = 0}},
    {name = "refined-concrete", position = {x = 1, y = 1}}
})

-- Efeito de explosão e teletransporte de entidade
LDARuntime.world.createExplosion(surface, {x = 0, y = 0}, "big-explosion")
LDARuntime.world.teleportEntity(nova_torre, {x = 12, y = 12}, surface)
```

---

## 4. Itens e Inventários (`LDARuntime.item`)

Operações seguras com pilhas de itens e manipulação de chão:

```lua
-- Validação de LuaItemStack
if LDARuntime.item.isValid(stack) then
    local dados = LDARuntime.item.toTable(stack)
end

-- Capacidade e transferência de inventários
local slots_vazios = LDARuntime.item.getEmptySlotCount(inventario_bau)
local cabe = LDARuntime.item.canFit(inventario_bau, "iron-ore", 100)

if cabe then
    local transferidos = LDARuntime.item.transfer(inv_origem, inventario_bau, "iron-ore", 50)
end

-- Derrubar (spill) itens no chão
LDARuntime.item.spill(surface, {x = 10, y = 10}, "iron-plate", 20)

-- Encontrar e recolher itens caídos no chão
local caidos = LDARuntime.item.findOnGround(surface, {x = 10, y = 10}, 5, "iron-plate")
local recolhidos = LDARuntime.item.collectFromGround(surface, {x = 10, y = 10}, 5, player)

-- Metadados de protótipos de itens
local max_pilha = LDARuntime.item.getStackSize("copper-cable") -- 200
local subgrupo = LDARuntime.item.getSubgroup("copper-cable")   -- "intermediate-product"
```

---

## 5. Rede de Entidades Persistida (`LDARuntime.network`)

Gerenciamento genérico de redes de máquinas interligadas (como portais ou reatores) salvas em `storage.lda.networks` com auto-limpeza de entidades destruídas:

```lua
-- 1. Registrar entidade na rede
script.on_event(defines.events.on_built_entity, function(event)
    local entity = event.entity
    if LDARuntime.entity.isValid(entity) and entity.name == "meu-portal" then
        LDARuntime.network.register("portais", entity, {
            name = "Portal Alpha",
            canal = 1
        })
    end
end)

-- 2. Desregistrar ao morrer
script.on_event(defines.events.on_entity_died, function(event)
    LDARuntime.network.unregister("portais", event.entity)
end)

-- 3. Consultar entidade específica na rede
local no_portal = LDARuntime.network.get("portais", entity)

-- 4. Consultar todas as entidades com filtros opcionais
local todos = LDARuntime.network.getAll("portais", "player") -- ou {surface = "nauvis"}

-- 5. Alterar nome ou metadados
LDARuntime.network.setName("portais", entity, "Portal Base Norte")
LDARuntime.network.setMetadata("portais", entity, {canal = 2, status = "ativo"}, true)

-- 6. Encontrar posição segura para saída/teleporte ao redor do nó
local pos_saida = LDARuntime.network.findFreeSpawnPosition(no_portal, "character", 4)

-- 7. Métricas e manutenção de redes
local total = LDARuntime.network.count("portais")
local orfas = LDARuntime.network.cleanup("portais")
local redes = LDARuntime.network.getNetworks() -- Lista de nomes de redes
-- LDARuntime.network.clear("portais") -- Limpa todos os nós da rede
```

---

## 6. Interface Gráfica Padronizada (`LDARuntime.gui`)

Criação de janelas modais padronizadas vinculadas a `player.opened` com fechamento automático no ESC / E:

```lua
local function abrir_painel(player)
    -- Janela centralizada com titlebar arrastável
    local win = LDARuntime.gui.createWindow(player, "meu_painel", "Controle Central", {
        width = 400,
        height = 300
    })

    -- Barra de progresso de energia com porcentagem e valores formatados
    local energy_bar = LDARuntime.gui.createEnergyBar(win.content, {
        initial_value = 5000000,
        max_value = 10000000
    })

    -- Atualização dinâmica
    energy_bar.update(7500000, 10000000)

    -- Busca recursiva em profundidade no container
    local bar = LDARuntime.gui.findElementByName(win.frame, "energy_progressbar")
    local botoes = LDARuntime.gui.findElementsByType(win.frame, "button")
end

-- Fechamento nativo por evento
script.on_event(defines.events.on_gui_closed, function(event)
    if event.element and event.element.name == "meu_painel" then
        LDARuntime.gui.closeWindow(game.get_player(event.player_index), event.element)
    end
end)

-- Alternar abertura/fechamento (Toggle)
local function toggle_painel(player)
    LDARuntime.gui.toggleWindow(player, "meu_painel", function(p)
        abrir_painel(p)
    end)
end

-- Formatação de texto para energia e potência
local texto_energia = LDARuntime.gui.formatEnergy(2500000) -- "2.5 MJ"
local texto_potencia = LDARuntime.gui.formatPower(750000)   -- "750.0 kW"
```

---

## 7. Grade de Equipamentos e Baterias (`LDARuntime.equipment_grid`)

Inspeção e controle atômico de energia em grades de armaduras e veículos:

```lua
script.on_event(defines.events.on_player_used_capsule, function(event)
    local player = game.get_player(event.player_index)

    -- Resolução automática de grade a partir de player, vehicle ou item stack
    local grid = LDARuntime.equipment_grid.getGrid(player)
    if not LDARuntime.equipment_grid.isValid(grid) then return end

    -- Leitura somada de energia de todas as baterias instaladas
    local energia = LDARuntime.equipment_grid.getEnergy(player)
    local max_energia = LDARuntime.equipment_grid.getMaxEnergy(player)

    -- Equipamentos instalados
    local baterias = LDARuntime.equipment_grid.getEquipment(player, "battery-equipment")
    local qtd = LDARuntime.equipment_grid.countEquipment(player, "energy-shield-equipment")

    -- Consumo atômico de energia (ex: custo = 2 MJ)
    local custo = 2000000
    if LDARuntime.equipment_grid.hasEnergy(player, custo) then
        local sucesso, drenado = LDARuntime.equipment_grid.drainEnergy(player, custo)
        if sucesso then
            player.print("Energia consumida: " .. LDARuntime.gui.formatEnergy(drenado))
        end
    else
        player.print("Energia insuficiente!")
    end

    -- Recarga de Joules distribuída
    LDARuntime.equipment_grid.addEnergy(player, 500000)
end)
```
