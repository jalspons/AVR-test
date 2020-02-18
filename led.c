#define F_CPU 16000000UL

#define TAILING_DELAY 0
#define CHANGE_DELAY 50

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    DDRD = 0xFF;
    PORTD = 0x04;

    /* Currently this a loop that lights up 6 leds back and forth one by one. Similar to 
     * Knight rider's KITT. Leds are connected to pins from D2 to D7 (port D in atmega).
     */ 
    while (1)
    {   
        for (unsigned int i = 1; i < 6; i++) {
            PORTD = (PORTD | PORTD >> 1);
            _delay_ms(TAILING_DELAY);
            PORTD = (0x04 << i);
            _delay_ms(CHANGE_DELAY);
        }
        for (unsigned int i = 1; i < 6; i++) {
            PORTD = (PORTD | PORTD >> 1);
            _delay_ms(TAILING_DELAY);
            PORTD = (0x80 >> i);
            _delay_ms(CHANGE_DELAY);
        }
    }
}