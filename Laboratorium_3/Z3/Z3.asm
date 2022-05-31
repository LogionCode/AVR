//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Cw4Z3

//Przez potencjalne uszkodzenie portu C w zadaniu u¿yty jest port B

//Pod³¹czenie
//GND-C1
//[a-dp]-[PB0-PB7]
//[PA0-PA7]-[D0-D7]
//GND-W1
//K3-PD2
//K4-PD3

///////////////////////

.include "m32def.inc"
	
	.org 0x00
	jmp main
	
	.org 0x002 ; adres wektora INT1
	jmp op0

	.org 0x004 ; adres wektora INT1
	jmp op1 

	.org 0x100
main: 			; program g³ówny
	cli ; wy³¹czenie przerwañ na czas inicjalizacji

	LDI R16, low(RAMEND)
	OUT SPL, R16

	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wskaŸnika stosu

	IN R16, GICR
	ORI R16, 0b11000000	; w³¹czenie przerwania INT1 i INT0
	OUT GICR, R16
	
	IN R16, MCUCR
	ORI R16, 0b00001010	; ustawienie przerwania INT1 i INT0 na tryb zbocza opadaj¹cego
	OUT MCUCR, R16

	SBI PORTD,2	; pod³¹czenie do zasilania przycisku pod³¹czonego do 
	SBI PORTD,3	; pod³¹czenie do zasilania przycisku pod³¹czonego do 

	LDI R16, 0xFF
	OUT DDRB, R16
	OUT DDRA, R16 ; ustawienie portów A i C jako wyjœciowe

	OUT PORTA, R16 ; ustawienie stanu pocz¹tkowego lini diod pod³¹czonych do portu A
	LDI R16, 0x00 ; odwrotna polaryzacja lini diod przy porcie B
	OUT PORTB, R16	; ustawienie stanu pocz¹tkowego lini diod pod³¹czonych do portu B

	sei ; w³¹czenie przerwañ

loop:		
    ldi  r18, 52
    ldi  r19, 242
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop ; opóŸnienie o 10ms
	
	call nega

	ldi  r18, 104
    ldi  r19, 229
L2: dec  r19
    brne L2
    dec  r18
    brne L2 ; opóŸnienie o 20ms

	rjmp loop 	; wróæ na pocz¹tek pêtli g³ównej

nega:
	push R16

	IN R16, SREG
	push R16 ; zapisanie rejestru stanu na stosie

	IN R16, PORTA ; pobranie stanu animacji
	COM R16	; zanegowanie bitów stanu
	OUT PORTA, R16 ; ustawienie nowego stanu

	
	IN R16, PORTB ; pobranie stanu animacji
	COM R16	; zanegowanie bitów stanu
	OUT PORTB, R16 ; ustawienie nowego stanu
	
	pop R16 ; wyjêcie rejestru stanu ze stosu
	OUT SREG, R16 ; ustwaienie rejestru stanu

	pop R16 

	reti ; powrót do miejsca wywo³ania
	
op0:
	reti
op1:
	reti

