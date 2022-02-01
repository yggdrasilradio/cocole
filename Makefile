all: cocole

cocole: cocole.bas
	decbpp < cocole.bas > /tmp/cocole.bas
	decb copy -tr /tmp/cocole.bas /media/share1/COCO/drive0.dsk,COCOLE.BAS
	decb copy -ral3 words.txt /media/share1/COCO/drive0.dsk,WORDS.TXT
	cp /tmp/cocole.bas redistribute
	cp words.txt redistribute
	cat /tmp/cocole.bas
	rm -f /tmp/cocole.bas
