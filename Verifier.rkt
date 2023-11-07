#lang racket

(require redex) 
(require "EBPF.rkt")
(require "Functions.rkt")

(define-extended-language VerifyEbpf ebpf
  ;;Grafo de fluxo
  (graph ::= ((vert ...)(edge ...))
             empty)
  (vert ::= number)
  (edge ::= (edgeO edgeD))
  (edgeO ::= number)
  (edgeD ::= number)
  ;;Programa Valido
  (valid ::= boolean)
  ;;Estrutura a ser utilizada para percorer as instuçoes
  (imputProg ::= (instr graph valid pc))
  )


(define-metafunction VerifyEbpf
  cmpValid : valid boolean -> boolean
  [(cmpValid #f _ ) #f ]
  [(cmpValid _ #f ) #f ]
  [(cmpValid _ _ ) #t ]
)
(define-metafunction VerifyEbpf
  buildGraph : graph pc offset -> graph
  [(buildGraph empty pc_0 offset_0 ) (( pc_0 )((pc_0 ,(+ (term offset_0) (term pc_0)) )))]
  [(buildGraph ((vert_0 ...)((edgeO_0 edgeD_0) ...)) pc_0 offset_0 )
   ((vert_0 ... pc_0)((edgeO_0 edgeD_0) ... (pc_0 ,(+ (term offset_0) (term pc_0)) )))]
)
(define-metafunction VerifyEbpf
  atV : pc instr -> word
  [(atV 0 () ) (0 0  rP rP eof)]
  [(atV 0 (word_1 word_2 ...) ) word_1] ;; Caso base pc 0 lista de palavras retornando word_1
  [(atV number (word_1 word_2 ...)) (at ,(- (term number) 1 ) (word_2 ...))]
)

(define ->verify
  (reduction-relation
   VerifyEbpf
   #:domain imputProg
   #:codomain imputProg
   (-->(instr_0 graph_0 valid_0 pc_0)
       (instr_0 graph_1 valid_1 ,(+(term pc_0)(term 1)))
       (where (immediate offset_0 sourceReg destinationReg (bpf-ja bpf-x bpf-jmp)) (atV pc_0 instr_0) )
       (where valid_1 (cmpValid valid_0 ,(< (term 0) (term offset_0))))
       (where graph_1 (buildGraph graph_0 pc_0 offset_0))
   )
  )

)


(define ProgValidate1(
  term(
        (
        (0 1 r1 r2 (bpf-ja bpf-x bpf-jmp))
        (0 1 r1 r2 (bpf-ja bpf-x bpf-jmp))
        (0 1 r5 r6 (bpf-ja bpf-x bpf-jmp))
        (0 1 r6 r8 (bpf-ja bpf-x bpf-jmp)));;Lista de Palavras
        empty
        ;(( () (()) ));;Grafo
        #t;;Valid
        0;; Pc
       )
 )
)

(define ProgValidate2(
  term(
        (
        (0 1 r1 r2 (bpf-ja bpf-x bpf-jmp))
        (0 -1 r1 r2 (bpf-ja bpf-x bpf-jmp))
        (0 1 r5 r6 (bpf-ja bpf-x bpf-jmp))
        (0 1 r6 r8 (bpf-ja bpf-x bpf-jmp)));;Lista de Palavras
        empty
        ;(( () (()) ));;Grafo
        #t;;Valid
        0;; Pc
       )
 )
)

(traces ->verify ProgValidate1)