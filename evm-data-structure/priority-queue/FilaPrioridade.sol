// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FilaPrioridade {

    struct No {
        uint256 prioridade;
        uint256 chegada;
        string  dado;
    }

    No[]    private pilha;
    uint256 private tamanho;
    uint256 private contador;

    function enqueue(uint256 p, string calldata d) external {
        No memory novo = No(p, contador++, d);

        if (tamanho == pilha.length) pilha.push(novo);
        else pilha[tamanho] = novo;

        uint256 i = tamanho++;

        while (i > 0) {
            uint256 pai = (i - 1) / 2;
            if (_menor(i, pai)) {
                _swap(i, pai);
                i = pai;
            } else break;
        }
    }

    function dequeue() external returns (uint256, string memory) {
        require(tamanho > 0, "fila vazia");

        uint256       p = pilha[0].prioridade;
        string memory d = pilha[0].dado;

        pilha[0] = pilha[--tamanho];

        uint256 i = 0;
        while (true) {
            uint256 e = 2*i+1, d2 = 2*i+2, m = i;
            if (e  < tamanho && _menor(e,  m)) m = e;
            if (d2 < tamanho && _menor(d2, m)) m = d2;
            if (m != i) { _swap(i, m); i = m; } else break;
        }

        return (p, d);
    }

    function peek() external view returns (uint256, string memory) {
        require(tamanho > 0, "fila vazia");
        return (pilha[0].prioridade, pilha[0].dado);
    }

    function size() external view returns (uint256) {
        return tamanho;
    }

    // retorna true se o nó em `a` deve sair antes do nó em `b`
    function _menor(uint256 a, uint256 b) private view returns (bool) {
        if (pilha[a].prioridade != pilha[b].prioridade)
            return pilha[a].prioridade < pilha[b].prioridade;
        return pilha[a].chegada < pilha[b].chegada;
    }

    function _swap(uint256 a, uint256 b) private {
        No memory t = pilha[a];
        pilha[a]    = pilha[b];
        pilha[b]    = t;
    }
}
