Estrutura geral
Esse contrato implementa uma fila de prioridade usando um heap mínimo (min-heap) em Solidity. Vamos dissecar cada pedaço:

// SPDX-License-Identifier: MIT
Comentário obrigatório que declara a licença do código. MIT = código aberto, qualquer um pode usar. Exigido pelo compilador Solidity moderno para evitar warnings.

pragma solidity ^0.8.20;

pragma = diretiva de compilador (não é código executável)
solidity ^0.8.20 = "compile com versão 0.8.20 ou superior, mas não 0.9.x"
O ^ é o operador "compatível com" (igual ao npm)


contract FilaPrioridade { ... }
A palavra contract é o equivalente Solidity de class em Java/JS. Tudo dentro das chaves é o contrato implantado na blockchain.

struct No { ... }
soliditystruct No {
    uint256 prioridade;
    uint256 chegada;
    string  dado;
}

struct = estrutura de dados customizada (igual em C/Go)
No = nome do tipo (um "nó" da fila)
uint256 = inteiro sem sinal de 256 bits (0 até ~1.16 × 10⁷⁷). Tipo padrão do EVM
prioridade = número que define quem sai primeiro (menor = mais urgente)
chegada = contador de inserção, serve como desempate: chegou primeiro, sai primeiro
string = sequência de bytes UTF-8 de comprimento dinâmico
dado = o payload — qualquer texto que o usuário quer armazenar


As três variáveis de estado
solidityNo[]    private pilha;
uint256 private tamanho;
uint256 private contador;

No[] = array dinâmico do tipo No. Fica no storage da blockchain (persistido entre chamadas)
private = só o próprio contrato pode acessar (não expõe getter automático)
pilha = o array que armazena o heap. Nome um pouco confuso — é o array do heap, não uma pilha LIFO
tamanho = quantos elementos válidos existem no array. Pode ser menor que pilha.length (array pode ter "buracos" no final)
contador = incrementa a cada enqueue, serve como timestamp de chegada para desempate de prioridade igual


function enqueue(uint256 p, string calldata d) external
solidityNo memory novo = No(p, contador++, d);

function = declaração de função
uint256 p = parâmetro prioridade
string calldata d = string lida direto do calldata (área de dados da transação). calldata é mais barato que memory para parâmetros de entrada — não copia, apenas referencia
external = só pode ser chamada de fora do contrato (não internamente por outras funções)
No memory novo = cria um nó temporário na memória (não no storage, mais barato)
No(p, contador++, d) = construtor do struct. contador++ usa o valor atual e depois incrementa (pós-incremento)

solidityif (tamanho == pilha.length) pilha.push(novo);
else pilha[tamanho] = novo;

Se o array está cheio, push expande e adiciona
Caso contrário, reutiliza uma posição que já existe no array (mais barato em gas — evita expansão de storage)

solidityuint256 i = tamanho++;

i recebe o índice da nova folha (posição onde o nó foi inserido)
tamanho++ incrementa o tamanho depois de capturar o valor — o nó entra na posição tamanho original, depois o tamanho cresce

Sobe no heap ("sift up"):
soliditywhile (i > 0) {
    uint256 pai = (i - 1) / 2;
    if (_menor(i, pai)) {
        _swap(i, pai);
        i = pai;
    } else break;
}

while (i > 0) = enquanto não chegou na raiz (índice 0)
pai = (i - 1) / 2 = fórmula clássica de heap para achar o pai. Em arrays 0-indexados, filho i tem pai em (i-1)/2
_menor(i, pai) = verifica se o nó em i deve sair antes do pai (menor prioridade numérica, ou mesmo prioridade mas chegou antes)
_swap(i, pai) = troca os dois nós no array
i = pai = sobe para continuar verificando
else break = parou de subir — a propriedade do heap está satisfeita


function dequeue() external returns (uint256, string memory)
solidityrequire(tamanho > 0, "fila vazia");
uint256       p = pilha[0].prioridade;
string memory d = pilha[0].dado;

require(condição, mensagem) = reverte a transação inteira se a condição for falsa. Equivalente a assert com mensagem
pilha[0] = a raiz do heap, que sempre contém o menor elemento (quem sai primeiro)
string memory d = copia a string para memória antes de sobrescrever o índice 0

soliditypilha[0] = pilha[--tamanho];

--tamanho = decrementa antes de usar (pré-decremento). tamanho passa a ser o índice do último elemento válido
Move o último elemento para a raiz. Isso quebra temporariamente a propriedade do heap

Desce no heap ("sift down"):
soliditywhile (true) {
    uint256 e = 2*i+1, d2 = 2*i+2, m = i;

e = 2*i+1 = índice do filho esquerdo (fórmula padrão de heap)
d2 = 2*i+2 = índice do filho direito
d2 foi nomeado assim para evitar conflito com o parâmetro d do dequeue. Um pouco confuso, sim
m = i = assume que o menor está em i (vai ser desafiado pelos filhos)

solidityif (e  < tamanho && _menor(e,  m)) m = e;
if (d2 < tamanho && _menor(d2, m)) m = d2;

e < tamanho = filho existe (não está fora dos limites)
Compara esquerdo com m, depois direito com m. m acumula o índice do menor dos três (pai + dois filhos)

solidityif (m != i) { _swap(i, m); i = m; } else break;

Se o menor não é o pai atual, troca e desce
Se o pai já é o menor, o heap está restaurado — sai do loop

solidityreturn (p, d);

Retorna tupla com prioridade e dado do elemento removido
Solidity permite múltiplos valores de retorno nativamente


function peek() external view returns (uint256, string memory)

view = função que lê estado mas não modifica. Não gasta gas quando chamada externamente (off-chain)
Retorna a raiz sem remover — "espiar" a fila


function size() external view returns (uint256)
Simples getter do tamanho atual. view pela mesma razão acima.

function _menor(uint256 a, uint256 b) private view returns (bool)
solidityif (pilha[a].prioridade != pilha[b].prioridade)
    return pilha[a].prioridade < pilha[b].prioridade;
return pilha[a].chegada < pilha[b].chegada;

private = só chamável internamente (funções auxiliares). Por convenção em Solidity, funções internas começam com _
Primeiro critério: menor prioridade numérica vence
Segundo critério (desempate): menor chegada vence — quem entrou antes sai antes (FIFO dentro da mesma prioridade)


function _swap(uint256 a, uint256 b) private
solidityNo memory t = pilha[a];
pilha[a]    = pilha[b];
pilha[b]    = t;

Troca clássica de dois elementos usando variável temporária t (em memory, barato)
Atualiza diretamente no storage (pilha é estado persistente)

Agora veja o diagrama da estrutura do heap:

<img width="1440" height="1128" alt="image" src="https://github.com/user-attachments/assets/54621bf8-9b97-4b77-932b-3d53fd115f52" />
