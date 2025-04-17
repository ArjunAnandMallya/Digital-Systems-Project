import serial
import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm

ser = serial.Serial("COM15", 115200, timeout=1)
ser.reset_input_buffer() 

print(f"Waiting on 'COM15' at 115200 baud...")
print(f"Listening on 'COM15' at 115200 baud...")
expected_bytes = 63 * 63
received_data = []
print(f"[INFO] Waiting to receive {expected_bytes} bytes from FPGA...")

try:
    with tqdm(total=expected_bytes, desc="Receiving", unit="B") as pbar:
        while len(received_data) < expected_bytes:
            byte = ser.read(1)
            if byte:
                received_data.append(ord(byte)) 
                pbar.update(1)
finally:
    ser.close()
    print("[INFO] UART connection closed.")

print(received_data)
print("done")

image_2d = np.array(received_data, dtype=np.uint8).reshape((63, 63))

plt.imshow(image_2d, cmap='gray', interpolation='nearest')
plt.title("Pooled Output")
plt.axis('off')
plt.show()
print("3x3 Pooled Image Matrix:")




