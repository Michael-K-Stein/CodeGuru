CS_OFFSET equ -0x01
COCAINE_LINES equ 2
GAP equ 0x0F00

@start:

;Copy the recusive thing into the stack segment
push es
push ss
pop es
mov cx, (@END_Area_To_Copy-@Area_To_Copy)/2
mov si, ax
add si, @Area_To_Copy
rep movsw

MOV dx, cs
add dx, CS_OFFSET
push dx
pop ds


PUSH dx
mov dx,ax
add dx, @AfterCSFuckery-(CS_OFFSET*16)
PUSH dx

; Change AX so that we don't hit the first line
and ax, 0xc000
add ax, GAP + (GAP*3)-0x0600 - 0x0100


mov bh, ah
mov word [bx - GAP +0x03 + 0xA0], 0x18FF
mov word [bx - GAP +0x01 + 0xA0], 0xEC29

RETF

@AfterCSFuckery:
mov al, 0xA1
sub ax, GAP

push ds
push es
pop ds

mov bx,100h
mov [bx+2],cs
mov [bx],ax

pop es

push cs
pop ss

mov sp,ax
add sp, GAP + 0x0a00

xor si,si
mov di,ax
inc di
mov cx, (@END_Area_To_Copy1_mid-@Area_To_Copy1)/2

;mov ax, 0x1FFF
mov ax, 3
mov bp, 0x24

jmp [bx]

@call_far:
sub sp, bp
call far [bx]



@end:


@Area_To_Copy:
@Area_To_Copy1:

REP movsw
sub di, (@END_Area_To_Copy1_mid-@Area_To_Copy1) +2 + (GAP*3) - 0x0600
mov word [bx], di
movsw
movsw
sub di,ax
mov cl, (@END_Area_To_Copy2_mid-@Area_To_Copy2)/2
dec bp
jmp [bx]

@END_Area_To_Copy1_mid:
nop
sub sp, bp
call far [bx]

@Area_To_Copy2:
REP movsw
sub di, (@END_Area_To_Copy2_mid-@Area_To_Copy2) +2 + GAP + 0x0A00
mov word [bx], di
movsw
movsw
sub di,ax
mov cl, (@END_Area_To_Copy1_mid-@Area_To_Copy1)/2
inc bp
xor si,si
jmp [bx+si]

@END_Area_To_Copy2_mid:
nop
sub sp,bp
call far [bx+si]

@END_Area_To_Copy:
