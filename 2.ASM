			    ORG 100H
;----------------------------START------------------------------
	start:   
		MOV  DX, info	;Przenies do rejestru DX adres zmiennej info
		PUSH DX		;Wrzuc adres zmiennej na stos
		CALL show	;Wywolanie procedury wyswietlania znakow
		
		CALL input	;Procedura wprowadzania cyfr
		CALL clear1	;Procedura przypisania zmiennej

		MOV  DX, info	;Przenies do rejestru DX adres zmiennej info
		PUSH DX		;Wrzuc adres na stos
		CALL show	;Wywolanie procedury wyswietlajacej

		CALL input	;Procedura wprowadzania cyfr
		CALL clear2	;Procedura przypisania liczby

		MOV  DX, info1	;Przenies do DX adres zmiennej info1
		PUSH DX		;Wrzuc adres na stos
		CALL show	;Wywolaj funkcje wyswietlajaca znaki

		CALL operat	;Procedura wyboru operacji matematycznej

		MOV  DX, ent1	;Do DX adres zmiennej odpowiadajacej za enter
		PUSH DX		;Wrzuc na stos
		CALL show	;Wyswietl za pomoca metody
		
		MOV  DX, info2	;Adres zmiennej info2 do DX
		PUSH DX		;Wrzuc DX na stos
		CALL show	;Procedura wyswietlajaca

		CALL showRes	;Procedura wyswietlajaca wynik

		MOV  DX, ent1	;Adres zmiennej ent1 do DX
		PUSH DX		;Adres na stos
		CALL show	;Wyswietl

		MOV  DX, progEnd ;Do DX adres zmiennej z podziekowaniem
		PUSH DX		;Wrzuc na stos
		CALL show	;Wyswietl

;--------------------------------Koniec---------------------------
	koniec:	
		MOV AX, 4C00H	;Przekazanie sterowania do systemu (program STOP)
		INT 21H		;Przerwanie DOS
;--------------------------------Zmienne--------------------------
info	 db   "Podaj liczbe: $"
progEnd  db   "Dziekuje bardzo.$"
info1    db   "Podaj operacje jaka chcesz wykonac na liczbach: $"
info2    db   "Wynik to: $"
info3    db   "Podano bledne dane.$"
ent1     db   10,13,36
st_count db   0
temp	 dw   0
liczba1  dw   0
liczba2  dw   0	
mnoznik  dw   1
adr_init dw   0
opChar   db   0
result   dw   0
digit    dw   0
;-------------------------Wypisywanie-znakow-----------------------
 show:   
    	POP  AX		;Zrzuc adres powrotu
   	POP  BX		;Zrzuc adres zmiennej do wyswietlenia
    	PUSH AX		;Wrzuc adres powrotu
    	MOV  CX, 0	;Przenies do CX wartosc 0

    showloop:
       		MOV SI, CX		;Do rejestru SI przenies wartosc CX
        	MOV DL, [BX + SI]	;Do DL przenies kolejny znak wedrujac rejestrem SI od bazowego BX
        	CMP DL, 36		;Porownaj czy to znak dolara
        	JE  showEND		;Jesli tak koniec wyswietlania lancucha
		MOV AH, 2		;Zaladuj AH wartoscia 2 czyli wypisanie znaku z DL
        	INT 21H			;Przerwanie DOS
        	INC CX			;Zwieksz o 1 wartosc CX
        	JMP showloop		;Przejdz do kolejnego kroku
     showEND:
RET
;----------------------------Wejscie----------------------------------

input:
        POP AX				;Zrzuc adres powrotu
	MOV [adr_init], AX		;Przenies adres do AX
	MOV CX, 0			;Wyzeruj licznik
    
    pushloop:
       		MOV AH, 1		;Wczytanie znaku z wejscia
        	INT 21H			;Przerwanie DOS
        
       		CMP AL, 13		;Porownaj czy enter
       		JE poploop		;Jesli tak przejdz do zrzucania
        
        	CMP AL, 48		;Sprawdz czy mniejsze od cyfr w ascii
        	JL _error		;Jesli tak to koniec
        	
        	CMP AL, 57		;Sprawdz czy wieksze od znakow cyfr ascii
        	JG _error		;Jesli tak to koniec
 
        	INC CX			;Mamy cyfre wiec zwieksz CX
        	MOV [st_count], CX	;Przenies do zmiennej przechowujacej ilosc liczb na stosie wartosc CX
                
        	SUB  AL, 48		;Odejmij od znaku 48 tak aby uzyskac odpowiadajaca jemu cyfre
        	XOR  AH, AH		;Wyzeruj gore rejestru AX
        	PUSH AX			;Wrzuc AX na stos

        	JMP pushloop		;Kolejny krok petli
        
       poploop:

        	POP BX			;Zdejm cyfre ze stosu
        	XOR BH, BH		;Wyzeruj gore rejestru BX
        	MOV [digit], BX		;Przenies cufre do zmiennej
        
        	XOR AX, AX		;Wyzeruj AX 
        	MOV AX, [mnoznik]	;Przenies do AX wartosc mnoznika
        	MUL BX			;Pomnoz AX razy BX wynik w DX:AX
        
        	ADD [temp], AX 		;Dodaj do zmiennej tymczasowej kolejna wartosc
        
        	MOV BX, 10		;Zaladuj rejestr BX wartoscia 10
        	XOR BH, BH		;Wyzeruj gore BX
        	MOV AX, [mnoznik]	;Przenies do AX wartosc mnoznika
        	MUL BX			;Z kazdym kolejnym zdjeciem ze stosu mnoznik wzrasta x 10 po 
        	MOV [mnoznik], AX	;Przenies mnoznik do zmiennej 
    
        	loop poploop		;Wykonuj petle

       	        MOV AX, [adr_init]    	;Przenies do AX adres powrotu procedury
		PUSH AX		        ;Wrzuc adres powrotu na stos
		XOR AX, AX		;Wyzeruj AX
		MOV AX, 1		;Przenies do AX wartosc poczatkowa mnoznika
		MOV [mnoznik], AX	;Do zmiennej mnoznik przenies jego wartosc poczatkowa
		XOR AX, AX		;Wyzeruj AX
		XOR BX, BX		;Wyzeruj BX
		
  RET

;---------------------------CLEAR-1----------------------------
  clear1:
            POP AX		;Zdejmij ze stosu adres powrotu procedury
            MOV [adr_init], AX	;Przenies adres powrotu do zmiennej

                MOV  AX,        [temp]		;Przenies do AX zmienna tymczasowa
                MOV  [liczba1], AX		;Przydziel wartosc zmiennej temp do zmiennej liczba1
                XOR  AX,        AX		;Wyczysc AX
                MOV  [temp],    AX		;Wyczysc temp

            MOV  AX, [adr_init]	;Zaladuj do AX adres powrotu
            PUSH AX		;Wrzuc adres powrotu na stos
  RET
;---------------------------CLEAR-2----------------------------  
  clear2:      
            POP AX		;Zrzuc adres procedury ze stosu
            MOV [adr_init], AX	;Przenies adres procedury do zmiennej

                MOV  AX,        [temp]		;Wartosc zmiennej tymczasowej do AX
                MOV  [liczba2], AX		;Zmienna liczba2 ma wartosc zmiennej tymczasowej
                XOR  AX,        AX		;Wyczysc AX
                MOV  [temp],    AX		;Wyczysc zmienna temp

            MOV  AX, [adr_init]	;Przenies do AX wartosc adresu powrotu
            PUSH AX		;Wrzuc adres powrotu na stos
 RET
;--------------------Operacje-matematyczne----------------------
operat:
	POP AX			;Zrzuc adres powrotu do AX
	MOV [adr_init], AX	;Przenies adres do zmiennej
		
	MOV AH, 1		;Czytaj znak z wejscia
	INT 21H			;Przerwanie DOS

	CMP AL, '+'		;Czy uzytkownik chce dodac liczby?
	JE  _add		;Jesli tak przejdz do etykiety dodawania
			
	CMP AL, '-'		;Czy uzytkownik chce odjac wprowadzone liczby?
	JE  _sub		;Jesli tak przejdz do etykierty odejmowania

	CMP AL, '*'		;Czy uzytkownik chce pomnozyc te liczby?
	JE  _mul		;Jesli tak to przejdz do etykiety mnozenia

	CMP AL, '/'		;Czy uzytkownik chce podzielic te liczby?
	JE  _div		;Jesli tak przejdz do etykiety dzielenia
		
	CMP AL, ':'		;Rowniez symbol dzielenia
	JE  _div		;Przejdz do dzielenia jesli rowne

_add:
	XOR AX, AX		;Czysc AX
	XOR BX, BX		;Czysc BX
	MOV AX, [liczba1]	;Do AX pierwsza liczba
	MOV BX, [liczba2]	;Do BX druga liczba
	ADD AX, BX		;Do AX dodaj BX
	MOV [result], AX	;Wynik do zmiennej
	
	JMP endOper		;Przejdz do etykiety konca procedury
_sub:	
	XOR AX, AX		;Czysc AX
	XOR BX, BX		;Czysc BX
	MOV AX, [liczba1]	;Przenies do AX liczbe pierwsza		
	MOV BX, [liczba2]	;Przenies do BX liczbe druga
	SUB AX, BX		;Odejmij od AX liczbe BX
	MOV [result], AX	;Przenies do zmiennej wynik dzialania

	JMP endOper		;Przejdz do konca procedury
_mul:
	XOR AX, AX		;Czysc AX
	XOR BX, BX		;Czysc BX
	MOV AX, [liczba1]	;Przenies do AX pierwsza liczbe
	MOV BX, [liczba2]	;Przenies do BX druga liczbe
	MUL BX			;Pomnoz AX razy BX i wynik w AX
	MOV [result], AX	;Przenies wynik do zmiennej

	JMP endOper		;Przejdz do konca procedury

_div:
	XOR AX, AX		;Czysc AX
	XOR BX, BX		;Czysc BX
	MOV AX, [liczba1]	;Przenies do AX liczbe pierwsza
	MOV BX, [liczba2]	;Przenies do BX liczbe druga
	XOR DX, DX		;Wyczysc DX
	DIV BX 			;Podziel AX przez BX wynik w AX reszta w DX
	MOV [result], AX	;Przenies wynik do zmiennej

 endOper:	

    XOR BX, BX			;Wyczysc BX
    XOR AX, AX			;Wyczysc AX
    XOR DX, DX			;Wyczysc DX

	MOV  AX, [adr_init]	;Zaladuj do AX adres powrotu
	PUSH AX			;Wrzuc na stos adres powrotu

RET
;--------------------------Wyswietl-wynik-----------------------------
showRes:
	POP AX		        ;Zdejmij ze stosu adres powrotu
	MOV [adr_init], AX  ;Przenies adres powrotu do zmiennej

    	XOR AX, AX	    ;Wyczysc AX
    	XOR BX, BX	    ;Wyczysc BX
    	XOR CX, CX	    ;Wyczysc CX
    	XOR DX, DX	    ;Wyczysc DX

        MOV AX, [result];Przenies do AX wynik operacji
        MOV CX, 0   	;Przenies 0 do CX
        MOV BX, 10  	;Przenies dzielnik do BX
    
      	     pushwyni:
        		XOR DX, DX  ;Wyzeruj DX
       		        DIV BX      ;Podziel AX przez BX
       		        PUSH DX     ;Wrzuc reszte
        		INC CX      ;Zwieksz licznik
        		CMP AX, 0   ;Porownaj czy licznik rowny 0
        		JA pushwyni ;Jesli wiekszy dziel dalej


       		        MOV AH, 2   ;Wypisz znak

    		echow:
        		POP DX      ;Zrzuc do DX
        		XOR DH, DH  ;Zeruj gore rejestru DX czyli DH
        		ADD DX, 48  ;Dodaj 48 tak aby wyswietlic cyfre
        		INT 21H     ;Przerwanie DOS
    			loop echow  


	MOV  AX, [adr_init]
	PUSH AX
RET
;-----------------------------Obsluga-bledow-----------------------------

_error:
        MOV  DX, ent1
        PUSH DX
        CALL show

        MOV  DX, info3
        PUSH DX
        CALL show
	
	MOV  DX, ent1
	PUSH DX
	CALL show

        JMP start
;------------------------------------------------------------------------ 