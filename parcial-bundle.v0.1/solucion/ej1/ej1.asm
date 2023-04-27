global templosClasicos
global cuantosTemplosClasicos

section .data

%define OFFSET_COLUM_LARGO 0
%define OFFSET_NOMBRE 8
%define OFFSET_COLUM_CORTO 16
%define SIZE_STRUCT 24
%define NULL 0
extern malloc

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;templo* templosClasicos(templo *temploArr, size_t temploArr_len)
                                    ;rdi            rsi
templosClasicos:

;prologo--------------------------------------------------------
push rbp
mov rbp, rsp

;registros no volatiles
push r13
push r14
push r15
sub rsp, 8

;desarrollo---------------------------------------------------

mov r13, rdi ; me guardo los datos en otros registros
mov r14, rsi


    .ciclo:
        mov r13, [rdi + OFFSET_COLUM_LARGO];  en 0
        mov r14, [rsi + OFFSET_COLUM_CORTO];  ¨¨¨¨

        ;filtro para templos clasicos: colum largo = 2*clomun corto + 1
        mov r15, [2*r14 + 1]

        cmp rax, [SIZE_STRUCT]
        je .fin
        cmp r13, r15
        je .esTemploclasico
        jmp .sigue

        .esTemploclasico: ;agrego el nombre al nuevo array de templos clasicos
        movzx eax, byte [OFFSET_NOMBRE] ;muevo al nuevo array de templos clasicos el nombre del templo sin pisar el resto del registro 
        mov rax, [rax + OFFSET_NOMBRE]
        jmp .ciclo
        
        .sigue: ;continua sin agregar el nombre ya que no era clasico
        mov rax, [rax + OFFSET_NOMBRE]
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]
        add rdi, SIZE_STRUCT 
        jmp .ciclo
            
        loop .ciclo

.fin:
call malloc
mov r8, [rax + OFFSET_NOMBRE]
mov [rax + OFFSET_COLUM_LARGO], r13
mov [rax + OFFSET_COLUM_CORTO], r14
    
pop r8


;uint32_t cuantosTemplosClasicos(templo *temploArr, size_t temploArr_len)
                                            ;rdi            rsi
cuantosTemplosClasicos:

;prologo-----------------------------------------------------------------

push rbp
mov rbp, rsp

;registros volatiles
push r13
push r14
push r15
sub rsp, 8

;desarrollo-----------------------------------------------------------------

mov r13, rdi
mov r14, rsi
mov r10, NULL

    .ciclo1:
        mov rax, [OFFSET_NOMBRE]
        mov r13,  [rdi + OFFSET_COLUM_LARGO]
        mov r14,  [rsi + OFFSET_COLUM_CORTO] 

        ;filtro para templos clasicos: colum largo = 2*clomun corto + 1
        mov r15, [2*r14 + 1]

        cmp rax, [SIZE_STRUCT]
        je .fin1
        cmp r13, r15
        je .esTemploclasico1
        jmp .noesteploclasico

        .esTemploclasico1: ;va sumando 1 al registro r10 que esta en 0 segun sea clasico el templo y pasa al siguiente nombre
        add r10, 1
        mov rax, [rax + OFFSET_NOMBRE]
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]
        jmp .ciclo1

        .noesteploclasico: ;no suma nada al registro r10 y pasa al siguiente nombre 
        add r10, 0 
        mov rax, [rax + OFFSET_NOMBRE]
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]
        jmp .ciclo1

        loop .ciclo1

.fin1:
call malloc
mov r8, [rax + OFFSET_NOMBRE]
mov [rax + OFFSET_COLUM_LARGO], r13
mov [rax + OFFSET_COLUM_CORTO], r14

pop r10


;epilogo---------------------------------------------------------------------------------------

add rsp, 8
pop r13
pop r14
pop r15    ;restauro los registros no volatiles
pop rbp
ret