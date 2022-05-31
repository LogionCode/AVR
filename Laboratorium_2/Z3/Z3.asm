//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw3Z3
///////////////////////

/*
Pod��czenie:
PA0-D0
PA1-D1
PA2-D2
PA3-D3
PA4-D4
PA5-D5
PA6-D6
PA7-D7
GND-W1
K2-PB0
K4-PB1
*/

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

	sbi PORTB,0
	sbi PORTD,0 ; podciagniecie do zasilania przyciskow

restart:
	LDI R16, 0x01	; ustawienie stanu pocz�tkowego port�w A

loop:						; pocz�tek p�tli g��wnej
	MOV R17, R16 ; kopia stanu animacji

	SBIS PINB, 0			;  jesliprzycisk na PB0 wci�ni�ty zaimplementuj mask�
	ORI R17, 0b10000001		;  implementacja maski dla przycisku B

	SBIS PIND, 0			; je�li przycisk na PD0 wci�ni�ty zaimplementuj mask�
	ANDI R17, 0b11100111	; implementacja maski dla D3 i D4

	OUT PORTA, R17			; wy�wietlanie wzoru (z ewentualn� mask�)

	RCALL delay				; op�nienie

	LSL R16					; przesu� wz�r w lewo
	CPI R16, 128			; je�li wz�r dojdzie do ko�ca to zresetuj animacj�
	BREQ restart
	RJMP loop 				; wr�� na pocz�tek p�tli g��wnej

delay:							; op�nienie 20 ms
    ldi  r18, 104
    ldi  r19, 229
L1: dec  r19
    brne L1
    dec  r18
    brne L1
	RET