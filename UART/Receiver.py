import serial
import numpy as np
import matplotlib.pyplot as plt
import time

# Connect to serial port
ser = serial.Serial("COM15", 115200, timeout=1)
ser.reset_input_buffer() 

print(f"Waiting on 'COM15' at 115200 baud...")
time.sleep(5)
print(f"Listening on 'COM15' at 115200 baud...")

received_data = []

try:
    while len(received_data) < 63 * 63:
        byte = ser.read()
        if byte:
            received_data.append(ord(byte))  # Convert byte to int
finally:
    ser.close()

print("done")

image_2d = np.array(received_data, dtype=np.uint8).reshape((63, 63))

plt.imshow(image_2d, cmap='gray')
plt.title("Pooled Output Image")
plt.axis('off')
plt.show()


