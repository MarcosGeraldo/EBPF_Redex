#lang racket
 
(require parser-tools/yacc  "lexer.rkt")
 
(define myparser
  (parser
 
   (start exp)
   (end EOF)
   (tokens value-tokens op-tokens )
   (src-pos)
   (error (lambda (a b c d e) (begin (printf "a = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n" a b c d e) (void))))   
   
   (grammar

    ;;(program
    ;; [(ASM RESULT)]
     ;;)

    ;;(line [(NEWLINE) '()]
    ;;      [(exp NEWLINE) (list $1)])
 
    (exp  [(NUMBER) $1]
          ;;[(ADD REG NUMBER SEP REG NUMBER) ("0 0 r"$3 "r"$6"(bpf-add bpf-k bpf-alu)")]
          [(ADD REG NUMBER SEP REG NUMBER) (+ $3 $6)]
          ))))
             
(define (parse ip)
  (port-count-lines! ip)  
  (myparser (lambda () (next-token ip))))   
 
(provide parse )

;;(parse (open-input-string "add %r1, %r2"))