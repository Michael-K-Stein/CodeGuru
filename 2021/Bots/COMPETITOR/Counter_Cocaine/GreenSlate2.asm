CS_OFFSET equ 0x01
COCAINE_LINES equ 2
GAP equ 0x0400

@start:

;Copy the recusive thing into the extra segment
mov cx, (@END_Area_To_Copy-@Area_To_Copy)/2
mov si, ax
add si, @Area_To_Copy
mov di, (@END_Area_To_Copy-@Area_To_Copy)
rep movsw
xor di,di

MOV dx, cs
add dx, CS_OFFSET
push dx
pop ds


PUSH dx
mov dx,ax
add dx, @AfterCSFuckery-(CS_OFFSET*16)
PUSH dx

; Change AX so that we don't hit the first line
and ax, 0xF000
add ax, (2 * GAP) - 0x0100


mov bh, ah
mov word [bx - GAP +0x03 + 0xA0], 0x1FFF
;mov word [bx - GAP +0x03 + 0xA0 + (CS_OFFSET*16)], 0xEC29

RETF

@AfterCSFuckery:
mov al,0xA3
sub ax, GAP

push ds
push es
pop ds

mov bx,60h
mov [bx+2],cs
mov [bx],ax

pop es

push cs
pop ss

mov sp,ax
add sp, GAP

xor si,si
mov di,ax
inc di
mov cx, (@END_Area_To_Copy-@Area_To_Copy)/2

mov ax, 0x1FFF
mov bp, 0x24

mov dx, (@END_Area_To_Copy-@Area_To_Copy)
mov si,dx

jmp [bx]

@call_far:
sub sp, bp
call far [bx]



@end:


@Area_To_Copy:

REP movsw
add sp, 3*GAP
add di, 2*GAP - (@END_Area_To_Copy-@Area_To_Copy) - 3
mov word [bx], di
stosw
dec di
mov si,dx
mov cl, (@END_Area_To_Copy-@Area_To_Copy)/2

jmp [bx]

@END_Area_To_Copy:
