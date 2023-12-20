#lang racket


(require redex
         "EBPFReductions.rkt"
         "Lexer/parser.rkt")

(define regs(
             term(
                  ((r0 0) (r1 0) (r2 0) (r3 0) (r4 0) (r5 0) (r6 0) (r7 0) (r8 0) (r9 0) (rP 0)))))

(define (parserUtil code)
  (parse code)
  )

(define (tester program)
  ;(list ->exe (append regs (parserUtil program) (list 0)))
  ->exe (append regs (list (parserUtil program)) (list 0))
  )


#|
(tester (open-input-string
"# Copyright (c) Big Switch Networks, Inc\n
# SPDX-License-Identifier: Apache-2.0\n
-- asm\n
mov32 %r0, 0\n
mov32 %r1, 2\n
add32 %r0, 1\n
add32 %r0, %r1\n
exit\n
-- result\n
0x2a\n"))
|#