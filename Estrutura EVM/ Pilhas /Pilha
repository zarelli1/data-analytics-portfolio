// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title PilhaSolidity
 * @author Leonardo Zarelli 
 * @notice Implementação de uma estrutura de dados de Pilha (LIFO)
 */
contract EstruturaPilha {
    
    uint256[] private itens;

    event ItemAdicionado(uint256 valor);
    event ItemRemovido(uint256 valor);

    function push(uint256 _valor) public {
        itens.push(_valor);
        emit ItemAdicionado(_valor);
    }

    
    function pop() public returns (uint256) {
        require(itens.length > 0, "A pilha esta vazia");
        
        uint256 valorNoTopo = itens[itens.length - 1];
        itens.pop();
        
        emit ItemRemovido(valorNoTopo);
        return valorNoTopo;
    }

    
    function peek() public view returns (uint256) {
        require(itens.length > 0, "A pilha esta vazia");
        return itens[itens.length - 1];
    }


    function size() public view returns (uint256) {
        return itens.length;
    }

  
    function isEmpty() public view returns (bool) {
        return itens.length == 0;
    }
}
