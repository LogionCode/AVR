//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw4Z2

//Przez potencjalne uszkodzenie portu C w zadaniu u�yty jest port B

//Pod��czenie
//GND-C1
//[a-dp]-[PB0-PB7]
//PA0-D0
//GND-W1
//K4-PD3

///////////////////////

.include "m32def.inc"
	
	.org 0x00
	jmp main
	
	.org 0x002 ; adres wektora INT0
	jmp oi0

	.org 0x004 ; adres wektora INT1
	jmp oi1 

	.org 0x100
main: 			; program g��wny
	cli ; wy��czenie przerwa� na czas inicjalizacji

	LDI R16, low(RAMEND)
	OUT SPL, R16

	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wska�nika stosu

	IN R16, GICR
	ORI R16, 0b11000000	; w��czenie przerwania INT1 i INT0
	OUT GICR, R16
	
	IN R16, MCUCR
	ORI R16, 0b00001010	; ustawienie przerwania INT1 i INT0 na tryb zbocza opadaj�cego
	OUT MCUCR, R16

	SBI PORTD,2	; pod��czenie do zasilania przycisku pod��czonego do PD2
	SBI PORTD,3	; pod��czenie do zasilania przycisku pod��czonego do PD3

	LDI R16, 0xFF
	OUT DDRB, R16 ; ustawienie port C jako wyj�ciowy
	sbi DDRA,0 ; ustawienie pinu 0 portu A jako wyj�ciowy

	cbi PORTA,0
	LDI R16, 0b01111111
	OUT PORTB, R16	; w��czenie pierwszej diody lini diod pod��czonych do portu C

	sei ; w��czenie przerwa�

loop:			
	IN R16, PORTB ; pobranie stanu animacji na porcie C
	ROR R16 ; kolejny krok animacji
	OUT PORTB, R16 ; ustawienie diod na kolejny krok

	call delay ; op�nienie o 20 ms

	rjmp loop 	; wr�� na pocz�tek p�tli g��wnej

delay:

    ldi  r18, 208 ; wygenerowane op�nienie
    ldi  r19, 202
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop

	reti ; powr�t do miejsca wywo�ania

oi0:
	sbi PORTA,0 ; w��czenie diody portu A 0
				; sbi nie modyfikuje rejestru stanu wi�c nie jest zapisywany
	reti
oi1:
	cbi PORTA,0	; wy��czenie diody portu A 0
				; cbi nie modyfikuje rejestru stanu wi�c nie jest zapisywany
	reti