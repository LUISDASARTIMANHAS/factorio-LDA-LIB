# LDA-LIB – Biblioteca Utilitária para Mods Factorio 2.0  

 local LDA = require('__LDA-LIB__/init') 
 local PATH = LDA.setBasePath('Quantum-Teleporter')

## 📘 Descrição

A **LDA-LIB** é uma biblioteca utilitária para Factorio 2.0 projetada para acelerar a criação de mods, fornecendo funções prontas para gerar:

- Itens  
- Fluidos  
- Gases  
- Receitas  
- Minérios  
- Tecnologias  
- Matrizes de receitas complexas  
- Estruturas completas (item + receita + entidade)  
- Versões especializadas (fornalhas, montadoras)

O objetivo é **reduzir trabalho repetitivo** e manter um **padrão uniforme** entre todos os seus mods.

A biblioteca também possui um **modo debug** configurável pelo usuário.

---
# FOLDER STRUCTURE

graphics - todo tipo de imagem e guardada aqui
graphics/icons - icones de itens
graphics/icons/fluid - icones de fluidos
graphics/item-group - icones de grupos e categorias de itens
graphics/equipment - icones de equipamentos
graphics/technology - icones de pesquisa
graphics/entities - icones de entidades

audio - todo tipo audio e guardado aqui

---

3. Ative o mod na tela de Mods.

---

## ⚙️ Configurações (settings.lua)

A LDA-LIB inclui uma configuração opcional:

- **LDA-LIB: Modo Debug** – habilita logs detalhados durante a geração de protótipos.

Pode ser ativada em:

Configurações → Mods → Startup

---

## 🔎 Comando /lda-list

Lista todas as funções públicas expostas pela biblioteca LDA.

---


## 🧩 Funções Disponíveis

### Base Functions| Função     
| Função                                            | Descrição Rápida                                   |
|-----------------------------|---------------------------------------------------|
| create-block-item                      | Cria itens do tipo bloco estrutural.             |
| create-equipment-item           | Cria itens do tipo equipamento colocavel em grids.             |
| create-entity                               | Cria entidades personalizadas.                   |
| create-fluid                                  | Cria fluidos com temperatura e ícone.            |
| create-gas                                    | Variante visual de fluido como gás.              |
| create-item                                  | Cria um item simples com sons e ícone.           |
| create-item-search                   | Busca itens dentro do mod.                        |
| create-ore                                    | Cria minérios completos com ícone e propriedades. automaticamente adiciona o prefixo -ore |
| create-recipe                               | Cria uma receita simples.                         |
| get-mod-path                             | Detecta automaticamente o caminho do mod.        |
| tech-util                                        | Funções utilitárias para manipulação de tecnologias.|
| utils-animations.create-animation              | Cria a estrutura completa de animação para um protótipo, a partir de uma ou mais layers |
| utils-animations. create-animation-layer  | Cria uma única camada (layer) de animação |
| create-item-group                     | Cria grupos de itens e category                   |

### Generic Functions
| Função                                                        | Descrição Rápida                                                             |
|------------------------------------|------------------------------------------------|
| create-block-item-with-recipe            | Cria bloco + receita completa.                                        |
| create-equipment-item-with-recipe | Cria Equipamentos colocaveis + Receita associada |
| create-fluid-with-recipe                        | Cria fluido + receita associada.                                      |
| create-generic-recipe                             | Gera receitas modulares definidas por matriz.         |
| create-item-with-recipe                        | Cria item + receita associada.                                        |

### Functions (Avançadas/Especializadas)
| Função                                     | Descrição Rápida                                |
|--------------------------------------------|------------------------------------------------|
| create-assembler-item-with-recipe          | Cria itens específicos de montadoras.        |
| create-smelting-item-with-recipe           | Cria itens destinados a fornalhas.           |
| create-technology-trigger                  | Cria tecnologias com gatilho de pesquisa.    |
| create-technology                          | Cria tecnologias completas com efeitos e custos.|

---

# Formato Bruto

utilsAnimations.createAnimation(layers_or_single_layer)
utilsAnimations.createAnimationLayer(filename, width, height, hr_scale, custom_props)
[Veja mais sobre utilsAnimations](https://mods.factorio.com/mod/LDA-LIB/discussion/694da6a5dd8214e6bcd2439c)

utils.array_contains(array, value)
utils.tableMerge(target, source, overwrite)
utils.createBoundingBox(x_max, y_max)
utils.createModuleSpec(slots, icon_shift)
utils.createResistance(resistenceType, percent)
utils.getFullResistance(percent)
utils.getAudio(filename, volume)
utils.getSequentialAudioList(base_filename, start_index, end_index, volume)
utils.CreateBaseAmbientSound(nameTrack, track_type, volume, SpaceLocationID)
utils.CreateInterludeAmbientSound(nameTrack, volume, SpaceLocationID)
utils.CreateMenuAmbientSound(nameTrack, volume)
utils.getPicture(filename, size, scale, mipmap_count)
utils.getSequentialPictureList(base_filename, start_index, end_index, size, scale, mipmap_count)
[Veja mais sobre Utils](https://mods.factorio.com/mod/LDA-LIB/discussion/694daa568a9eed78e7a0667d)

utilsEnergySource.createPipeConnection(flow_direction, direction, position, connection_type, params)
utilsEnergySource.createFluidBox(volume, filter, production_type, pipe_connections, pipecoverspictures, params)
utilsEnergySource.createBurnerEnergySource(fuel_inventory_size, effectivity, fuel_categories, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)
[Veja mais sobre utilsEnergySource](https://mods.factorio.com/mod/LDA-LIB/discussion/6955448c5915bc61eba44217)

- automaticamente adiciona o prefixo -ore
name-ore
createOre(name, stack_size, fuel_category, fuel_value)

createItem(name,subgroup, stack_size,pictures)
createBlockItem(name, subgroup, stack_size)
createEquipmentItem(name, subgroup, weight)
createFluid(name, energy)
createGas(name, energy)

- typeIcon: "item" or "fluid"

createRecipe(typeIcon, name, crafted_in, time, ingredients, results,alternative_unlock_methods,enabled)
createItemGroup(group_name, group_order, icon_size, subgroups, icon_mipmaps)

createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures)
createFluidWithRecipe(name, heatEnergy, crafted_in, time, ingredients, results,alternative_unlock_methods)
createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,icon_size,pick_sound,drop_sound)
createEquipmentItemWithRecipe(name, subgroup, weight, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled)
createSmeltingItemWithRecipe(name, time, qtde, ingredients,crafted_in,alternative_unlock_methods,isEnabled)
createAssemblerItemWithRecipe(name, time, qtde, ingredients, stack_size,alternative_unlock_methods,isEnabled)

createTechnology(name, ingredients, prerequisitesList, unlocksList,time,pack_count,isUpgrade,icon_size)
createTechnologyTrigger(name, unlocks, prerequisites, research_trigger)
createItemSearch(name, stack_size)
createGenericRecipe(name)

---

### Crafted-In
| Criado em                          | Descrição Rápida                                 |
|-----------------------|----------------------------------|
| advanced-crafting          | maquinas de montagem tier 2 e 3  |
| basic-crafting                   | maquinas de montagem tier 1         |
| crafting                               | feito a mão.                                           |
| smelting                             | feito em fornalhas.                              |
| centrifuging                       | feito na centrifuge.                              |
