//Poni¿ej podaj swoje dane
//Jakub £achmañski
//95481
//5
//10
//Zadanie Cw5Z2
/////////////////////////
// PD5=D0
#include<avr/io.h>


int main(void)
{
	DDRD |= 0x20; // pin 5 na lini d jako wyjscie
	
	TCCR1A |= 0x82; // TIMER 1 w tryb fast PWM i tryb nieodwracaj¹cy
	TCCR1B |= 0x18; // TIMER 1 w tryb fast PWM
	
	ICR1 = 23750; // szczyt ustawiony na 380ms
	OCR1A = 11875; // moment porównania na 190ms
	
	TCCR1B |= 0x03; // preskalar na 1/64
	
    while (1) 
    {	
		asm("nop");	
    }
}
