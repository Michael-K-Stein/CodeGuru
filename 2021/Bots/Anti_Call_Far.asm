jmp @act

@start:
add ax,@call_far-@start


push es
pop ds

mov bx,50h
mov [bx+2],cs
mov [bx],ax

push cs
pop ss

mov sp,ax
mov si, 0x15

@call_far:
sub sp, si
call far [bx]

@act:
push ds
push es
pop ds
mov [bx], ax
pop ds



mov dx, 0xCCCC
mov cl, 0x04
mov di, ax
add di, @end + 0x48

@loop:
@internalLoop:
mov bx, [di] ; Read from board
mov [bx-2], dx ; Kill the read IP
inc di
mov bx, [di] ; Read from board
mov [bx-2], dx ; Kill the read IP
inc di
mov bx, [di] ; Read from board
mov [bx-2], dx ; Kill the read IP
inc di
mov bx, [di] ; Read from board
mov [bx-2], dx ; Kill the read IP
inc di


@OutinternalLoop:
mov cl, 0x4
sub di, cx
;add di, 0x0FC ; Move to next row
jmp @loop

@end:
