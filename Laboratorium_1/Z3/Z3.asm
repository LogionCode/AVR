//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Cw2Z3
///////////////////////
// Opis podl¹czenia:
// PA0 = D0
// PB0 = D1
// PC0 = D2
// PD0 = D3
// GND = W4
// K3 = PA7
// K4 = PD7

.include "m32def.inc"
	
	.org 0x00
	jmp main

	.org 0x100
main: 
	sbi DDRA,0	; ustawienie 0 bitu portu a jako wyjscie
	sbi DDRB,0	; ustawienie 0 bitu portu b jako wyjscie
	sbi DDRC,0	; ustawienie 0 bitu portu c jako wyjscie
	sbi DDRD,0	; ustawienie 0 bitu portu d jako wyjscie

	sbi PORTA,7 ; podlaczenie do zasilania przycisku a
	sbi PORTD,7 ; podlaczenie do zasilania przycisku b
loop:

	sbi PORTA,0 ; wy³¹czenie diody do³¹czonej do PA0
	sbi PORTB,0 ; wy³¹czenie diody do³¹czonej do PB0
	cbi PORTC,0 ; w³¹czenie diody do³¹czonej do PC0
	
	sbic PIND,7 ; nie w³¹cza diody jesli przycisk jest wcisniety
	cbi PORTD,0 ; w³¹czenie diody do³¹czonej do PD0


    ldi  r18, 11
    ldi  r19, 38
    ldi  r20, 94
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1 ; opóŸnienie o 500 ms

	sbic PINA,7 ; nie wy³¹cza diody jesli przycisk jest wcisniety
	cbi PORTA,0 ; wy³¹czenie diody do³¹czonej do PA0

	cbi PORTB,0 ; wy³¹czenie diody do³¹czonej do PB0
	sbi PORTC,0 ; w³¹czenie diody do³¹czonej do PC0
	sbi PORTD,0 ; w³¹czenie diody do³¹czonej do PD0

    ldi  r18, 5
    ldi  r19, 15
    ldi  r20, 242
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2 ; opóŸnienie o 200 ms

	rjmp loop 	; wróæ na pocz¹tek pêtli g³ównej
