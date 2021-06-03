.text
    .global _start

_start:

#Cód para empilhar o numero 100
    pushq    $100

#Cód para empilhar o numero 5
    pushq    $5

#Código para operacao de +
    popq    %rax
    popq    %rbx
    addq    %rax, %rbx
    pushq    %rbx

#Cód para empilhar o numero 2
    pushq    $2

#Código para operacao de -
    popq    %rax
    popq    %rbx
    subq    %rax, %rbx
    pushq    %rbx

# Codigo de retorno
    popq    %rbx
    movq    $1, %rax
    int     $0x80

