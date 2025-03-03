#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  2 18:32:01 2024

@author: emrahsimsek
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Define custom colors for Bp and Pa192622
custom_color_Bp = (255/255, 111/255, 97/255)  # Red shade for Bp
custom_color_Pa192622 = (166/255, 220/255, 239/255)  # Blue shade for Pa192622192622

# Define markers and fill styles
experiment_markers = ['o', '^', 's']  # Circle for Exp 1, Triangle for Exp 2
fill_styles = ['full', 'none', 'top']  # Solid, Open, Shaded

# Load data from CSV file
data = pd.read_csv('RelAbn_data_BpPa192622_agar.csv')


# Filter out rows with missing or invalid technical replicate entries
data = data[data['Technical replicate'].notna()]
data['Technical replicate'] = data['Technical replicate'].astype(int)

# SePa192622rate the data into control and antibiotic conditions
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
Bp_means_control, Bp_std_control = calculate_stats(control_data, 'Bp')
Pa192622_means_control, Pa192622_std_control = calculate_stats(control_data, 'Pa192622')
Bp_means_antibiotic, Bp_std_antibiotic = calculate_stats(antibiotic_data, 'Bp')
Pa192622_means_antibiotic, Pa192622_std_antibiotic = calculate_stats(antibiotic_data, 'Pa192622')

# Define horizontal bar positions and labels
bar_labels = ['Bp (Control)', 'Pa192622 (Control)', 'Bp (Antibiotic)', 'Pa192622 (Antibiotic)']
bar_positions = [0, 0.35, 1, 1.35]  # Adjusted positions for closer bars and new condition

# Create the figure
plt.figure(figsize=(9.4, 7))
bar_width = 0.3

# Plot horizontal bars with error bars
plt.barh(
    bar_positions,
    [Bp_means_control, Pa192622_means_control, Bp_means_antibiotic, Pa192622_means_antibiotic],
    xerr=[Bp_std_control, Pa192622_std_control, Bp_std_antibiotic, Pa192622_std_antibiotic],
    height=bar_width,
    color=[custom_color_Bp, custom_color_Pa192622, custom_color_Bp, custom_color_Pa192622],
    edgecolor='black',
    linewidth=1,
    capsize=10,
)

# To track the already jittered positions for each condition
jittered_positions = {'control': {'Bp': [], 'Pa192622': []}, 'antibiotic': {'Bp': [], 'Pa192622': []}}

# Overlay scatter data points for technical replicates
for i, condition_data in enumerate([control_data, antibiotic_data]):  # Control and antibiotic conditions
    for j, species in enumerate(['Bp', 'Pa192622']):  # Species: Bp and Pa192622
        species_data = condition_data[condition_data['Species'] == species]
        for _, row in species_data.iterrows():
            experiment = int(row['Experiment'])
            replicate = int(row['Technical replicate'])
            value = row['Value']

            # Add jitter for better visualization
            jitter = np.random.uniform(-bar_width / 2.5, bar_width / 2.5)
            
            # Check if the jittered value is too close to the already jittered values
            condition_name = 'control' if i == 0 else 'antibiotic'  # Control or antibiotic condition
            while any(abs(jitter - pos) < 0.03 for pos in jittered_positions[condition_name][species]):
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
plt.savefig('Figure3B.pdf', format='pdf', dpi=300, bbox_inches='tight')

# Show the plot
plt.show()
