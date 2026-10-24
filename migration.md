# Plano e Registro de Migração

## Estrutura Canônica Atual (v0.0.16+)

A partir da versão **0.0.16**, o ciclo de migração transitória (v0.0.14 e v0.0.15) foi finalizado. As pastas legadas (`base-functions/`, `generic-functions/`, `functions/`, `utils/`) foram totalmente removidas, tornando obrigatório o uso da nova arquitetura de componentes encapsulados.

```text
data.lua             -> Ponto de entrada do estágio Data (chama data-stage/init.lua)
control.lua          -> Ponto de entrada do estágio Runtime (chama runtime/init.lua)
init.lua             -> Ponto de entrada da API pública consumida por outros mods

api/
  registry.lua       -> Catálogo único de funções expostas na API pública
  modules.lua        -> Mapeamento canônico dos módulos da biblioteca

data-stage/
  init.lua           -> Inicialização do data stage
  addons/            -> Conteúdos concretos de add-ons (itens, mecânicas como jogar na água)
  builders/          -> Construtores de protótipos modulares e encapsulados
    base/            -> Construtores individuais (itens, fluidos, entidades, receitas base, techs)
    composites/      -> Combinações atômicas (ex: item + receita, fluido + receita)
    specialized/     -> Builders de nicho (máquinas categorizadas, triggers)

shared/              -> Utilitários compartilhados puros (animações, energia, caminhos, efeitos)
runtime/             -> Lógica do estágio de controle (commands, function-registry, storage)
  modules/           -> Utilitários de controle: player, entity, world, item
```

## Benefícios do Encapsulamento em Componentes

1. **Fonte Única de Verdade (Single Source of Truth)**: Cada componente de protótipo reside em seu próprio módulo encapsulado em `data-stage/builders/` ou `shared/`.
2. **Propagação Imediata**: Qualquer modificação, correção de bug ou evolução em um componente propaga instantaneamente para composições, add-ons e consumidores externos sem esforço ou duplicação.
3. **Isolamento de Estágios**: Separação estrita entre estágios do Factorio (`data-stage`, `runtime` e utilitários neutros `shared`).
4. **Base de Código Limpa**: Sem pastas duplicadas, wrappers obsoletos ou desvios desnecessários.
