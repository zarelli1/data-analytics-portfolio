// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract FilaComPrioridade {
    // 1. O MOLDE: Agora cada item tem duas informações (Valor e Urgência)
    struct Item {
        uint256 valor;
        uint256 prioridade; // Quanto maior o número, maior a urgência
    }

    // A nossa lista agora guarda "Itens" inteiros, e não apenas números
    Item[] private fila;

    event ItemAdicionado(uint256 valor, uint256 prioridade);
    event ItemRemovido(uint256 valor, uint256 prioridade);

    // 2. PUSH (Adicionar na sala de espera)
    function push(uint256 _valor, uint256 _prioridade) public {
        // Criamos o paciente e colocamos no final da fila
        fila.push(Item(_valor, _prioridade));
        emit ItemAdicionado(_valor, _prioridade);
    }

    // 3. POP (Chamar o paciente mais grave)
    function pop() public returns (uint256) {
        require(fila.length > 0, "A fila esta vazia");

        // Assumimos inicialmente que o primeiro da fila é o mais grave
        uint256 indiceMaisGrave = 0;
        uint256 maiorPrioridade = fila[0].prioridade;

        // O robô caminha pela fila comparando as prioridades
        for (uint256 i = 1; i < fila.length; i++) {
            if (fila[i].prioridade > maiorPrioridade) {
                maiorPrioridade = fila[i].prioridade; // Atualiza a maior urgência
                indiceMaisGrave = i;                  // Anota a cadeira (índice) dele
            }
        }

        // Salva o valor do paciente mais grave antes de apagá-lo
        uint256 valorRetornado = fila[indiceMaisGrave].valor;

        // 4. O TRUQUE DE MESTRE (Swap & Pop)
        // Movemos o ÚLTIMO paciente da fila para a cadeira do paciente que vai sair.
        fila[indiceMaisGrave] = fila[fila.length - 1];
        
        // Agora apagamos a última cadeira (que ficou duplicada).
        fila.pop();

        emit ItemRemovido(valorRetornado, maiorPrioridade);
        return valorRetornado;
    }
}
