all: cocole

cocole: cocole.bas
	decbpp < cocole.bas > /tmp/cocole.bas
	decb copy -tr /tmp/cocole.bas /media/share1/COCO/drive0.dsk,COCOLE.BAS
	decb copy -ral3 words.txt /media/share1/COCO/drive0.dsk,WORDS.TXT
	cp /tmp/cocole.bas redistribute
	cp words.txt redistribute
	rm -f redistribute/cocole.dsk
	decb dskini redistribute/cocole.dsk
	decb copy -tr /tmp/cocole.bas redistribute/cocole.dsk,COCOLE.BAS
	decb copy -ral3 words.txt redistribute/cocole.dsk,WORDS.TXT
	cat /tmp/cocole.bas
	rm -f /tmp/cocole.bas
