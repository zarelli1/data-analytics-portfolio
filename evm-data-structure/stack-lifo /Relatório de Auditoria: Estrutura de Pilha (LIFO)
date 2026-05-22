# 🛡️ Relatório de Auditoria: Estrutura de Pilha (LIFO)

## 1. Visão Geral do Contrato
O contrato `EstruturaPilha` implementa de forma segura uma estrutura de dados do tipo Pilha, operando no modelo **LIFO** (Last-In, First-Out). O último elemento adicionado é sempre o primeiro a ser removido.

## 2. Análise de Segurança e Arquitetura
**Encapsulamento de Dados:** O array principal `itens` foi declarado como `private`. Isso impede a manipulação direta por contratos maliciosos externos, forçando o uso das funções oficiais e seguras.

**Proteção contra Falhas (EVM):** As funções `pop` e `peek` utilizam `require(itens.length > 0)` para prevenir erros de Index Out of Bounds (acessar posições vazias) e Underflow matemático.

**Otimização de Gas:** As funções de leitura (`peek`, `size` e `isEmpty`) utilizam o modificador `view`, tornando as consultas na blockchain 100% gratuitas para os usuários.

**Rastreabilidade (Off-Chain):** Uso estratégico de Eventos (`ItemAdicionado` e `ItemRemovido`) para notificar o Front-end (ex: React) em tempo real, otimizando a comunicação.

## 3. Resumo das Operações
**`push(valor)`:** Adiciona um novo item ao topo da memória da pilha.
**`pop()`:** Valida a segurança, remove o item do topo, emite um evento e retorna o valor removido.
**`peek()`:** Retorna o valor exato do topo da pilha sem alterar o estado da blockchain.
**`size()`:** Retorna a quantidade total de itens armazenados.
**`isEmpty()`:** Retorna um booleano (`true` ou `false`) validando o status da pilha.

## 4. Veredito Final
O código está limpo, bem estruturado, otimizado para leitura e protegido contra as principais vulnerabilidades de manipulação de arrays dinâmicos em Solidity. Aprovado.
