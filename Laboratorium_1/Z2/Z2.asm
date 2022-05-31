//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw2Z2
///////////////////////
// Opis podl�czenia:
// PA0 = D0
// PB0 = D1
// PC0 = D2
// PD0 = D3

.include "m32def.inc"
	
	.org 0x00
	jmp main

	.org 0x100
main: 			; program g��wny
				; tutaj ci�g instrukcji inicjalizacyjnych
	sbi DDRA,0	; ustawienie 0 bitu portu a jako wyjscie
	sbi DDRB,0	; ustawienie 0 bitu portu a jako wyjscie
	sbi DDRC,0	; ustawienie 0 bitu portu a jako wyjscie
	sbi DDRD,0	; ustawienie 0 bitu portu d jako wyjscie

				; Ustawienie stanow poczatkowych
	sbi PORTA,0 ; w��czenie diody do��czonej do PA0
	sbi PORTB,0 ; w��czenie diody do��czonej do PB0
	cbi PORTC,0 ; wy��czenie diody do��czonej do PC0
	cbi PORTD,0 ; wy��czenie diody do��czonej do PD0

loop:

    ldi  r18, 3
    ldi  r19, 8
    ldi  r20, 120
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1	; op�nienie o 100 ms

	cbi PORTA,0 ; wy��czenie diody do��czonej do PA0
	cbi PORTB,0 ; wy��czenie diody do��czonej do PB0
	sbi PORTC,0 ; w��czenie diody do��czonej do PC0
	sbi PORTD,0 ; w��czenie diody do��czonej do PD0

    ldi  r18, 9
    ldi  r19, 30
    ldi  r20, 229
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    nop		; op�nienie o 400 ms

	sbi PORTB,0 ; w��czenie diody do��czonej do PB0
	cbi PORTD,0 ; wy��czenie diody do��czonej do PD0

	ldi  r18, 3
    ldi  r19, 8
    ldi  r20, 120
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3		; op�nienie o 100 ms

	sbi PORTA,0 ; w��czenie diody do��czonej do PA0
	cbi PORTC,0 ; wy��czenie diody do��czonej do PC0

	rjmp loop 	; wr�� na pocz�tek p�tli g��wnej
