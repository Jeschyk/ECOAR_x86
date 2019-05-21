program: setcolor.o moveto.o lineto.o graph_io.o
	gcc -m32 -o program setcolor.o moveto.o lineto.o graph_io.o -lm
setcolor.o: setcolor.asm
	nasm -f elf32 -o setcolor.o setcolor.asm
moveto.o: moveto.asm
	nasm -f elf32 -o moveto.o moveto.asm
lineto.o: lineto.asm
	nasm -f elf32 -o lineto.o lineto.asm
graph_io.o : graph_io.c
	gcc -m32 -c graph_io.c -o graph_io.o -fpack-struct

