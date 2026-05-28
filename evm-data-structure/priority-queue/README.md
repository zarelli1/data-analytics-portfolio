# 🏥 Smart Contract: Fila de Prioridade (Priority Queue)

## 📌 Visão Geral
Este repositório contém a implementação de um contrato inteligente (Smart Contract) em Solidity que gerencia uma **Fila de Prioridade**. 

Diferente de uma fila tradicional (FIFO - *First In, First Out*), onde o primeiro a chegar é o primeiro a ser atendido, este contrato atua como a triagem de um Pronto-Socorro: **a urgência dita a ordem de execução, independentemente do tempo de espera.**

## ⚙️ Como Funciona a Arquitetura

O contrato armazena os dados em um Array Dinâmico (`[] private fila`). Cada elemento da fila é um "Pacote" (Struct) contendo dois valores fundamentais:
* **`_valor`**: O dado principal (ex: ID do usuário, RG do paciente, ID da transação).
* **`_prioridade`**: O nível de urgência numérico daquele pacote.

### 1. Inserção de Dados (Função Push)
Quando um novo item entra na fila, a EVM (Ethereum Virtual Machine) não o insere sequencialmente logo após a variável de estado para evitar colisões de memória. 
* O tamanho do array é armazenado em um Slot Base (Chave Mestra).
* A EVM calcula `Keccak256(Slot Base) + Tamanho Atual` para encontrar uma coordenada segura e isolada no Storage.
* O novo item é inserido no final da fila com custo constante O(1).

### 2. Remoção de Dados (Função Pop e Algoritmo de Busca)
A remoção do item de maior prioridade é o núcleo lógico do contrato. Ela opera em duas fases:

#### Fase A: A Busca Linear (O Robô Inspetor)
O sistema assume inicialmente que o item no índice `0` é o mais grave. Em seguida, um loop `for` percorre a fila a partir do índice `1` verificando se há algum item com prioridade superior. Ao final do loop, o contrato tem em mãos o **índice exato** do pacote mais urgente (`indiceMaisGrave`).

#### Fase B: O "Truque de Mestre" (Padrão Swap & Pop)
Para remover o item do meio da fila sem gastar milhares de dólares em taxas de rede (Gas), utilizamos o padrão avançado **Swap and Pop** de complexidade O(1):
1. **Swap (Substituição):** Copiamos o último item da fila e o colamos por cima do item que será removido (esmagando o item antigo).
2. **Pop (Limpeza):** Como o último item foi copiado para o meio, o final da fila fica com um dado duplicado. Executamos `fila.pop()` para destruir exclusivamente a última gaveta e atualizar o tamanho do array.

## ⛽ Otimização de Gas (Por que usar Swap & Pop?)
Se removêssemos um elemento do meio do array e movêssemos todos os elementos subsequentes um passo para trás para tapar o buraco (Shift), teríamos uma operação de custo **O(n)**. Em arrays gigantes na Blockchain, isso esgotaria o limite de Gas da transação.

O padrão **Swap & Pop** resolve isso movendo apenas um elemento (o último) para tampar o buraco, mantendo a operação com custo fixo **O(1)**. O efeito colateral é que a ordem cronológica dos itens restantes é alterada, mas em uma fila de prioridade, a ordem cronológica não importa, apenas o nível de urgência.

## 🚀 Casos de Uso no Mundo Real (Web3)
Esta estrutura de dados é vital para protocolos descentralizados de alta performance:
* **Sistemas DeFi:** Fila de liquidação de garantias, onde os empréstimos com maior risco de insolvência recebem prioridade máxima para serem liquidados.
* **DAOs:** Filas de execução de propostas, onde correções de segurança (patches) furam a fila de votações comuns.
* **GameFi:** Servidores de processamento de ações em massa, priorizando jogadores ou transações críticas.
