blocks:
    mov ax, 0xb800
    mov es, ax
               
    mov di, bx      ; position
    mov ax, dx      ; color
    mov bx, si      ; width  

construct:
    mov word [es:di], ax
    add di, 2
    sub si, 1
    jz updateconstruct
    jmp construct

updateconstruct:
    sub cx, 1
    jz exitblock
    mov si, bx
    add di, 160
    sub di, si
    sub di, si
    jmp construct

exitblock:
    ret 

clrscr:
    mov ax, 0xb800
    mov es, ax
    mov di, 0

clearw:
    mov word [es:di], 0x0fdb
    add di, 2
    cmp di, 4000
    jb clearw
    ret 

drawobs:
    call clrscr

    mov dx, 0x2F20
    mov bx, 1200
    mov cx, 7
    mov si, 2
    call blocks

    mov dx, 0x2F20
    mov bx, 902
    mov cx, 7
    mov si, 2
    call blocks

    mov dx, 0x2F20
    mov bx, 156
    mov cx, 25
    mov si, 2
    call blocks

    mov dx, 0x2F20
    mov bx, 1786
    mov cx, 7
    mov si, 2
    call blocks

    mov dx, 0x2F20
    mov bx, 1480
    mov cx, 1
    mov si, 13
    call blocks

    mov dx, 0x2F20
    mov bx, 2768
    mov cx, 1
    mov si, 13
    call blocks

    mov dx, 0x2F20
    mov bx, 1240
    mov cx, 1
    mov si, 13
    call blocks

    mov dx, 0x4000
    mov bx, 0
    mov cx, 2
    mov si, 2
    call blocks

    ret

