
import lgpio
import time
import os

# Pin configuration
# https://pinout.xyz/pinout/pin16_gpio23/
# 
OPENCCA_MASKROM_PIN = int(os.getenv('OPENCCA_MASKROM_PIN', 23)) 

print("using pin: ", OPENCCA_MASKROM_PIN)

h = lgpio.gpiochip_open(0) 
lgpio.gpio_claim_output(h, OPENCCA_MASKROM_PIN)

lgpio.gpio_write(h, OPENCCA_MASKROM_PIN, 1) 
print('pressing maskrom button')

time.sleep(4) 
# time.sleep(4) 
# time.sleep(4) 

lgpio.gpio_write(h, OPENCCA_MASKROM_PIN, 0) 
print('releasing maskrom button')

