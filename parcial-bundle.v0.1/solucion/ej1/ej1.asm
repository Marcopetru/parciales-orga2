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

;(comentario post parcial) aca es donde hubiese tenido que pedir memoria basandome en la funcion cuantosTemplosClasicos(call), mover el rax a rdi para llamar a malloc
;y multiplicar el puntero de templos clasicos *24 porque cada struct es de 24 bytes

    .ciclo:
        mov r13, [rdi + OFFSET_COLUM_LARGO];  en 0
        mov r14, [rsi + OFFSET_COLUM_CORTO];  ¨¨¨¨        ;(comentario post parcial)tendria que ser r13 en vez de rdi y rsi y guardar en otro registro que no sea r13

        ;filtro para templos clasicos: colum largo = 2*clomun corto + 1
        mov r15, [2*r14 + 1]

        cmp rax, [SIZE_STRUCT]  ;(comentario post parcial)no se bien que intente hacer aca 
        je .fin                 ;(""""""""""""""""""""""")""""""""""""""""""""""""""""""""
        cmp r13, r15
        je .esTemploclasico
        jmp .sigue

        .esTemploclasico: ;agrego el nombre al nuevo array de templos clasicos
        movzx eax, byte [OFFSET_NOMBRE] ;muevo al nuevo array de templos clasicos el nombre del templo sin pisar el resto del registro 
        mov rax, [rax + OFFSET_NOMBRE]  ;(comentario post parcial) hubiese tenido que ser: mov rdx, [r13 + OFFSET_NOMBRE]
                                        ;                                                   mov r8(o cualquier registro), [r13 + OFFSET_COLUM_LARGO]
                                        ;                                                   mov r9"", [r13 + OFFSET_COLUM_CORTO]
                                        ;                                                   mov [rax + OFFSET_COLUMN_LARGO], r13
                                        ;                                                   mov [rax + OFFSET_NOMBRE], r8
                                        ;                                                   mov [rax + OFFSET_COLUMN_CORTO], r9
                                        ;                                                   add rax, SIZE_STRUCT
        jmp .ciclo
        
        .sigue: ;continua sin agregar el nombre ya que no era clasico
        mov rax, [rax + OFFSET_NOMBRE]
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]    ;(comentario post parcial) aca solo hacer el add y loopear el ciclo(osea las ultimas dos lineas de .sigue)
        add rdi, SIZE_STRUCT 
        jmp .ciclo
            
        loop .ciclo

.fin:
call malloc
mov r8, [rax + OFFSET_NOMBRE]                ;(comentario post parcial) basicamente no sabia como pedir memoria entonces pense en esto que esta mal claramente
mov [rax + OFFSET_COLUM_LARGO], r13
mov [rax + OFFSET_COLUM_CORTO], r14
    
pop r8                                       ;(comentario post parcial) esto esta mal aca deberia mover el rax que debi guardar antes de ciclar


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
        mov r13,  [rdi + OFFSET_COLUM_LARGO]  ;(comentario post parcial) lo mismo que comente en la funcion anterior
        mov r14,  [rsi + OFFSET_COLUM_CORTO] 

        ;filtro para templos clasicos: colum largo = 2*clomun corto + 1
        mov r15, [2*r14 + 1]

        cmp rax, [SIZE_STRUCT]     ;(comentario post parcial) lo mismo que comente antes
        je .fin1
        cmp r13, r15
        je .esTemploclasico1
        jmp .noesteploclasico

        .esTemploclasico1: ;va sumando 1 al registro r10 que esta en 0 segun sea clasico el templo y pasa al siguiente nombre
        add r10, 1
        mov rax, [rax + OFFSET_NOMBRE]       ;(comentario post parcial) aca solo necesitaba incrmentar r10
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]
        jmp .ciclo1

        .noesteploclasico: ;no suma nada al registro r10 y pasa al siguiente nombre 
        add r10, 0 
        mov rax, [rax + OFFSET_NOMBRE]           ;(comentario post parcial) aca solo tenia que hacer ; add r13, SIZE_STRUCT y loopear el ciclo
        mov r13, [r13 + OFFSET_COLUM_LARGO]
        mov r14, [r14 + OFFSET_COLUM_CORTO]       
        jmp .ciclo1

        loop .ciclo1

.fin1:
call malloc
mov r8, [rax + OFFSET_NOMBRE]               ;(comentario post parcial) lo mismo que comente antes, deberia haber llamado a malloc anteriormente para pedir memoria para estanfuncion
mov [rax + OFFSET_COLUM_LARGO], r13
mov [rax + OFFSET_COLUM_CORTO], r14

pop r10                                      ;(comentario post parcial) aca mov rax, r10


;epilogo---------------------------------------------------------------------------------------

add rsp, 8                                      ;(comentario post parcial) toda esta parte del epilogo deberia ir antes de cuantosTemplosClasicos
pop r13
pop r14
pop r15    ;restauro los registros no volatiles ;(comentario post parcial) hasta aca 
pop rbp
ret
