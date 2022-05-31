//Poni¿ej podaj swoje dane
//Jakub £achmañski
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
	sbi PORTA,1 ; pod³¹czenie zasilania do przycisku

loop:			; pocz¹tek pêtli g³ównej

	sbis PINA,1
	cbi PORTA,0 ; wy³¹czenie diody jeœli przycisk jest wcisniety

	sbic PINA,1
	sbi PORTA,0 ; w³¹czenie diody jesli przycisk nie jest wcisniety

	rjmp loop 	; wróæ na pocz¹tek pêtli g³ównej

