import RPi.GPIO as GPIO
import time
import os

# Pin configuration
# https://pinout.xyz/pinout/pin16_gpio23/
# 
MOSFET_PIN = int(os.getenv('MOSFET_PIN', 23)) 

print("using pin: ", MOSFET_PIN)

GPIO.setmode(GPIO.BCM)
GPIO.setup(MOSFET_PIN, GPIO.OUT)

try:
    GPIO.output(MOSFET_PIN, GPIO.HIGH)
    print('pressing maskrom button')
    time.sleep(4) 
    GPIO.output(MOSFET_PIN, GPIO.LOW)
    print('releasing maskrom button')
finally:
    GPIO.cleanup()
