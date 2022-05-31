//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//CW7Z1
////////////////////////////
// Pod³¹czenie uk³adu:
// PA(0-7)=(a-dp)
// PC(0-7)=D(0-7)

//PD2=W1
//PD3=W2

//PD4=K1
//PD5=K2
//PD6=K3
//PD7=K4

#define F_CPU 4000000
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>

ISR(INT0_vect) // przerwanie INT0
{
	for(int i = 0; i < 4; i++)
	{
		PORTD = (~_BV(i+4) & 0xF0) | (PORTD & 0x0F); // ustawienie starszego bitu na pozycji i na 0 i 1 na resztê
		_delay_us(2);
		if(!(PIND & 0x04)) // wyswietlenie na diodach led ktory klawisz jest wcisniety
			{
				PORTA = (PORTA & 0x0F) | (((i+1) << 4) & 0xF0) | 0x10; //wyswietlenie ktory przycisk jest wcisniety
			}
	}
	
	PORTD &= 0x0F; // oczyszczenie starszych bitów
}

ISR(INT1_vect) // przerwanie INT0
{	
	for(int i = 0; i < 4; i++)
	{
		PORTD = (~_BV(i+4) & 0xF0) | (PORTD & 0x0F); // ustawienie starszego bitu na pozycji i na 0 i 1 na resztê
		_delay_us(2);
		if(!(PIND & 0x08)) // sprawdzenie czy przycisk jest wcisniety
		{
			PORTA = (PORTA & 0x0F) | (((i+1) << 4) & 0xF0) | 0x10; //wyswietlenie ktory przycisk jest wcisniety
		}
	}
	
	PORTD &= 0x0F; // oczyszczenie starszych bitów
}

int main(void)
{
	DDRA = 0xFF; // ustawienie lini portów na wyjœcie
	DDRC = 0xFF;
	
	PORTA |= 0x10; // wlaczenie 4 od prawej diody na porcie a
	
	DDRD |= 0xF0; // ustawienie 4 starszych bitów na wyjœcie
	
	PORTD |= 0x0C; // podci¹gniêcie zasilania pod przyciski INT0 i INT1
	
	MCUCR |= 0x0A; // ustawienie obu przerwañ w tryb falling edge
	
	GICR |= 0xC0; // w³¹czenie przerwañ INT0 i INT1
	
	sei(); // w³¹czenie przerwañ
	
	
    while (1) 
    {	
		PORTC ^= 0xFF; // animacja na porcie C
		_delay_ms(150);
    }
}
