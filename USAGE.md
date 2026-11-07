# LDA-LIB – Guia de Uso e Integração

Bem-vindo ao índice central da biblioteca **LDA-LIB** para Factorio 2.0+.

A documentação prática foi modularizada por domínio dentro do diretório [`docs/`](docs/) para manter a organização e facilitar consultas rápidas.

---

## 📚 Documentação Modular por Domínio

| Módulo / Domínio | Arquivo de Documentação | O que você encontra |
| :--- | :--- | :--- |
| **Construtores de Protótipos (Data Stage)** | [**`docs/builders.md`**](docs/builders.md) | Criação de itens, fluidos, gases, receitas simples e combos, blocos, equipamentos, máquinas especializadas, minérios com autoplace, entidades e tecnologias com gatilhos. |
| **Espaço e Planetas (Space Age)** | [**`docs/space.md`**](docs/space.md) | Criação de planetas completos, propriedades de superfície, geração de relevo/penhascos (cliffs) e rotas espaciais com asteroides. |
| **Utilitários Compartilhados** | [**`docs/utils.md`**](docs/utils.md) | Animações (`LDA.utilsAnimations`), fontes de energia e caixas de fluido (`LDA.utilsEnergySource`), efeitos in-game (`LDA.utilsAmbientEffects`), bounding boxes, áudios, imagens e resistências (`LDA.utils`). |
| **Runtime e Scripts (Control Stage)** | [**`docs/runtime.md`**](docs/runtime.md) | Manipulação de jogadores (`LDARuntime.player`), entidades (`LDARuntime.entity`), mundo e superfícies (`LDARuntime.world`), itens (`LDARuntime.item`), redes de entidades persistidas (`LDARuntime.network`), GUIs padronizadas (`LDARuntime.gui`) e grades de equipamentos (`LDARuntime.equipment_grid`). |

---

## 🚀 Instalação Rápida

1. Adicione a dependência em seu `info.json`:
   ```json
   "dependencies": ["base >= 2.0.0", "LDA-LIB >= 0.0.17"]
   ```

2. No início dos seus arquivos de protótipos (`data.lua`), defina o nome do seu mod:
   ```lua
   local LDA = require("__LDA-LIB__/init")
   LDA.setBasePath("seu-mod-nome")
   ```

3. No seu script de controle (`control.lua`), importe o runtime:
   ```lua
   local LDARuntime = require("__LDA-LIB__/runtime.init")
   ```

---

## 📁 Estrutura de Pastas Recomendada para o seu Mod

A biblioteca resolve caminhos de assets automaticamente quando mantida a convenção:

```text
seu-mod-nome/
├── info.json
├── data.lua
├── control.lua
├── graphics/
│   ├── icons/            # Ícones de itens (ex: meu-item.png)
│   │   ├── fluid/        # Ícones de fluidos
│   │   └── gas/          # Ícones de gases
│   ├── entities/         # Ícones e sprites de entidades
│   ├── equipment/        # Ícones de módulos de armadura
│   ├── item-group/       # Ícones de abas de categorias
│   └── technology/       # Ícones de tecnologias (256x256)
├── audios/               # Arquivos de som em formato .ogg
└── locale/
    └── pt-BR/
        └── base.cfg
```

---

## 🛠️ Comandos de Depuração in-game

- Digite `/lda-list` no console do jogo para listar todas as funções disponíveis da biblioteca.
- Ative o modo debug em `Configurações → Mods → Startup` para registrar logs detalhados durante o carregamento de protótipos.
