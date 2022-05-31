//Poni�ej podaj swoje dane
//Jakub �achma�ski
//95481
//5
//10
//Cw4Z3

//Przez potencjalne uszkodzenie portu C w zadaniu u�yty jest port B

//Pod��czenie
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

	SBI PORTD,2	; pod��czenie do zasilania przycisku pod��czonego do 
	SBI PORTD,3	; pod��czenie do zasilania przycisku pod��czonego do 

	LDI R16, 0xFF
	OUT DDRB, R16
	OUT DDRA, R16 ; ustawienie port�w A i C jako wyj�ciowe

	OUT PORTA, R16 ; ustawienie stanu pocz�tkowego lini diod pod��czonych do portu A
	LDI R16, 0x00 ; odwrotna polaryzacja lini diod przy porcie B
	OUT PORTB, R16	; ustawienie stanu pocz�tkowego lini diod pod��czonych do portu B

	sei ; w��czenie przerwa�

loop:		
    ldi  r18, 52
    ldi  r19, 242
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop ; op�nienie o 10ms
	
	call nega

	ldi  r18, 104
    ldi  r19, 229
L2: dec  r19
    brne L2
    dec  r18
    brne L2 ; op�nienie o 20ms

	rjmp loop 	; wr�� na pocz�tek p�tli g��wnej

nega:
	push R16

	IN R16, SREG
	push R16 ; zapisanie rejestru stanu na stosie

	IN R16, PORTA ; pobranie stanu animacji
	COM R16	; zanegowanie bit�w stanu
	OUT PORTA, R16 ; ustawienie nowego stanu

	
	IN R16, PORTB ; pobranie stanu animacji
	COM R16	; zanegowanie bit�w stanu
	OUT PORTB, R16 ; ustawienie nowego stanu
	
	pop R16 ; wyj�cie rejestru stanu ze stosu
	OUT SREG, R16 ; ustwaienie rejestru stanu

	pop R16 

	reti ; powr�t do miejsca wywo�ania
	
op0:
	reti
op1:
	reti

