# Plano e Registro de Migração

## Estrutura Canônica Implementada

```text
data.lua             -> Ponto de entrada do estágio Data (chama data-stage/init.lua)
control.lua          -> Ponto de entrada do estágio Runtime (chama runtime/init.lua)
init.lua             -> Ponto de entrada da API pública consumida por outros mods

api/
  registry.lua       -> Catálogo único de funções expostas na API pública
  modules.lua        -> Mapeamento de imports para os módulos canônicos

data-stage/
  init.lua           -> Inicialização do data stage
  addons/            -> Conteúdos concretos de add-ons (itens, mecânicas como jogar na água)
  builders/          -> Construtores de protótipos modulares e encapsulados
    base/            -> Construtores individuais (itens, fluidos, entidades, receitas base, techs)
    composites/      -> Combinações atômicas (ex: item + receita, fluido + receita)
    specialized/     -> Builders de nicho (máquinas categorizadas, triggers)

shared/              -> Utilitários compartilhados (utils, animações, energia, caminhos, efeitos)
runtime/             -> Lógica do estágio de controle (commands, function-registry, storage)

Camada de Compatibilidade Retroativa (Bridge Modules / Proxies):
base-functions/      -> Módulos-ponte que delegam para data-stage/builders/base/
generic-functions/   -> Módulos-ponte que delegam para data-stage/builders/composites/
functions/           -> Módulos-ponte que delegam para data-stage/builders/specialized/
utils/               -> Módulos-ponte que delegam para shared/
```

## Benefícios do Encapsulamento em Componentes

1. **Fonte Única de Verdade (Single Source of Truth)**: Cada componente de protótipo reside em seu próprio módulo encapsulado em `data-stage/builders/` ou `shared/`.
2. **Propagação Imediata**: Qualquer modificação, correção de bug ou evolução em um componente propaga instantaneamente para composições, add-ons e consumidores externos sem esforço ou duplicação.
3. **Isolamento de Estágios**: Separação estrita entre estágios do Factorio (`data-stage`, `runtime` e utilitários neutros `shared`).
4. **Zero Breaking Changes**: Os módulos-ponte nas pastas legadas garantem que mods consumidores ou scripts que importem caminhos legados continuem funcionando sem nenhuma quebra.
