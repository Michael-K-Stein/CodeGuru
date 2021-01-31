mov ax, 0xf8e2
mov dx, 0x8346

push es
push cs
pop es

int 0x87

pop es
