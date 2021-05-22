;====================================[ ������ �������� ���� ]====================================
MYCODE: segment .code
org 100h; ������������ ��������� ������ ��� COM-������
;-------------------------------------------[�������]--------------------------------------------

; SPC 32
; ENT 13
; ESC 27
; : 58
;alt+x - �����
;f7 � f8 - ������ �� ������ ����
%macro create_new_file 1
; 1 - ��� �������� �����
	mov dx, %1
	call create_file
%endmacro

%macro  macro_write_information_to_file 2
; 1 - ��� ����� 2 - ������ ��������� � ������
	mov dx, %1
	mov word[qq], dx
	mov dx, %2
	mov word[gh], dx
	call write_information_to_file
%endmacro

%macro macro_read_information_from_file 2
;1 - ��� ����� 2 - ������ ���������
	mov dx, %1
	mov si, %2
	call read_information_from_file
%endmacro macro_read_specific_line_in_file 3
	
%macro macro_read_specific_line_in_file 3
;1 - ��� ����� 2 - �����-��������� 3 - ����� ������ � �����
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
;---------------------------------------[ ����� ������ ]-----------------------------------------
	;������� 1
	;�������� ��������� ��������� ����� �����
	;create_new_file name_file
	; 1 - ��� �������� �����
	
	;������� 2
	;�������� ���������, ���������������� ���������� ����� �����-���� ���������� �� ������
	;macro_write_information_to_file name_file, message ;1 - ��� ����� 2 - ������ ���������� ���������
	
	;������� 3
	;�������� ��������� ����������� ���������� ����� � �����-���� ���������� � ������� ������
	; 1 - ��� ����� 2 - ������ ������, ���� �������� ��������� ������
	;macro_read_information_from_file name_file, read_info
	
	;������� 4 
	;�������� ���������, ����������� ���� ������ ����������� �����
	;��������� �������  1 - ��� ����� 2 - �����-��������� 3 - ����� ������ � �����
	;����� ������� ������ � �����, �� ������� ����� ������ ��������� ������ ������ ������� �� ��������� (������� ��������� ��������� ������)
	;��������� �������� ���������, ���� � ����� ������ ������ ���� \n, ��� ascii 0Ah
	;macro_read_specific_line_in_file name_file, read_info, 2
	
	;������� 5
	;�������� ���������, ������� �������� ��������� �������� � ����
	;create_new_file name_file_ini
	;macro_task_5 name_file_ini
;-------------------------------[ ����������� ���������� ��������� ]-----------------------------
	mov ax, 4C00h
	int 21h
;------------------------------------------[������������]----------------------------------------
	create_file:
	;�������� �����
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
	;������ ���������� � ����
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
	;������ ������ �� �����
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
	mov dx, si ;������ ������ ��� ������
	mov cx, 80 ;������������ ���������� �������� ������
	int 21h
	jnc MYREAD2 ;���� ��� ������, �� ����������
	call error_msg
	jmp close_file2 ;������� ���� � ����� �� ���������
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
	;��������� ������������ ������� � �����
	mov ah, 3Dh
	mov al, 0
	int 21h
	jnc NO_ERR3
	call error_msg
	jmp exit4
NO_ERR3:
	mov [handle], ax ;���������� ����������� �����
return1:	
	mov bx, [handle]
	mov ah, 3Fh
	mov dx, si ;������ ������ ��� ������
	mov cx, 1 ;������������ ���������� �������� ������
	int 21h
	jnc MYREAD6 ;���� ��� ������, �� ����������
	call error_msg
	jmp close_file3 ;������� ���� � ����� �� ���������
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
	add bx, ax ;ax - ���������� ����������� ����
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
	;�������� ��������� ������������ �������� ��������� � ����
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
	;����� ��������� �� ������
	mov ah, 9
	mov dx, s_error
	int 21h
	mov dx, endline
	int 21h
	ret
;====================================[ ������ �������� ������ ]==================================

align 16, db 90h
db '=[MYDATA BEGIN]='
align 16, db 20h
s_error db 'Error!', 13, 10, 'file!'
s_pak db 'All is ok!$'
handle dw 1 ;���������� �����
endline db 13, 10, '$'
name_file db 'new_file.txt', 0 ;��� �����
write_n db 0Ah
write_reg db '[REGISTERS]', 0Ah
write_read_l db '  '
write_read_h db '  '
write_ax db 'AX='
write_bx db 'BX='
write_dx db 'DX='
write_cx db 'CX='
name_file_ini db 'new_file.ini' ;��� �����
message db 'Hello world!' ;��������� ��� ������ � ����
rb_info dw ''
number_line db 0
count db 0
count_2 db 0
gh dw 0
qq dw 0
size db 12 ;������ ���������
rf dw 0
read_info db ''
;db '=[MYDATA BEGIN]='
;str2 dw 3456h ;�����������
;str3 db 0
;my equ 123; equ - ���������, ����� ��� ���������� my ����� �������� �� �������� 123
;align 16, db 32h
;times 16 db '=' ; ������ ���������� �������� ����� ��������� 
;mov al, byte[str1] ;���� ����� ������� ����������� ��������
;mov bx, word[str2] ;���� ����� ������� ����������� ��������


