#lang racket

(require redex
         "EBPF.rkt")

(provide (all-defined-out))


(define-metafunction ebpf
  at : pc instr -> word
  [(at 0 () ) (0 0  rP rP eof)]
  [(at 0 (word_1 word_2 ...) ) word_1] ;; Caso base pc 0 lista de palavras retornando word_1
  [(at number (word_1 word_2 ...)) (at ,(- (term number) 1 ) (word_2 ...))]
)

(define-metafunction ebpf
  regread : registers destinationReg -> number
  [(regread () registerCode_1) -1]
  [(regread ((registerCode_1 content_1) (registerCode_2 content_2) ...) registerCode_1) content_1] ;; Caso base pc 0 lista de palavras retornando word_1
  [(regread ((registerCode_10 content_1) (registerCode_2 content_2) ...) registerCode_1) (regread ((registerCode_2 content_2) ...) registerCode_1)]
)

(define-metafunction ebpf
  regwrite : registers destinationReg number -> registers
  [(regwrite () registerCode_1 content_1) ()]
  [(regwrite ((registerCode_1 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) ((registerCode_1 content_1) (registerCode_2 content_2) ...)] ;; Caso base pc 0 lista de palavras retornando word_1
  [(regwrite ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) (insert (regwrite ((registerCode_2 content_2) ...) registerCode_1 content_1) (registerCode_10 content_10) )]
  )
(define-metafunction ebpf
  regwriteaux : registers destinationReg number registers -> registers
  [(regwriteaux () registerCode_1 content_1 registers_1) registers_1]
  [(regwriteaux ((registerCode_1 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1 (register_10 ...)) (register_10 ... (registerCode_1 content_1) (registerCode_2 content_2) ...)] ;; Caso base pc 0 lista de palavras retornando word_1
  [(regwriteaux ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1 (register_10 ...)) (regwriteaux ((registerCode_2 content_2) ...) registerCode_1 content_1(register_10 ...(registerCode_10 content_10) ))]
)
(define-metafunction ebpf
  insert : registers register -> registers
  [(insert () register_1) (register_1)]
  [(insert ( register_2 register_3 ...) register_1) (register_1 register_2 register_3 ...)] 
)
(define-metafunction ebpf
  and : number number -> number
  [(and 0 number_11 ) 0 ]
  [(and number_10 0 ) 0 ]
  [(and number_1 number_2 ) number_1 ]
)
(define-metafunction ebpf
  or : number number -> number
  [(or 0 0 ) 0 ]
  [(or 0 number_2 ) number_2 ]
  [(or number_1 0 ) number_1 ]
  [(or number_1 number_2 ) number_1 ]
)
(define-metafunction ebpf
  xor : number number -> number
  [(xor 0 0 ) 0 ]
  [(xor 0 number_2 ) number_2 ]
  [(xor number_1 0 ) number_1 ]
  [(xor number_1 number_2 ) 0 ]
)
(define-metafunction ebpf
  lsh : number number -> number
  [(lsh number_1 0 ) number_1 ]
  [(lsh number_1 number_2 ) (lsh ,(/(term number_1) 2 ) ,(-(term number_2) 1 )) ]
)
(define-metafunction ebpf
  rsh : number number -> number
  [(rsh number_1 0 ) number_1 ]
  [(rsh number_1 number_2 ) (rsh ,(*(term number_1) 2 ) ,(-(term number_2) 1 )) ]
)
(define-metafunction ebpf
  neg : number -> number
  [(neg 0  ) 1 ]
  [(neg number_1  ) 0 ]
)

(define-metafunction ebpf
  compare : number number number symbol -> number
  [(compare number_1 number_1 number_3 equal       ) number_3]
  [(compare number_1 number_1 number_3 less-eq     ) number_3]
  [(compare number_1 number_1 number_3 greater-eq  ) number_3]
  [(compare number_1 number_2 number_3 diff        ) number_3]
  [(compare    0         0    number_3 bool-and    )    1    ]
  [(compare    0     number_1 number_3 bool-and    )    1    ]
  [(compare number_1     0    number_3 bool-and    )    1    ]
  [(compare number_1 number_2 number_3 bool-and    ) number_3]
  
  [(compare number_1 number_2 number_3 symbol) 1]
)

(define-metafunction ebpf
  compare-less : number number number -> number
  [(compare-less number_1     0     number_3 ) 1]
  [(compare-less    0      number_1 number_3 ) number_3]
  [(compare-less number_1  number_2 number_3 ) (compare-less ,(-(term number_1)(term 1)) ,(-(term number_2)(term 1)) number_3)]
)
(define-metafunction ebpf
  compare-greater : number number number -> number
  [(compare-greater number_1     0     number_3 ) number_3]
  [(compare-greater    0      number_1 number_3 ) 1]
  [(compare-greater number_1  number_2 number_3 ) (compare-greater ,(-(term number_1)(term 1)) ,(-(term number_2)(term 1)) number_3)]
)