**Sugestão de estrutura**
Eu manteria `data.lua`, `control.lua` e `init.lua` na raiz como entradas claras para cada estágio e organizaria os módulos por responsabilidade:

```text
data-stage/
  builders/
    base/
    composites/
    specialized/
  addons/
runtime/
shared/
```

A migração deve ser gradual: os caminhos atuais aparecem em `require` e podem ser usados por mods consumidores. Antes de mover módulos, vale preservar compatibilidade com aliases ou módulos-ponte e atualizar a documentação.

melhor coisa e voce encapsular as coisas os componentes porque qualquer alteração voce modifica naquele componente e ele se propaga pra tudo sem esforço nenhum.

