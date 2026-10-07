# AWS re/Start — Laboratório 253: Desafio de Scripts Shell Bash

## Sobre o laboratório

Neste laboratório de desafio do **AWS re/Start**, foi desenvolvido um script Bash para automatizar a criação de arquivos numerados.

O desafio consiste em criar **25 arquivos vazios por execução**, seguindo uma sequência numérica baseada no maior número de arquivo que já existe no diretório.

Os números não devem ser definidos manualmente no script. A sequência deve ser determinada automaticamente pelo próprio Bash.

Por exemplo, considerando `azevaldo` como nome utilizado no exercício:

```text
azevaldo1
azevaldo2
azevaldo3
...
azevaldo25
```

Ao executar o script novamente, a próxima sequência deverá continuar:

```text
azevaldo26
azevaldo27
...
azevaldo50
```

Assim, cada execução cria um novo lote de 25 arquivos sem sobrescrever a sequência anterior.

## Objetivos

* Criar um diretório e trabalhar com arquivos no Linux.
* Criar um script Bash.
* Utilizar o comando `touch`.
* Trabalhar com variáveis.
* Utilizar estruturas de repetição.
* Identificar automaticamente o maior número existente.
* Gerar sequências numéricas automaticamente.
* Criar 25 arquivos vazios por execução.
* Evitar números definidos manualmente no código.
* Testar o script e verificar os arquivos criados.

## Ambiente utilizado

* **Programa:** AWS re/Start
* **Lab:** 253 — Desafio: Scripts de Shell Bash
* **AWS:** Vocareum
* **Serviço:** Amazon EC2
* **Sistema operacional:** Amazon Linux
* **Acesso:** SSH
* **Sistema utilizado:** Windows
* **Cliente SSH:** PuTTY
* **Chave:** `labsuser.ppk`
* **Usuário:** `ec2-user`

## Conexão com a instância

Como o laboratório foi realizado no Windows, a conexão com a instância EC2 foi feita utilizando o **PuTTY**.

Configuração utilizada:

```text
Host Name: <PublicIP>
Port: 22
Connection type: SSH
```

Na configuração de autenticação do PuTTY:

```text
Connection
└── SSH
    └── Auth
        └── Credentials
            └── Private key file: labsuser.ppk
```

Depois da conexão, foi utilizado o usuário:

```text
ec2-user
```

> A chave privada `labsuser.ppk` não deve ser adicionada ao repositório.

---

# Desafio

O desafio apresenta os seguintes requisitos:

1. Criar 25 arquivos vazios.
2. Utilizar o comando `touch`.
3. Os arquivos devem possuir um nome formado pelo nome escolhido e um número.
4. A cada nova execução, o script deve criar os próximos 25 arquivos.
5. A numeração deve continuar a partir do maior número já existente.
6. Os números não podem ser definidos manualmente no script.
7. O processo deve ser automatizado.
8. Após a execução, deve ser possível verificar os arquivos utilizando uma listagem longa do diretório.

---

## Exemplo prático

Para facilitar a compreensão, foi utilizado:

```text
azevaldo
```

como nome base.

### Primeira execução

O diretório está inicialmente vazio.

O script cria:

```text
azevaldo1
azevaldo2
azevaldo3
...
azevaldo25
```

Total:

```text
25 arquivos
```

### Segunda execução

O script identifica que o maior número existente é:

```text
25
```

Então começa a próxima sequência em:

```text
26
```

Criando:

```text
azevaldo26
azevaldo27
azevaldo28
...
azevaldo50
```

Agora existem:

```text
50 arquivos
```

### Terceira execução

O maior número existente passa a ser:

```text
50
```

O script então cria:

```text
azevaldo51
azevaldo52
...
azevaldo75
```

Dessa forma, cada execução adiciona exatamente 25 novos arquivos.

---

# Desenvolvimento do script

O script utilizado no desafio foi:

```bash
#!/bin/bash

PREFIX="azevaldo"

LAST=$(find . -maxdepth 1 -type f -name "${PREFIX}[0-9]*" \
    -printf "%f\n" 2>/dev/null |
    sed "s/^${PREFIX}//" |
    grep -E '^[0-9]+$' |
    sort -n |
    tail -1)

if [ -z "$LAST" ]; then
    LAST=0
fi

START=$((LAST + 1))
END=$((LAST + 25))

for ((counter=START; counter<=END; counter++))
do
    touch "${PREFIX}${counter}"
    echo "${PREFIX}${counter}"
done

echo "Arquivos criados: 25"
```

> O prefixo `azevaldo` pode ser substituído pelo nome escolhido para a realização do desafio.

---

# Entendendo o script

## Shebang

```bash
#!/bin/bash
```

Indica que o script será executado utilizando o Bash.

---

## Definindo o nome base

```bash
PREFIX="azevaldo"
```

A variável `PREFIX` armazena o nome utilizado nos arquivos.

Assim, em vez de escrever `azevaldo` várias vezes no código, utilizamos:

```bash
$PREFIX
```

Por exemplo:

```bash
"${PREFIX}1"
```

resulta em:

```text
azevaldo1
```

---

## Encontrando o maior número existente

A parte mais importante do desafio é descobrir qual foi o maior número criado anteriormente.

Foi utilizado:

```bash
find . -maxdepth 1 -type f -name "${PREFIX}[0-9]*"
```

Esse comando procura arquivos no diretório atual.

O objetivo é encontrar arquivos semelhantes a:

```text
azevaldo1
azevaldo2
azevaldo25
azevaldo50
```

O resultado passa pelas etapas seguintes para extrair somente os números.

### Extraindo os nomes

```bash
-printf "%f\n"
```

Faz com que o `find` apresente somente o nome do arquivo.

Exemplo:

```text
azevaldo1
azevaldo25
azevaldo50
```

### Removendo o prefixo

```bash
sed "s/^${PREFIX}//"
```

Remove `azevaldo` do início dos nomes.

O resultado passa a ser:

```text
1
25
50
```

### Garantindo que sejam números

```bash
grep -E '^[0-9]+$'
```

Mantém somente valores compostos por números.

### Ordenando numericamente

```bash
sort -n
```

Organiza os números em ordem crescente:

```text
1
25
50
```

### Pegando o maior número

```bash
tail -1
```

Pega o último número da lista.

Neste exemplo:

```text
50
```

Portanto:

```bash
LAST=50
```

---

# Quando ainda não existem arquivos

Na primeira execução, não haverá nenhum arquivo correspondente.

Por isso, existe a verificação:

```bash
if [ -z "$LAST" ]; then
    LAST=0
fi
```

Se nenhuma numeração for encontrada, `LAST` recebe:

```text
0
```

Assim, a primeira execução começa corretamente em:

```text
1
```

---

# Definindo o início e o fim

Depois de descobrir o maior número existente:

```bash
START=$((LAST + 1))
```

Define o primeiro número do novo lote.

E:

```bash
END=$((LAST + 25))
```

define o último número.

Por exemplo, se:

```text
LAST=25
```

então:

```text
START=26
END=50
```

---

# Criando os 25 arquivos

Para gerar automaticamente os arquivos foi utilizada uma estrutura `for`:

```bash
for ((counter=START; counter<=END; counter++))
do
    touch "${PREFIX}${counter}"
    echo "${PREFIX}${counter}"
done
```

O contador começa em `START` e continua até `END`.

O comando:

```bash
touch "${PREFIX}${counter}"
```

cria o arquivo.

Por exemplo:

```text
azevaldo26
```

Depois:

```text
azevaldo27
```

E assim por diante.

---

# Testando o script

Depois de criar o arquivo:

```bash
desafio.sh
```

foi necessário torná-lo executável:

```bash
chmod +x desafio.sh
```

O script pode então ser executado com:

```bash
./desafio.sh
```

Na primeira execução, a saída será semelhante a:

```text
azevaldo1
azevaldo2
azevaldo3
azevaldo4
...
azevaldo25
Arquivos criados: 25
```

Na segunda execução:

```text
azevaldo26
azevaldo27
azevaldo28
...
azevaldo50
Arquivos criados: 25
```

---

# Validando os arquivos

O laboratório solicita uma listagem longa do diretório para validar os arquivos criados.

Para isso, foi utilizado:

```bash
ls -l
```

O resultado apresenta os arquivos criados, por exemplo:

```text
-rw-r--r-- 1 ec2-user ec2-user 0 Oct  6 23:00 azevaldo1
-rw-r--r-- 1 ec2-user ec2-user 0 Oct  6 23:00 azevaldo2
-rw-r--r-- 1 ec2-user ec2-user 0 Oct  6 23:00 azevaldo3
...
```

O valor:

```text
0
```

indica que os arquivos possuem **0 KB**, conforme solicitado pelo desafio.

---

# Principais comandos utilizados

| Comando | Função                          |
| ------- | ------------------------------- |
| `pwd`   | Exibe o diretório atual         |
| `touch` | Cria arquivos vazios            |
| `chmod` | Altera permissões               |
| `find`  | Procura arquivos e diretórios   |
| `sed`   | Manipula texto                  |
| `grep`  | Filtra informações              |
| `sort`  | Ordena resultados               |
| `tail`  | Obtém as últimas linhas         |
| `ls -l` | Exibe uma listagem detalhada    |
| `for`   | Cria uma estrutura de repetição |

---

# Conceitos praticados

## Automação

Em vez de criar manualmente:

```bash
touch azevaldo1
touch azevaldo2
touch azevaldo3
...
```

o script automatiza todo o processo.

## Variáveis

Foram utilizadas variáveis para armazenar informações:

```bash
PREFIX="azevaldo"
LAST=...
START=...
END=...
```

## Estrutura de repetição

O `for` permite executar uma ação várias vezes:

```bash
for ((counter=START; counter<=END; counter++))
```

## Substituição de comandos

O Bash permite utilizar o resultado de um comando dentro de uma variável:

```bash
LAST=$(...)
```

## Aritmética no Bash

O Bash permite realizar cálculos utilizando:

```bash
$((...))
```

Por exemplo:

```bash
START=$((LAST + 1))
```

## Arquivos vazios

O comando:

```bash
touch arquivo
```

pode ser utilizado para criar um arquivo vazio.

---

# O que foi aprendido

Neste desafio, foram praticados:

* criação de scripts Bash;
* criação de arquivos utilizando `touch`;
* utilização de variáveis;
* estruturas de repetição com `for`;
* operações matemáticas no Bash;
* pesquisa de arquivos com `find`;
* filtragem de informações com `grep`;
* manipulação de texto com `sed`;
* ordenação numérica com `sort`;
* identificação do maior número existente;
* criação automática de sequências;
* automação de tarefas repetitivas;
* verificação dos arquivos utilizando `ls -l`.

## Conclusão

O laboratório demonstrou na prática como o Bash pode ser utilizado para automatizar tarefas que seriam trabalhosas se realizadas manualmente.

O principal desafio foi fazer com que o script **não dependesse de números definidos manualmente**.

A cada execução, o script verifica os arquivos existentes, identifica o maior número e cria automaticamente os próximos 25 arquivos.

Esse tipo de lógica é importante para compreender como scripts Bash podem ser utilizados em tarefas de administração de sistemas e automação no ambiente Linux.

## Arquivos do repositório

```text
aws-restart-laboratorio-253-desafio-scripts-shell-bash/
├── README.md
├── desafio.sh
└── .gitignore
```

O arquivo `desafio.sh` contém a implementação do desafio e o `README.md` documenta o processo realizado no laboratório.
