#lang racket


(require redex
         "Lexer/parserR.rkt"
         "EBPFReductions.rkt"
         "Lexer/parser.rkt"
         "EBPF.rkt")

(define regs(term(((r0 0) (r1 0) (r2 0) (r3 0) (r4 0) (r5 0) (r6 0) (r7 0) (r8 0) (r9 0) (rP 0)))))

(define (parseCode code);Recebe os testes de conformidade e Retorna apenas o codigo
  (parse code)
  )
(define (parseResult code);Recebe os testes de conformidade e Retorna apenas o resultado
  (list-ref (parseR code) 0)
  )
(define (getResult code);Recebe a ultima execução das reduçoes e Retorna o resultado da execução das reduçoes
  (string->number(string-replace(string-replace(string-replace(list-ref (string-split (~v code) "(" #:repeat? #t) 1) ")" "")"r0" "")" " ""))
  )

(define (exe program);Recebe os testes de conformidade e Retorna a ultima redução obtida
  (apply-reduction-relation* ->exe (append regs (list (parseCode program)) (list 0)))
  )

(define (compare program)
    (equal? (parseResult (open-input-string program)) (getResult (exe (open-input-string program)))) 
)

(define (fileCompare program)
    (equal? (parseResult (open-input-file program)) (getResult (exe (open-input-file program)))) 
)

(define fileInput(term(
              "conformance_tests/add.data"
              "conformance_tests/add64.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ;;"conformance_tests/.data"
              ))
  )

(define (execFiles input)
  (for ([i input])
  (display(fileCompare i)))
)

;;(execFiles fileInput)

;;"conformance_tests/add.data"

;;(fileCompare "conformance_tests/add.data")

#|
(exe (open-input-string
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
exit\n
-- result\n
0x3\n"))
|#
#|
(compare
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
add32 %r0, %r0\n
add32 %r0, -3\n
exit\n
-- result\n
0x3\n")
|#
#|
(compare
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
add32 %r0, %r0\n
add32 %r0, -3\n
exit\n
-- result\n
0x3\n")
|#
#|
(getResult(exe (open-input-string
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
exit\n
-- result\n
0x3\n")))
|#
#|
(parseResult (open-input-string
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
exit\n
-- result\n
0x3\n"))
|#
#|
(parseCode (open-input-string
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
exit\n
-- result\n
0x3\n"))
|#
#|
((0 0 r0 r0 (bpf-mov bpf-k bpf-alu))
    (2 0 r0 r1 (bpf-mov bpf-k bpf-alu))
    (1 0 r0 r0 (bpf-add bpf-k bpf-alu))
    (0 0 r1 r0 (bpf-add bpf-x bpf-alu)))
|#