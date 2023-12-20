#lang racket
 
(require redex parser-tools/yacc  "lexer.rkt")
 
(define myparser
  (parser
 
   (start input)
   (end EOF)
   (tokens value-tokens op-tokens )
   (src-pos)
   (error (lambda (a b c d e) (begin (printf "a = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e) (void))))   
   
   (grammar

    (input [() '()]           
           [(input line) (append $1  $2)])

    (line [(NEWLINE) '()]
          [(TRASH) '() ]
          [(ASM) '() ]
          ;[(exp NEWLINE) (list $1)]
          [(exp) (list $1)]
          [(EXIT) '()]
          [(HEX) '()]
          [(RESULT) '()]
          ;;[(exp NEWLINE exp) (list $1)]
          )
 
    (exp  [(NUMBER) $1]
          ;[(RESULT) (list  (string->symbol "===\n"))]
          ;[(HEX) (list  $1)]
          ;;[(NEWLINE) (fprintf(current-output-port) "\n" )]
          ;;[(ADD REG NUMBER SEP REG NUMBER) (format "0 0 r~a r~s(bpf-add bpf-k bpf-alu)\n" $3 $6)]
          ;[(ADD REG NUMBER SEP REG NUMBER) (begin (printf "0 0 r~a r~s (bpf-add bpf-k bpf-alu)\n" $3 $6) (void))]
          [(ADD REG NUMBER SEP REG NUMBER) (list 0 0 (string->symbol (format "r~a" $3)) (string->symbol (format "r~s" $6)) '(bpf-add bpf-k bpf-alu))]
          [(MOV REG NUMBER SEP REG NUMBER) (list 0 0 (string->symbol (format "r~a" $3)) (string->symbol (format "r~s" $6)) '(bpf-mov bpf-k bpf-alu))]
          [(ADD REG NUMBER SEP NUMBER) (list $5 0 (string->symbol (format "r~a" $3)) 'r5 '(bpf-add bpf-k bpf-alu))]
          [(MOV REG NUMBER SEP NUMBER) (list $5 0 (string->symbol (format "r~a" $3)) 'r5 '(bpf-mov bpf-k bpf-alu))]
          ;;[(EXIT) (list 0 0 'r5 'r5 'eof)]
          ;;[(ADD REG NUMBER SEP REG NUMBER) (fprintf (current-output-port) "0 0 r~a r~s (bpf-add bpf-k bpf-alu)\n" $3 $6)]
          ))))
             
(define (parse ip)
  (port-count-lines! ip)  
  (myparser (lambda () (next-token ip))))   
 
(provide parse )

;;(parse (open-input-string "add32 %r1, %r2"))
;;(parse (open-input-string "add32 %r1, %r2 \n add32 %r1, %r2 \n"))
;;(parse (open-input-string "-- asm add32 %r1, %r2 \n add32 %r1, %r2 \n"))
;;(parse (open-input-string "-- asm add32 %r1, %r2 \n add32 %r1, %r2 \n -- result \n"))
;;(parse (open-input-string "-- asm add32 %r1, %r2 \n add32 %r1, %r2 \n exit \n -- result \n 0x3 \n"))
;;(parse (open-input-string "-- asm add32 %r1, %r2 \n add32 %r1, %r2 \n exit \n -- result \n 0x2a \n"))
#|
(parse (open-input-string
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