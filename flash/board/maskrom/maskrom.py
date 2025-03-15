import lgpio
import time
import os
import sys

# Pin configuration
# https://pinout.xyz/pinout/pin16_gpio23/
# 
OPENCCA_MASKROM_PIN = int(os.getenv('OPENCCA_MASKROM_PIN', 23))

def press_maskrom_button(handle, pin):
    print(f'Press maskrom button (set pin ${OPENCCA_MASKROM_PIN} HIGH)...')
    lgpio.gpio_write(handle, pin, 1)
    
def release_maskrom_button(handle, pin):
    print(f'Releasing maskrom button (set pin ${OPENCCA_MASKROM_PIN} LOW)...')
    lgpio.gpio_write(handle, pin, 0)
    
def usage():
    print("Usage: script.py <press|release>")
    sys.exit(1)

def main():
    h = lgpio.gpiochip_open(0)
    lgpio.gpio_claim_output(h, OPENCCA_MASKROM_PIN)

    if len(sys.argv) < 2:
        usage()

    command = sys.argv[1].strip().lower()
    if command == "press":
        press_maskrom_button(h, OPENCCA_MASKROM_PIN)
    elif command == "release":
        release_maskrom_button(h, OPENCCA_MASKROM_PIN)
    else:
        usage()
    
if __name__ == "__main__":
    main()