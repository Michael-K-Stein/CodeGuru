@start:
mov si, ax
add ax,@call_far-@start

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

push ds
push es
pop ds
mov dx, [0x0]
add dx, 0x0500
mov dl, 0xA3
pop ds

push ds
push ss
pop ds
mov bx,40h
mov [bx+2],cs
mov [bx],dx
pop ds

mov ax, 0x1FFF
push ss
push ds
pop es
mov di, dx
stosw
pop ds

push cs
pop ss

add dx, 0x0300

mov sp,dx

dec di

xor si, si

; Waste 60 turns
mov cx, 0x14
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
sub sp, (0x05E8 + (@EndCopyMe - @CopyMe - 1))
mov cl, (@EndCopyMe - @CopyMe + 1)/2
mov ax, 0x1FFF
sub di, (0x0900 + (@EndCopyMe - @CopyMe) + 4)
mov dx, di
mov [bx], di
stosw
xor si, si
dec di
mov di, di
mov di, di
mov di, di
mov di, di
jmp dx
@EndCopyMe:
