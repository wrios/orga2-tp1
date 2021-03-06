; FUNCIONES de C
	extern malloc
	extern free
	extern fopen
	extern fclose
	extern fprintf

section .data

%define off_data_type 0
%define off_remove 8
%define off_print 16

%define off_matrix_data_type 0
%define off_matrix_remove 8
%define off_matrix_print 16
%define off_matrix_col 24
%define off_matrix_fil 28
%define off_matrix_data 32

%define matrix_data_size 8

%define off_list_data_type 0
%define off_list_remove 8
%define off_list_print 16
%define off_list_first 24
%define off_nodo_data 0
%define off_nodo_next 8

%define off_string_data_type 0
%define off_string_remove 8
%define off_string_print 16
%define off_string_data 24

%define off_int_data_type 0
%define off_int_remove 8
%define off_int_print 16
%define off_int_data 24
%define list_size_nodo 16

%define malloc_int 32
%define malloc_str 32
%define malloc_list 32
%define malloc_matrix 40

fopen_w: db "w",0;a
fprintf_c: db "%c", 0 
fprintf_d: db "%d", 0 
fprintf_s: db "%s", 0
fprintf_null: db "NULL",0 
fprintf_coma: db ",",0
fprintf_coma_endl: db ",",0,10
fprintf_corcheteI: db "[", 0
fprintf_corcheteF: db "]", 0
fprintf_pipe: db "|", 0
fprintf_endl: db 10, 0
NULL: dq 0
section .text

global str_len
global str_copy
global str_cmp
global str_concat
global matrixPrint
global matrixNew
global matrixAdd
global matrixRemove
global matrixDelete
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global strNew
global strSet
global strAddRight
global strAddLeft
global strRemove
global strDelete
global strCmp
global strPrint
global intNew
global intSet
global intRemove
global intDelete
global intCmp
global intPrint



;########### Funciones Auxiliares Recomendadas

; uint32_t str_len(char* a);7
str_len:
	push rbp
	mov rbp, rsp
	push rdi
	sub rsp, 8
	
	;(rdi puntero a char)
	xor rax, rax ; rax en 0
	cmp rdi, NULL
	je finstr_len
cicloStr_Len:
	cmp byte [rdi], 0
	je finstr_len
	add eax, 1
	add rdi, 1
	jmp cicloStr_Len
finstr_len:
	add rsp, 8
	pop rdi
	pop rbp
	ret

; char* str_copy(char* a);19
str_copy:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push rdi
	push rcx
	push rsi
	push rbx

	xor rax, rax ; rax en 0
	cmp rdi, NULL
	je finstr_copy
	call str_len
	mov  ecx, eax ; rcx tamaño del string
	mov r12, rdi ; puntero a char* a
	add eax, 1
	mov edi, eax ; rdi tamaño de char*
	call malloc ; rax puntero a nueva memoria
	mov r13,rax ; r13 putero a nuevo char*
cicloStr_Copy:
	mov bl, [r12]
	mov [rax], bl
	add rax, 1
	add r12, 1
	cmp byte [r12], 0
	jne cicloStr_Copy
	;loop cicloStr_Copy
	mov byte [rax], 0
	mov rax, r13
finstr_copy:

	pop rbx
	pop rsi
	pop rcx
	pop rdi
	pop r13
	pop r12
	pop rbp
	ret

; int32_t str_cmp(char* a, char* b);25
str_cmp:
	push rbp
	mov rbp,rsp
	push rdi
	push rsi
	push rbx
	sub rsp, 8

	;(rdi puntero a)
	;(rsi puntero b)
	jmp ifNullStrCmp
cicloStrCmp:
	mov bl, [rdi]
	cmp [rsi], bl
	jne distintos
	inc rdi
	inc rsi
ifNullStrCmp:
	cmp byte [rdi], 0
	jne cicloStrCmp
	cmp byte [rsi], 0
	jne distintos
	mov eax, 0
	jmp finStrCmp
distintos:
	mov bl, [rdi]
	cmp [rsi], bl
	jg StrbMayor
	mov eax, -1
	jmp finStrCmp
StrbMayor:
	mov eax, 1
finStrCmp:
	
	add rsp, 8
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	ret
	
; char* str_concat(char* a, char* b);36
str_concat:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rcx
	push rbx
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi
	mov r13, rsi
	xor rcx, rcx
	call str_len
	mov r15d, eax ; r15 size char* a
	mov rdi, rsi
	call str_len
	mov r14d, eax ; r14 size char* b
	mov edi, r14d
	add edi, r15d
	add edi, 1
	call malloc
	jmp primerIFConcat
primerCicloConcat:
	mov bl, [r12]
	mov [rax], bl
	inc r12
	inc rax
primerIFConcat:		
	cmp byte [r12], 0
	jne primerCicloConcat
	jmp segundoIFConcat
segundoCicloConcat:
	mov bl,[r13]
	mov [rax], bl
	inc r13
	inc rax
segundoIFConcat:
	cmp byte [r13], 0
	jne segundoCicloConcat
	mov byte [rax], 0
	sub	rax, r14
	sub	rax, r15

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rcx
	pop rsi
	pop rdi
	pop rbp
	ret
	
;########### Funciones: Matriz

;matrix_t* matrixNew(uint32_t m, uint32_t n);35
matrixNew:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	push rsi
	push rdi
	sub rsp, 8

	mov r12d, esi ; r12 cantidad de filas
	mov r15d, edi ; r15 cantidad de columnas
	mov eax, esi ; eax cantidad de filas
	mov ecx, edi ; ecx cantidad de columnas
	mul ecx ; rax cantidad de filas * cantidad de columnas
	mov r13d, eax ; r13 cantidad de filas * cantidad de columnas
	mov ecx , matrix_data_size
	mul ecx
	mov r14d, eax ; size of matrix de punteros
;reservandoMem
	mov rdi, malloc_matrix	; solicitando 48 Bytes de memoria
	call malloc				; llamamos a malloc que devuelve en rax
				            ; el puntero a la memoria solicitada
	mov rbx, rax	        ; rbx tiene puntero a estructura
;guardando estructura
;rax puntero a matrix
	mov dword [rax+off_matrix_data_type], 4
	mov qword [rax+off_matrix_remove], matrixDelete
	mov qword [rax+off_matrix_print], matrixPrint
	mov [rax+off_matrix_col], r15d ; cantidad de columnas, parte alta limpia
	mov [rax+off_matrix_fil], r12d ; cantidad de filas, parte alta limpia
	;mov qword [rax+off_matrix_data], falta perdir memoria

;armandando matrix;inc de a 8(un puntero)
	mov rdi, r14 ; r14 tiene size of matrix de punteros
	call malloc
	mov [rbx+off_matrix_data], rax ; rax puntero a la matriz de memoria para punteros solicitada
	mov ecx, r13d ; rcx cantidad de filas * cantidad de columnas
rellenarMatrizConNull:
	mov qword [rax], NULL
	lea rax, [rax+matrix_data_size]
	loop rellenarMatrizConNull

	mov rax, rbx ; regresando puntero a la estructura

	add rsp, 8
	pop rdi
	pop rsi
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp	
	ret

;void matrixPrint(matrix_t* m, FILE *pFile);64
matrixPrint:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rdi
	push rsi
	push rcx
	push rdx

	mov r12, [rdi+off_matrix_data] ; r12 doble puntero a data
	mov r13d, [rdi+off_matrix_fil] ; r13 cantidad de filas
	mov r14d, [rdi+off_matrix_col] ; r14 cantidad de columnas
	mov r15, rsi ; r15 puntero a File
	mov rbx, rdi ; rbx puntero a estructura
	mov ecx, [rdi+off_matrix_fil] ; rcx cantidad de filas
	jmp printFila
cicloFilasMatrix:
	mov rdi, r15 ; r15 puntero a file
	mov rsi, fprintf_s ; tipo de print (%s)
	mov rdx, fprintf_pipe ; char* a pintear
	call fprintf
	mov r14d, [rbx+off_matrix_col]
	mov rdi, r15 ; r15 puntero a file
	mov rsi, fprintf_s ; tipo de print (%s)
	mov rdx, fprintf_endl ; char* a pintear
	call fprintf
printFila:
	mov rdi, r15 ; r15 puntero a file
	mov rsi, fprintf_s ; tipo de print (%s)
	mov rdx, fprintf_pipe ; char* a pintear
	call fprintf
	cmp qword [r12], NULL
	je printMatrixNull
	;Sprint(S*, * FILE)
	;segfault con lista []
	mov rdi, [r12] ;puntero a estructura
	mov rsi, r15 ; puntero a file
	mov rdx, [rdi+off_print]
	call rdx
	lea r12, [r12+matrix_data_size]
	dec r14d
	cmp r14d, 0
	jne printFila
	jmp loopMatrix
printMatrixNull:
	mov rdi, r15
	mov rsi, fprintf_s
	mov rdx, fprintf_null
	call fprintf
	lea r12, [r12+matrix_data_size]
	dec r14d
	cmp r14d, 0
	jne printFila
loopMatrix:
	dec r13d
	cmp r13d, 0
	jne cicloFilasMatrix
	mov rdi, r15
	mov rsi, fprintf_s
	mov rdx, fprintf_pipe	
	call fprintf
	mov rdi, r15 ; r15 puntero a file
	mov rsi, fprintf_s ; tipo de print (%s)
	mov rdx, fprintf_endl ; char* a pintear
	call fprintf
	
	pop rdx
	pop rcx
	pop rsi
	pop rdi
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret


; matrix_t* matrixAdd(matrix_t* m, uint32_t x, uint32_t y, void* data);22
matrixAdd:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rdx
	push rcx
	push r12
	push r13
	push r14
	push rbx

	;(rdi = *m puntero a matriz)
	;(rsi = x indice de columnas)
	;(rdx = y indice de filas)
	;(rcx = *data)
	call matrixRemove
	mov r14, rdi ; r14 puntero a estructura
	mov rbx, rcx ; rbx puntero a data
	mov eax, edx ; eax indice de fila 
	mov ecx, [rdi+off_matrix_col] ; ecx cantidad de filas
	mul ecx ; rax cantidad de elementos de las filas * indice de filas
	add eax, esi ; eax (cantidad de elementos de las filas * indice de filas)+indice de columna
	mov rdi, [rdi+ off_matrix_data]
	lea rdi, [rdi+rax*matrix_data_size]; rdi doble puntero a la posicion donde insertar la data
	mov r12, rdi ; r12 tiene doble puntero a la posicion de la data
asignarMatrix:	
	;asignacion del dato nuevo
	mov [r12], rbx
	
	pop rbx
	pop r14
	pop r13
	pop r12
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, rdi
	pop rbp
	ret
	
; matrix_t* matrixRemove(matrix_t* m, uint32_t x, uint32_t y);23
matrixRemove:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rdx
	push r12
	push r13
	push rcx
	;(rdi puntero a matrix)
	;(rsi columnas)
	;(rdx filas)

	mov eax, edx ; eax indice de fila 
	mov ecx, [rdi+off_matrix_col] ; ecx cantidad de filas
	mul ecx ; rax cantidad de elementos de las filas * indice de filas
	add eax, esi ; eax (cantidad de elementos de las filas * indice de filas)+indice de columna
	mov rdi, [rdi+ off_matrix_data] ; rdi puntero al inicio de la matriz de punteros
	lea rdi, [rdi+rax*matrix_data_size] ; rdi puntero a la matriz de punteros donde insertar la data
	mov r12, rdi ; r12 tiene doble puntero a la posicion de la data
	cmp qword [rdi], NULL
	;si el puntero a data es null no hago nada
	je finMatrixRemove
	;borrando dato
	mov rdi, [rdi] ; rdi puntero a data
	mov r13, [rdi+off_remove] ; r13 tiene puntero a funcion remove
	call r13
	;mov qword [r12], NULL
	;dato borrado
finMatrixRemove:
	pop rcx
	pop r13
	pop r12
	pop rdx
	pop rsi
	pop rdi
	mov rax, rdi
	pop rbp
	ret
	
; void matrixDelete(matrix_t* m);26
matrixDelete:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rdx
	push rcx
	push r12
	push r13
	push r14
	sub rsp, 8
	;(rdi puntero a matrix)
	mov r14, rdi
	mov eax, [rdi+off_matrix_col]
	mov ebx, [rdi+off_matrix_fil]
	xor r12, r12
	xor r13, r13
	jmp columnas
filas:
	inc r12
	cmp r12d, ebx
	jge finDeleteMatrix
	xor r13, r13
columnas:
	mov rdi, r14
	mov esi, r13d ; columas
	mov edx, r12d ; filas
	call matrixRemove
	inc r13d
	cmp r13d, [rdi+off_matrix_col]
	jb columnas
	jmp filas
finDeleteMatrix:
	mov rdi, [r14+off_matrix_data]
	call free
	mov rdi, r14
	call free
	add rsp, 8
	pop r14
	pop r13
	pop r12
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	pop rbp
	ret
	
;########### Funciones: Lista
; list_t* listNew();12
listNew:
	push rbp
	mov rbp, rsp
	push rsi
	push rdi

;reservandoMem
	mov rdi, malloc_list	; solicitando 32 Bytes de memoria
	call malloc				; llamamos a malloc que devuelve en rax
				            ; el puntero a la memoria solicitada
;guardando
	mov dword [rax+off_list_data_type], 3
	mov qword [rax+off_list_remove], listDelete
	mov qword [rax+off_list_print], listPrint
	mov qword [rax+off_list_first], NULL

	pop rdi
	pop rsi
	pop rbp 	
	ret
	
; list_t* listAddFirst(list_t* l, void* data);16
listAddFirst:
	push rbp
	mov rbp,rsp
	push rsi
	push r12
	push r13
	push r14
	push rdi
	push rdx

	;(rdi puntero a l)
	;(rsi puntero a data)
	mov r13, rdi
	mov r14, rsi
	mov rdi, list_size_nodo
	call malloc
	mov [rax+off_nodo_data], r14 ; 
	mov r12, [r13+off_list_first] ; 
	mov [rax+off_nodo_next], r12 ; siguiente de data es el primero actual
	mov [r13+off_list_first], rax ; el primero es data

	pop rdx
	pop rdi
	mov rax, rdi
	pop r14
	pop r13
	pop r12
	pop rsi
	pop rbp
	ret
	
; list_t* listAddLast(list_t* l, void* data);24
listAddLast:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push rdi
	push rsi
	push rdx
	sub rsp, 8
	;(rdi puntero a l)
	;(rsi puntero a data)
;ifNULL
	mov r13, rsi
	mov r12, [rdi+off_list_first]
	cmp r12, NULL
	je agregarPrimeroLast
	jmp ifTieneSiguiente
avanzarLast:
	mov r12, [r12+off_nodo_next]
ifTieneSiguiente:
	cmp qword [r12+off_nodo_next], NULL
	jne avanzarLast
	mov edi, list_size_nodo
	call malloc
	mov qword [rax+off_nodo_next], NULL
	mov [rax+off_nodo_data], r13
	mov [r12+off_nodo_next], rax
	jmp finAddLast
agregarPrimeroLast:
	call listAddFirst	
finAddLast:
	add rsp, 8
	pop rdx
	pop rsi
	pop rdi
	mov rax, rdi
	pop r13
	pop r12
	pop rbp
	ret
	
; list_t* listAdd(list_t* l, void* data, funcCmp_t* f);43
listAdd:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	push rdi
	;(rdi puntero a estructura)
	;(rsi puntero a data)
	;(rdx puntero a funcion)
	mov rbx, rdx ; rbx puntero a función
	mov r12, [rdi + off_list_first] ; r12 puntero al primer nodo
	mov r13, rsi ; r13 puntero a data
	mov r14, rdi ; r14 puntero a estructura
	cmp r12, NULL ; si es lista vacia-> agregarAdelante
	je agregarAdelanteListAdd
	;hay al menos un nodo
	mov rdi, [r12+off_nodo_data]
	call rbx;if (b < a , agrego b adelante de a)
	cmp eax, -1 ;si el primer nodo es mayor, agregar adelante
	je agregarAdelanteListAdd
cicloListAdd:
	cmp r12, NULL
	je agregarAtrasListAdd
	mov rdi, [r12+ off_nodo_data]
	mov rsi, r13
	call rbx
	cmp eax, -1
	je agregarListAdd
	mov r15, r12
	mov r12, [r12 + off_nodo_next]
	jmp cicloListAdd
agregarAdelanteListAdd:
	mov rdi, r14
	mov rsi, r13
	call listAddFirst
	jmp finListAdd
agregarAtrasListAdd:
	mov rdi, r14
	mov rsi, r13
	call listAddLast
	jmp finListAdd
agregarListAdd:
	;r15 -> r12, insert=> r15 -> rax -> r12
	mov edi, 16
	call malloc
	mov [rax + off_nodo_data], r13 ; nodo->data = *data
	mov r8, [r15+ off_nodo_next]
	mov [rax+ off_nodo_next], r8
	mov [r15+ off_nodo_next], rax
finListAdd:
	pop rdi
	mov rax, rdi
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; list_t* listRemove(list_t* l, void* data, funcCmp_t* f);36
listRemove:
	push rbp
	mov rbp, rsp
	push rsi
	push rdx
	push rcx
	push r12
	push r13
	push r14
	push r15
	push rbx
	push rdi
	sub rsp, 8

	;(rdi puntero a l)
	;(rsi puntero a data)
	;(rdx puntero a fun)
	mov rbx, rdx ;rbx puntero a función
	xor rax, rax
	mov r15, rdi
	mov r13, rsi
	mov r12, [rdi+off_list_first]
	cmp r12, NULL
	;si es vacio, termine
	je finListRemove
	;tiene al menos un elemento
	cmp qword [r12+off_nodo_next], NULL
	;si es una lista de un elemento, MirarPrimero
	je MirarPrimero
	;tiene al menos 2 elementos
	jmp ifHaySiguiente
haySiguiente:
;miro el siguiente
	mov r14, r12 ; r14 apunta al anterior borrar
	mov r12, [r12+off_nodo_next] ; r12 apunta al nodo a borrar
	mov rdi, [r12+off_nodo_data] ; rdi apunta a la data a borrar
	call rbx
	cmp eax, 0
	;si es igual a la data que me pasaron, borro
	je removerNodo
	;si no es igual, pregunto si hay siguiente
ifHaySiguiente:
	cmp qword [r12+off_nodo_next], NULL
	;si hay siguiente, comparo con data
	jne haySiguiente
	;si no hay siguiente, "miro el primer elemento, que nunca mire"
MirarPrimero:
	mov rdi, [r15+off_list_first]
	mov rdi, [rdi+off_nodo_data]
	call rbx
	cmp eax, 0
	;si el primero es no igual, termine
	jne finListRemove
	;si es igual, borro y termino
	mov rdi, r15
	call listRemoveFirst
	jmp finListRemove
removerNodo:
;r14 tiene el nodo anterior
;r12 nodo a borrar y es distinto de null(siempre borro el siguiente)
	mov r13, [r12+off_nodo_next] ; r13 puntero a siguiente o NULL
	mov [r14+off_nodo_next], r13 ; r14 apunta a siguiente
	mov r13, rsi
	;acomodando registros para llamar a dataRemove(*data)
	mov rdi, [r12+off_nodo_data]
	mov rcx, [rdi+off_remove]
	call rcx
	mov rdi, r12
	call free
	;mov qword [r12], NULL
	mov rsi, r13
	mov r12, r14
	mov rdx, rbx
	jmp ifHaySiguiente
finListRemove:	
	
	add rsp, 8
	pop rdi
	mov rax, rdi
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rcx
	pop rdx
	pop rsi
	pop rbp	
	ret
	
; list_t* listRemoveFirst(list_t* l);19
listRemoveFirst:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push rsi
	push rdi
	push rdx
	;(rdi puntero a l)

	cmp qword [rdi+off_list_first], NULL
	je finlistRemFirst
;reencadenamiento
	mov r12, [rdi+off_list_first]
	mov r14, r12
	mov r13, [r12+off_nodo_next]
	mov [rdi+off_list_first], r13 ; lista apunta al siguiente elemento
;borrar nodo	
	mov rdi,[r12+off_nodo_data]
	mov r12, [rdi+off_remove]
	call r12 ; liberando data
	mov rdi, r14 
	call free ; liberando puntero a nodo
finlistRemFirst:
	
	pop rdx
	pop rdi
	mov rax, rdi
	pop rsi
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; list_t* listRemoveLast(list_t* l);25
listRemoveLast:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push rdi
	;(rdi puntero a l)
	mov r12, [rdi+off_list_first]
	cmp r12, NULL
	je finLastRemove
	cmp qword[r12+off_nodo_next], NULL
	je eliminarPrimeroLastRemove
cicloLastRemove:
	mov r13, r12
	mov r12, [r12+off_nodo_next]
	cmp qword[r12+off_nodo_next], NULL
	jne cicloLastRemove
	mov qword[r13+off_nodo_next], NULL
	mov rdi, [r12+off_nodo_data]
	mov r14, [rdi+off_remove]
	call r14
	mov rdi, r12
	call free
	jmp finLastRemove
eliminarPrimeroLastRemove:
	call listRemoveFirst
finLastRemove:
	pop rdi
	mov rax, rdi
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; void listDelete(list_t* l);20
listDelete:
	push rbp
	mov rbp,rsp
	push rsi
	push rbx
	push r12
	push r13
	push rdx
	sub rsp, 8
	;(rdi puntero a estructura)
listDeleteFirst:	
	mov rbx, rdi
	cmp qword [rdi+off_list_first], NULL
	;si es lista vacia, termino
	je finListDelete
	call listRemoveFirst
	;nodo borrado
	cmp qword [rdi+off_list_first], NULL
	je finListDelete
	jmp listDeleteFirst
finListDelete:
	call free
finlistDel:
	add rsp, 8
	pop rdx
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp
	ret
	
; void listPrint(list_t* m, FILE *pFile);35
listPrint:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rdx
	push rcx
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi
	mov r13, rsi
	mov r14, [rdi+off_list_first]
	mov rdi, r13
	mov rsi, fprintf_s
	mov rdx, fprintf_corcheteI
	call fprintf
	cmp r14, NULL
	je finListPrint
	mov rsi, r13
	jmp ifListPrint
cicloListPrint:
;print elemento
	mov r15, [r14+off_nodo_data]
	mov rcx, [r15+off_print] ; rdi puntero a funcion de la estructura a printear
	mov rdi, r15 ; rdi puntero a estructura a printear
	call rcx
	mov r14, [r14+off_nodo_next]
;print coma
	mov rdi, r13
	mov rsi, fprintf_s
	mov rdx, fprintf_coma
	call fprintf
	mov rsi, r13
ifListPrint:
	cmp qword [r14+off_nodo_next], NULL
	jne cicloListPrint
	mov r15, [r14+off_nodo_data]
	mov rcx, [r15+off_print] ; rdi puntero a funcion de la estructura a printear
	mov rdi, r15 ; rdi puntero a estructura a printear
	call rcx

finListPrint:	
	mov rdi, r13
	mov rsi, fprintf_s
	mov rdx, fprintf_corcheteF
	call fprintf

	pop r15
	pop r14
	pop r13
	pop r12
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	pop rbp
	ret
	
;########### Funciones: String

; string_t* strNew();11
strNew:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi

;reservandoMem
	mov rdi, malloc_str		; solicitando 32 Bytes de memoria
	call malloc				; llamamos a malloc que devuelve en rax
				            ; el puntero a la memoria solicitada			            
;guardando
	mov dword [rax+off_string_data_type], 2
	mov qword [rax+off_string_remove], strDelete
	mov qword [rax+off_string_print], strPrint
	mov qword [rax+off_string_data], NULL
	
	pop rsi
	pop rdi
	pop rbp
	ret
	
; string_t* strSet(string_t* s, char* c);14
strSet:
	push rbp
	mov rbp, rsp
	push r12
	push rdi
	push rsi
	push r13

	;rdi(puntero a la estructura s)
	;rsi(puntero a la estructura c)
	mov r13, rsi
	mov r12, rdi ; r12 puntero a estructura
	call strRemove ; estructura no tiene data
	mov rdi, r13
	call str_copy ; puntero de copia de C en rax, rdi puntero a char c
	mov [r12+off_string_data], rax ; registro a memoria 
	mov rax, r12 ; rax puntero a estructura

	pop r13
	pop rdi
	pop rsi
	pop r12
	pop rbp
	ret
	
; string_t* strAddRight(string_t* s, string_t* d);21
strAddRight:
;aridad de char* str_concat(char* a, char* b)
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push r12
	push r13

	;(rdi puntero a struct s)
	;(rsi puntero a struct d)
;concat

	mov r12, rdi
	mov r13, rsi
	mov rdi, [r12+off_string_data]
	mov rsi, [r13+off_string_data]
	call str_concat ; puntero a concat
	;mov rdi, [r13+off_string_data]
	mov [r12+off_string_data], rax; puntero a concat
	call free
	cmp r12, r13
	je finStrRight
;delete d
	mov rdi, r13 ; rdi apunta a d
	call strDelete
finStrRight:
	mov rax, r12

	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbp
	ret
	
; string_t* strAddLeft(string_t* s, string_t* d);21
strAddLeft:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push r12
	push r13

	;(rdi puntero a struct s)
	;(rsi puntero a struct d)
;concat
	mov r12, rdi
	mov r13, rsi
	mov rdi, [r13+off_string_data]
	mov rsi, [r12+off_string_data]
	;mov rdi, [rdi]
	;mov rsi, [rsi]
	call str_concat ; puntero a concat
	mov rdi, [r12+off_string_data] ; puntero a liberar
	mov [r12+off_string_data], rax; puntero a concat
	call free
	cmp r12, r13
	je finStrLeft
;delete d
	mov rdi, r13 ; rdi puntero a data
	call strDelete
finStrLeft:
	mov rax, r12

	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbp
	ret
	
; string_t* strRemove(string_t* s);11
strRemove:
	push rbp
	mov rbp, rsp
	push r12
	push rdi
	push rsi
	push rdx

	;rdi(puntero)
	mov r12, rdi ; r12 puntero a estructura
	cmp qword [rdi+off_string_data], NULL
	je finstrRemove
;liberarMemoria
	mov rdi, [rdi+off_string_data] 	; llendo a la locacion donde va la data
	call free 				; liberando memoria del dato
	mov qword [r12+off_string_data], NULL
	jmp finstrRemove
finstrRemove:
	mov rax, r12 ; regresando el puntero al inicio

	pop rdx
	pop rsi
	pop rdi
	pop r12
	pop rbp	
	ret
	
; void strDelete(string_t* s);6
strDelete:
	push rbp
	mov rbp, rsp
	push rsi
	push rdx
	sub rsp, 8

	call strRemove
	call free
	
	add rsp, 8
	pop rdx
	pop rsi
	pop rbp
	ret
	
; int32_t strCmp(string_t* a, string_t* b);3
strCmp:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	mov rdi, [rdi+off_string_data]
	mov rsi, [rsi+off_string_data]
	call str_cmp

	pop rsi
	pop rdi
	pop rbp
	ret
	
; void strPrint(string_t* m, FILE *pFile);13
strPrint:
	push rbp
	mov rbp, rsp
	push r12
	push rdi
	push rsi
	push rdx
	;(integer_t * en rdi) 
	;(FILE* en rsi)
	mov r12,[rdi+off_string_data] ; r12 puntero a data
;preparandoFPRINTF
	mov rdi, rsi
;ifNull
	cmp r12, NULL
	je printStrNULL
;printValor:
	mov rsi, fprintf_s
	mov rdx, r12
	jmp finPrintStr
printStrNULL:
	mov rsi, fprintf_s
	mov rdx, fprintf_null
finPrintStr:
	call fprintf

	pop rdx
	pop rsi
	pop rdi
	pop r12
	pop rbp
	ret
	
;########### Funciones: Entero

; integer_t* intNew();11
intNew:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi

;reservandoMem
	mov rdi, malloc_int		; solicitando 32 Bytes de memoria
	call malloc				; llamamos a malloc que devuelve en rax
				            ; el puntero a la memoria solicitada
;guardando
	mov dword [rax+off_int_data_type], 1
	mov qword [rax+off_int_remove], intDelete
	mov qword [rax+off_int_print], intPrint
	mov qword [rax+off_int_data], NULL	

	pop rsi
	pop rdi
	pop rbp
	ret
	
; integer_t* intSet(integer_t* i, int d);15
intSet:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push r12
	push r13

	;rdi(puntero)
	;rsi(entero)
	mov r12, rdi ; r12 puntero a estructura
	mov r13d, esi ; puntero a entero a guardar(limpia a la parte alta)
	call strRemove
;pedirMemoria:
	mov rdi, 8
	call malloc		; llamamos a malloc que devuelve en rax
				    ; el puntero a la memoria solicitada
;asignar:	
	mov [rax], r13 	; asignando data  
	mov [r12+off_int_data], rax  ; asignando puntero

;el puntero quedo guardado en la posicion correspondiente y en rax(para retorno)
;reestableciendoAlineado
	mov rax, r12
	
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbp
	ret
	
; integer_t* intRemove(integer_t* i);11
intRemove:
	push rbp
	mov rbp, rsp
	push r12
	push rdi
	push rsi
	push rdx

	;rdi(puntero a estructura)
;ifNULL
	mov r12, rdi
	cmp qword [rdi+off_int_data], NULL
	je finIntRemove
;liberarMemoria
	mov rdi, [r12+off_int_data] ; rdi tiene el puntero a data
	call free 					; liberando memoria del dato
	mov qword [r12+off_int_data], NULL
finIntRemove:

	pop rdx
	pop rsi
	pop rdi
	mov rax, rdi
	pop r12
	pop rbp
	ret
	
; void intDelete(integer_t* i);6
intDelete:
	push rbp
	mov rbp, rsp
	push rsi
	push rdi
	push rdx
	sub rsp, 8

	call intRemove
	call free

	add rsp, 8
	pop rdx
	pop rdi
	pop rsi
	pop rbp
	ret
	
; int32_t intCmp(integer_t* a, integer_t* b);10
intCmp:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi

	mov rdi, [rdi+off_int_data]
	mov rsi, [rsi+off_int_data]
	mov edi, [rdi]
	mov esi, [rsi]
	cmp edi, esi
	jg aMayor
	jl bMayor
	xor rax, rax ;son iguales
	jmp finIntCmp
bMayor:
	mov eax, 0x1
	jmp finIntCmp
aMayor:
	mov eax, 0x-1
finIntCmp:
	pop rsi
	pop rdi
	pop rbp
	ret
	
; void intPrint(integer_t* m, FILE *pFile);14
intPrint:
;int fprintf (FILE *stream, const char *format)(d or i) : Signed decimal integer
	push rbp
	mov rbp, rsp
	push rdi
	push rsi
	push rdx
	push r12
	;(integer_t * en rdi) 
	;(FILE* en rsi)
	mov r12, rdi ; r12 tiene puntero al int
;preparandoFPRINTF
	mov rdi, rsi
;ifNull
	mov rdx,[r12+off_int_data]
	cmp rdx, NULL
	je printIntNULL
;printValor
	mov rsi, fprintf_d
	mov rdx, [rdx]
	jmp printINT
printIntNULL:
	mov rsi, fprintf_s
	mov rdx, fprintf_null 
printINT:
	call fprintf

	pop r12
	pop rdx
	pop rsi
	pop rdi
	pop rbp
	ret
	