import RPi.GPIO as GPIO
import time
import os

# Pin configuration
MOSFET_PIN = int(os.getenv('MOSFET_PIN', 11)) 

print("using pin: ", MOSFET_PIN)


# GPIO setup
GPIO.setmode(GPIO.BOARD)
GPIO.setup(MOSFET_PIN, GPIO.OUT)

try:
    # Pull the maskrom pin to 0V (simulate button press)
    GPIO.output(MOSFET_PIN, GPIO.HIGH)
    print('pressing maskrom button')
    time.sleep(4)  # Hold the button for 1 second

    
    # Release the maskrom pin (simulate button release)
    GPIO.output(MOSFET_PIN, GPIO.LOW)
    print('releasing maskrom button')
finally:
    # Cleanup GPIO state
    GPIO.cleanup()
