// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title PilhaSolidity
 * @author Leonardo Zarelli (Ecosystem One)
 * @notice Implementação de uma estrutura de dados de Pilha (LIFO)
 */
contract EstruturaPilha {
    // O array que armazenará os dados da pilha
    uint256[] private itens;

    event ItemAdicionado(uint256 valor);
    event ItemRemovido(uint256 valor);

    // Adiciona um elemento ao topo da pilha (PUSH)
    function push(uint256 _valor) public {
        itens.push(_valor);
        emit ItemAdicionado(_valor);
    }
PAREI AQUI
    // Remove e retorna o elemento do topo (POP)
    function pop() public returns (uint256) {
        require(itens.length > 0, "A pilha esta vazia");
        
        // Em Solidity, o pop() de um array remove o ultimo elemento
        uint256 valorNoTopo = itens[itens.length - 1];
        itens.pop();
        
        emit ItemRemovido(valorNoTopo);
        return valorNoTopo;
    }

    // Apenas olha o elemento do topo sem remover (PEEK)
    function peek() public view returns (uint256) {
        require(itens.length > 0, "A pilha esta vazia");
        return itens[itens.length - 1];
    }

    // Retorna o tamanho atual da pilha
    function size() public view returns (uint256) {
        return itens.length;
    }

    // Verifica se está vazia
    function isEmpty() public view returns (bool) {
        return itens.length == 0;
    }
}
