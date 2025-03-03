#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 15:38:54 2023

@author: emrahsimsek
"""

import tifffile
import numpy as np
import matplotlib.pyplot as plt

# Set the backend to 'agg' before importing pyplot, otherwise the saved output image will just be plain white
import matplotlib
matplotlib.use('agg')

import cv2

from skimage.color import rgb2gray
from skimage.measure import find_contours
import csv


image_filename = '27_BpPa_CB10_P01'
# Step 1: Load and preprocess the image
image = tifffile.imread(image_filename+'.TIF')
gray_image = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
h_org, w_org = gray_image.shape[:2]
pix_to_mm = 0.105882353

resized_image = cv2.resize(gray_image, (400, 400))  # Resize the image if needed
# resized_image = gray_image * 1# Resize the image if needed

# Step 2: Thresholding
_, binary_image = cv2.threshold(resized_image, 127, 255, cv2.THRESH_BINARY)

# Step 3: Edge Detection
edges = cv2.Canny(binary_image, 30, 100)

# Step 4: Create a mask to retrieve the central part of the image
mask = np.zeros_like(resized_image, dtype=np.uint8)  # Make sure it's uint8
center_x, center_y = mask.shape[1] // 2, mask.shape[0] // 2
radius = 150  # Adjust the radius value according to the size of your petri dish
cv2.circle(mask, (center_x, center_y), radius, 255, -1)

# Apply the mask to the edges image
masked_edges = cv2.bitwise_and(edges, edges, mask=mask)

# Convert the masked edges image to grayscale
masked_edges_gray = cv2.cvtColor(masked_edges, cv2.COLOR_GRAY2RGB)

# Step 5: Crop the image based on the masked edges
resized_color_image = cv2.resize(image, (400, 400))  # Resize the original image
# resized_color_image = image * 1
cropped_image = cv2.bitwise_and(resized_color_image, resized_color_image, mask=mask)
plt.imshow(cropped_image, cmap='gray')
plt.title('cropped image')
plt.axis('off')
plt.show()


threshold = 59
# threshold
# threshold = cv2.threshold(cropped_image, 128, 255, cv2.THRESH_BINARY)[1]
_, binary_cropped_image = cv2.threshold(cropped_image, threshold, 255, cv2.THRESH_BINARY)
binary_cropped_image = binary_cropped_image.astype(np.uint8)  # Convert to 8-bit unsigned integer

plt.imshow(binary_cropped_image, cmap='gray')
plt.title('binary cropped image')
plt.axis('off')
plt.show()


# Convert the binary_cropped_image to grayscale
binary_cropped_image_gray = rgb2gray(binary_cropped_image)

# Find contours using scikit-image
contours_cropped = find_contours(binary_cropped_image_gray, 0.4)

# Select the outermost contour
outer_contour = None
outer_contour_area = 0

for contour in contours_cropped:
    # Calculate the area of the contour
    contour_area = len(contour)
    
    # Check if the current contour has a larger area than the previous outer contour
    if contour_area > outer_contour_area:
        outer_contour = contour
        outer_contour_area = contour_area

# Create a new image to draw the outer contour
outer_contour_image = np.zeros_like(binary_cropped_image)
outer_contour = np.flip(outer_contour, axis=1).astype(np.int32)

# Draw the outer contour on the image
cv2.drawContours(outer_contour_image, [outer_contour], -1, (255, 0, 0), 1)

# Display the image with the outer contour
plt.imshow(outer_contour_image, cmap='gray')
plt.title('Outer Contour of the Colony')
plt.axis('off')
plt.show()


#######

# Step 6: Perform dilation to fill in gaps within the colony
kernel = np.ones((1, 2), np.uint8)  # You can adjust the kernel size as needed
dilated_image = cv2.dilate(binary_cropped_image, kernel, iterations=1)

# Convert the dilated image to grayscale
dilated_image_gray = rgb2gray(dilated_image)

# Find contours in the dilated image
contours_dilated = find_contours(dilated_image_gray, 0.4)

# Select the outermost contour in the dilated image
outer_contour_dilated = None
outer_contour_area_dilated = 0

for contour in contours_dilated:
    contour_area = len(contour)
    
    if contour_area > outer_contour_area_dilated:
        outer_contour_dilated = contour
        outer_contour_area_dilated = contour_area

# Create a new image to draw the outer contour on the dilated image
outer_contour_image_dilated = np.zeros_like(dilated_image)
outer_contour_dilated = np.flip(outer_contour_dilated, axis=1).astype(np.int32)

# Draw the outer contour on the dilated image
cv2.drawContours(outer_contour_image_dilated, [outer_contour_dilated], -1, (255, 0, 0), 1)

# Display the image with the outer contour after dilation
plt.imshow(outer_contour_image_dilated, cmap='gray')
# plt.title('Outer Contour of the Colony (After Dilation)')
plt.axis('off')
plt.show()

s_outer_contour_image_dilated = np.uint8(outer_contour_image_dilated[:, :, 0])

h, w = s_outer_contour_image_dilated.shape[:2]
mask = np.zeros((h+2, w+2), np.uint8)

im_floodfill = s_outer_contour_image_dilated.copy()

cv2.floodFill(im_floodfill, mask, (0,0), 255);

# cv2.imshow("Floodfilled Image", im_floodfill)
plt.imshow(im_floodfill, cmap='gray')
plt.axis('off')
plt.show()

# Invert floodfilled image
# im_floodfill_inv = cv2.bitwise_not(im_floodfill)
 
# Combine the two images to get the foreground.
# im_out = s_outer_contour_image_dilated | im_floodfill_inv
im_out = s_outer_contour_image_dilated | im_floodfill


plt.imshow(im_out)
plt.axis('off')
plt.show()


# Define the dark gray color (BGR format)
dark_gray = (160, 150, 150)


# Create an empty color image with an alpha channel
height, width = im_out.shape
color_image = np.zeros((height, width, 4), dtype=np.uint8)

# Set the background color to fully transparent (0 alpha)
color_image[:, :, 3] = 255

# Set the foreground (white) regions to black (0) and fully transparent (0 alpha)
color_image[im_out == 0, :3] = 255
# color_image[im_out == 255, 3] = 0

# Set the foreground (white) regions to dark gray
color_image[im_out == 0, :3] = dark_gray

image_rgb = cv2.cvtColor(color_image, cv2.COLOR_BGR2RGB)

# Define the color to replace black with (white in BGR format)
white_color = (255, 255, 255)

# Create a mask for black pixels
black_mask = np.all(image_rgb == [0, 0, 0], axis=2)

# Replace black pixels with white color
image_rgb[black_mask] = white_color




# Display the image using matplotlib
plt.imshow(image_rgb)

# uncommand lines 207 - 225 to add a scale bar
# Define the length of the scale bar in your desired units (e.g., millimeters)
scale_bar_length_mm = 15

# Define the image resolution in pixels per unit length (e.g., pixels per millimeter)
pixels_per_mm = 1 / (pix_to_mm * ( (h_org) / (h) ) ) # Adjust this value according to your image resolution

# Calculate the length of the scale bar in pixels
scale_bar_length_px = scale_bar_length_mm * pixels_per_mm

# Add the scale bar line
plt.plot([230, 230 + scale_bar_length_px], [300, 300], color='black', linewidth=4)

# Add the scale bar label
# plt.text(10 + scale_bar_length_px / 2, 5, f'{scale_bar_length_mm} mm', color='white',
#          ha='center', va='bottom', fontsize=12)

# Adjust the appearance of the scale bar (line color, label color, etc.) as needed

# Customize plot settings
plt.gca().set_aspect('equal')  # Equal aspect ratio

plt.axis('off')  # Turn off axis labels and ticks
plt.title('')  # Turn off axis labels and ticks
plt.show()

# Save the displayed figure as a file
# plt.savefig(image_filename+'.png', format='png', bbox_inches='tight')
# # Show the saved PDF filename
# print(f'Image saved as {image_filename}')


inverted_image = (255 - im_out)/255


area_pixels = np.sum(inverted_image) * ( (h_org * w_org) / (h * w) )


area_mm2 = area_pixels * (pix_to_mm * pix_to_mm)

# Display the areas on the console
print(f"Colonized Area (Pixels): {area_pixels} pixels")
print(f"Colonized Area (Square Millimeters): {area_mm2:.2f} mm²")

# Write the areas to a CSV file
csv_filename = image_filename+'_colonized_areas.csv'
with open(csv_filename, mode='w', newline='') as csv_file:
    fieldnames = ['Measurement', 'Value']
    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerow({'Measurement': 'Colonized Area (Pixels)', 'Value': area_pixels})
    writer.writerow({'Measurement': 'Colonized Area (Square Millimeters)', 'Value': area_mm2})

# Close the CSV file
csv_file.close()

# Display the saved CSV filename
print(f"Area data saved to {csv_filename}")

gray_mask = 255 - im_floodfill
# gray_mask = im_floodfill * 1

plt.imshow(gray_mask, cmap='gray')
plt.axis('off')
plt.show()

# Create an all-black RGB image of the same size as the gray mask
height, width = gray_mask.shape
rgb_mask = np.zeros((height, width, 3), dtype=np.uint8)

# Set all three channels (R, G, B) to the values of the gray mask
rgb_mask[:, :, 0] = gray_mask/255  # Red channel
rgb_mask[:, :, 1] = gray_mask/255  # Green channel
rgb_mask[:, :, 2] = gray_mask/255  # Blue channel

# Convert cropped_image to the same data type as rgb_mask
cropped_image = cropped_image.astype(rgb_mask.dtype)

result_image = cv2.multiply(cropped_image, rgb_mask)

# Find the black pixels (pixels with all channels equal to 0)
black_pixels = np.all(result_image == [0, 0, 0], axis=-1)

# Set the black pixels to white (255 in all channels)
result_image[black_pixels] = [255, 255, 255]

# Display the image using matplotlib
plt.imshow(result_image)

# uncommand lines 297 - 315 to add a scale bar
# Define the length of the scale bar in your desired units (e.g., millimeters)
# scale_bar_length_mm = 15

# # Define the image resolution in pixels per unit length (e.g., pixels per millimeter)
# pixels_per_mm = 1 / (pix_to_mm * ( (h_org) / (h) ) ) # Adjust this value according to your image resolution

# # Calculate the length of the scale bar in pixels
# scale_bar_length_px = scale_bar_length_mm * pixels_per_mm

# # Add the scale bar line
# plt.plot([275, 275 + scale_bar_length_px], [370, 370], color='black', linewidth=4)

# # Add the scale bar label
# # plt.text(10 + scale_bar_length_px / 2, 5, f'{scale_bar_length_mm} mm', color='white',
# #          ha='center', va='bottom', fontsize=12)

# # Adjust the appearance of the scale bar (line color, label color, etc.) as needed

# # Customize plot settings
# plt.gca().set_aspect('equal')  # Equal aspect ratio

plt.axis('off')  # Turn off axis labels and ticks
plt.title('')  # Turn off axis labels and ticks
plt.show()

#Save the displayed figure as a file
plt.savefig(image_filename+'_proc.png', format='png', bbox_inches='tight')
# Show the saved PDF filename
print(f'Image saved as {image_filename}')


# Display the areas on the console
print(f"Colonized Area (Pixels): {area_pixels} pixels")
print(f"Colonized Area (Square Millimeters): {area_mm2:.2f} mm²")