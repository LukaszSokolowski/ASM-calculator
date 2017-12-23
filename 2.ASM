org 100h

	start:
		MOV  DX, info
 		PUSH DX
		CALL show

		MOV  DX, ent1
		PUSH DX
		CALL show
		
		MOV CX, 0

      pushloop:
		MOV AH, 1
		INT 21H
		
		CMP AL, 13
		JE poploop
		
		CMP AL, 48
		JL koniec
		
		CMP AL, 57
		JG koniec

		INC CX
		MOV [st_count], CX
				
		SUB  AL, 48
		XOR  AH, AH
		PUSH AX

		JMP pushloop	

		
       poploop:

		POP BX
		XOR BH, BH
		MOV [digit], BX
        
		XOR AX, AX
		MOV AX, [mnoznik]
		MUL BX
        
		ADD [temp], AX 
        
		MOV BX, 10
		XOR BH, BH
		MOV AX, [mnoznik]
		MUL BX
		MOV [mnoznik], AX
	
        loop poploop
		
;--------------------------------Koniec---------------------------
	koniec:

		MOV  DX, ent1
		PUSH DX
		CALL show

		MOV  DX, progEnd
		PUSH DX
		CALL show

		MOV AH, 2
		MOV DL, [temp]
		INT 21H
		
		MOV AX, 4C00H
		INT 21H
	
;--------------------------------Zmienne--------------------------
info	 db   "Podaj liczbe.$"
progEnd  db   "Koniec.$"
ent1     db   10,13,36
st_count db   0
temp	 dw   0
liczba1  dw   0
liczba2  dw   0	
mnoznik  db   1
digit    dw   0


;-------------------------Wypisywanie-znakow-----------------------
 show:   
    	POP  AX
   	POP  BX
    	PUSH AX
    	MOV  CX, 0

    showloop:
       		MOV SI, CX
        	MOV DL, [BX + SI]
        	CMP DL, 36
        	JE  showEND
		MOV AH, 2
        	INT 21H
        	INC CX
        	JMP showloop
     showEND:
RET
;------------------------------------------------------------------