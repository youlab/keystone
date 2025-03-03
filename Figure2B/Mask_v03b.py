import tifffile
import numpy as np
import matplotlib.pyplot as plt
import cv2
from skimage.color import rgb2gray
from skimage.measure import find_contours
import csv

# Image and scale settings
image_filename = 'yourImageName'
pix_to_mm = 0.105882353  # Pixel to millimeter conversion factor

# Step 1: Load and preprocess the image
image = tifffile.imread(image_filename+'.TIF')
gray_image = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
h_org, w_org = gray_image.shape[:2]

# Resize the image for easier processing (optional)
resized_image = cv2.resize(gray_image, (400, 400))
h, w = resized_image.shape[:2]

# Step 2: Thresholding to create a binary image
threshold = 60
_, binary_image = cv2.threshold(resized_image, threshold, 255, cv2.THRESH_BINARY)

# Step 3: Masking the central part of the image (for Petri dish isolation)
mask = np.zeros_like(resized_image, dtype=np.uint8)
center_x, center_y = mask.shape[1] // 2, mask.shape[0] // 2
radius = 150  # Adjust radius for your specific image
cv2.circle(mask, (center_x, center_y), radius, 255, -1)

# Apply the mask
masked_image = cv2.bitwise_and(binary_image, binary_image, mask=mask)

# Display the masked binary image
plt.imshow(masked_image, cmap='gray')
plt.title('Masked Binary Image')
plt.axis('off')
plt.show()

# Step 4: Ensure binary_cropped_image is in grayscale and 8-bit
binary_cropped_image = masked_image
if len(binary_cropped_image.shape) > 2:
    binary_cropped_image_gray = cv2.cvtColor(binary_cropped_image, cv2.COLOR_BGR2GRAY)
else:
    binary_cropped_image_gray = binary_cropped_image

# Convert to binary again (in case of small variations) and 8-bit
_, binary_cropped_image_gray = cv2.threshold(binary_cropped_image_gray, threshold, 255, cv2.THRESH_BINARY)
binary_cropped_image_gray = binary_cropped_image_gray.astype(np.uint8)

# Step 5: Find contours of the colonies
contours_cropped, _ = cv2.findContours(binary_cropped_image_gray, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# Step 6: Calculate areas of colonies and filter based on size threshold
colony_areas_pixels = []
filtered_contours = []
for contour in contours_cropped:
    # Calculate the area in the resized image
    area_pixels_resized = cv2.contourArea(contour)
    
    # Adjust the area to the original image size using the scaling factor
    scaling_factor = (h_org * w_org) / (h * w)
    area_pixels = area_pixels_resized * scaling_factor
    
    # Apply the lower threshold (4000 pixels)
    if area_pixels >= 2000:
        colony_areas_pixels.append(area_pixels)
        filtered_contours.append(contour)  # Store only the contours that pass the threshold

# Convert areas to square millimeters
colony_areas_mm2 = [(area_pixels * pix_to_mm * pix_to_mm) for area_pixels in colony_areas_pixels]

# Display the areas in pixels and mm²
for i, (area_px, area_mm2) in enumerate(zip(colony_areas_pixels, colony_areas_mm2)):
    print(f"Colony {i+1}: {area_px:.2f} pixels, {area_mm2:.2f} mm²")

# Calculate the total area in mm²
total_area_mm2 = sum(colony_areas_mm2)
print(f"Total Colonized Area (Square Millimeters): {total_area_mm2:.2f} mm²")

# Step 7: Display the final masked image with filtered contours
final_image = np.zeros_like(resized_image)  # Create an empty black image to draw filtered contours

# Draw the filtered contours onto the final image
cv2.drawContours(final_image, filtered_contours, -1, 255, thickness=cv2.FILLED)

# Display the final image with colonies that passed the size threshold
plt.imshow(final_image, cmap='gray')
plt.title('Final Masked Image with Thresholded Colonies (>= 2000 pixels)')
plt.axis('off')
plt.show()

# Save the final masked image to a file if needed
final_masked_image_filename = image_filename + '_filtered_masked_image.TIF'
tifffile.imwrite(final_masked_image_filename, final_image)

print(f"Final masked image saved as {final_masked_image_filename}")

# Save the areas to a CSV file
csv_filename = image_filename+'_colonized_areas_filtered.csv'
with open(csv_filename, mode='w', newline='') as csv_file:
    fieldnames = ['Colony Number', 'Area (Pixels)', 'Area (Square Millimeters)']
    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    writer.writeheader()
    for i, (area_px, area_mm2) in enumerate(zip(colony_areas_pixels, colony_areas_mm2)):
        writer.writerow({'Colony Number': i+1, 'Area (Pixels)': area_px, 'Area (Square Millimeters)': area_mm2})
    writer.writerow({'Colony Number': 'Total', 'Area (Pixels)': '-', 'Area (Square Millimeters)': total_area_mm2})

print(f"Filtered area data saved to {csv_filename}")


# Step 8: Select two points and calculate Euclidean distance
def click_event(event, x, y, flags, params):
    if event == cv2.EVENT_LBUTTONDOWN:
        # Store the point
        points.append((x, y))
        # Mark the point on the image
        cv2.circle(orig_image_copy, (x, y), 3, (255, 0, 0), -1)
        cv2.imshow('Original Image', orig_image_copy)

# Load the original image for point selection
orig_image_copy = image.copy()
cv2.imshow('Original Image', orig_image_copy)
points = []
cv2.setMouseCallback('Original Image', click_event)

print("Please click two points on the image to measure the distance.")
cv2.waitKey(0)  # Wait until two points are clicked
cv2.destroyAllWindows()

# Ensure two points were selected
if len(points) == 2:
    point1, point2 = points
    # Calculate Euclidean distance between the two points
    distance_pixels = np.linalg.norm(np.array(point1) - np.array(point2))
    distance_mm = distance_pixels * pix_to_mm
    print(f"Distance between the points: {distance_pixels:.2f} pixels, {distance_mm:.2f} mm")
else:
    print("Error: Please select exactly two points.")
