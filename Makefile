all: cocole

cocole: cocole.bas
	decbpp < cocole.bas > /tmp/cocole.bas
	cp /tmp/cocole.bas redistribute
	tr -d '\r\n' < words.txt > redistribute/words.txt
	tr -d '\r\n' < guess.txt > redistribute/guess.txt
ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)", "")
	decb copy -tr /tmp/cocole.bas /media/share1/COCO/drive0.dsk,COCOLE.BAS
	decb kill /media/share1/COCO/drive0.dsk,WORDS.TXT
	decb copy -ra1 redistribute/words.txt /media/share1/COCO/drive0.dsk,WORDS.TXT
	decb kill /media/share1/COCO/drive0.dsk,GUESS.TXT
	decb copy -ra1 redistribute/guess.txt /media/share1/COCO/drive0.dsk,GUESS.TXT
endif
	rm -f redistribute/cocole.dsk
	decb dskini redistribute/cocole.dsk
	decb copy -tr /tmp/cocole.bas redistribute/cocole.dsk,COCOLE.BAS
	decb copy -ra1 redistribute/words.txt redistribute/cocole.dsk,WORDS.TXT
	decb copy -ra1 redistribute/guess.txt redistribute/cocole.dsk,GUESS.TXT
	cat /tmp/cocole.bas
	rm -f /tmp/cocole.bas
