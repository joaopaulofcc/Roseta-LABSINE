COMPILE
========

gcc -c ecrypt-sync.c

gcc -c grain.c

gcc ecrypt-sync.o grain.o ecrypt-test.c -o grain


RUN
========

grain.exe [QTD] [KEY DEC 1] ... [KEY DEC 10] [IV DEC 1] ... [IV DEC 8] > [Out File]


	[QTD] 		= amount of 8 bits set (in hexa format) to be generated.

	[KEY DEC] 	= decimal representation of n_th byte of the Key (range of 0-255).

	[IV DEC] 	= decimal representation of n_th byte of the IV (range of 0-255).

	[Out File] 	= name of output file.
