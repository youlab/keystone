#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  2 17:00:14 2024

@author: emrahsimsek
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  2 16:27:46 2024

@author: emrahsimsek
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Define custom colors for Kp and Pa
custom_color_Kp = (178/255, 64/255, 59/255)  # Red shade for Kp
custom_color_Pa = (23/255, 162/255, 184/255)  # Blue shade for Pa

# Define markers and fill styles
experiment_markers = ['o', '^', 's']  # Circle for Exp 1, Triangle for Exp 2
fill_styles = ['full', 'none', 'top']  # Solid, Open, Shaded

# Load data from CSV file
data = pd.read_csv('RelAbn_data_KpPa_agar.csv')

# Filter out rows with missing or invalid technical replicate entries
data = data[data['Technical replicate'].notna()]
data['Technical replicate'] = data['Technical replicate'].astype(int)

# Separate the data into control and antibiotic conditions
control_data = data[data['Condition'] == 'Control']
antibiotic_data = data[data['Condition'] == 'Antibiotic']

# Function to calculate means and standard deviations across independent replicates
def calculate_stats(data, species):
    # Filter data for the given species
    species_data = data[data['Species'] == species]

    # Calculate mean and SD across independent replicates
    replicate_means = species_data.groupby(['Experiment'])['Value'].mean()
    overall_mean = replicate_means.mean()  # Biological mean
    biological_sd = replicate_means.std()  # Biological variability (SD)
    return overall_mean, biological_sd

# Calculate statistics for control and antibiotic conditions
Kp_means_control, Kp_std_control = calculate_stats(control_data, 'Kp')
Pa_means_control, Pa_std_control = calculate_stats(control_data, 'Pa')
Kp_means_antibiotic, Kp_std_antibiotic = calculate_stats(antibiotic_data, 'Kp')
Pa_means_antibiotic, Pa_std_antibiotic = calculate_stats(antibiotic_data, 'Pa')

# Define horizontal bar positions and labels
bar_labels = ['Kp (Control)', 'Pa (Control)', 'Kp (Antibiotic)', 'Pa (Antibiotic)']
bar_positions = [0, 0.35, 1, 1.35]  # Adjusted positions for closer bars and new condition

# Create the figure
plt.figure(figsize=(9.4, 7))
bar_width = 0.3

# Plot horizontal bars with error bars
plt.barh(
    bar_positions,
    [Kp_means_control, Pa_means_control, Kp_means_antibiotic, Pa_means_antibiotic],
    xerr=[Kp_std_control, Pa_std_control, Kp_std_antibiotic, Pa_std_antibiotic],
    height=bar_width,
    color=[custom_color_Kp, custom_color_Pa, custom_color_Kp, custom_color_Pa],
    edgecolor='black',
    linewidth=1,
    capsize=10,
)

# To track the already jittered positions for each condition
jittered_positions = {'control': {'Kp': [], 'Pa': []}, 'antibiotic': {'Kp': [], 'Pa': []}}

# Overlay scatter data points for technical replicates
for i, condition_data in enumerate([control_data, antibiotic_data]):  # Control and antibiotic conditions
    for j, species in enumerate(['Kp', 'Pa']):  # Species: Kp and Pa
        species_data = condition_data[condition_data['Species'] == species]
        for _, row in species_data.iterrows():
            experiment = int(row['Experiment'])
            replicate = int(row['Technical replicate'])
            value = row['Value']

            # Add jitter for better visualization
            jitter = np.random.uniform(-bar_width / 2.5, bar_width / 2.5)
            
            # Check if the jittered value is too close to the already jittered values
            condition_name = 'control' if i == 0 else 'antibiotic'  # Control or antibiotic condition
            while any(abs(jitter - pos) < 0.02 for pos in jittered_positions[condition_name][species]):
                jitter = np.random.uniform(-bar_width / 2.5, bar_width / 2.5)  # Recalculate jitter if too close

            # Select marker and style based on experiment and replicate
            marker = experiment_markers[experiment - 1]
            fill_style = fill_styles[(replicate - 1) % len(fill_styles)]

            if fill_style == 'full':  # Filled marker
                plt.scatter(
                    value,
                    bar_positions[i * 2 + j] + jitter,
                    marker=marker,
                    facecolor='black',
                    edgecolor='black',
                    s=100,
                    zorder=5,
                )
            elif fill_style == 'none':  # Open marker
                plt.scatter(
                    value,
                    bar_positions[i * 2 + j] + jitter,
                    marker=marker,
                    facecolor='none',
                    edgecolor='black',
                    s=100,
                    zorder=5,
                )
            elif fill_style == 'top':  # Shaded marker (half-filled)
                plt.scatter(
                    value,
                    bar_positions[i * 2 + j] + jitter,
                    marker=marker,
                    facecolor='none',
                    hatch='////',
                    edgecolor='black',
                    s=100,
                    zorder=5,
                )

            # Store the jittered y-value for future checks
            jittered_positions[condition_name][species].append(bar_positions[i * 2 + j] + jitter)

# Customize axes and aesthetics
plt.xlim(-1, 102)
plt.gca().set_yticks(bar_positions)
plt.tick_params(axis='y', labelleft=False, labelsize=36)
plt.xlabel('final relative abundance (%)', fontsize=44, fontname='Arial', labelpad=16)
plt.gca().invert_yaxis()  # Flip y-axis for horizontal bars
plt.gca().set_xticks([0, 25, 50, 75, 100])  # Positions for x-ticks
plt.tick_params(axis='x', labelsize=36)
plt.gca().spines[['top', 'right']].set_visible(False)  # Hide top and right spines
plt.gca().spines['left'].set_position(('data', 0))  # Move the left spine to x=3
plt.gca().spines['left'].set_linewidth(1.5)  # Left axis thicker
plt.gca().spines['bottom'].set_linewidth(1.5)  # Bottom axis thicker

# Save the plot
plt.savefig('Figure1D.pdf', format='pdf', dpi=300, bbox_inches='tight')

# Show the plot
plt.show()
