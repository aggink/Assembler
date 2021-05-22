;====================================[ Начало сегмента кода ]====================================
MYCODE: segment .code
org 100h; Обязательная директива ТОЛЬКО для COM-файлов
;-------------------------------------------[макросы]--------------------------------------------

; SPC 32
; ENT 13
; ESC 27
; : 58
;alt+x - выход
;f7 и f8 - проход по одному шагу
%macro create_new_file 1
; 1 - имя будущего файла
	mov dx, %1
	call create_file
%endmacro

%macro  macro_write_information_to_file 2
; 1 - имя файла 2 - адресс сообщения в памяти
	mov dx, %1
	mov word[qq], dx
	mov dx, %2
	mov word[gh], dx
	call write_information_to_file
%endmacro

%macro macro_read_information_from_file 2
;1 - имя файла 2 - строки сообщения
	mov dx, %1
	mov si, %2
	call read_information_from_file
%endmacro macro_read_specific_line_in_file 3
	
%macro macro_read_specific_line_in_file 3
;1 - имя файла 2 - стока-сообщение 3 - номер строки в файле
	mov dx, %1
	mov si, %2
	mov cx, %3
	dec cx
	mov word[rf], si
	mov byte[number_line], cl
	call read_specific_line_in_file
%endmacro

%macro macro_task_5 1
	mov dx, %1
	mov word[qq], dx
	call task_5
%endmacro
;---------------------------------------[ Точка старта ]-----------------------------------------
	;задание 1
	;написать программу создающую новый файло
	;create_new_file name_file
	; 1 - имя будущего файла
	
	;задание 2
	;написать программу, перезаписывающее содержимое файла каким-либо сообщением из памяти
	;macro_write_information_to_file name_file, message ;1 - имя файла 2 - адресс текстового сообщения
	
	;задание 3
	;написать программу считывающее содержимое файла в какую-либо переменную в области памяти
	; 1 - имя файла 2 - адресс памяти, куда положить считанные данные
	;macro_read_information_from_file name_file, read_info
	
	;задание 4 
	;написать программу, считывающее одну строку содержимого файла
	;параметры макроса  1 - имя файла 2 - стока-сообщение 3 - номер строки в файле
	;когда вводишь строки в файле, не забывай после каждой введенной строки делать переход на следующую (включая последнюю введенную строку)
	;программа работает правильно, если в конце каждой строки есть \n, код ascii 0Ah
	;macro_read_specific_line_in_file name_file, read_info, 2
	
	;задание 5
	;написать программу, которая значения регистров печатает в файл
	;create_new_file name_file_ini
	;macro_task_5 name_file_ini
;-------------------------------[ Стандартное завершение программы ]-----------------------------
	mov ax, 4C00h
	int 21h
;------------------------------------------[Подпрограммы]----------------------------------------
	create_file:
	;создание файла
	mov ah, 3Ch
	mov cx, 0
	int 21h
	jnc NO_ERR1
	call error_msg
	jmp exit1
NO_ERR1:
	mov [handle], ax
exit1:
	mov ah, 9
	mov dx, s_pak
	int 21h
	mov dx, endline
	int 21h
	ret
	
	write_information_to_file:
	mov ah, 3Dh
	mov al, 1
	mov dx, word[qq]
	mov cx, 0
	int 21h
	jnc NO_ERR4
	call error_msg
	jmp exit6
NO_ERR4:
	mov [handle], ax
	;запись информации в файл
	mov bx, [handle]
	mov ah, 40h
	mov dx, word[gh]
	movzx cx, [size]
	int 21h
	jnc close_file1
	call error_msg
close_file1:
	mov ah, 3Eh
	mov bx, [handle]
	int 21h
	jnc exit3
	call error_msg
exit3:
exit6:
	mov ah, 9
	mov dx, s_pak
	int 21h
	mov dx, endline
	int 21h
	ret
	
	read_information_from_file:
	;чтение данных из файла
	mov ah, 3Dh
	mov al, 0
	int 21h
	jnc NO_ERR2
	call error_msg
	jmp exit2
NO_ERR2:
	mov [handle], ax
	mov bx, [handle]
	mov ah, 3Fh
	mov dx, si ;адресс буфера для данных
	mov cx, 80 ;максимальное количество читаемых байтов
	int 21h
	jnc MYREAD2 ;если нет ошибки, то продолжаем
	call error_msg
	jmp close_file2 ;закрыть файл и выйти из программы
MYREAD2:
	mov bx, si
	add bx, ax
	mov byte[bx], '$'
	mov  ah, 9
	mov dx, si
	int 21h
	mov dx, endline
	int 21h
close_file2:
	mov ah, 3Eh
	mov bx, [handle]
	int 21h
	jnc exit2
	call error_msg
exit2:
	mov ah, 9
	mov dx, s_pak
	int 21h
	ret
	
	read_specific_line_in_file:
	;прочитать определенную строчку в файле
	mov ah, 3Dh
	mov al, 0
	int 21h
	jnc NO_ERR3
	call error_msg
	jmp exit4
NO_ERR3:
	mov [handle], ax ;сохранение дескриптора файла
return1:	
	mov bx, [handle]
	mov ah, 3Fh
	mov dx, si ;адресс буфера для данных
	mov cx, 1 ;максимальное количество читаемых байтов
	int 21h
	jnc MYREAD6 ;если нет ошибки, то продолжаем
	call error_msg
	jmp close_file3 ;закрыть файл и выйти из программы
MYREAD6:
	mov cl, 0Ah
	cmp byte[si], cl
	jz MYREAD3
	jnz return1
MYREAD3:
	mov cl, byte[count]
	inc cl
	mov byte[count], cl
	cmp cl, byte[number_line]
	jz MYREAD4
	jnz return1
MYREAD4:
return3:
	mov bx, [handle]
	mov ah, 3Fh
	mov dx, si
	mov cx, 1
	int 21h
	jnc MYREAD5
	call error_msg
	jmp close_file3
MYREAD5:
	mov cl, 0Ah
	cmp byte[si], cl
	jz go
	jnz return2
return2:
	mov al, byte[count_2]
	inc al
	mov byte[count_2], al
	inc si
	jmp return3
go:
	mov bx, si
	mov ax, 0
	mov al, byte[count_2]
	add bx, ax ;ax - количество прочитанных байт
	mov byte[bx], '$'
	
	mov ah, 9
	mov dx, word[rf]
	
	int 21h
	mov dx, endline
	int 21h
close_file3:
	mov ah, 3Eh
	mov bx, [handle]
	int 21h
	jnc exit5
	call error_msg
exit4:
exit5:
	mov ah, 9
	mov dx, s_pak
	int 21h
	ret

	task_5:
	;написать программу записывающую значения регистров в файл
	mov ah, 3Dh
	mov al, 1
	mov dx, word[qq]
	mov cx, 0
	int 21h
	jnc NO_ERR8
	call error_msg
	jmp exit8
NO_ERR8:
	mov [handle], ax
	
	mov bx, [handle]
	mov ah, 40h
	mov dx, write_reg
	mov byte[size], 12
	movzx cx, [size]
	int 21h
	jnc NO_ERR9
	call error_msg
	jmp close_file4
NO_ERR9:	
	mov bx, [handle]
	mov ah, 40h
	mov dx, write_ax
	mov byte[size], 3
	movzx cx, [size]
	int 21h
	jnc NO_ERR10
	call error_msg
	jmp close_file4
NO_ERR10:	
	mov ax, 10
	mov byte[write_read_l], al
	mov byte[write_read_h], ah
	
	mov bx, [handle]
	mov ah, 40h
	mov dx, write_read_h
	mov byte[size], 1
	movzx cx, [size]
	int 21h
	jnc NO_ERR11
	call error_msg
	jmp close_file4
NO_ERR11:

	mov bx, [handle]
	mov ah, 40h
	mov dx, write_read_l
	mov byte[size], 1
	movzx cx, [size]
	int 21h
	jnc NO_ERR12
	call error_msg
	jmp close_file4
NO_ERR12:

	mov bx, [handle]
	mov ah, 40h
	mov dx, write_n
	mov byte[size], 1
	movzx cx, [size]
	int 21h
	jnc NO_ERR13
	call error_msg
	jmp close_file4
NO_ERR13:	

close_file4:
	mov ah, 2Eh
	mov bx, [handle]
	int 21h
	jnc exit8
	call error_msg
exit8:
	mov ah, 9
	mov dx, s_pak
	int 21h
	ret
	
	error_msg:
	;вывод сообщения об ошибке
	mov ah, 9
	mov dx, s_error
	int 21h
	mov dx, endline
	int 21h
	ret
;====================================[ Начало сегмента данных ]==================================

align 16, db 90h
db '=[MYDATA BEGIN]='
align 16, db 20h
s_error db 'Error!', 13, 10, 'file!'
s_pak db 'All is ok!$'
handle dw 1 ;дескриптор файла
endline db 13, 10, '$'
name_file db 'new_file.txt', 0 ;имя файла
write_n db 0Ah
write_reg db '[REGISTERS]', 0Ah
write_read_l db '  '
write_read_h db '  '
write_ax db 'AX='
write_bx db 'BX='
write_dx db 'DX='
write_cx db 'CX='
name_file_ini db 'new_file.ini' ;имя файла
message db 'Hello world!' ;сообщение для записи в файл
rb_info dw ''
number_line db 0
count db 0
count_2 db 0
gh dw 0
qq dw 0
size db 12 ;размер сообщения
rf dw 0
read_info db ''
;db '=[MYDATA BEGIN]='
;str2 dw 3456h ;двухбайтная
;str3 db 0
;my equ 123; equ - константа, везде где втречается my будет заменено на значение 123
;align 16, db 32h
;times 16 db '=' ; задаем количество повторов через дерективу 
;mov al, byte[str1] ;если хотим считать однобайтное значение
;mov bx, word[str2] ;если хотим считать двухбайтное значение


