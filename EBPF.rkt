#lang racket

(require redex)

(provide ebpf)


(define-language ebpf

  ;;Representação da palavra 
  (instr ::= (word ...))
  (word ::= (immediate offset sourceReg destinationReg opcode))
  (immediate ::= number)
  (offset ::= number)
  (sourceReg ::= registerCode)
  (destinationReg ::= registerCode)
  (opcode ::= (msb source lsb)
              eof)
  (msb ::=
       ;;Arithmetic Instructions
        ;;Math
         bpf-add bpf-sub bpf-mul bpf-div bpf-mod
        ;;Boolean
         bpf-or bpf-and bpf-neg 
        ;;Shift
         bpf-lsh bpf-rsh bpf-arsh bpf-xor
        ;;Commands
         bpf-mov bpf-end
       ;;Jump Instructions
        bpf-ja
        ;;Commands
         bpf-call bpf-exit
        ;;Conditioned Jump
           bpf-jeq
           bpf-jgt 
           bpf-jge
           bpf-jset
           bpf-jne
           bpf-jsgt
           bpf-jsge
           bpf-jlt
           bpf-jle
           bpf-jslt
           bpf-jsle)
  (source ::= bpf-k
              bpf-x)
  (lsb ::= bpf-ld bpf-ldx bpf-st bpf-stx bpf-alu bpf-jmp bpf-jmp32 bpf-alu64)

  ;;Representação dos registradores
  (registers ::= (register ...))
  (register ::= (registerCode content)) ;;Representador do Registrador Generico
  (content ::= number)
  (registerCode ::= r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 rP);;Lista dos possiveis registradores
  ;;Representação de um Programa EBPF
  (pc ::= number);;Contador de Programa
  (program ::= (registers instr pc )
           )
  (symbol ::= equal greater less greater-eq less-eq bool-and diff)
 )


;;list-ref(list 1 2 3 4 5) 2)



