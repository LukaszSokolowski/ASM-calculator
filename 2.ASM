			    ORG 100H
;----------------------------START------------------------------
	start:   
		MOV  DX, info
		PUSH DX
		CALL show
		
		CALL input
		CALL clear1

		MOV  DX, info
		PUSH DX
		CALL show

		CALL input
		CALL clear2

		MOV  DX, info1
		PUSH DX
		CALL show

		CALL operat

;--------------------------------Koniec---------------------------
	koniec:
		MOV  DX, ent1
		PUSH DX
		CALL show

		MOV  DX, progEnd
		PUSH DX
		CALL show

		MOV AH, 2
		MOV DL, [liczba1]
		INT 21H

		MOV AH, 2
		MOV DL, [liczba2]
		INT 21H
		
		MOV AX, 4C00H
		INT 21H
	
;--------------------------------Zmienne--------------------------
info	 db   "Podaj liczbe: $"
progEnd  db   "Koniec.$"
info1    db   "Podaj operacje jaka chcesz wykonac na liczbach: $"
ent1     db   10,13,36
st_count db   0
temp	 dw   0
liczba1  dw   0
liczba2  dw   0	
mnoznik  db   1
digit    dw   0
sp_init  dw   0
opChar   db   0
result   dw   0
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
;----------------------------Wejscie----------------------------------

input:
        POP AX
	MOV [sp_init], AX
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
	
		MOV AX, [sp_init]
		PUSH AX
		MOV AX, 1
		MOV [mnoznik], AX
		XOR AX, AX
		XOR BX, BX
		
  RET

;---------------------------CLEAR-1-------------------------
  clear1:
            POP AX
            MOV [sp_init], AX

                MOV  AX,        [temp]
                MOV  [liczba1], AX
                XOR  AX,        AX
                MOV  [temp],    AX

            MOV  AX, [sp_init]
            PUSH AX
  RET
;---------------------------CLEAR-2-------------------------  
  clear2:      
            POP AX
            MOV [sp_init], AX

                MOV  AX,        [temp]
                MOV  [liczba2], AX
                XOR  AX,        AX
                MOV  [temp],    AX

            MOV  AX, [sp_init]
            PUSH AX
 RET
;------------------------------------------------------------
operat:
	POP AX
	MOV [sp_init], AX
		
	MOV AH, 1
	INT 21H

	CMP AL, '+'
	JE  _add
	
	CMP AL, '-'
	JE  _sub

	CMP AL, '*'
	JE  _mul

	CMP AL, '/'
	JE  _div

	CMP AL, ':'
	JE  _div

_add:

	JMP endOper
_sub:

	JMP endOper
_mul:

	JMP endOper

_div:
	JMP endOper
	
	
 endOper:	

	MOV  AX, [sp_init]
	PUSH AX

RET