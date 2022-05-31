//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//CW5Z3
////////////////////////////
// Schemat pod³¹czenia
// PC(0-7)=D(0-7)
// PA0=dp
// PA7=a
// C4=GND
// PD2=K4
// W4=GND

// 4 000 000 / 64 = 62 500; 62 500 * 0.16 = 10000; 62500 * 0.32 = 20000; 62500 * 0.192 = 12000

#define F_CPU 4000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

volatile int czas_przebiegu_2;
const int czas_przebiegu_1 = 10000; // 0.16 ms;

ISR(INT0_vect){ // przy wcisnieciu przycisku
	
	if(czas_przebiegu_2 > 12000){  // czy stan jest wiêkszy ni¿ minimalny
		if(czas_przebiegu_2 - 5000 > 12000){ // czy mo¿na skróciæ czas
			czas_przebiegu_2 -= 5000; // skracanie czasu
			OCR1A = czas_przebiegu_2; // aktualizacja licznika
			if(OCR1A >= TCNT1) // czy TCNT1 nie przekroczy³o licznika
			{
				TCNT1 = OCR1A -1; // poprawa wartoœci TCNT1
			}
		}
		else{
			czas_przebiegu_2 -= 5000; // skracanie czasu
			PORTA &= 0x7F; // wylaczamy diodê
		}
	}
	else {
		if(OCR1A == czas_przebiegu_2){ // czy w trybie 2
			czas_przebiegu_2 = 12000; // ustawienie minimalnego czasu
			OCR1A = czas_przebiegu_2; // aktualizacja licznika
			if(OCR1A >= TCNT1) // czy TCNT1 nie przekroczy³o licznika
			{
				TCNT1 = OCR1A -1; // poprawa wartoœci TCNT1
			}
		}
		else{
			czas_przebiegu_2 = 12000; // ustawienie minimalnego czasu
		}
		PORTA &= 0x7F; // wylaczamy diodê
	}
}

ISR(TIMER1_COMPA_vect){ // przy osiagnieciu okreslonej ilosci tickow
	PORTA ^= 0x01; // negowanie stanu diody
	
	if(OCR1A == czas_przebiegu_2){ // zmiana czasu trwania przebiegu
		OCR1A = czas_przebiegu_1;
	}
	else{
		OCR1A = czas_przebiegu_2;
	}
}

int main(void)
{
	DDRA |= 0xF1; // ustwienie PORTA 7 i 0 jako wyjœcie
	DDRC = 0xFF; // ustawienie PORTC jako wyjœcie
	
	PORTD |= 0x04; // pod³¹czenie zasilania do przycisku PORTB 2
	PORTC = 0xFF; // ustawienie stanu poczatkowego diod LED
	PORTA |= 0x80; // w³¹czenie diody 7
	
	MCUCR |= 0x02; // ustawienie trybu zbocza opadaj¹cego na INT0
	GICR |= 0x40; // w³¹czenie przerwania INT0
	
	czas_przebiegu_2 = 20000; // czas na 0.32 sek
	
	OCR1A = czas_przebiegu_2; // ustawiam czas poczatkowy
	
	TIMSK |= 0x10; // w³aczenie timera 1 na tryb porównywania
	
	TCCR1B |= 0x08; // tryb ctc
	TCCR1B |= 0x03; // preskalar na 1/64
	
	sei(); // w³¹czenie obs³ugi przerwañ
	
	while (1)
	{
		_delay_ms(250); // opóŸnienie
		PORTC =~PORTC; // zmiana animacji diod
	}
}
