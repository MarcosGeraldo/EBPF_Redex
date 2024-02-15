
#lang racket
 
(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))
 
 
(define-tokens value-tokens (NUMBER HEX) )
(define-empty-tokens op-tokens (ASM RESULT EXIT EOF MOV MOV32 SEP REG ADD ADD32 NEG NEWLINE HEXX TRASH NUMBERHEX))
(define-lex-abbrev hex-number (:: "0x" (:+ (:or numeric (char-range #\a #\f)))))
 
(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ (:& (:~ #\newline) whitespace)) (return-without-pos (next-token input-port))]
   ["# Copyright (c) Big Switch Networks, Inc\n" (token-TRASH)]
   ["# SPDX-License-Identifier: Apache-2.0\n" (token-TRASH)]
   ["," (token-SEP)]
   ["%r" (token-REG)]
   ["exit" (token-EXIT)]
   ["-- result" (token-RESULT)]
   ["-- asm" (token-ASM)]
   ["mov" (token-MOV)]
   ["mov32" (token-MOV32)]
   ["add" (token-ADD)]
   ["add32" (token-ADD32)]
   [hex-number (token-HEX (string->number (string-append "#x" (substring lexeme 2))))]
   [#\newline (token-NEWLINE)]
   [(:: (:* #\-) (:+ numeric) (:* (:: #\. (:+ numeric) ))) (token-NUMBER (string->number lexeme))]))
 
 
(provide value-tokens op-tokens next-token)