
	' Reset machine on BREAK
	pclear 1
	on brk goto 1000

	' Init graphics
	width 40
	palette 0, 0  	' 0 black background
	palette 8, 63	' 0 white text
	palette 9, 22	' 1 green text
	palette 10, 54	' 2 yellow text
	palette 11, 7	' 3 grey text
	palette 12, 31	' 4 cyan text
	cls 1
	attr 4, 0

	locate 0, 0
	print "COCOLe"

	' Seed the random number generator
	r = rnd(-timer)

	' Choose word
10	open "R", #1, "GUESS.TXT", 5
	field #1, 5 AS r$
	n = lof(1)
	r = rnd(n)
	get #1, r
	w$ = r$
	close 1
	'print w$

	' Get guess
	g = 1
60	locate 0, 2
	print g; "/ 6";
	input g$
	locate 8, 2
	print
	locate 0, 15
	print

	' Validate guess
	if len(g$) <> 5 then
		m$ = "That is not a valid word"
	else
		gosub 2000
	end if
	locate 0, 4
	print m$
	if m$ <> "" then
		goto 60
	end if

	' Evaluate guess
	d$ = ""
	locate 10, g + 5
	for i = g to 6
		print
	next i
	locate 10, g + 5
	for i = 1 to 5
		c1$ = mid$(g$, i, 1)
		a$ = "."
		for j = 1 to 5
			c2$ = mid$(w$, j, 1)
			if c2$ = c1$ and i = j then
				a$ = "X"		
			end if
			if a$ <> "X" and c2$ = c1$ then
				a$ = "O"		
			end if
		next j
		attr 3, 0 ' grey text
		if a$ = "O" then
			attr 2, 0 ' yellow text
		end if
		if a$ = "X" then
			attr 1, 0 ' green text
		end if
		print c1$;
		attr 4,0
	next i
	print

	' Did the user win yet?
	if g$ = w$ then
		locate 0, 15
		print "You won in"; g; "guesses!"
		goto 10
	end if

	' Did the user lose yet?
	if g = 6 then
		locate 0, 15
		print "You did not guess correctly"
		goto 10
	end if

	' Next guess
	g = g + 1
	goto 60

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b

	' Validate guess
2000	m$ = ""
	open "R", #1, "WORDS.TXT", 5
	field #1, 5 AS r$
	lo = 1
	hi = lof(1)
2010	r = lo + int((hi - lo) / 2)
	get #1, r
	if g$ = r$ then
		close 1
		return
	end if
	if g$ > r$ then
		lo = r + 1
	end if
	if g$ < r$ then
		hi = r '- 1
	end if
	'print r$;lo;hi
	if lo <> hi then
		goto 2010
	end if
	m$ = "That is not a valid word"
	close 1
	return
