import serial
from PIL import Image

ser = serial.Serial("COM15", baudrate=115200, timeout=1)
rx_busy = False
rx_done = False

try:
    img = "img1.jpg"
    img = Image.open(img).convert('L')
    img = img.resize((128, 128))
    counter = 0
    pixels = list(img.getdata())
    for byte in pixels:
        counter += 1
        if not rx_busy:
            rx_busy = True
            ser.write(bytes([byte]))
            print(f"Sent byte: {counter}", byte)
            rx_busy = False

except Exception as e:
    print(f"[ERR!] Loading image: {e}")

ser.close()
print("Image transmission completed.")


