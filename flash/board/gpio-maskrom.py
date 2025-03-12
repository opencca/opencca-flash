
import lgpio
import time
import os

# Pin configuration
# https://pinout.xyz/pinout/pin16_gpio23/
# 
MOSFET_PIN = int(os.getenv('MOSFET_PIN', 23)) 

print("using pin: ", MOSFET_PIN)

h = lgpio.gpiochip_open(0) 
lgpio.gpio_claim_output(h, MOSFET_PIN)

lgpio.gpio_write(h, MOSFET_PIN, 1) 
print('pressing maskrom button')

time.sleep(4) 
# time.sleep(4) 
# time.sleep(4) 

lgpio.gpio_write(h, MOSFET_PIN, 0) 
print('releasing maskrom button')

