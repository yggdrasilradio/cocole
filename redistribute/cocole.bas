1PCLEAR1:ONBRKGOTO1000:POKE&HFFD9,0:HSCREEN2:PALETTE0,0:PALETTE1,63:PALETTE2,22:PALETTE3,54:PALETTE4,7:PALETTE5,31
10HCLS0:HCOLOR1:HPRINT(0,0),"COCOdle":HCOLOR5:HPRINT(27,0),"by Rick Adams":R=RND(-TIMER):OPEN"R",#1,"GUESS.TXT",5:FIELD#1,5AS R$:N=LOF(1):R=RND(N):GET#1,R:W$=R$:CLOSE1:HCOLOR4:HPRINT(6,3),"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
11HCOLOR1:FORY=7TO17STEP2:FORX=15TO23STEP2:HLINE(X*8-3,Y*8-3)-(X*8+9,Y*8+9),PSET,B:NEXTX:NEXTY:HCOLOR5:G=1
60GOSUB4000:IFLEN(G$)<>5 THENM$="Invalid" ELSEGOSUB2000
61IFM$<>"" THENSOUND1,2:GOTO60
62FORI=1TO5:C$=MID$(G$,I,1):C=4:S$=W$:FORJ=1TO5:C1$=MID$(W$,J,1):C2$=MID$(S$,J,1):IFC1$=C$AND I=J THENC=2
63IFC2$=C$AND I<>J AND C<>2 THENC=3:MID$(S$,J)=" "
64NEXTJ:X=I*2+13:Y=G*2+5:HCOLORC:HLINE(X*8-2,Y*8-2)-(X*8+8,Y*8+8),PSET,BF:HCOLOR0:HPRINT(X,Y),C$:POKE&HF015,&H21:IFC=4 THENHPRINT(6+ASC(C$)-ASC("A"),3)," " ELSEHCOLOR1:HPRINT(6+ASC(C$)-ASC("A"),3),C$
65POKE&HF015,&HAA:NEXTI:HCOLOR5:IFG$=W$ THENM$="You won in"+STR$(G)+" guesses!":HPRINT(10,21),M$:GOSUB5000:GOTO10
66IFG=6 THENM$="The word was "+W$:HPRINT(10,21),M$:GOSUB5000:GOTO10
67G=G+1:GOTO60
1000POKE&H71,0:EXEC&H8C1B
2000POKE&HFFD8,0:F$="GUESS.TXT":GOSUB3000:IFM$<>"" THENF$="WORDS.TXT":GOSUB3000
2001POKE&HFFD9,0:RETURN
3000M$="":OPEN"R",#1,F$,5:FIELD#1,5AS R$:LO=1:HI=LOF(1)
3010R=LO+INT((HI-LO)/2):GET#1,R:IFG$=R$ THENCLOSE1:RETURN
3011IFG$>R$ THENLO=R+1
3012IFG$<R$ THENHI=R
3013IFLO<>HI THENGOTO3010
3014CLOSE1:M$="Invalid":RETURN
4000G$="":POKE&HF015,&H21:FORI=15TO23STEP2:HPRINT(I,5+(G*2))," ":NEXTI:PALETTE7,0:HCOLOR7:HPRINT(15,5+(G*2)),CHR$(127):T=0
4010C$=INKEY$:T=(T+1)AND&HFF:IF(T AND16)>0 THENPALETTE7,0 ELSEPALETTE7,31
4011IFC$="" THENGOTO4010
4012C=ASC(C$):IFC>=ASC("A")AND C<=ASC("Z")AND LEN(G$)<5 THENG$=G$+C$
4013N=LEN(G$):N2=N*2:R=G*2+5:IFC=8AND N>0 THENN=N-1:N2=N2-2:G$=LEFT$(G$,N):HPRINT(15+N2,R)," ":HPRINT(17+N2,R)," "
4014IFC=13 THENFORI=15TO23STEP2:HPRINT(I,5+(G*2))," ":NEXTI:POKE&HF015,&HAA:RETURN
4015IFN>0 THENHCOLOR5:HPRINT(13+N2,R),RIGHT$(G$,1)
4016IFN<5 THENHCOLOR7:HPRINT(15+N2,R),CHR$(127)
4017GOTO4010
5000HPRINT(6,23),"Press any key to play again":EXEC&HADFB:C$=INKEY$:RETURN
