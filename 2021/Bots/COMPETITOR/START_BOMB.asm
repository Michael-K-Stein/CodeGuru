push es
push cs
pop es

mov cx, 0x0101

mov dx, 0xCCCC

mov si, ax
add si, @end

@anti_call_far_loop:

lodsw
cmp ax, dx
jne @kill

add si, cx


jmp @anti_call_far_loop

@kill:
mov di,si
sub di, cx
mov ax, dx
int 0x86

test cl, cl
je @continue
dec cl
add si, cx
jmp @anti_call_far_loop

@continue:

pop es

@end:
