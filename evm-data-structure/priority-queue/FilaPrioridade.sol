
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FilaPrioridade {

    struct No {
        uint256 prioridade;
        string  dado;
    }

    No[]    private pilha;
    uint256 private tamanho;

    function enqueue(uint256 p, string calldata d) external {
        if (tamanho == pilha.length) pilha.push(No(p, d));
        else pilha[tamanho] = No(p, d);

        uint256 i = tamanho++;

        while (i > 0) {
            uint256 pai = (i - 1) / 2;
            if (pilha[i].prioridade < pilha[pai].prioridade) {
                _swap(i, pai);
                i = pai;
            } else break;
        }
    }

    function dequeue() external returns (uint256, string memory) {
        require(tamanho > 0, "fila vazia");

        uint256 p      = pilha[0].prioridade;
        string memory d = pilha[0].dado;

        pilha[0] = pilha[--tamanho];

        uint256 i = 0;
        while (true) {
            uint256 e = 2*i+1, d2 = 2*i+2, m = i;
            if (e  < tamanho && pilha[e ].prioridade < pilha[m].prioridade) m = e;
            if (d2 < tamanho && pilha[d2].prioridade < pilha[m].prioridade) m = d2;
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

    function _swap(uint256 a, uint256 b) private {
        No memory t = pilha[a];
        pilha[a]    = pilha[b];
        pilha[b]    = t;
    }
}
