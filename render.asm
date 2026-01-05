checkkey:
    mov ah, 01h
    int 16h
    jz skipkey
    mov ah, 00h
    int 16h
    cmp ah, 4Bh   ; left
    je setleft
    cmp ah, 4Dh   ; right
    je setright
    cmp ah, 50h   ; down
    je setdown
    cmp ah, 48h   ; up
    je setup
    jmp skipkey
setleft:   mov byte [direction], 0  ; left
           jmp skipkey
setright:  mov byte [direction], 1  ; right
           jmp skipkey
setup:     mov byte [direction], 2  ; up
           jmp skipkey
setdown:   mov byte [direction], 3  ; down
skipkey:
    ret

initstar:
    mov ax, 0b800h
    mov es, ax
    mov bx, (24 * 160) + (80 * 2 / 2)  
    mov [starpos], bx
    mov byte [direction], 1
    mov ax, [tickcount]
    mov [prevtick], ax
    mov di, [starpos]
    mov al, '*'
    mov ah, 1Fh
    mov [es:di], ax
    ret

updatestar:
    mov ax, [tickcount]
    mov cx, [prevtick]
    sub ax, cx
    cmp ax, 1  
    jl skipmove

    mov ax, [tickcount]
    mov [prevtick], ax
    push ax
    push bx
    push dx
    push si
    push di

    mov ax, 0b800h
    mov es, ax
    mov di, [starpos]
    mov word [es:di], 0x0FDB

    mov al, [direction]
    cmp al, 0
    je moveleft
    cmp al, 1
    je moveright
    cmp al, 2
    je moveup
    cmp al, 3
    je movedown
    jmp drawstar

moveleft:
    mov bx, [starpos]
    mov ax, bx
    xor dx, dx     
    mov cx, 160
    div cx          
    cmp dx, 0
    je drawstar     
    sub bx, 2
    mov [starpos], bx
    jmp drawstar

moveright:
    mov bx, [starpos]
    add bx, 2
    cmp bx, (24 * 160 + 158)
    jle storeposr
    mov bx, (24 * 160 + 158)
storeposr:
    mov [starpos], bx
    jmp drawstar

moveup:
    mov bx, [starpos]
    sub bx, 160                  
    cmp bx, 0
    jl keepattop
    mov [starpos], bx
    jmp drawstar

keepattop:
    mov ax, [starpos]
    xor dx, dx
    mov cx, 160
    div cx                        
    mov bx, 0                     
    add bx, dx                     
    mov [starpos], bx
    jmp drawstar

movedown:
    mov bx, [starpos]
    add bx, 160                      
    cmp bx, (24 * 160 + 158)         
    jg keepatbottom
    mov [starpos], bx
    jmp drawstar

keepatbottom:
  
    mov ax, [starpos]
    xor dx, dx
    mov cx, 160
    div cx                
    mov bx, (24*160)
    add bx, dx           
    mov [starpos], bx
    jmp drawstar

drawstar:
    mov ax, 0b800h
    mov es, ax
    mov di, [starpos]
    mov al, '*'
    mov ah, 1Fh 
    push cx 
    mov cx,[es:di]
    cmp cx,0x2F20 
    je end 
    cmp cx,0x4000 
    je end 
    pop cx
    mov [es:di], ax

    pop di
    pop si
    pop dx
    pop bx
    pop ax

skipmove:
    ret

mainloop:
    call checkkey
    jmp mainloop



end:
    cmp cx, 0x2F20
    je lost 
    cmp cx,0x4000 
    je won 


won:
    mov ax, 0b800h
    mov es, ax
    mov di, (12 * 160) + (36 * 2)
    mov si, msg_won
    mov cx, 7
won_loop:
    lodsb                  
    mov ah, 2Fh            
    stosw                 
    loop won_loop
    mov ax, 4c00h
    int 21h

lost:
    mov ax, 0b800h
    mov es, ax
    mov di, (12 * 160) + (35 * 2)
    mov si, msg_lost
    mov cx, 9
lost_loop:
    lodsb                   
    mov ah, 4Fh            
    stosw                   
    loop lost_loop
    mov ax, 4c00h
    int 21h

msg_won:  db 'YOU WON'
msg_lost: db 'GAME OVER'


