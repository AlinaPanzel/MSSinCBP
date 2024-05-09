# Multisensory Sensitivity in Chronic Lower Back Pain fMRI Analysis

## Overview

This repository contains the fMRI analysis code for a study examining multisensory sensitivity in individuals with chronic lower back pain (CLBP) compared to control participants.

## Author

Alina Panzel

## Last Edited

17.04.2024

## Source Code

The analysis is based on the CANlab toolbox as well as source code by Yoni Ashar.

## Analysis Plan

The following analysis steps are included in this study:

### I. Behavioral Analysis
Linear Mixed Model to assess differences in unpleasantness ratings (auditory lo/hi, pressure pain lo/hi) between CLBP and controls.
Pearson Correlations between unpleasantness ratings and clinical pain measures (avg_pain (BPI-item), spontaneous pain).

### II. Follow-up Whole-Brain Exploratory Voxel-Wise Analysis
Investigate potential multisensory sensitivity (MSS)-related activity changes outside of defined ROI regions.

### III. Univariate ROI Analysis
Unisensory: Auditory (A1, IC, MGN), Mechanical (S1)
Sensory integrative: Insula (Ventral & Dorsal Anterior, Posterior)
Higher level: Medial Prefrontal Cortex, Precuneus, TPJ, Posterior Cingulate Cortex

### IV. Multivariate Analysis
Analysis of Aversive Patterns: Common, Mechanical, Auditory
Functional Mapping (FM) patterns: FM pain, FM multisensory stimulation.

### V. Brain - Behavior Correlations
Correlate areas showing significant BOLD activity differences between groups with the behavioral outcomes from the Behavioral Analysis section.

## Hypotheses

• Increased sensitivity to auditory and mechanical stimulation in CLBP patients compared to controls.
• Hypoactivation in CLBP patients in primary sensory areas, coupled with hyperactivation of sensory-integrative and self-referential areas.
• Increased stimulus-specific and generalized negative aversive processing in CLBP patients.
• Increased activity in CLBP patients compared to controls in FM pain and FM multisensory stimulation patterns.
• Hyperactivation of insula sub-areas to correlate with the degree of clinical pain.

## Usage

To run the analysis, go to the main script 'MSS_analysis.m' and follow the step-by-step instructions provided in each script. Ensure that all dependencies, including the CANlab tools, are installed and properly configured in your MATLAB environment.

## Contact

For any queries regarding the analysis, please contact Alina Panzel.


## Acknowledgements

Special thanks for the development of the CANlab tools, which facilitated this analysis.

