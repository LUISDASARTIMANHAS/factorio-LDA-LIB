# Instruções para agentes

## Contexto do projeto

- LDA-LIB é uma biblioteca Lua para Factorio. A documentação menciona Factorio 2.0, mas `info.json` contém marcadores de conflito de merge: não o trate como JSON válido nem infira a versão ou dependências até o conflito ser resolvido. A API pública é montada em [init.lua](init.lua).
- Consulte [README.md](README.md) para o catálogo de funções e [USAGE.md](USAGE.md) para exemplos de integração em outros mods. Prefira links para essa documentação em vez de duplicá-la aqui.

## Arquitetura

- `data.lua` delega a carga de conteúdo para `data-stage/init.lua`; os módulos de `game-addons/` continuam sendo carregados no estágio data.
- `base-functions/` contém construtores individuais de protótipos.
- `generic-functions/` combina construtores, principalmente item + receita.
- `functions/` contém atalhos especializados, gatilhos de tecnologia e receitas de jogar na água.
- `api/registry.lua` é a fonte única dos nomes e destinos da API pública; [init.lua](init.lua) resolve esses módulos para consumidores no estágio data.
- `runtime/` contém o registro de funções e comandos; `control.lua` delega a inicialização para `runtime/init.lua`.
- `game-addons/` contém conteúdo concreto carregado automaticamente por `data-stage/init.lua`.
- `utils/` contém utilitários de assets, animação, energia, efeitos ambientais, caminhos e tecnologias.
- Separe sempre APIs de protótipo do estágio data e APIs runtime como `storage`, `script`, `commands` e `game`.
- [init.lua](init.lua) retorna diretamente a tabela `LDA.functions`; o resultado de `require("__LDA-LIB__/init")` é a própria tabela de funções, não um objeto com uma propriedade `functions`.

## Regras de implementação

- Mantenha a separação entre APIs de protótipo do estágio data e APIs runtime como `storage`, `script`, `commands` e `game`.
- Funções de criação normalmente devem retornar tabelas de protótipos; o consumidor decide quando chamar `data:extend(...)`.
- Use `require` explícito e preserve exatamente os nomes de módulos e os separadores de caminho já usados no repositório.
- Ao adicionar ou alterar uma função pública, atualize [init.lua](init.lua) e preserve aliases ou assinaturas existentes quando possível.
- Chame `LDA.setBasePath("Nome-do-Mod")` antes de qualquer helper que resolva imagens ou sons do mod consumidor. Esse caminho é estado compartilhado do módulo.
- Verifique tipos e categorias conforme as APIs do Factorio 2.0. Receitas devem aceitar apenas ingredientes e resultados compatíveis com os protótipos suportados pelo projeto.
- Não introduza dependências ou conteúdo global novo sem verificar o impacto em mods consumidores. [data.lua](data.lua) já carrega os add-ons internos automaticamente.

## Assets e compatibilidade

- Use os caminhos convencionais `graphics/icons`, `graphics/entities` e `audios`; consulte [USAGE.md](USAGE.md) para a estrutura esperada pelos mods consumidores.
- Ao tocar em `game-addons/throw-in-water.lua`, confirme as APIs, assets e dependências de Space Age usados pelo módulo. Como `info.json` está em conflito, não use seu conteúdo atual para concluir quais dependências estão declaradas.
- Não trate `structure.txt` como fonte de verdade: ele é um inventário gerado por [generate-structure.cmd](generate-structure.cmd) e pode ficar desatualizado.

## Validação

- Não há testes unitários, lint ou typecheck configurados no repositório.
- Não há suíte automatizada, lint, typecheck ou build configurados. Para mudanças de protótipos, valide carregando o mod numa versão compatível do Factorio, após resolver/verificar o manifesto e as dependências; confira erros no console e os protótipos gerados.
- [generate-structure.cmd](generate-structure.cmd) apenas regenera o inventário de arquivos; use-o quando precisar atualizar `structure.txt`.
- [autoupdate.cmd](autoupdate.cmd) depende de Windows, `tar` e um caminho fixo de Steam; se `API_KEY` estiver ausente, grava um valor placeholder em `.env`. Também pode apagar um ZIP anterior de mesmo nome, copiar o novo ZIP para a instalação Steam e iniciar o Factorio. Não execute durante validações comuns; use apenas quando a tarefa pedir essa instalação/publicação e após conferir os efeitos.