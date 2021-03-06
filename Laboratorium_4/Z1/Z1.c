//Poniżej podaj swoje dane
//Jakub Łachmański
//95481
//5
//10
//CW5Z1
////////////////////////////
// Schemat podłączenia
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
	PORTA |= 0x01; // włączenie diody
	
	TCCR1B |= 0x03; // włączenie timera 1 preskalar jako 1/64
	TCCR1B |= 0x08; // tryb ctc
	TCNT1 = 0; // wyzerowanie timera
}

ISR(TIMER1_COMPA_vect){ // przy osiagnieciu okreslonej ilosci tickow
	PORTA &= 0xFE; // wyłączenie diody
	
	TCCR1B &= 0xF8; // wyłączenie timera 1
}
	
int main(void)
{
	DDRA |= 0x01; // ustwienie PORTA 0 jako wyjście
	DDRC = 0xFF; // ustawienie PORTC jako wyjście
	
	PORTD |= 0x04; // podłączenie zasilania do przycisku PORTB 2
	PORTC = 0xFF; // ustawienie stanu poczatkowego diod LED
	
	MCUCR |= 0x02; // ustawienie trybu zbocza opadającego na INT0
	GICR |= 0x40; // włączenie przerwania INT0
	
	OCR1A = 31250; // ustawienie celu czasu na 0,5 sek
	
	TIMSK |= 0x10; // właczenie timera 1 na tryb porównywania
	
	sei(); // włączenie obsługi przerwań
	
    while (1) 
    {
		_delay_ms(150); // opóźnienie
		PORTC =~PORTC; // zmiana animacji diod	
    }
}
