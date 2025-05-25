.model small
.stack 100h

.data
    s1      db 6 dup(?)          
    s2      db 6 dup(?)       
    number1 dw 0                 
    number2 dw 0               
    operator db ?               
    result  dw 0                
    error   db 'Loi: Toan tu khong hop le hoac chia 0.$'
    guide1  db 'Nhap vao so thu nhat: $'
    guide2  db 'Nhap vao toan tu (+ - * /): $'
    guide3  db 'Nhap vao so thu hai: $'
    ans     db 'Ket qua la: $'

.code
start:
    mov ax, @data
    mov ds, ax

    call newline
    lea dx, guide1
    mov ah, 09h
    int 21h
    lea di, s1
    call read_number
    lea si, s1
    call atoi
    mov number1, ax

    call newline
    lea dx, guide2
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    mov operator, al

    call newline
    lea dx, guide3
    mov ah, 09h
    int 21h
    lea di, s2
    call read_number
    lea si, s2
    call atoi
    mov number2, ax

    mov ax, number1
    mov bx, number2

    cmp operator, '+'
    je cong
    cmp operator, '-'
    je tru
    cmp operator, '*'
    je nhan
    cmp operator, '/'
    je chia
    jmp loi_op

cong:
    add ax, bx
    mov result, ax
    jmp in_ans

tru:
    sub ax, bx
    mov result, ax
    jmp in_ans

nhan:
    mul bx
    mov result, ax
    jmp in_ans

chia:
    cmp bx, 0
    je loi_op
    xor dx, dx
    div bx
    mov result, ax
    jmp in_ans

loi_op:
    call newline
    mov ah, 09h
    lea dx, error
    int 21h
    jmp end_program

in_ans:
    call newline
    lea dx, ans
    mov ah, 09h
    int 21h
    mov ax, result
    call print_num
    jmp end_program

end_program:
    mov ah, 4Ch
    int 21h
read_number proc
    xor cx, cx
read_loop:
    mov ah, 01h
    int 21h
    cmp al, 13
    je done_input
    mov [di], al
    inc di
    inc cx
    cmp cx, 5
    je done_input
    jmp read_loop
done_input:
    mov byte ptr [di], 0
    ret
read_number endp
atoi proc
    xor ax, ax
    mov bx, 10
next_digit:
    mov cl, [si]
    cmp cl, 0
    je done_conv
    sub cl, '0'
    xor ch, ch
    push ax
    mul bx
    pop dx
    add ax, cx
    inc si
    jmp next_digit
done_conv:
    ret
atoi endp
print_num proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov bx, 10
    cmp ax, 0
    jne chialai
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp done

chialai:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne chialai

hienthi:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop hienthi

done:
    call newline
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp
newline proc
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
newline endp

end start
