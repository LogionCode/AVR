//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//CW5Z1
////////////////////////////
// Schemat pod³¹czenia
// PC(0-7)=D(0-7)
// PA0=C1
// a=GND
// PD2=K4
// W4=GND

// 4 000 000 / 64 = 62 500; 62 500 /2 = 31 250

#define F_CPU 4000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

ISR(INT0_vect){ // przy wcisnieciu przycisku
	PORTA |= 0x01; // w³¹czenie diody
	
	TCCR1B |= 0x03; // w³¹czenie timera 1 preskalar jako 1/64
	TCCR1B |= 0x08; // tryb ctc
	TCNT1 = 0; // wyzerowanie timera
}

ISR(TIMER1_COMPA_vect){ // przy osiagnieciu okreslonej ilosci tickow
	PORTA &= 0xFE; // wy³¹czenie diody
	
	TCCR1B &= 0xF8; // wy³¹czenie timera 1
}
	
int main(void)
{
	DDRA |= 0x01; // ustwienie PORTA 0 jako wyjœcie
	DDRC = 0xFF; // ustawienie PORTC jako wyjœcie
	
	PORTD |= 0x04; // pod³¹czenie zasilania do przycisku PORTB 2
	PORTC = 0xFF; // ustawienie stanu poczatkowego diod LED
	
	MCUCR |= 0x02; // ustawienie trybu zbocza opadaj¹cego na INT0
	GICR |= 0x40; // w³¹czenie przerwania INT0
	
	OCR1A = 31250; // ustawienie celu czasu na 0,5 sek
	
	TIMSK |= 0x10; // w³aczenie timera 1 na tryb porównywania
	
	sei(); // w³¹czenie obs³ugi przerwañ
	
    while (1) 
    {
		_delay_ms(150); // opóŸnienie
		PORTC =~PORTC; // zmiana animacji diod	
    }
}
