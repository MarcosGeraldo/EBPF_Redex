#lang racket

(require redex)

#|
Exemplo: Uma linguagem de expressões aritméticas
================================================

Preliminares
------------

Para executar esse código é necessário instalar um
compilador para a linguagem Racket. Instalações para
diferentes sistemas operacionais podem ser encontradas
no site:

https://racket-lang.org/

Após instalar a linguagem é necessário instalar a
biblioteca Redex. Para isso, recomendo o uso do terminal
usando o comando:

raco pkg install redex

que instalará todas as dependências necessárias para
utilizar o Redex para especificação de linguagens.


Introdução
----------

Neste exemplo utilizaremos a biblioteca (ou linguagem)
redex para a especificação de uma pequena linguagem de
expressões aritméticas. A definição desta linguagem
possuirá dois componentes: a sintaxe e semântica.

A sintaxe usará uma estrutura similar a uma gramática
livre de contexto. A semântica, por sua vez, será
definida como regras que especificam como expressões
devem ser executadas.

Sintaxe
-------

A seguir vamos definir a sintaxe de nossa linguagem de
expressões usando uma notação similar à utilizada por
uma gramática livre de contexto:

e -> v
  | (+ e e)
  | (* e e)

v -> número

Redex é uma linguagem/biblioteca desenvolvida utilizando
a linguagem Racket, que é uma versão moderna da linguagem
Lisp. Uma das características dessas linguagens é o uso de
parêntesis como uma construção sintática que representa uma
chamada de função. Logo, quando definimos:

(+ e e)

estamos realizando uma chamada de função para criar um elemento
da sintaxe da linguagem especificada, a saber, a soma de duas
expressões.

Para definirmos a sintaxe de uma linguagem devemos utilizar
o comando _define-language_, que recebe como argumento o nome
da linguagem (no exemplo a seguir, ArithL) e um conjunto de
regras da gramática da linguagem.

|#

(define-language ArithL
  (e ::= v
         (+ e e)
         (* e e))
  (v ::= natural))

#|
Observe que o comando anterior possui uma estrutura muito similar
à gramática apresentada anteriormente para esta mesma linguagem.

A partir da definição da sintaxe da linguagem, podemos definir
a sua semântica, isto é, como programas dessa linguagem devem
se comportar quando executados.

Semântica
---------

* Introdução

Redex utiliza uma estratégia para especificar a semântica de uma
linguagem de programação conhecida como _reduction semantics_, em que
o significado da linguagem é dado em termos de um conjunto de
regras de re-escrita.

* Definição da semântica de expressões aritméticas

Para a linguagem de expressões aritméticas, podemos representar seu
significado pelo seguinte conjunto de regras:

v_3 = v_1 .+. v_2
-------------------(E-add)
(+ v_1 v_2) --> v_3


v_3 = v_1 .*. v_2
-------------------(E-mul)
(* v_1 v_2) --> v_3

A regra E-add especifica que uma expressão composta pela soma de dois
valores numéricos, (+ v_1 v_2), pode ser reduzida para o inteiro que
corresponde a soma destes valores. A notação .+. representa a adição
sobre números e + representa a sintaxe da linguagem de expressões para
a operação de soma. Dessa forma, o resultado da adição é a constante
numérica v_3 = v_1 .+. v_2.

A regra E-mul para a multiplicação é definida de maneira similar.

Observe que as regras anteriores apenas definem como executar expressões
básicas, isto é, que envolvem constantes numéricas como sub-expressões.
Quando temos expressões compostas como, por exemplo, (+ (* 2 2) 3);
devemos avaliar cada subexpressão para então combinar o resultado com
a operação apropriada. Neste sentido, podemos definir as seguintes
regras para a avaliação recursiva de expressões:

        e_1 --> e'_1
------------------------------(E-add-left)
(+ e_1 e_2) --> (+ e'_1 e_2)

Nesta primeira regra, mostramos que a avaliação de expressões executa
primeiro expressões à esquerda. Por sua vez, a próxima regra

e_2 --> e'_2
------------------------------(E-add-right)
(+ v_1 e_2) --> (+ v_1 e'_2)

especifica que somente executamos a expressão à direita quando a
subexpressão da esquerda já é um valor numérico. Estas duas regras
mostram que a avaliação procede da esquerda para a direita.
Regras para a multiplicação são similares:

e_1 --> e'_1
------------------------------(E-mul-left)
(* e_1 e_2) --> (* e'_1 e_2)

e_2 --> e'_2
------------------------------(E-mul-right)
(* v_1 e_2) --> (* v_1 e'_2)

Evidentemente, as regras apresentadas para a avaliação recursiva
de expressões são bastante similares.  Isso nos leva a necessidade
de _refatorar_ essas definições de forma a facilitar a sua modificação,
caso necessário. Para obtermos uma definição suscinta do processo de
avaliação desta linguagem, vamos recorrer a um conceito conhecido como
_contextos de avaliação_.

* Contextos de avaliação

De maneira simples, um contexto de avaliação é uma representação de
como a recursão sobre expressões deve ser realizada. Definimos os
contextos de avaliação para expressões da seguinte forma:

E -> hole
  | (+ v E)
  | (+ E e)
  | (* v E)
  | (* E e)

Um contexto pode ser um _hole_, que representa uma expressão qualquer.
Podemos entender um hole como sendo uma sub-expressão em que um passo
de execução será realizado. Além de um hole, contextos podem representar
estruturas de expressões. Por exemplo, o contexto (+ v E) representa uma
expressão em que o lado esquerdo é um valor numérico seguido de um contexto
E qualquer. Como exemplo, esse contexto representa uma expressão como
(+ 1 (* 2 2)), em que a variável v representa o valor numérico 1 e o contexto
E representa a expressão (* 2 2). O contexto (+ E e) representa expressões de
adição em que o lado esquerdo é uma expressão composta, como por exemplo,
(+ (* 2 2) (+ 1 1)), em que o contexto E denota a express (* 2 2) e a variável
e representa a expressão (+ 1 1). Contextos para a multiplicação possuem
definições similares.

Representamos por E[e] o resultado de substituir um _hole_ presente no contexto
E por uma expressão e. Como exemplo, considere o contexto (+ 1 hole). O resultado
de (+ 1 hole)[(* 2 2)] é a expressão (+ 1 (* 2 2)), em que o hole foi substituído
pela expressão (* 2 2).

Em redex, representamos contextos através de uma gramática. No trecho de código
a seguir, extendemos a linguagem ArithL usando o comando _define-extended-language_,
que permite incluir novos elementos a uma gramática já existente.
|#

(define-extended-language
  ArithCtx
  ArithL
  (E ::= hole
     (+ v E)
     (+ E e)
     (* v E)
     (* e E)))

#|

A seguir, descrevemos como contextos de avaliação podem ser utilizados para evitar
redundâncias em definições semânticas.

* Utilizando contextos de avaliação na definição da semântica

Como previamente dito, um contexto indica possíveis locais de uma expressão onde
a execução pode acontecer. Por exemplo, o contexto da forma (+ v E) representa
expressões em que o lado esquerdo foi completamente avaliação e a execução deve
então proceder para a sub-expressão à direita, indicada pela variável E. Observe
que essa forma de contexto possui uma estrutura similar à utilizada pela regra

e_2 --> e'_2
------------------------------(E-add-right)
(+ v_1 e_2) --> (+ v_1 e'_2)

Em que a avaliação deve proceder para a subexpressão à direita sempre que a
sub-expressão esquerda for um valor numérico. De maneira similar, o contexto
(+ E e) denota a mesma estrutura que a regra 

e_1 --> e'_1
------------------------------(E-add-left)
(+ e_1 e_2) --> (+ e'_1 e_2)

As regras E-add-right e E-add-left mostram que a execução deve proceder para
subexpressões de acordo com a forma sintática da expressão a ser executada.
Esse padrão pode ser abstraído utilizando contextos de avaliação da
seguinte forma

e --> e'
----------------(E-ctx)
E[e] --> E[e']

que especifica que se em um contexto E existe uma sub-expressão e tal que
e --> e' (e avalia para e') então a expressão E[e] pode ser reduzida para
E[e']. Como exemplo, considere a expressão (+ (* 2 2) 3) que pode ser generalizada
pelo contexto (+ hole 3), indicando que devemos avaliar a expressão à esquerda.
Porém, podemos observar que a expressão (* 2 2) pode ser reduzida para 4 usando a
regra E-mul, definida anteriormente:

4 = 2 .*. 2
---------------(E-mul)
(* 2 2) --> 4

Note que a expressão original (+ (* 2 2) 3) pode ser obtida a partir do contexto
(+ hole 3) pela substituição (+ hole 3)[(* 2 2)]. Dessa forma, pela regra E-ctx temos:

4 = 2 .*. 2
---------------(E-mul)
(* 2 2) --> 4
---------------------------------(E-ctx)
(+ hole 3)[(* 2 2)] --> (+ 4 3)

que mostra que a expressão original, (+ (* 2 2) 3) reduz para (+ 4 3).

Diante do apresentado, podemos então definir a semântica desta linguagem apenas
usando as regras E-add, que soma dois números; E-mul, que realiza a multiplicação
de dois números e E-ctx que realiza a avaliação recursiva utilizando contextos
para expressões.

A seguir, apresentamos como definir as regras E-add, E-mul e E-ctx utilizando redex.
|#

(define ->e
  (reduction-relation
   ArithCtx
   #:domain e
     (-->e (+ v_1 v_2)
          ,(+ (term v_1) (term v_2))
          "E-add")
     (-->e (* v_1 v_2)
          ,(* (term v_1) (term v_2))
          "E-mul")
     with
     [(--> (in-hole E a) (in-hole E b))
      (-->e a b)]))

#|
Especificamos a semântica utilizando a função reduction-relation do Redex. Esta
função recebe 3 argumentos: o primeiro é a linguagem sobre a qual a semântica está
sendo definida (em nosso exemplo, é a ArithCtx), o domínio (a variável "e" da
gramática desta linguagem) e um conjunto de regras de redução que possuem o seguinte
formato geral:

(-->e left
      right
      "name")

em que _left_ representa o lado esquerdo de uma regra de reescrita, _right_ o lado
direito e "name" o nome da regra sendo definida. Dessa forma, na regra

(-->e (+ v_1 v_2)
     ,(+ (term v_1) (term v_2))
     "E-add")

temos que

left = (+ v_1 v_2)
right = ,(+ (term v_1) (term v_2))
name = "E-add"

ou seja, o lado esquerdo da regra é uma expressão da forma (+ v_1 v_2), que
representa expressões de soma que tem como subexpressões valores numéricos.
Por sua vez, o lado direito

,(+ (term v_1) (term v_2))

utiliza a função term que converte um valor numérico da linguagem de expressões
definida para um valor numérico de racket, a linguagem na qual o Redex é
implementado. Após converter os dois valores numéricos, v_1 e v_2, para expressões
racket, realizamos a sua soma (usando a função de soma +) e convertemos o resultado
desta soma (um valor numérico racket) para um valor numérico da linguagem de
expressões do Redex usando o operador ",". Assim, a regra "E-add" é representada
em Redex como:

(-->e (+ v_1 v_2)
     ,(+ (term v_1) (term v_2))
     "E-add")

Novamente, a regra E-mul possui definição similar. Por sua vez, a definição da
regra E-ctx possui uma forma especial.

with
[(--> (in-hole E a) (in-hole E b))
 (-->e a b)]

A regra E-ctx é definida utilizando uma cláusula with que permite definir a redução
em termos de contextos. A expressão (in-hole E a) denota E[a], ou seja a substituição
do hole do contexto E pela expressão a. Dessa forma, temos que

[(--> (in-hole E a) (in-hole E b))
 (-->e a b)]

representa exatamente a regra E-ctx

a --> b
------------- (E-ctx)
E[a] --> E[b]

Para testarmos a relação de redução, podemos utilizar a função traces. Esta função
possui como parâmetros o nome da semântica considerada, no exemplo ->e, e uma
expressão a ser executada e exibe uma janela apresentando o passo-a-passo da
redução desta expressão.
|#


(traces ->e (term (+ (* 2 2) 3)))


#|

Conclusão
=========

Apresentamos um pequeno exemplo de como especificar uma linguagem simples utilizando
a biblioteca Redex de Racket.

Tarefa
------

Como tarefa, considere implementar uma linguagem de expressões booleanas formadas
apenas pelas constantes lógicas true, false e a operação and, de "e" lógico.
Sua linguagem deverá especificar a sintaxe seguindo a seguinte estrutura de gramática:

b ::= v
   | (and b b)

v ::= true
   | false

A semântica de sua linguagem deverá avaliar expressões da esquerda para a direita
e produzir como resultado o valor lógico da expressão executada. Para isso, siga os
seguintes passos:

1. Defina um contexto de avaliação para a linguagem de expressões lógicas. Seu
contexto deve ser tal que a execução das expressões proceda da esquerda para
direita, como no exemplo apresentado para expressões aritméticas.

2. Defina os casos básicos da semântica. Os casos base devem envolver os
valores (true e false) e como expressões formadas apenas por valores e a operação
and devem ser reduzidas.

3. Especifique a regra da semântica utilizando contextos de avaliação, como
no exemplo de expressões aritméticas.

4. Utilize a função traces para testar se sua semântica está se comportando como
esperado.

5. Estenda sua linguagem para considerar a operação de "ou" lógico.

Referências
===========

1. Experimenting with languages with Redex. Willian J. Bowman.
   [[https://www.williamjbowman.com/doc/experimenting-with-redex/index.html]]
2. Redex: Practical semantics engineering. Robert Bruce Findler, Casey Klein,
   Burke Fetscher e Matthias Felleisen.
   [[https://docs.racket-lang.org/redex/]]

|#


#|Inicio do meu codigo|#
#|
Minhas consideraçoes, não consegui encontrar esse erro que é citado na linha 438
"reduction-relation:
before underscore must be either a non-terminal or a built-in pattern, found vAnd in vAnd_1 at:
 vAnd_1 in: (and vAnd_1 vAnd_2)"

Creio que utilziei de forma correta o vAnd ou Or como ::=Bool
Criei muitas variaçoes de nomes, eAnd, eOr, creio que algumas foram desnecessarias, mas por meio de testes descobri que o
define->e tem que possuir nomes distintos para cada definição, desta forma seria necessario pelo menos o eAnd e o eOr,
com relação ao v creio que não se faz necessario e ao E tambem não, no caso do é so seria necessario exterder a definição.
Mas o que consegui desenvolver segue abaixo, deixando mais que claro que usei muito como padrão o que foi realizado acima



|#