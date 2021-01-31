mov ax, 0x1e07
mov dx, 0x5089

push es
push cs
pop es

int 0x87

pop es
