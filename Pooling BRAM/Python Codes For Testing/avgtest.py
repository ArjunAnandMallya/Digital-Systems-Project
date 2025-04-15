import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

def pool_kernel(kernel):
    ad0 = abs(int(kernel[0,0]) - int(kernel[0,1]))
    ad1 = abs(int(kernel[0,1]) - int(kernel[0,2]))
    ad2 = abs(int(kernel[1,0]) - int(kernel[1,1]))
    ad3 = abs(int(kernel[1,1]) - int(kernel[1,2]))
    ad4 = abs(int(kernel[2,0]) - int(kernel[2,1]))
    ad5 = abs(int(kernel[2,1]) - int(kernel[2,2]))
    return (ad0+ad1+ad2+ad3+ad4+ad5)//6


def apply_pooling(image_array, kernel_size=3, stride=2):
    H, W = image_array.shape
    out_H = (H - kernel_size) // stride + 1
    out_W = (W - kernel_size) // stride + 1
    pooled_image = np.zeros((out_H, out_W), dtype=np.uint8)

    for i in range(out_H):
        for j in range(out_W):
            start_i = i * stride
            start_j = j * stride
            kernel = image_array[start_i:start_i+kernel_size, start_j:start_j+kernel_size]
            if kernel.shape == (kernel_size, kernel_size):
                print(kernel)
                pooled_image[i, j] = pool_kernel(kernel)
    return pooled_image


image = Image.open('img.jpg').convert("L")
resized_image = image.resize((7 , 7))
image_array = np.array(resized_image, dtype=np.uint8)
pooled_image = apply_pooling(image_array, kernel_size=3, stride=2)
plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.imshow(image_array, cmap='gray', interpolation='nearest')
plt.title("Resized 7x7 Image")
plt.axis('off')
plt.subplot(1, 2, 2)
plt.imshow(pooled_image, cmap='gray', interpolation='nearest')
plt.title("Pooled 3x3 Image")
plt.axis('off')
plt.show()
print("Yo")
print("3x3 Pooled Image Matrix:")
print(resized_image)
