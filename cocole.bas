
	' COCODLE Wordle clone by Rick Adams http://github.com/yggdrasilradio/cocole

	' Reset machine on BREAK
	pclear 1
	on brk goto 1000

	' Double speed poke
	poke &hffd9, 0

	' Init graphics
	hscreen 2
	palette 0, 0  	' 0 black
	palette 1, 63	' 1 white
	palette 2, 22	' 2 green
	palette 3, 54	' 3 yellow
	palette 4, 7	' 4 grey
	palette 5, 31	' 5 cyan

	' X position of input field
	lm = 17

	' Clear screen
10	hcls 0

	' Title
	hcolor 5 ' cyan
	hprint (0, 0), "COCOdle"

	' Error line
	' We flip palette 6 between black and cyan to show/hide this line
	' Think of it as "disappearing ink"
	palette 6, 0
	hcolor 6
	hprint (0, 4), "That is not a valid word"

	' Seed the random number generator
	r = rnd(-timer)

	' Choose word
	open "R", #1, "GUESS.TXT", 5
	field #1, 5 as r$
	n = lof(1)
	r = rnd(n)
	get #1, r
	w$ = r$
	close 1

	' Draw word grid
	hcolor 1
	for y = 8 to 18 step 2
		for x = 15 to 23 step 2
			hline (x * 8 - 3, y * 8 - 3)-(x * 8 + 9, y * 8 + 9), pset, b
		next x
	next y
	hcolor 5

	' Get guess
	g = 1
60	gosub 4000

	' Clear error line
	palette 6, 0 ' black

	' Validate guess
	if len(g$) <> 5 then
		m$ = "Invalid"
	else
		gosub 2000
	end if
	if m$ <> "" then

		' Show error line
		palette 6, 31 ' cyan
		goto 60

	end if

	' Evaluate guess
	for i = 1 to 5

		' Which color?
		c1$ = mid$(g$, i, 1)
		c = 4 ' grey
		for j = 1 to 5
			c2$ = mid$(w$, j, 1)
			if c2$ = c1$ and i = j then
				c = 2 ' green
			end if
			if c2$ = c1$ and i <> j and c <> 2 then
				c = 3 ' yellow
			end if
		next j

		' Draw character in grid cell
		x = i * 2 + 13
		y = g * 2 + 6
		hcolor c
		hline (x * 8 - 2, y * 8 - 2)-(x * 8 + 8, y * 8 + 8), pset, bf
		hcolor 0
		hprint (x, y), c1$

	next i
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
		m$ = "The word was " + w$ ' 13 + 5 = 18
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
2000	poke &hffd8, 0 ' slow down CPU (who am I kidding, nobody's gonna use this with actual disk drives)
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
		hi = r
	end if
	if lo <> hi then
		goto 3010
	end if
	close 1
	m$ = "Invalid"
	return

	' Handle string input
4000	g$ = ""
	poke &hf015, &h21 ' Make HPRINT destructive
4010	c$ = inkey$
	if c$ = "" then
		goto 4010
	end if
	c = asc(c$)
	if c >= asc("A") and len(g$) < 5 then
		g$ = g$ + c$
	end if
	n = len(g$)
	if c = 8 and n > 0 then	' backspace
		n = n - 1
		g$ = left$(g$, n)
		hprint (lm + n, 0), "  "
	end if
	if c = 13 then		' enter
		hprint (lm, 0), "      "
		poke &hf015, &haa ' Make HPRINT nondestructive
		return
	end if
	if len(g$) > 0 then
		hprint (lm, 0), g$
	end if
	goto 4010

	' Play again?
5000 	hprint (6, 23), "Press any key to play again"
	exec &hadfb
	return
