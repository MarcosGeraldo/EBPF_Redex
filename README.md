# Link do Latex
https://www.overleaf.com/9423326817ytrghtnzgfwp
# Link dos Sites 
https://1drv.ms/w/s!AgTQzZr7VQRxgYU7ab9KSjBYWpFAfg?e=OzACcp
# Codigo da especificação do EBPF feito em REDEX
## Imports Necessarios

        #lang racket

        (require redex)

## Definição da Semântica 

        (define-language ebpf

  ###### Representação da lista de Comandos/Palavras
        (instr ::= (word ...))
  
  ###### Representação do Comando/Palavra
        (word ::= (immediate offset sourceReg destinationReg opcode))
  
  ###### Imediato, um valor que pode ser passado como parâmetro do comando
        (immediate ::= natural)
  
  ###### Ainda não utilizado
        (offset ::= natural)
  
  ###### Registrador de origem e destino, respectivamente, da operação
        (sourceReg ::= registerCode)
  
        (destinationReg ::= registerCode)
  
  ###### Codigo da operação separado em respectivamente, operação a ser feita, destino do resultado e valor ainda não utilizado
        (opcode ::= (msb source lsb)
              eof)
  
  
        (msb ::= bpf-add
           bpf-sub)
  
  
        (source ::= bpf-k
              bpf-x)
  
  
        (lsb ::= natural)
  
  
  ###### Representação da lista dos registradores
        (registers ::= (register ...))
  
  ###### Representação do registrador tendo como atributos um nome e um conteudo
        (register ::= (registerCode content)) ;;Representador do Registrador Generico
  
        (content ::= natural)
  
        (registerCode ::= r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 rP);;Lista dos possiveis registradores
  
  ###### Contador de Programa
        (pc ::= natural)
  
  ###### Programa EBPF composto por uma lista de registradores, uma lista de palavras e um contador de programa 
        (program ::= (registers instr pc )
           )
         )
## Inicio da implementação da sintaxe
###### Função que busca na lista de instruções a intrução de indice pc 
        (define-metafunction ebpf

        at : pc instr -> word
  
        [(at 0 () ) (0 0  rP rP eof)]
  
        [(at 0 (word_1 word_2 ...) ) word_1] ;; Caso base pc 0 lista de palavras retornando word_1
  
        [(at natural (word_1 word_2 ...)) (at ,(- (term natural) 1 ) (word_2 ...))]
        )

###### Função que busca na lista de registradores um registrador x e retorna o seu conteudo
        (define-metafunction ebpf

        regread : registers destinationReg -> natural
  
        [(regread () registerCode_1) -1]
  
        [(regread ((registerCode_1 content_1) (registerCode_2 content_2) ...) registerCode_1) content_1]
  
        [(regread ((registerCode_10 content_1) (registerCode_2 content_2) ...) registerCode_1) (regread ((registerCode_2 content_2) ...) registerCode_1)]
        )

###### Função que busca um registrador e atualiza o conteúdo dele pelo conteudo passado como parâmetro
        (define-metafunction ebpf

        regwrite : registers destinationReg natural -> registers
  
        [(regwrite () registerCode_1 content_1) ()]
  
        [(regwrite ((registerCode_1 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) ((registerCode_1 content_1) (registerCode_2 content_2) ...)]
  
        [(regwrite ((registerCode_10 content_10) (registerCode_2 content_2) ...) registerCode_1 content_1) 
        (insert (regwrite ((registerCode_2 content_2) ...) registerCode_1 content_1) (registerCode_10 content_10) )]
        )

###### Função que insere um registrador a frente de uma lista de registradores
        (define-metafunction ebpf
  
        insert : registers register -> registers
  
        [(insert () register_1) (register_1)]
  
        [(insert ( register_2 register_3 ...) register_1) (register_1 register_2 register_3 ...)] 
        )

## Relação de redução que executa o opcode BPF_add - bpf-k
        (define ->exe

        (reduction-relation
  
        ebpf
   
        #:domain program
   
        #:codomain program
   
        ;;Regra BPF_add com bpf-k
   
        (--> ( registers_0 instr_1 pc_1 )
        
        (registers_1 instr_1 ,(+(term pc_1)(term 1)))
        
  ###### Busca a instrução correspondente com o pc atual
        (where (immediate_1 offset sourceReg destinationReg (bpf-add bpf-k 0)) (at pc_1 instr_1) )
        
  ###### Lê do Registrador o seu valor
        (where natural_1 (regread registers_0 destinationReg))
        
  ###### Escreve no registrador o valor obtido com a operação 
        (where registers_1 (regwrite registers_0 destinationReg ,(+ (term immediate_1) (term natural_1) )))
        
        );;Fechamento da regra BPF_add com bpf-k
        )
        )

  ###### Programa para testes, com a seguinte estrutura ((Lista de Registradores) (Lista de palavras) (PC)) 
        (define Prog1(

          term(
  
        ;;Registradores R0 (R1-R5) (R6-R9) R10

        ((r0 0) (r1 10) (r2 11) (r3 12) (r4 13) (r5 14) (r6 15) (r7 16) (r8 17) (r9 18) (rP 19) )
       
       
        ((15 0 r1 r2 (bpf-add bpf-k 0))
        
        (4 1 r1 r2 (bpf-add bpf-k 0))
        
        );;Lista de Palavras
       
        0);; Pc
      
        )
  
        )

###### Para teste da função at 
        (define Prog2(
  
        term(
        
        (15 0 r1 r2 (bpf-add bpf-k 0))
  
        (4 1 r1 r2 (bpf-add bpf-k 0))
  
        (14 1 r5 r6 (bpf-add bpf-k 0))
  
        (24 1 r6 r8 (bpf-add bpf-k 0))
  
        )
  
        )
 
        )

(traces ->exe Prog1)

