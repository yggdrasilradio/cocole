1PCLEAR1:ONBRKGOTO1000:WIDTH40:PALETTE0,0:PALETTE8,63:PALETTE9,22:PALETTE10,54:PALETTE11,7:PALETTE12,31:CLS1:LOCATE0,0:ATTR4,0:PRINT"COCOLe":R=RND(-TIMER)
10OPEN"R",#1,"GUESS.TXT",5:FIELD#1,5AS R$:N=LOF(1):R=RND(N):GET#1,R:W$=R$:CLOSE1:G=1
60LOCATE0,2:PRINTG;"/ 6";:INPUTG$:LOCATE8,2:PRINT:LOCATE0,15:PRINT:IFLEN(G$)<>5 THENM$="That is not a valid word" ELSEGOSUB2000
61LOCATE0,4:PRINTM$:IFM$<>"" THENGOTO60
62LOCATE10,G+5:FORI=G TO6:PRINT:NEXTI:LOCATE10,G+5:FORI=1TO5:C1$=MID$(G$,I,1):ATTR3,0:FORJ=1TO5:C2$=MID$(W$,J,1):IFC2$=C1$AND I=J THENATTR1,0
63IFC2$=C1$AND I<>J THENATTR2,0
64NEXTJ:PRINTC1$;:NEXTI:ATTR4,0:PRINT:IFG$=W$ THENLOCATE0,15:PRINT"You won in";G;"guesses!":GOTO10
65IFG=6 THENLOCATE0,15:PRINT"You did not guess correctly":GOTO10
66G=G+1:GOTO60
1000POKE&H71,0:EXEC&H8C1B
2000F$="GUESS.TXT":GOSUB3000:IFM$<>"" THENF$="WORDS.TXT":GOSUB3000
2001RETURN
3000M$="":OPEN"R",#1,F$,5:FIELD#1,5AS R$:LO=1:HI=LOF(1)
3010R=LO+INT((HI-LO)/2):GET#1,R:IFG$=R$ THENCLOSE1:RETURN
3011IFG$>R$ THENLO=R+1
3012IFG$<R$ THENHI=R
3013IFLO<>HI THENGOTO3010
3014CLOSE1:M$="That is not a valid word":RETURN
