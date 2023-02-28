#lang racket

(require redex)

(define-language ebpf

  ;;Representação da palavra 
  (instr ::= (word ...))
  (word ::= (immediate offset sourceReg destinationReg opcode))
  (immediate ::= natural)
  (offset ::= natural)
  (sourceReg ::= registerCode)
  (destinationReg ::= registerCode)
  (opcode ::= (msb source lsb)
              eof)
  (msb ::= bpf-add
           bpf-sub)
  (source ::= bpf-k
              bpf-x)
  (lsb ::= natural)
  
  
  ;;Representação dos registradores
  (registers ::= (register ...))
  (register ::= (registerCode content)) ;;Representador do Registrador Generico
  (content ::= natural)
  (registerCode ::= r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 rP);;Lista dos possiveis registradores
  ;;Representação de um Programa EBPF
  (pc ::= natural);;Contador de Programa
  (program ::= (registers instr pc )
           )
 )

(define-metafunction ebpf
  at : pc instr -> word
  [(at 0 () ) (0 0  rP rP eof)]
  [(at 0 (word_1 word_2 ...) ) word_1] ;; Caso base pc 0 lista de palavras retornando word_1
  [(at natural (word_1 word_2 ...)) (at ,(- (term natural) 1 ) (word_2 ...))]
)

(define-metafunction ebpf
  regread : registers destinationReg -> natural
  [(regread () registerCode_1) -1]
  [(regread ((registerCode_1 content_1) (registerCode_2 content_2) ...) registerCode_1) content_1] ;; Caso base pc 0 lista de palavras retornando word_1
  [(regread ((registerCode_10 content_1) (registerCode_2 content_2) ...) registerCode_1) (regread ((registerCode_2 content_2) ...) registerCode_1)]
)

(define-metafunction ebpf
  regwrite : registers destinationReg natural -> registers
  [(regwrite () registerCode_1 content_1) ()]
  [(regwrite ((registerCode_1 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) ((registerCode_1 content_1) (registerCode_2 content_2) ...)] ;; Caso base pc 0 lista de palavras retornando word_1
  ;;[(regwrite ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) (regwriteaux ((registerCode_2 content_2) ...) registerCode_1 content_1((registerCode_10 content_10)))]
  ;;[(regwrite ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) registers_10 (where registers_10 (insert (regwrite ((registerCode_2 content_2) ...) registerCode_1 content_1) (registerCode_10 content_10) ))]
  [(regwrite ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) (insert (regwrite ((registerCode_2 content_2) ...) registerCode_1 content_1) (registerCode_10 content_10) )]
  )
(define-metafunction ebpf
  regwriteaux : registers destinationReg natural registers -> registers
  [(regwriteaux () registerCode_1 content_1 registers_1) registers_1]
  [(regwriteaux ((registerCode_1 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1 (register_10 ...)) (register_10 ... (registerCode_1 content_1) (registerCode_2 content_2) ...)] ;; Caso base pc 0 lista de palavras retornando word_1
  [(regwriteaux ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1 (register_10 ...)) (regwriteaux ((registerCode_2 content_2) ...) registerCode_1 content_1(register_10 ...(registerCode_10 content_10) ))]
)
(define-metafunction ebpf
  insert : registers register -> registers
  [(insert () register_1) (register_1)]
  [(insert ( register_2 register_3 ...) register_1) (register_1 register_2 register_3 ...)] 
)


(define ->exe
  (reduction-relation
   ebpf
   #:domain program
   #:codomain program
   ;;Regra BPF_add com bpf-k
   (--> ( registers_0
            instr_1
         pc_1
        )
        (registers_1
         instr_1
         ,(+(term pc_1)(term 1))
        )
        (where (immediate_1 offset sourceReg destinationReg (bpf-add bpf-k 0)) (at pc_1 instr_1) )
        (where natural_1 (regread registers_0 destinationReg))
        (where registers_1 (regwrite registers_0 destinationReg ,(+ (term immediate_1) (term natural_1) )))
        );;Fechamento da regra BPF_add com bpf-k

   ;;Regra BPF_add com bpf-x


   ;;Fechamento da regra BPF_add com bpf-x
   ;;Regra BPF_sub com bpf-k

   ;;Fechamento da regra BPF_sub com bpf-k
   ;;Regra BPF_sub com bpf-x

   ;;Fechamento da regra BPF_sub com bpf-x|#
   )
)

;;list-ref(list 1 2 3 4 5) 2)

(define Prog1(
  term(
       ((r0 0) (r1 10) (r2 11) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) );;Registradores R0 (R1-R5) (R6-R9) R10
       ((15 0 r1 r2 (bpf-add bpf-k 0))
        (4 1 r1 r2 (bpf-add bpf-k 0))
        );;Lista de Palavras
       0);; Pc
      )
  )

(define Prog2(
  term(
        
        (15 0 r1 r2 (bpf-add bpf-k 0))
        (4 1 r1 r2 (bpf-add bpf-k 0))
        (14 1 r5 r6 (bpf-add bpf-k 0))
        (24 1 r6 r8 (bpf-add bpf-k 0))
        );;Lista de Palavras
      );; Pc
 )

(traces ->exe Prog1)



