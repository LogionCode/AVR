//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw3Z1
///////////////////////
// Opis po��cze�:
// PB0 = K3
// PB1 = K4
// W4 = GND
// PA(0-7) = D(0-7)

.include "m32def.inc"
	
	.org 0x00
	jmp main

	.org 0x100
main: 			; program g��wny

	LDI R16, low(RAMEND)
	OUT SPL, R16
	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wska�nika stosu

	LDI R16, 0xFF
	OUT DDRA, R16	; ustawienie port�w A na wyj�ciowe

	LDI R16, 0x03
	OUT PORTB, R16	; podciagniecie zasilania do przyciskow
	

loop:			; pocz�tek p�tli g��wnej

	LDI R16, 0x0F ; stan portow przy braku wcisniecia
	IN R17, PINB
	ANDI R17, 0x03 ; maska zostawiajaca tylko stan portow przyciskow

	cpi R17, 0x03 ; sprawdza czy ktorykolwiek z przyciskow jest wcisniety
	BRNE negacja	; przechodzi do funkcji jesli jest

	OUT PORTA, R16 ; ustawia stan diod
rjmp loop

negacja:
	LDI R16, 0xF0 ; ustawia stan swiecienia dla wcisnietego przycisku
	OUT PORTA, R16

rjmp loop