#include <avr/io.h>
#include <util/delay.h>

#include "led.h"

int main(void)
{
    /* Set all pins as output */
    DDRD = 0xFF;
    /* Set only 3rd pin on */
    PORTD = 0x04;

    /* Currently this a loop that lights up 6 leds back and forth one by one. Similar to 
     * Knight rider's KITT. Leds are connected to pins from D2 to D7 (port D in atmega).
     */ 
    while (1)
    {   
        for (unsigned int i = 1; i < 6; i++) {
            /* Shift bits forward to light up next LED */
            PORTD = (0x04 << i);
            _delay_ms(CHANGE_DELAY);
        }
        for (unsigned int i = 1; i < 6; i++) {
            /* Shift bits backward to light up previous LED */
            PORTD = (0x80 >> i);
            _delay_ms(CHANGE_DELAY);
        }
    }
}