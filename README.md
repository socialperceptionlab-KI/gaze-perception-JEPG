# PNAS Analysis Scripts

Analysis scripts for gaze perception experiments.

## Experiments

### Experiment 1 (S vs O)
- **S** = Self
- **O** = Other
- N = 31 participants

### Experiment 2 (O vs M vs B)
- **O** = Other
- **M** = Mannequin
- **B** = Blank Screen
- N = 30 participants

## Scripts

### Single Participant Analysis

**`computeParticipantMetrics_Exp1.m`** and **`computeParticipantMetrics_Exp2.m`**

Computes body-vs-face downward bias, accuracy, and gaze radius for a single participant.

**Input:** `.mat` files containing processed data with:
- `point3D` - 3D coordinates of pointed locations (3×38 matrix)
- `gazeClusterCenterFixed` - 3D coordinates of perceived gaze locations, calibrated (3×38 matrix)
- `errMagFixed` - Error magnitudes for each point, calibrated (1×38 array)
- `gazeClusterRadius` - Radius of gaze cluster for each point (1×38 array)

Note: "Fixed" indicates calibrated data.

**How metrics are computed:**
1. **Error direction**: `errorDirs = point3D - gazeClusterCenterFixed`
2. **Body-vs-face downward bias**: 
   - Mean vertical error for face prompts (1-9)
   - Mean vertical error for body prompts (10-38)
   - Bias = Body mean - Face mean
3. **Accuracy**: Mean of `errMagFixed` (overall, face-only, body-only)
4. **Gaze Radius**: Mean of `gazeClusterRadius` (consistency of gaze estimates)
5. **Conversion to visual degrees**: `2 * atand((mm / 2) / distFromEye)` where distFromEye = 1850 mm

### Group Analysis

**`groupAnalysis_Exp1.m`**

Loads pre-computed arrays for all participants and performs:

*Vertical Bias:*
- Paired t-test: Self vs Other
- One-sample t-tests vs 0 (for each condition)
- Cohen's d effect sizes

*Accuracy:*
- 2×2 Repeated Measures ANOVA (Region × Mode) with partial eta squared (η²p)
- Post-hoc paired t-tests

*Gaze Radius:*
- Descriptive statistics (M, SEM)

Generates bar plots with significance markers.

**`groupAnalysis_Exp2.m`**

Loads pre-computed arrays for all participants and performs:

*Vertical Bias:*
- Pairwise t-tests between conditions (O vs M, O vs B, M vs B)
- One-sample t-tests vs 0
- Cohen's d effect sizes

*Accuracy:*
- 2×3 Repeated Measures ANOVA (Region × Mode) with partial eta squared (η²p)
- Post-hoc paired t-tests

*Gaze Radius:*
- Descriptive statistics (M, SEM)

Generates bar plots with significance markers.

### Calibration Quality Analysis

**`calibrationQuality_Exp1.m`** and **`calibrationQuality_Exp2.m`**

Loads pre-computed calibration quality data and displays summary statistics.

**Calibration method:**
- 21-point calibration grid
- Gaze error corrected using Procrustes analysis (translation, rotation, uniform scaling)
- Points with missing data or gaze cluster radius > 50 mm excluded from fit

**Metrics reported:**
- Mean error magnitude before calibration (mm and visual degrees)
- Mean error magnitude after Procrustes correction
- Error reduction due to calibration

## Data Files

### Single Participant Data
| File | Description |
|------|-------------|
| `Exp1_S_singleParticipant.mat` | Exp1 Self condition - single participant |
| `Exp1_O_singleParticipant.mat` | Exp1 Other condition - single participant |
| `Exp2_O_singleParticipant.mat` | Exp2 Other condition - single participant |
| `Exp2_M_singleParticipant.mat` | Exp2 Mannequin condition - single participant |
| `Exp2_B_singleParticipant.mat` | Exp2 Blank condition - single participant |

### Group Average Data

**Exp1 files:**
| File | Description |
|------|-------------|
| `Exp1_S_average_vertBiasDiff.mat` | Self - body-vs-face downward bias |
| `Exp1_S_average_accuracy.mat` | Self - overall accuracy |
| `Exp1_S_average_accuracyFace.mat` | Self - face region accuracy |
| `Exp1_S_average_accuracyBody.mat` | Self - body region accuracy |
| `Exp1_S_gazeRadius.mat` | Self - gaze cluster radius |
| `Exp1_O_average_vertBiasDiff.mat` | Other - body-vs-face downward bias |
| `Exp1_O_average_accuracy.mat` | Other - overall accuracy |
| `Exp1_O_average_accuracyFace.mat` | Other - face region accuracy |
| `Exp1_O_average_accuracyBody.mat` | Other - body region accuracy |
| `Exp1_O_gazeRadius.mat` | Other - gaze cluster radius |

**Exp2 files:**
| File | Description |
|------|-------------|
| `Exp2_O_average_vertBiasDiff.mat` | Other - body-vs-face downward bias |
| `Exp2_O_average_accuracy.mat` | Other - overall accuracy |
| `Exp2_O_average_accuracyFace.mat` | Other - face region accuracy |
| `Exp2_O_average_accuracyBody.mat` | Other - body region accuracy |
| `Exp2_O_gazeRadius.mat` | Other - gaze cluster radius |
| `Exp2_M_average_vertBiasDiff.mat` | Mannequin - body-vs-face downward bias |
| `Exp2_M_average_accuracy.mat` | Mannequin - overall accuracy |
| `Exp2_M_average_accuracyFace.mat` | Mannequin - face region accuracy |
| `Exp2_M_average_accuracyBody.mat` | Mannequin - body region accuracy |
| `Exp2_M_gazeRadius.mat` | Mannequin - gaze cluster radius |
| `Exp2_B_average_vertBiasDiff.mat` | Blank - body-vs-face downward bias |
| `Exp2_B_average_accuracy.mat` | Blank - overall accuracy |
| `Exp2_B_average_accuracyFace.mat` | Blank - face region accuracy |
| `Exp2_B_average_accuracyBody.mat` | Blank - body region accuracy |
| `Exp2_B_gazeRadius.mat` | Blank - gaze cluster radius |

### Calibration Quality Data
| File | Description |
|------|-------------|
| `Exp1_calibrationQuality_allParticipants.mat` | Exp1 calibration metrics (before/after) |
| `Exp2_calibrationQuality_allParticipants.mat` | Exp2 calibration metrics (before/after) |

## Metrics

- **Body-vs-face downward bias**: Body - Face vertical error difference (positive = gaze perceived lower on body than face)
- **Accuracy**: Mean error magnitude in visual degrees
- **Gaze Radius**: Mean radius of gaze cluster in visual degrees (measure of response consistency)
