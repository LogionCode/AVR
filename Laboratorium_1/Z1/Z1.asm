//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw2Z1
///////////////////////
// Odpis podlaczenia:
// PA0 = D0
// GND = W4
// K4 = PA1
.include "m32def.inc"
	
	.org 0x00
	jmp main

	.org 0x100
main:
	sbi DDRA,0 ; ustawienie 0 bitu portu jako wyjscie
	sbi PORTA,1 ; pod��czenie zasilania do przycisku

loop:			; pocz�tek p�tli g��wnej

	sbis PINA,1
	cbi PORTA,0 ; wy��czenie diody je�li przycisk jest wcisniety

	sbic PINA,1
	sbi PORTA,0 ; w��czenie diody jesli przycisk nie jest wcisniety

	rjmp loop 	; wr�� na pocz�tek p�tli g��wnej

