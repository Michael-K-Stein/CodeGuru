mov dx, 0x071e
mov ax, 0x8950

push es
push cs
pop es

int 0x87

pop es
