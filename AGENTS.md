# Instruções para agentes

## Contexto do projeto

- LDA-LIB é uma biblioteca Lua para Factorio (compatível com Factorio 2.0+). A API pública é montada em [init.lua](init.lua).
- Consulte [README.md](README.md) para o catálogo de funções e [USAGE.md](USAGE.md) para exemplos de integração em outros mods. Prefira links para essa documentação em vez de duplicá-la aqui.

## Arquitetura

- `data.lua` delega a carga de conteúdo para `data-stage/init.lua`; os add-ons concretos ficam em `data-stage/addons/`.
- `data-stage/builders/` contém os construtores de protótipos encapsulados:
  - `base/`: construtores individuais de protótipos (itens, fluidos, entidades, receitas base, tecnologias).
  - `composites/`: combina construtores (item + receita, fluido + receita, bloco + receita, etc.).
  - `specialized/`: construtores especializados (máquinas categorizadas, triggers de tecnologia, jogar na água).
- `shared/`: utilitários compartilhados de assets, animação, energia, efeitos ambientais, caminhos e tecnologias.
- `runtime/`: registro de funções e comandos no estágio de controle; `control.lua` delega para `runtime/init.lua`.
- `api/registry.lua` e `api/modules.lua`: registro canônico e catálogo central de funções públicas montadas por [init.lua](init.lua).
- Pastas legadas (`base-functions/`, `generic-functions/`, `functions/`, `utils/`): mantidas como módulos-ponte (proxies) para assegurar compatibilidade retroativa com qualquer mod ou script que ainda requisite os caminhos antigos.
- Separe sempre APIs de protótipo do estágio data e APIs runtime como `storage`, `script`, `commands` e `game`.
- [init.lua](init.lua) retorna diretamente a tabela pública de funções da LDA.

## Regras de implementação

- Mantenha a separação entre APIs de protótipo do estágio data e APIs runtime como `storage`, `script`, `commands` e `game`.
- Funções de criação normalmente devem retornar tabelas de protótipos; o consumidor decide quando chamar `data:extend(...)`.
- Use `require` explícito e referencie caminhos canônicos (`data-stage.builders.*`, `shared.*`). Novos módulos devem ser colocados em seus respectivos componentes encapsulados.
- Ao adicionar ou alterar uma função pública, registre-a em `api/registry.lua` e `api/modules.lua`.
- Chame `LDA.setBasePath("Nome-do-Mod")` antes de qualquer helper que resolva imagens ou sons do mod consumidor. Esse caminho é estado compartilhado do módulo.
- Verifique tipos e categorias conforme as APIs do Factorio 2.0+. Receitas devem aceitar apenas ingredientes e resultados compatíveis com os protótipos suportados pelo projeto.
- Não introduza dependências ou conteúdo global novo sem verificar o impacto em mods consumidores. `data.lua` já carrega os add-ons internos automaticamente.

## Assets e compatibilidade

- Use os caminhos convencionais `graphics/icons`, `graphics/entities` e `audios`; consulte [USAGE.md](USAGE.md) para a estrutura esperada pelos mods consumidores.
- Ao tocar em `data-stage/addons/throw-in-water.lua`, confirme as APIs, assets e dependências de Space Age usados pelo módulo.
- Não trate `structure.txt` como fonte de verdade: ele é um inventário gerado por [generate-structure.cmd](generate-structure.cmd) e pode ficar desatualizado.

## Validação

- Valide a sintaxe Lua com `lua -e "assert(loadfile([[...]]))"`.
- [generate-structure.cmd](generate-structure.cmd) regenera o inventário de arquivos quando necessário.
- [autoupdate.cmd](autoupdate.cmd) depende de Windows, `tar` e um caminho fixo de Steam; não execute durante validações comuns, apenas se solicitado explicitamente.
