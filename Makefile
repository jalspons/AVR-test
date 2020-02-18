# Based on https://wiki.archlinux.org/index.php/AVR#Sample_Makefile
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude
SIZE = avr-size
REMOVE = rm -f

MCU = atmega328p
F_CPU = 16000000UL

TARGET = led
SRC = led.c
OBJ = $(SRC:.c=.o)
LST = $(SRC:.c=.lst)

FORMAT = ihex
OPTLEVEL = s

CFLAGS = -DF_CPU=$(F_CPU) -O$(OPTLEVEL) -mmcu=$(MCU) -std=c99
# If want some optimization, then use also
#CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
#CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wall -Wstrict-prototypes
CFLAGS += -Wa,-adhlns=$(<:.c=.lst)

LDFLAGS = -Wl,--gc-sections
LDFLAGS += -Wl,--print-gc-sections

AVRDUDE_PORT = /dev/ttyACM0
AVRDUDE_PROGRAMMER = arduino
AVRDUDE_BAUDRATE = 115200 # 57600 For arduino mini pro with CP2102 USB-to-ttl
AVRDUDE_MCU = m328p

AVRDUDE_FLAGS = -p $(AVRDUDE_MCU)
AVRDUDE_FLAGS += -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS += -P $(AVRDUDE_PORT) 
AVRDUDE_FLAGS += -b $(AVRDUDE_BAUDRATE)
AVRDUDE_FLAGS += -D

MSG_LINKING = Linking:
MSG_COMPILING = Compiling:
MSG_FLASH = Preparing HEX file:
MSG_UPLOAD = Uploading:

all: gccversion $(TARGET).elf $(TARGET).hex size flash

.SECONDARY: $(TARGET).elf
.PRECIOUS: $(OBJ)

%.o: %.c
	@echo $(MSG_COMPILING) $<
	$(CC) $(CFLAGS) -c $< -o $(@F)

%.elf: $(OBJ)
	@echo
	@echo $(MSG_LINKING) $@
	$(CC) -mmcu=$(MCU) $(LDFLAGS) $^ --output $(@F) 

%.hex: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

gccversion:
	@$(CC) --version

flash: $(TARGET).hex
	@echo $(MSG_UPLOAD)
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$(TARGET).hex

size: $(TARGET).elf
	@echo
	$(SIZE) -C --mcu=$(AVRDUDE_MCU) $(TARGET).elf

clean:
	$(REMOVE) $(TARGET).hex $(TARGET).elf $(OBJ) $(LST)