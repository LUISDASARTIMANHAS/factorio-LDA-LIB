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
| `createAutoplaceControl` | Cria controles de autoplace para geração de recursos no mapa. |
| `createResource` | Cria a entidade de recurso (o minério físico no chão). |
| `createOre` | Cria o item do minério (adiciona automaticamente o prefixo `-ore`). |
| `createItem` | Cria um item simples com sons e ícone. |
| `createBlockItem` | Cria itens do tipo bloco estrutural. |
| `createEquipmentItem` | Cria itens do tipo equipamento (colocáveis em grids). |
| `createFluid` | Cria fluidos com temperatura e ícone. |
| `createGas` | Variante visual de fluido como gás. |
| `createRecipe` | Cria uma receita simples. |
| `createItemGroup` | Cria grupos de itens e categorias no inventário. |
| `createItemSearch` | Cria itens de busca/pesquisa (ex: science packs). |
| `createEntity` | Cria entidades personalizadas (base). |

### Generic Functions (Combos Item + Receita)
| Função | Descrição Rápida |
| :--- | :--- |
| `createItemWithRecipe` | Cria item + receita associada em um único comando. |
| `createFluidWithRecipe` | Cria fluido + receita associada. |
| `createBlockItemWithRecipe` | Cria bloco + receita completa. |
| `createEquipmentItemWithRecipe` | Cria Equipamento + Receita associada. |
| `createGenericRecipe` | Gera receitas modulares definidas por matriz. |
| `createThrowInWaterItemWithRecipe` | Cria item + receita que exige "jogar na água" (ex: sementes). |

### Advanced Functions (Especializadas)
| Função | Descrição Rápida |
| :--- | :--- |
| `createAssemblerItemWithRecipe` | Cria itens produzidos especificamente em montadoras. |
| `createSmeltingItemWithRecipe` | Cria itens produzidos em fornalhas. |
| `createTechnology` | Cria tecnologias completas com efeitos e custos. |
| `createTechnologyTrigger` | Cria tecnologia com gatilho genérico. |
| `createTechnologyCraftEntityTrigger`| Tecnologia desbloqueada ao fabricar um item específico. |
| `createTechnologyMineEntityTrigger` | Tecnologia desbloqueada ao minerar uma entidade específica. |

---

## 🛠️ Utilitários (Utils)

### `utilsAnimations` (CANI)
- `createAnimation(layers)`: Estrutura completa de animação.
- `createAnimationLayer(filename, width, height, ...)`: Cria uma camada individual (layer) com suporte a HR.

### `utilsEnergySource`
- `createPipeConnection(...)`: Define conexões de tubos.
- `createFluidBox(...)`: Define caixas de fluidos para entidades.
- `createBurnerEnergySource(...)`: Fonte de energia por queima.
- `createElectricEnergySource(...)`: Fonte de energia elétrica.
- `createFluidEnergySource(...)`: Fonte de energia por fluido.
- `createHeatEnergySource(...)`: Fonte de energia térmica.
- `createVoidEnergySource(...)`: Sem consumo de energia.

### `utils` (Geral)
- `array_contains(array, value)`: Verifica existência em lista.
- `tableMerge(target, source, overwrite)`: Mescla tabelas.
- `createBoundingBox(x, y)`: Gera caixas de colisão/seleção.
- `getAudio(filename, volume)`: Atalho para carregar sons.
- `getPicture(filename, size, ...)`: Atalho para carregar sprites.
- `getFullResistance(percent)`: Gera 100% de resistência a todos os danos.

---

## 📝 Formato Bruto (Parâmetros)

### Recursos e Itens
- `createAutoplaceControl(name, order, tint, icon_size, icon_mipmaps)`
- `createResource(name, order, particleName, resource_parameters, autoplace_parameters)`
- `createOre(name, stack_size, fuel_category, fuel_value)`
- `createItem(name, subgroup, stack_size, pictures)`
- `createBlockItem(name, subgroup, stack_size)`
- `createEquipmentItem(name, subgroup, weight)`
- `createFluid(name, energy)`
- `createGas(name, energy)`

### Receitas
- `createRecipe(typeIcon, name, crafted_in, time, ingredients, results, alt_unlocks, enabled)`
- `createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results, alt_unlocks, isEnabled, pictures)`
- `createThrowInWaterItemWithRecipe(name, time, qtde, ingredients, stack_size, requiredWaterValue, alt_unlocks, isEnabled)`

### Tecnologia
- `createTechnology(name, ingredients, prerequisites, unlocks, time, count, isUpgrade, icon_size)`
- `createTechnologyCraftEntityTrigger(name, unlocks, prerequisites, item, count)`
- `createTechnologyMineEntityTrigger(name, unlocks, prerequisites, mine_entity)`

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
