# Kernel Ridge Regression 
## with gaussian kernel and k-Fold cross-validation

#### KRR
The four Matlab scripts found in the root directory of this repository are tools for using the kernel ridge regression algorithms. With the use of these matlab scripts you can easily implement and evaluate the KRR algorithm on any set of continuous floating point data. 

#### Walkthrough
The `/walkthrough` directory contains resources that were designed to explain the usage and inner workings of the KRR algorithms found in this repository. 

#### Double Perovskites
The `/double_perovskites` directory contains an example implementation of the KRR algorithms from this repository. The goal is to learn to predict the bang-gaps of a material from it's chemical composition. 

#### Data
The `/data` directory contains all the data files used in the examples. `gaussian_data.csv` represents a 3-dimensional function with added gaussian noise. `double_perovskites_gap.xlsx` contains chemical compositions and accompanying band-gaps of 1306 different double-perovskites. 

The double-perovskites database was sourced from https://cmr.fysik.dtu.dk/
  
------
*written by Robert Kuramshin*