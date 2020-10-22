@start:
add ax,@call_far-@start

push ss
pop ds


mov bx,50h
@weirdMiddle:
mov word [bx+2],0x0FFF
mov word [bx + 4], 0xFFFF
mov [bx],ax
add word [bx], @call_far-@weirdMiddle

mov dx, 0xFFF
push dx
pop es

push cs
pop ss

mov sp,ax

mov bp, 0x2B
inc si

@call_far:
sub sp, bp
call far [bx+si]


