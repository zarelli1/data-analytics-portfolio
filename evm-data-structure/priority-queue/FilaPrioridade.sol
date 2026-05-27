// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract FilaComPrioridade {
    struct Item {
        uint256 valor;
        uint256 prioridade; 
    }

    Item[] private fila;

    event ItemAdicionado(uint256 valor, uint256 prioridade);
    event ItemRemovido(uint256 valor, uint256 prioridade);


    function push(uint256 _valor, uint256 _prioridade) public {
        
        fila.push(Item(_valor, _prioridade));

        emit ItemAdicionado(_valor, _prioridade);
    }

parei aqui


function pop() public returns (uint256) {
        require(fila.length > 0, "A fila esta vazia");

        uint256 indiceMaisGrave = 0;
        uint256 maiorPrioridade = fila[0].prioridade;

        for (uint256 i = 1; i < fila.length; i++) {
            if (fila[i].prioridade > maiorPrioridade) {
                maiorPrioridade = fila[i].prioridade;
                indiceMaisGrave = i;                 
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
