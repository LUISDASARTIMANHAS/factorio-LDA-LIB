# LDA-LIB – Biblioteca Utilitária para Mods Factorio 2.0  

```lua
local LDA = require('__LDA-LIB__/init') 
-- OBRIGATÓRIO: Define o caminho base do seu mod para busca de assets (gráficos/sons)
local PATH = LDA.setBasePath('Seu-Mod-Nome') 
```

## 📘 Descrição

A **LDA-LIB** é uma biblioteca utilitária para Factorio 2.0 projetada para acelerar a criação de mods, fornecendo funções prontas para gerar:

- Itens, Fluidos e Gases
- Receitas simples e complexas
- Minérios e Recursos de mapa (Autoplace)
- Tecnologias (comuns e por gatilhos)
- Estruturas completas (item + receita + entidade)
- Versões especializadas (fornalhas, montadoras, "jogar na água")

O objetivo é **reduzir trabalho repetitivo** e manter um **padrão uniforme** entre todos os seus mods.

---

# FOLDER STRUCTURE (Padrão esperado pelo Mod)

A biblioteca busca assets automaticamente baseada nesta estrutura:

- `graphics/icons` - ícones de itens e fluidos
- `graphics/entities` - sprites de entidades
- `graphics/technology` - ícones de pesquisa
- `audio` - arquivos de som (.ogg)

---

## ⚙️ Configurações (settings.lua)

- **LDA-LIB: Modo Debug** – habilita logs detalhados durante a geração de protótipos.
  - Ativar em: Configurações → Mods → Startup

---

## 🔎 Comando /lda-list

Lista todas as funções públicas expostas pela biblioteca LDA no console do jogo.

---

## 🧩 Funções Disponíveis

### Base Functions
| Função | Descrição Rápida |
| :--- | :--- |
| `LDA.createAutoplaceControl` | Cria controles de autoplace para geração de recursos no mapa. |
| `LDA.createResource` | Cria a entidade de recurso (o minério físico no chão). |
| `LDA.createOre` | Cria o item do minério (adiciona automaticamente o prefixo `-ore`). |
| `LDA.createItem` | Cria um item simples com sons e ícone. |
| `LDA.createBlockItem` | Cria itens do tipo bloco estrutural. |
| `LDA.createEquipmentItem` | Cria itens do tipo equipamento (colocáveis em grids). |
| `LDA.createFluid` | Cria fluidos com temperatura e ícone. |
| `LDA.createGas` | Variante visual de fluido como gás. |
| `LDA.createRecipe` | Cria uma receita simples. |
| `LDA.createItemGroup` | Cria grupos de itens e categorias no inventário. |
| `LDA.createItemSearch` | Cria itens de busca/pesquisa (ex: science packs). |

### Generic Functions (Combos Item + Receita)
| Função | Descrição Rápida |
| :--- | :--- |
| `LDA.createItemWithRecipe` | Cria item + receita associada em um único comando. |
| `LDA.createFluidWithRecipe` | Cria fluido + receita associada. |
| `LDA.createBlockItemWithRecipe` | Cria bloco + receita completa. |
| `LDA.createEquipmentItemWithRecipe` | Cria Equipamento + Receita associada. |
| `LDA.createGenericRecipe` | Gera receitas modulares definidas por matriz. |
| `LDA.createThrowInWaterItemWithRecipe` | Cria item + receita que exige "jogar na água" (ex: sementes). |

### Advanced Functions (Especializadas)
| Função | Descrição Rápida |
| :--- | :--- |
| `LDA.createAssemblerItemWithRecipe` | Cria itens produzidos especificamente em montadoras. |
| `LDA.createSmeltingItemWithRecipe` | Cria itens produzidos em fornalhas. |
| `LDA.createTechnology` | Cria tecnologias completas com efeitos e custos. |
| `LDA.createTechnologyTrigger` | Cria tecnologia com gatilho genérico. |
| `LDA.createTechnologyCraftEntityTrigger`| Tecnologia desbloqueada ao fabricar um item específico. |
| `LDA.createTechnologyMineEntityTrigger` | Tecnologia desbloqueada ao minerar uma entidade específica. |

---

## 🛠️ Utilitários (Utils)

### `LDA.utilsAnimations`
- `LDA.utilsAnimations.createAnimation(layers)`
- `LDA.utilsAnimations.createAnimationLayer(filename, width, height, hr_scale, shift, draw_as_shadow, custom_props)`

### `LDA.utilsEnergySource`
- `LDA.utilsEnergySource.createPipeConnection(flow_direction, direction, position, connection_type, params)`
- `LDA.utilsEnergySource.createFluidBox(volume, filter, production_type, pipe_connections, pipecoverspictures, params)`
- `LDA.utilsEnergySource.createBurnerEnergySource(fuel_inventory_size, effectivity, fuel_categories, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)`
- `LDA.utilsEnergySource.createElectricEnergySource(usage_priority, buffer_capacity, input_flow_limit, output_flow_limit, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)`
- `LDA.utilsEnergySource.createFluidEnergySource(fluid_volume, fluid_connections, fluid_filter, effectivity, burns_fluid, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)`
- `LDA.utilsEnergySource.createHeatEnergySource(max_temperature, specific_heat, max_transfer, default_temperature, min_working_temperature, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)`
- `LDA.utilsEnergySource.createVoidEnergySource(emissions_per_minute, render_no_power_icon, render_no_network_icon, params)`

### `LDA.utils` (Geral)
- `LDA.utils.array_contains(array, value)`
- `LDA.utils.tableMerge(target, source, overwrite)`
- `LDA.utils.createBoundingBox(x, y)`
- `LDA.utils.createModuleSpec(slots, icon_shift)`
- `LDA.utils.createResistance(resistenceType, percent)`
- `LDA.utils.getFullResistance(percent)`
- `LDA.utils.getAudio(filename, volume)`
- `LDA.utils.getSequentialAudioList(base_filename, start_index, end_index, volume)`
- `LDA.utils.CreateBaseAmbientSound(nameTrack, track_type, volume, SpaceLocationID)`
- `LDA.utils.CreateInterludeAmbientSound(nameTrack, volume, SpaceLocationID)`
- `LDA.utils.CreateMenuAmbientSound(nameTrack, volume)`
- `LDA.utils.getPicture(filename, size, scale, mipmap_count)`
- `LDA.utils.getSequentialPictureList(base_filename, start_index, end_index, size, scale, mipmap_count)`

---

## 📝 Formato Bruto (Parâmetros)

### Recursos e Itens
- `LDA.createAutoplaceControl(name, order, tint, icon_size, icon_mipmaps)`
- `LDA.createResource(name, order, particleName, resource_parameters, autoplace_parameters)`
- `LDA.createOre(name, stack_size, fuel_category, fuel_value)`
- `LDA.createItem(name, subgroup, stack_size, pictures)`
- `LDA.createBlockItem(name, subgroup, stack_size)`
- `LDA.createEquipmentItem(name, subgroup, weight)`
- `LDA.createFluid(name, energy)`
- `LDA.createGas(name, energy)`
- `LDA.createItemGroup(group_name, group_order, icon_size, subgroups, icon_mipmaps)`

### Receitas
- `LDA.createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alt_unlocks, enabled)`
- `LDA.createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alt_unlocks, isEnabled, pictures)`
- `LDA.createThrowInWaterItemWithRecipe(name, time, qtde, ingredients, stack_size, requiredWaterValue, alt_unlocks, isEnabled)`
- `LDA.createFluidWithRecipe(name, heatEnergy, crafted_in, time, ingredients, results, alt_unlocks)`
- `LDA.createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alt_unlocks, isEnabled, icon_size, pick_sound, drop_sound)`
- `LDA.createEquipmentItemWithRecipe(name, subgroup, weight, crafted_in, time, ingredients, results, alt_unlocks, isEnabled)`
- `LDA.createSmeltingItemWithRecipe(name, time, qtde, ingredients, crafted_in, alt_unlocks, isEnabled)`
- `LDA.createAssemblerItemWithRecipe(name, time, qtde, ingredients, stack_size, alt_unlocks, isEnabled)`

### Tecnologia
- `LDA.createTechnology(name, ingredients, prerequisites, unlocks, time, count, isUpgrade)`
- `LDA.createTechnologyTrigger(name, unlocks, prerequisites, research_trigger)`
- `LDA.createTechnologyCraftEntityTrigger(name, unlocks, prerequisites, item, count)`
- `LDA.createTechnologyMineEntityTrigger(name, unlocks, prerequisites, mine_entity)`

---

### Categorias de `crafted_in` Comuns
| ID | Descrição |
| :--- | :--- |
| `crafting` | Feito à mão. |
| `basic-crafting` | Máquinas de montagem Tier 1. |
| `advanced-crafting` | Máquinas de montagem Tier 2 e 3. |
| `smelting` | Fornalhas. |
| `centrifuging` | Centrífuga. |
| `throw-in-water` | Gatilho de água (customizado pela LIB). |
