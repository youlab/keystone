#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Customized Bar Plot with Logarithmic Y-axis and Font Adjustments
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load your CSV file (replace 'data.csv' with the path to your file, if needed)
df = pd.read_csv('data.csv', header=None)

# Convert the DataFrame to a list of lists (each column represents a group)
#data = [df[column].dropna().values.tolist() for column in df.columns]  # `dropna()` ensures n/a values are excluded
data = [df[column].values.tolist() for column in df.columns]  # `dropna()` ensures n/a values are excluded

# Split data into 3 independent experiments, with 2 technical replicates each
def split_experiments(data):
    experiments = []
    for group in data:
        exp1 = group[:2]  # Technical replicates for exp 1
        exp2 = group[2:4] # Technical replicates for exp 2
        exp3 = group[4:6] # Technical replicates for exp 3
        experiments.append((exp1, exp2, exp3))
    return experiments

experiments_data = split_experiments(data)

# Calculate the mean and standard deviation for each group, ignoring NaN values
means = df.mean(axis=0).tolist()  # `pandas` automatically ignores NaN in mean()
std_devs = df.std(axis=0, ddof=1).tolist()  # `pandas` ignores NaN in std()

# Define bar widths and custom separations (adjust as needed to fit your data)
bar_widths = [1, 0.5, 0.5, 1, 1, 1, 0.5, 0.5, 1, 1]  # Example for 10 groups
#bar_positions = [0, 0.75, 1.25, 3, 4.175, 6.675, 7.425, 7.925, 9.675, 10.85]  # Adjust for your data
#bar_positions = [0.0, 0.75, 1.25, 3.0, 4.25, 6.75, 7.5, 8.0, 9.75, 11.0]  # Adjust for your data
bar_positions = [0.0, 0.95, 1.65, 3.4, 4.65, 7.15, 8.1, 8.8, 10.55, 11.8]  # Adjust for your data

# Define the custom RGB colors (same as before)
#
custom_color_1 = (178/255, 64/255, 59/255)
custom_color_2 = (23/255, 162/255, 184/255)
custom_color_3 = (100.5/255, 113/255, 121.5/255)

# Define markers for independent experiments
experiment_markers = {
    'exp1': ['o', 'o'],  # Circle, filled and unfilled
    'exp2': ['^', '^'],  # Triangle, filled and unfilled
    'exp3': ['s', 's']   # Square, filled and unfilled
}
fill_styles = ['full', 'none']  # Filled first, then unfilled for technical replicates

# Plot the bar chart
plt.figure(figsize=(10, 6))

# Loop to customize face and edge colors for specific bars and thicken the edges
for i in range(len(bar_positions)):
    if i == 0:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_3, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 1:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_1, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 2:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_2, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 3:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_1, 
                edgecolor=custom_color_1, linewidth=8)
    elif i == 4:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_2, 
                edgecolor=custom_color_2, linewidth=8)
    elif i == 5:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_3, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 6:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_1, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 7:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_2, 
                edgecolor=custom_color_3, linewidth=8)
    elif i == 8:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_1, 
                edgecolor=custom_color_1, linewidth=8)
    elif i == 9:
        plt.bar(bar_positions[i], means[i], width=bar_widths[i], color=custom_color_2, 
                edgecolor=custom_color_2, linewidth=8)

# Add error bars with dark grey color
plt.errorbar(bar_positions, means, yerr=std_devs, fmt='none', capsize=5, color='darkgrey', linewidth=1)


# Set the random seed
#np.random.seed(42)

# Overlay individual data points with different marker symbols and styles
for i, group_data in enumerate(experiments_data):
    # Iterate through the 3 experiments
    for exp_num, (exp_data, marker) in enumerate(zip(group_data, experiment_markers.values())):
        for tech_rep_num, tech_data in enumerate(exp_data):
            # tech_rep_num is 0 (filled) and 1 (unfilled)
            jitter = np.random.uniform(-bar_widths[i]/2, bar_widths[i]/2)  # Jitter for visibility
            plt.scatter(np.full_like(tech_data, bar_positions[i]) + jitter, tech_data, 
                        marker=marker[tech_rep_num], edgecolor='black', facecolor='none' if tech_rep_num == 1 else 'black',
                        label=f'Exp {exp_num+1} Rep {tech_rep_num+1}' if i == 0 else "")  # Label legend only once

# Set y-axis to logarithmic scale and adjust limits
plt.yscale('log')
plt.ylim(0.001, 100)

# Customize the y-axis label and ticks
plt.ylabel(r'Biomass (OD$_{600}$$\times$ml)', fontsize=30, fontname='Arial')
# Make the y-axis spine (line) three times thicker
plt.gca().spines['left'].set_linewidth(2.0)  # Set left spine (y-axis line) thickness
plt.tick_params(axis='y', labelsize=24)  # Set y-axis numbers to 24 pt
plt.xticks([])  # This will hide the x-axis tick values
# Make the tick marks thicker
plt.tick_params(axis='y', which='both', width=2.0)  # Thicker y-axis tick marks
plt.gca().spines[['top', 'right']].set_visible(False)

# Save the plot as a PDF with high resolution (300 dpi)
plt.savefig('SupFig4.pdf', format='pdf', dpi=300, bbox_inches='tight')

# Show the plot
plt.show()


