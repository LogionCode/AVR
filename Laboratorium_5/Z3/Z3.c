//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Zadanie Cw7Z3
/////////////////////////
// Pod³¹czenie uk³adu:
// PD(0-3)=W(1-4)
// PD(4-7)=K(1-4)
// PA(0-7)=D(0-7)
// PC(0-7)=(a-dp)
// C1=GND

#define F_CPU 4000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>


ISR(TIMER0_COMP_vect) // przerwanie timer0
{
	PORTD = (~_BV(licznik+4) && 0xF0) | (PORTD & 0x0F); // ustawiam dany bit na 0
	if((PIND & 0x0F) != 0x0F) // sprawdzam czy wcisniety jest przycisk
	{
		PORTA = (PORTA & 0xF0) | (1 << (4 + licznik));
	}
}

int main(void)
{
	DDRA = 0xFF; // ustawienie portów a,b i starszych bitow c jako wyjsciowe
	DDRC = 0xFF;
	DDRD |= 0xF0;
	
	PORTD |= 0x0F; // podciagniecie zasilania pod przyciski
	PORTC = 0xFF; // ustawienie stanu animacji
	
	OCR0 = 195; // ustawienie czasu przerwania na 50 milisekund
	
	TIMSK |= 0x02; // wlaczenie timer0 w trybie porównywania
	
	TCCR0 |= 0b01000101; // preskalar na /1024 i tryb ctc
	
	sei();
	
	while (1)
	{
		_delay_ms(150);
		PORTC ^= 0xFF; // zmianu stanu animacji
		asm("nop");
	}
}
