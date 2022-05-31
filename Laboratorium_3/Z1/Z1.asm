//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Cw4Z1

//Przez potencjalne uszkodzenie portu C w zadaniu u¿yty jest port B

//Pod³¹czenie
//GND-C1
//[a-dp]-[PB0-PB7]
//[PA0-PA7]-[D0-D7]
//GND-W1
//K4-PD3

///////////////////////

.include "m32def.inc"
	
	.org 0x00
	jmp main
	
	.org 0x004 ; adres wektora INT1
	jmp oposite 

	.org 0x100
main: 			; program g³ówny
	cli ; wy³¹czenie przerwañ na czas inicjalizacji

	LDI R16, low(RAMEND)
	OUT SPL, R16

	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wskaŸnika stosu

	IN R16, GICR
	ORI R16, 0b10000000	; w³¹czenie przerwania INT1
	OUT GICR, R16
	
	IN R16, MCUCR
	ORI R16, 0b00001000	; ustawienie przerwania INT1 na tryb zbocza opadaj¹cego
	OUT MCUCR, R16

	SBI PORTD,3	; pod³¹czenie do zasilania przycisku pod³¹czonego do portu D pinu 3

	LDI R16, 0xFF
	OUT DDRB, R16
	OUT DDRA, R16 ; ustawienie portów A i C jako wyjœciowe

	OUT PORTA, R16 ; ustawienie stanu pocz¹tkowego lini diod pod³¹czonych do portu A

	LDI R16, 0b01111111
	OUT PORTB, R16	; w³¹czenie pierwszej diody lini diod pod³¹czonych do portu C

	sei ; w³¹czenie przerwañ

loop:			
	IN R16, PORTB ; pobranie stanu animacji na porcie B
	ROR R16 ; kolejny krok animacji
	OUT PORTB, R16 ; ustawienie diod na kolejny krok

	call delay ; opóŸnienie o 20 ms

	rjmp loop 	; wróæ na pocz¹tek pêtli g³ównej

delay:

    ldi  r18, 208 ; wygenerowane opóŸnienie
    ldi  r19, 202
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop

	reti ; powrót do miejsca wywo³ania

oposite:
	push R16

	IN R16, SREG
	push R16 ; zapisanie rejestru stanu na stosie

	IN R16, PORTA ; pobranie stanu animacji
	COM R16	; zanegowanie bitów stanu
	OUT PORTA, R16 ; ustawienie nowego stanu
	
	pop R16 ; wyjêcie rejestru stanu ze stosu
	OUT SREG, R16 ; ustwaienie rejestru stanu

	pop R16 

	cli
	call delay ; opóŸnienie do ustatkowania sie przycisku
	sei

	reti ; powrót do miejsca wywo³ania



