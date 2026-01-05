org 0x100

jmp start

prevtick:     dw 0
starpos:      dw 0
direction:    db 1       ; 1=right
tickcount:    dw 0

oldtimer:     dw 0, 0

star_move_addr: dw updatestar 

timer:
    push ax
    push bx
    inc word [tickcount]
    call updatestar
    mov al, 0x20
    out 0x20, al
    pop bx
    pop ax
    iret

start:
    cli
    mov ah, 35h
    mov al, 08h
    int 21h
    mov word [oldtimer], bx
    mov word [oldtimer+2], es

    mov ah, 25h
    mov al, 08h
    mov dx, timer
    int 21h
    sti

    call drawobs
    call initstar
    call mainloop

%include "utils.asm"
%include "render.asm"
