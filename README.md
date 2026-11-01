# Change-point detection for aCGH data

MATLAB implementations of two change-point detection algorithms using kernel and histogram betting functions.

## Requirements

- MATLAB (checked with R2025b)
- Statistics and Machine Learning Toolbox (`ksdensity`)
- Signal Processing Toolbox (`medfilt1`)

## Usage

Open MATLAB in this repository directory and run:

```matlab
alg1 = run_acgh('C:/data/CGH dataset.csv', 1, 'results/algorithm1');
alg2 = run_acgh('C:/data/CGH dataset.csv', 2, 'results/algorithm2');
```

A MAT file containing a table named `CGH` is also accepted. Input data are not included.

The CSV must contain 174 columns: BAC identifier, chromosome, position, followed by 57 patient triplets (log2 ratio, GNL, outlier flag), in the order defined in `csv2mat.m`.

## Algorithms and settings

Algorithm 1 uses a single betting stream and ranks observations together. Algorithm 2 combines two streams: ranks of normalized scores within the same sign group, and ranks of historical running-median scores within that same group. Positive observations form one group; zero and negative observations form the other.

Both methods remove missing ratios and observations flagged as outliers, apply a median filter of width 15, and normalize absolute filtered values by a moving standard deviation of width 15. Histogram counts and evaluation use matching equal-width bins. Processing restarts at the observation following an alarm.

Current settings are epsilon 10, significance 0.01, and random seed 2. Chromosomes 1–23 are processed; summary statistics cover chromosomes 1–22. Random draws share a stream across kernel and histogram calculations, so changing their execution order can change detections.

## Output

Each call writes `results.mat` and `summary.csv` to the requested directory. The returned structure contains kernel and histogram change-point cells, per-patient chromosome counts, summary statistics, and run settings. Change-point indices refer to the retained observations within each chromosome after missing values and outliers have been removed; they are not original CSV row numbers or genomic coordinates.

## Implementation notes

Constant filtered windows can yield infinite normalized scores. The existing random replacement of NaN p-values and single-observation segment handling are retained. No additional handling of these cases is introduced in this version.

## Reference

Charalambos Eliades and Harris Papadopoulos. Reliable Change Point Detection for ACGH data. Proceedings of Machine Learning Research 230:387–405, 2024.

https://proceedings.mlr.press/v230/eliades24a.html
