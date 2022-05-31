//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw4Z1

//Przez potencjalne uszkodzenie portu C w zadaniu u�yty jest port B

//Pod��czenie
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
main: 			; program g��wny
	cli ; wy��czenie przerwa� na czas inicjalizacji

	LDI R16, low(RAMEND)
	OUT SPL, R16

	LDI R16, high(RAMEND)
	OUT SPH, R16	; inicjalizacja wska�nika stosu

	IN R16, GICR
	ORI R16, 0b10000000	; w��czenie przerwania INT1
	OUT GICR, R16
	
	IN R16, MCUCR
	ORI R16, 0b00001000	; ustawienie przerwania INT1 na tryb zbocza opadaj�cego
	OUT MCUCR, R16

	SBI PORTD,3	; pod��czenie do zasilania przycisku pod��czonego do portu D pinu 3

	LDI R16, 0xFF
	OUT DDRB, R16
	OUT DDRA, R16 ; ustawienie port�w A i C jako wyj�ciowe

	OUT PORTA, R16 ; ustawienie stanu pocz�tkowego lini diod pod��czonych do portu A

	LDI R16, 0b01111111
	OUT PORTB, R16	; w��czenie pierwszej diody lini diod pod��czonych do portu C

	sei ; w��czenie przerwa�

loop:			
	IN R16, PORTB ; pobranie stanu animacji na porcie B
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

oposite:
	push R16

	IN R16, SREG
	push R16 ; zapisanie rejestru stanu na stosie

	IN R16, PORTA ; pobranie stanu animacji
	COM R16	; zanegowanie bit�w stanu
	OUT PORTA, R16 ; ustawienie nowego stanu
	
	pop R16 ; wyj�cie rejestru stanu ze stosu
	OUT SREG, R16 ; ustwaienie rejestru stanu

	pop R16 

	cli
	call delay ; op�nienie do ustatkowania sie przycisku
	sei

	reti ; powr�t do miejsca wywo�ania



