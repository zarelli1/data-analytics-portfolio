// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FilaPrioridade {

    struct Cliente {
        address endereco;
        uint8 gravidade;
        uint256 chegada;
    }

    Cliente[] public fila;
    uint256 private contador;

    function entrar(uint8 _gravidade) external {
        require(_gravidade >= 1 && _gravidade <= 10, "Gravidade invalida");
        fila.push(Cliente(msg.sender, _gravidade, contador));
        contador++;
        _ordenar();
    }

    function atender() external returns (address) {
        require(fila.length > 0, "Fila vazia");
        address atendido = fila[0].endereco;
        for (uint256 i = 0; i < fila.length - 1; i++) {
            fila[i] = fila[i + 1];
        }
        fila.pop();
        return atendido;
    }

    function _ordenar() internal {
        uint256 i = fila.length - 1;
        while (i > 0) {
            uint256 j = i - 1;
            if (_temPrioridade(fila[i], fila[j])) {
                Cliente memory temp = fila[i];
                fila[i] = fila[j];
                fila[j] = temp;
                i = j;
            } else {
                break;
            }
        }
    }

    function _temPrioridade(Cliente memory a, Cliente memory b) internal pure returns (bool) {
        if (a.gravidade != b.gravidade) {
            return a.gravidade > b.gravidade;
        }
        return a.chegada < b.chegada;
    }

    function verFila() external view returns (Cliente[] memory) {
        return fila;
    }

    function tamanho() external view returns (uint256) {
        return fila.length;
    }
}
