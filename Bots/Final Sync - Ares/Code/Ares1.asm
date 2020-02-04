@start:
mov si, ax

xor ax, ax
xor dx, dx

mov di, 0x2060

push es
push ds
pop es

int 86h
int 86h

pop es

mov word [0xDFE7], 0xB8 ; Then the zombie jumps to 0xDFE7
mov word [0xDFE8], si ; So we put the order 'mov ax, {my ax}'
add word [0xDFE8], @ZStart ; Then we add some offset to that original {ax}
mov word [0xDFEA], 0xE0FF ; add then we put 'jmp ax'

mov [si + @ZStart - 2], ss

xor di, di
mov ax, si

add ax, @call_far-@start
sub ah, 0x01

push ds
push es
pop ds
mov [0x0], ax
pop ds

push es
push ss
pop es
mov dx, sp
add si, @CopyMe
mov cl, 0Dh
mov cx, (@EndCopyMe - @CopyMe + 1)/2
rep movsw
mov sp, dx
pop es

mov dx, ax
mov dl, 0xA3

mov ax, 0x1FFF
push ss
push es
push ds
pop es
mov di, dx
stosw
pop es
pop ds
mov bx,50h
mov [bx+2],cs
mov [bx],dx
push cs
pop es

push cs
pop ss

add dx, 0x0300

mov sp,dx

dec di

xor si, si

; Waste 40 turns
mov cx, 0x0D
@DumbLoop:
dec cx
jcxz @EndDumbLoop
jmp @DumbLoop

@EndDumbLoop:
mov cl, (@EndCopyMe - @CopyMe + 1)/2

@call_far:
call far [bx]

@CopyMe:
rep movsw
sub sp, (0x05E8 + (@EndCopyMe - @CopyMe - 1) -8h)
mov cl, (@EndCopyMe - @CopyMe + 1)/2
mov ax, 0x1FFF
sub di, (0x0900 + (@EndCopyMe - @CopyMe) + 4)
mov dx, di
mov [bx], di
stosw
xor si, si
dec di
;mov word [di-0x0134], 0xCCCC
mov di, di
mov di, di
mov di, di
mov di, di
jmp dx
@EndCopyMe:

db 0x00 ; Placeholder, Zombies will use this to set their position
db 0x00

@ZStart:
mov si, ax
add ax, @Zcall_far-@ZStart
push ss
pop bx
xchg bx, ax
sub ax, [si - 2]
mov cx, 0x000A
mul cx
add bx, ax

push es
push ss
pop es
mov dx, sp
add si, (@ZCopyMe-@ZStart)
mov cl, 0Dh
mov cx, (@ZEndCopyMe - @ZCopyMe + 1)/2
rep movsw
mov sp, dx
pop es

sub bh, 0x36
mov bl, 0xA3

mov ax, 0x1FFF
push ss
push es
push ds
pop es
mov di, bx
stosw
pop es
pop ds
mov dx, bx
mov bx,50h
mov [bx+2],cs
mov [bx],dx
push cs
pop es

push cs
pop ss

add dx, (0x0300)

mov sp,dx

dec di

xor si, si

mov cl, (@ZEndCopyMe - @ZCopyMe + 1)/2

mov ax, 0x0240 ; Repeates until death - should be around 0x0140

@Zcall_far:
call far [bx]

@ZCopyMe:
rep movsw
sub sp, (0x05E8 + (@ZEndCopyMe - @ZCopyMe - 1) - 8h)
mov cx, ax
mov ax, 0x1FFF
sub di, (0x0900 + (@ZEndCopyMe - @ZCopyMe) + 4h)
mov dx, di
mov [bx], di
stosw
@Death:
mov ax, cx
xor si, si
dec ax
jz short (@Death+1)
mov cx, (@ZEndCopyMe - @ZCopyMe + 1)/2
dec di
jmp dx
@ZEndCopyMe:
