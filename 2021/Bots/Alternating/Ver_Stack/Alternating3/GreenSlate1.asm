CS_OFFSET equ 0x01
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
and ax, 0x4000
add ax, GAP


mov bh, ah
mov word [bx - GAP +0x03 + 0xA0], 0x1FFF
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
add sp, GAP

xor si,si
mov di,ax
inc di
mov cx, (@END_Area_To_Copy1_mid-@Area_To_Copy1)/2

mov ax, 0x1FFF
mov bp, 0x24

jmp [bx]

@call_far:
sub sp, bp
call far [bx]



@end:


@Area_To_Copy:
@Area_To_Copy1:

REP movsw
sub di, (@END_Area_To_Copy1_mid-@Area_To_Copy1) +3 + (GAP*3) - 0x0600
mov word [bx], di
sub si,2
movsw
movsw
sub di,3
mov cl, (@END_Area_To_Copy2_mid-@Area_To_Copy2)/2
dec bp
jmp [bx]
nop

@END_Area_To_Copy1_mid:

sub sp, bp
call far [bx]

@Area_To_Copy2:
REP movsw
sub di, (@END_Area_To_Copy2_mid-@Area_To_Copy2) +1 + (0x0A00/2)
mov word [bx], di
sub si,2
movsw
dec di
mov cl, (@END_Area_To_Copy3_mid-@Area_To_Copy3)/2
inc bp
sub sp, 2
jmp [bx]
nop

@END_Area_To_Copy2_mid:

call far [bx]

@Area_To_Copy3:
REP movsw
sub di, (@END_Area_To_Copy3_mid-@Area_To_Copy3) +3 + (0x0A00/2)
mov word [bx], di
sub si,2
movsw
dec di
mov cl, (@END_Area_To_Copy4_mid-@Area_To_Copy4)/2
jmp [bx]
nop

@END_Area_To_Copy3_mid:

call far [bx]

@Area_To_Copy4:
REP movsw
sub di, (@END_Area_To_Copy4_mid-@Area_To_Copy4) +5 + GAP
mov word [bx], di
sub si,2
movsw
movsw
sub di,3
mov cl, (@END_Area_To_Copy1_mid-@Area_To_Copy1)/2
sub sp, 2
xor si,si
jmp [bx]
nop

@END_Area_To_Copy4_mid:

sub sp,bp
call far [bx]

@END_Area_To_Copy:
