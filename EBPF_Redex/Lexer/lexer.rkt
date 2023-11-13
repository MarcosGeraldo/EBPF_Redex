
#lang racket
 
(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))
 
 
(define-tokens value-tokens (NUMBER))
(define-empty-tokens op-tokens (ASM RESULT EXIT EOF MOV SEP REG ADD NEG NEWLINE))
 
(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ (:& (:~ #\newline) whitespace)) (return-without-pos (next-token input-port))]
   [#\newline (token-NEWLINE)]
 ;;["" (token-)]
   ["," (token-SEP)]
   ["%r" (token-REG)]
   ["mov" (token-MOV)]
   ["exit" (token-EXIT)]
   ["-- result" (token-RESULT)]
   ["-- asm" (token-ASM)]
   ["add" (token-ADD)]
   [#\- (token-NEG)]      
   [(:: (:+ numeric) (:* (:: #\. (:+ numeric) ))) (token-NUMBER (string->number lexeme))]))
 
 
(provide value-tokens op-tokens next-token)