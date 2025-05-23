.model small
.stack 100h

.data
    num1  db ?
    num2  db ?
    op    db ?
    result dw ?
    errmsg db 'Loi: Toan tu khong hop le hoac chia 0.$'

.code
start:
    mov ax, @data
    mov ds, ax


    mov ah, 01h
    int 21h
    sub al, '0'
    mov num1, al

    call newline


    mov ah, 01h
    int 21h
    mov op, al

    call newline


    mov ah, 01h
    int 21h
    sub al, '0'
    mov num2, al

    mov al, num1
    mov bl, num2

    cmp op, '+'
    je cong
    cmp op, '-'
    je tru
    cmp op, '*'
    je nhan
    cmp op, '/'
    je chia

    jmp loi

cong:
    add al, bl
    mov ah, 0
    mov result, ax
    jmp in_kq

tru:
    sub al, bl
    mov ah, 0
    mov result, ax
    jmp in_kq

nhan:
    mul bl         
    mov result, ax
    jmp in_kq

chia:
    cmp bl, 0
    je loi
    xor ah, ah
    div bl         
    mov ah, 0
    mov result, ax
    jmp in_kq

loi:
    mov ah, 09h
    lea dx, errmsg
    int 21h
    jmp ketthuc

in_kq:
    call newline      
    mov ax, result
    call print_num

ketthuc:
    mov ah, 4Ch
    int 21h
print_num proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov bx, 10

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
