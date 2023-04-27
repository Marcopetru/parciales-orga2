global miraQueCoincidencia

section .data
%define MULT_R 0.299
%define MULT_G 0.587
%define MULT_B 0.114

mask: db 0.299, 0.587, 0.114, 0.000

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;void miraQueCoincidencia_c( uint8_t *A, uint8_t *B, uint32_t N, uint8_t *laCoincidencia ){}
                                ;rdi       rsi        rdx                rcx
miraQueCoincidencia:

;prologo-------------------------------------------------
push rbp
mov rbp, rsp
push rbx
push r13
;desarrollo----------------------------------------------

;guardo N
mov rbx, rdx
;guardo la coincidencia
mov r13, rcx 

;calculo el tamaño total de la imagen = N*N
imul rdx, rbx 

;ciclo sobre la coincidencia basado en el tamaño total de la imagen
mov rcx, rbx

;guardo A y B
movdqu xmm0, [rdi]
movdqu xmm1, [rsi] 
movdqu xmm2, xmm0 ; guardo el xmm0 asi no lo pierdo cuando haga el compare
movdqu xmm3, [mask] ; guardo la mascara para utilizarla luego como filtro en el compare
pcmpeqd xmm0, [xmm1] ; comparo y guardo en que valores coinciden ambas imagenes

;Deberia utilizar la mascara para filtrar los pixeles y compararlos
;luego guardar esos pixeles que coinciden en otro registro para operar con el resto de pixeles y convertirlos a grises




;incremento los punteros para acceder los otros datos
add rdi, 16
add rsi, 16
add r13, 4
loop .ciclo


;epilogo------------------------------------------------    
pop r13
pop rbx
pop rbp
ret