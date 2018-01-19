COMPILE
========

gcc -c ecrypt-sync.c

gcc -c trivium.c

gcc ecrypt-sync.o trivium.o ecrypt-test.c -o trivium


RUN
========

trivium.exe [QTD] [KEY DEC 1] ... [KEY DEC 10] [IV DEC 1] ... [IV DEC 10] > [Out File]


	[QTD] 		= amount of 32 bits set (in hexa format) to be generated.

	[KEY DEC] 	= decimal representation of n_th byte of the Key (range of 0-255).

	[IV DEC] 	= decimal representation of n_th byte of the IV (range of 0-255).

	[Out File] 	= name of output file.
