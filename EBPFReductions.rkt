#lang racket

(require redex
         "EBPF.rkt"
         "Functions.rkt")

(provide (all-defined-out))


(define ->exe
  (reduction-relation
   ebpf
   #:domain program
   #:codomain program
   
   ;;Regra BPF_add com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-add bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(+ (term immediate_1) (term number_1) )))
        )
   ;;Fechamento da regra BPF_add com bpf-k
   
   ;;Regra BPF_sub com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-sub bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(- (term number_1) (term immediate_1) )))
        )
   ;;Fechamento da regra BPF_sub com bpf-k
   
   ;;Regra BPF_mul com bpf-k
  (--> ( registers_0 instr_1 pc_1 )
       (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mul bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(* (term immediate_1) (term number_1) )))
        )
   ;;Fechamento da regra BPF_mul com bpf-k
  
   ;;Regra BPF_div com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-div bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(/ (term number_1) (term immediate_1))))
        )
   ;;Fechamento da regra BPF_div com bpf-k
   
   ;;Regra BPF_add com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-add bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(+ (term number_1) (term number_2) )))
        )
   ;;Fechamento da regra BPF_add com bpf-x
   
   ;;Regra BPF_sub com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-sub bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(- (term number_1) (term number_2) )))
        )
   ;;Fechamento da regra BPF_sub com bpf-x
   
   ;;Regra BPF_mul com bpf-x
  (--> ( registers_0 instr_1 pc_1 )
       (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mul bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(* (term number_1) (term number_2) )))
        )
   ;;Fechamento da regra BPF_mul com bpf-x
  
   ;;Regra BPF_div com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-div bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(/ (term number_1) (term number_2))))
        )
   ;;Fechamento da regra BPF_div com bpf-x

   ;;Regra BPF_or com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-and bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (and number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_or com bpf-k
   
   ;;Regra BPF_and com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-or bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (or number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_and com bpf-k
   
   ;;Regra BPF_lsh com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-lsh bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (lsh number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_lsh com bpf-k
   
   ;;Regra BPF_rsh com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-rsh bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (rsh number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_rsh com bpf-k
   
   ;;Regra BPF_neg com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-neg bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (neg immediate_1)))
        )
   ;;Fechamento da regra BPF_neg com bpf-k
   
   ;;Regra BPF_mod com bpf-k
   
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mod bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(modulo (term number_1)(term immediate_1))))
        )
   ;;Fechamento da regra BPF_mod com bpf-k
   
   ;;Regra BPF_xor com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-xor bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (xor number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_xor com bpf-k
   
   ;;Regra BPF_mov com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mov bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg immediate_1))
        )
   ;;Fechamento da regra BPF_mov com bpf-k
   
   ;;Regra BPF_arsh com bpf-k
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-arsh bpf-k 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where registers_1 (regwrite registers_0 destinationReg (rsh number_1 immediate_1)))
        )
   ;;Fechamento da regra BPF_arsh com bpf-k
   
   ;;Regra BPF_end com bpf-k
   ;;Fechamento da regra BPF_end com bpf-k

   ;;Regra BPF_or com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-or bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (or number_1 number_2)))
        )
   ;;Fechamento da regra BPF_or com bpf-x
   
   ;;Regra BPF_and com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-and bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (and number_1 number_2)))
        )
   ;;Fechamento da regra BPF_and com bpf-x
   
   ;;Regra BPF_lsh com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-lsh bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (lsh number_1 number_2)))
        )
   ;;Fechamento da regra BPF_lsh com bpf-x
   
   ;;Regra BPF_rsh com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-rsh bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (rsh number_1 number_2)))
        )
   ;;Fechamento da regra BPF_rsh com bpf-x
   
   ;;Regra BPF_neg com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-neg bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (neg number_2)))
        )
   ;;Fechamento da regra BPF_neg com bpf-x
   
   ;;Regra BPF_mod com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mod bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg ,(modulo (term number_1) (term number_2))))
        )
   ;;Fechamento da regra BPF_mod com bpf-x
   
   ;;Regra BPF_xor com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-xor bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (xor number_1 number_2)))
        )
   ;;Fechamento da regra BPF_xor com bpf-x
   
   ;;Regra BPF_mov com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-mov bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg number_2))
        )
   ;;Fechamento da regra BPF_mov com bpf-x
   
   ;;Regra BPF_arsh com bpf-x
   (--> ( registers_0 instr_1 pc_1 )
        (registers_1 instr_1 ,(+(term pc_1)(term 1)) )
         (where (immediate_1 offset sourceReg destinationReg (bpf-arsh bpf-x 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where registers_1 (regwrite registers_0 destinationReg (rsh number_1 number_2)))
        )
   ;;Fechamento da regra BPF_arsh com bpf-x
   
   ;;Regra BPF_end com bpf-x
   ;;Fechamento da regra BPF_end com bpf-x
   
   ;;Regra BPF_ja
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term offset_1)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-ja bpf-jmp 0)) (at pc_1 instr_1) )
    )
   ;;Fechamento da regra BPF_ja

   ;;Regra BPF_jeq
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jeq bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 equal))
    )
   ;;Fechamento da regra BPF_jeq

   ;;Regra BPF_jgt
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jgt bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 greater))
    )
   ;;Fechamento da regra BPF_jgt
   
   ;;Regra BPF_jge
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jge bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 greater-eq))
    )   
   ;;Fechamento da regra BPF_jge
   
   ;;Regra BPF_jset
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jset bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 bool-and))
    )
   ;;Fechamento da regra BPF_jset
     
   ;;Regra BPF_jne
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jne bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 diff))
    )
   ;;Fechamento da regra BPF_jne
   
   ;;Regra BPF_jsgt
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jsgt bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 greater))
    )
   ;;Fechamento da regra BPF_jsgt
   
   ;;Regra BPF_jsge
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jsge bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 greater-eq))
    )
   ;;Fechamento da regra BPF_jsge
   
   ;;Regra BPF_jlt
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jlt bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 less))
    )
   ;;Fechamento da regra BPF_jlt
   
   ;;Regra BPF_jle
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jle bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 less-eq))
    )
   ;;Fechamento da regra BPF_jle
   
   ;;Regra BPF_jslt
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jslt bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 less))
    )
   ;;Fechamento da regra BPF_jslt
   
   ;;Regra BPF_jsle
   (--> ( registers_0 instr_1 pc_1 )
        (registers_0 instr_1 ,(+(term pc_1)(term number_3)) )
         (where (immediate_1 offset_1 sourceReg destinationReg (bpf-jsle bpf-jmp 0)) (at pc_1 instr_1) )
         (where number_1 (regread registers_0 destinationReg))
         (where number_2 (regread registers_0 sourceReg))
         (where number_3 (compare number_1 number_2 offset_1 less-eq))
    )
   ;;Fechamento da regra BPF_jsle
   
   ;;Regra BPF_call
   ;;Fechamento da regra BPF_call
   
   ;;Regra BPF_exit
   ;;Fechamento da regra BPF_exit
   

   )
)


(define Prog1(
  term(
       ((r0 0) (r1 -2) (r2 11) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) );;Registradores R0 (R1-R5) (R6-R9) R10
       ((15 0 r1 r2 (bpf-add bpf-k 0))
        (4 1 r1 r2 (bpf-sub bpf-k 0))
        (2 1 r1 r2 (bpf-mul bpf-k 0))
        (2 1 r1 r2 (bpf-div bpf-k 0))
        (0 0 r1 r2 (bpf-add bpf-x 0))
        (0 1 r1 r2 (bpf-sub bpf-x 0))
        (0 1 r1 r2 (bpf-mul bpf-x 0))
        (0 1 r1 r2 (bpf-div bpf-x 0))
        );;Lista de Palavras
       0);; Pc
      )
  )
(define Prog3(
  term(
       ((r0 0) (r1 2) (r2 12) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) );;Registradores R0 (R1-R5) (R6-R9) R10
       ((1 0 r1 r2 (bpf-or bpf-k 0))
        (1 1 r1 r2 (bpf-and bpf-k 0))
        (1 1 r1 r2 (bpf-lsh bpf-k 0))
        (1 1 r1 r2 (bpf-rsh bpf-k 0))
        (0 0 r1 r2 (bpf-or bpf-x 0))
        (0 1 r1 r2 (bpf-and bpf-x 0))
        (0 1 r1 r2 (bpf-lsh bpf-x 0))
        (0 1 r1 r2 (bpf-rsh bpf-x 0))
        );;Lista de Palavras
       0);; Pc
      )
  )
(define Prog4(
  term(
       ((r0 0) (r1 2) (r2 12) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) );;Registradores R0 (R1-R5) (R6-R9) R10
       ((1 0 r1 r2 (bpf-mod bpf-k 0))
        (1 1 r1 r2 (bpf-xor bpf-k 0))
        (1 1 r1 r2 (bpf-mov bpf-k 0))
        (1 1 r1 r2 (bpf-arsh bpf-k 0))
        (0 0 r1 r2 (bpf-mod bpf-x 0))
        (0 1 r1 r2 (bpf-xor bpf-x 0))
        (0 1 r1 r2 (bpf-mov bpf-x 0))
        (0 1 r1 r2 (bpf-arsh bpf-x 0))
        (0 1 r1 r2 (bpf-neg bpf-k 0))
        (0 1 r1 r2 (bpf-neg bpf-x 0))
        );;Lista de Palavras
       0);; Pc
      )
  )

(define Prog5(
  term(
       ((r0 0) (r1 11) (r2 11) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) );;Registradores R0 (R1-R5) (R6-R9) R10
       ((15 1 r1 r2 (bpf-ja bpf-jmp 0))
        (4 1 r1 r2 (bpf-jeq bpf-jmp 0))
        (2 1 r1 r2 (bpf-jgt bpf-jmp 0))
        (2 1 r1 r2 (bpf-jge bpf-jmp 0))
        (0 1 r1 r2 (bpf-jset bpf-jmp 0))
        (0 1 r1 r2 (bpf-jne bpf-jmp 0))
        (0 1 r1 r2 (bpf-jsgt bpf-jmp 0))
        (0 1 r1 r2 (bpf-jsge bpf-jmp 0))
        (0 1 r1 r2 (bpf-jlt bpf-jmp 0))
        (0 1 r1 r2 (bpf-jle bpf-jmp 0))
        (0 1 r1 r2 (bpf-jslt bpf-jmp 0))
        (0 1 r1 r2 (bpf-jsle bpf-jmp 0))
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
