//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Cw3Z2
///////////////////////

/*
Pod³¹czenie:
PA0-D0
PA1-D1
PA2-D2
PA3-D3
PA4-D4
PA5-D5
PA6-D6
PA7-D7
*/

.include "m32def.inc"
	
	.org 0x00
	jmp main

	.org 0x100
	
main: 			; program g³ówny
	LDI R16, low(RAMEND)
	OUT SPL, R16
	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wskaŸnika stosu

	LDI R16, 0xFF
	OUT DDRA, R16	; ustawienie portów A na wyjœciowe

restart:
	LDI R16, 0x01	; ustawienie stanu pocz¹tkowego portów A

loop:			; pocz¹tek pêtli g³ównej
	OUT PORTA, R16	; w³¹czenie ledów wed³ug stanu 
	
    ldi  r18, 104
    ldi  r19, 229
L1: dec  r19
    brne L1
    dec  r18
    brne L1		; przeczekanie 20 ms

	LSL R16	; przesuniêcie bitowe w lewo
	BREQ restart	; w przypadku dotarcia do koñca powrot co stanu pocz¹tkowego

	rjmp loop 	; wróæ na pocz¹tek pêtli g³ównej
