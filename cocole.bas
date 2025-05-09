
	' COCODLE Coco3 Wordle port by Rick Adams
	' http://github.com/yggdrasilradio/cocole

	' Reset machine on BREAK
	pclear 1
	on brk goto 1000

	' Double speed poke
	poke &hffd9, 0

	' Init graphics
	hscreen 2
	palette 0, 0  	' 0 black
	palette 1, 63	' 1 white
	palette 2, 16 	' 2 green
	palette 3, 54	' 3 yellow
	palette 4, 7	' 4 grey
	palette 5, 31	' 5 cyan

	' Clear screen
10	hcls 0

	' Title
	hcolor 5 ' cyan
	hprint (0, 0), "COCOdle"
	hprint (27, 0), "by Rick Adams"

	' Seed the random number generator
	r = rnd(-timer)

	' Choose word
	'poke &hffd8, 0 ' slow down CPU for disk IO
	open "R", #1, "GUESS.TXT", 5
	field #1, 5 as r$
	n = lof(1)
	r = rnd(n)
	get #1, r
	w$ = r$
	close 1
	poke &hffd9, 0 ' speed up CPU

	' Alphabet guide
	hcolor 4 ' grey
	hprint (6, 3), "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	' Draw word grid
	hcolor 1
	for y = 7 to 17 step 2
		y8 = y * 8
		for x = 15 to 23 step 2
			x8 = x * 8
			hline (x8 - 3, y8 - 3)-(x8 + 9, y8 + 9), pset, b
		next x
	next y

	' Get guess
	g = 1
	hcolor 5
60	gosub 4000

	' Validate guess
	if len(g$) <> 5 then
		m$ = "Invalid"
	else
		gosub 2000
	end if
	if m$ <> "" then

		' Error beep
		sound 1, 2
		goto 60

	end if

	' Evaluate guess
	g2$ = g$
	w2$ = w$
	r$ = "44444" ' all grey

	' Right letter, right position
	for i = 1 to 5
		c1$ = mid$(g2$, i, 1)
		c2$ = mid$(w2$, i, 1)
		if c1$ = c2$ then
			mid$(r$, i, 1) = "2" ' green
			mid$(g2$, i, 1) = "."
			mid$(w2$, i, 1) = " "
		end if
	next

	' Right letter, wrong position
	for i = 1 to 5
		c1$ = mid$(g2$, i, 1)
		for j = 1 to 5
			c2$ = mid$(w2$, j, 1)
			if c1$ = c2$ then
				mid$(r$, i, 1) = "3" ' yellow
				mid$(g2$, i, 1) = "."
				mid$(w2$, j, 1) = " "
			end if
		next
	next

	' Update display
90	for i = 1 to 5

		' Draw character in grid cell
		c$ = mid$(g$, i, 1)
		c = val(mid$(r$, i, 1))
		x = i * 2 + 13
		y = g * 2 + 5
		x8 = x * 8
		y8 = y * 8
		hcolor c
		hline (x8 - 2, y8 - 2)-(x8 + 8, y8 + 8), pset, bf
		hcolor 0
		hprint (x, y), c$

		' Update alphabet guide
		poke &hf015, &h21 ' Make HPRINT destructive
95		if instr(w$, c$) > 0 then
			hcolor 1 ' white
			hprint (6 + asc(c$) - asc("A"), 3), c$ 
		else
			hprint (6 + asc(c$) - asc("A"), 3), " "
		end if
		poke &hf015, &haa ' Make HPRINT nondestructive

	next

	hcolor 5 ' cyan

	' Did the user win yet?
	if g$ = w$ then
		m$ = "You won in" + str$(g) + " guesses!"
		hprint (10, 21), m$
		gosub 5000
		goto 10
	end if

	' Did the user lose yet?
	if g = 6 then
		m$ = "The word was " + w$
		hprint (10, 21), m$
		gosub 5000
		goto 10
	end if

	' Next guess
	g = g + 1
	goto 60

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b

	' Validate guess
2000	'poke &hffd8, 0 ' slow down CPU for disk IO
	f$ = "GUESS.TXT"
	gosub 3000
	if m$ <> "" then
		f$ = "WORDS.TXT"
		gosub 3000
	end if
	poke &hffd9, 0 ' speed up CPU
	return

	' Binary search through word list
3000	m$ = ""
	open "R", #1, f$, 5
	field #1, 5 as r$
	lo = 1
	hi = lof(1)
3010	r = lo + int((hi - lo) / 2)
	get #1, r
	if g$ = r$ then
		close 1
		return
	end if
	if g$ > r$ then
		lo = r + 1
	end if
	if g$ < r$ then
		hi = r - 1
	end if
	if lo <= hi then
		goto 3010
	end if
	close 1
	m$ = "Invalid"
	return

	' Handle string input
4000	g$ = ""
	poke &hf015, &h21 ' Make HPRINT destructive
	for i = 15 to 23 step 2
		hprint (i, 5 + (g * 2)), " "
	next i
	palette 7, 0
	hcolor 7 ' flash
	hprint (15, 5 + (g * 2)), chr$(127) ' initial cursor
	t = 0
4010	c$ = inkey$
	t = (t + 1) and &hff	' blink cursor
	if (t and 16) > 0 then
		palette 7, 0
	else
		palette 7, 31
	end if
	if c$ = "" then
		goto 4010
	end if
	c = asc(c$)
	if c >= asc("A") and c <= asc("Z") and len(g$) < 5 then
		g$ = g$ + c$
	end if
	n = len(g$)
	n2 = n * 2
	r = g * 2 + 5
	if c = 8 and n > 0 then	' backspace
		n = n - 1
		n2 = n2 - 2
		g$ = left$(g$, n)
		hprint (15 + n2, r), " "
		hprint (17 + n2, r), " "
	end if
	if c = 13 then ' enter
		for i = 15 to 23 step 2
			hprint (i, 5 + (g * 2)), " "
		next i
		poke &hf015, &haa ' Make HPRINT nondestructive
		return
	end if
	if n > 0 then
		hcolor 5 ' cyan
		hprint (13 + n2, r), right$(g$, 1) ' echo character
	end if
	if n < 5 then
		hcolor 7 ' flash
		hprint (15 + n2, r), chr$(127) ' cursor
	end if
	goto 4010

	' Play again?
5000 	hprint (6, 23), "Press any key to play again"
	exec &hadfb
	c$ = inkey$
	return
