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

    (input [() '()]           
           [(input line) (append $1  $2)])

    (line [(NEWLINE) '()]
          [(exp NEWLINE) (list $1)]
          [(exp NEWLINE exp) (list $1)])
 
    (exp  [(NUMBER) $1]
          ;;[(ADD REG NUMBER SEP REG NUMBER) ("0 0 r"$3 "r"$6"(bpf-add bpf-k bpf-alu)")]
          ;;[(ADD REG NUMBER SEP REG NUMBER) (+ $3 $6)]
          [(ADD REG NUMBER SEP REG NUMBER) (fprintf
                                           (current-output-port)
                                           "0 0 r~a r~s (bpf-add bpf-k bpf-alu)"
                                           $3 $6)]
          [(NEWLINE) (fprintf(current-output-port)"\n")]
          ))))
             
(define (parse ip)
  (port-count-lines! ip)  
  (myparser (lambda () (next-token ip))))   
 
(provide parse )

;;(parse (open-input-string "add %r1, %r2"))
;;(parse (open-input-string "add %r1, %r2 \n add %r1, %r2"))