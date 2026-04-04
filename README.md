# South German Credit Risk Analysis
### Binary Logistic Regression Model for Loan Default Prediction | SAS

![SAS](https://img.shields.io/badge/Tool-SAS%20Viya-blue?style=flat-square)
![Model](https://img.shields.io/badge/Algorithm-Logistic%20Regression-green?style=flat-square)
![AUC](https://img.shields.io/badge/AUC-0.78-orange?style=flat-square)
![Dataset](https://img.shields.io/badge/Dataset-1000%20Observations-lightgrey?style=flat-square)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)



##  Project Overview

Non-Performing Assets (NPAs) are among the biggest threats to banking profitability. This project builds a **statistically rigorous, regulatory-compliant credit scoring model** to automate loan approval decisions and quantify default risk at the applicant level.

Using the **South German Credit Dataset** (1,000 applicants, 21 variables), a Binary Logistic Regression model was developed in SAS to classify applicants as creditworthy or high risk and translate findings into **actionable business policy**.

---

## Business Objectives

- Predict the probability of loan default for individual applicants
- Identify the most statistically significant risk drivers
- Translate odds ratios into concrete bank policies to minimize NPAs
- Build a model that meets the AUC > 0.75 industry benchmark

---

## Key Results

| Metric | Value |
|---|---|
| **AUC (Discriminatory Power)** | **0.78** |
| **Sensitivity at 0.25 cutoff** | 74.4% |
| **Specificity at 0.25 cutoff** | 67.6% |
| **AIC Reduction (vs Null Model)** | 1360.6 → 1117.4 (17.9% improvement) |
| **Global Null Hypothesis p-value** | < 0.0001 |

> An AUC of 0.78 means the model correctly distinguishes a defaulter from a non-defaulter **78% of the time** meeting industry standards for credit scoring models.

---

## Top Risk Drivers (Type 3 Analysis)

| Variable | Wald Chi-Square | p-value |
|---|---|---|
| Checking Account Status | **76.52** | < .0001 |
| Savings Amount | 24.54 | < .0001 |
| Credit Amount | 18.56 | < .0001 |
| Telephone | 11.26 | 0.0008 |
| Credit History | 16.07 | 0.0029 |

### Odds Ratio Highlights
- Applicants with **overdraft/negative checking balance** are **5.23x more likely** to default
- Applicants with a **critical credit history** are **2.82x more likely** to default
- Applicants with **savings > 1000 DM** showed significantly lower default probability

---

## Methodology

```
Raw Data (1,000 obs, 21 vars)
        ↓
Data Cleaning & Variable Renaming (German → English banking terms)
        ↓
Stratified Random Sampling (70% Train / 30% Test)
        ↓
Binary Logistic Regression (MLE estimation)
        ↓
Stepwise Variable Selection (SLENTRY = SLSTAY = 0.05)
        ↓
Model Evaluation: AIC, ROC/AUC, Odds Ratios, Classification Table
        ↓
Business Policy Recommendations
```

**Why Logistic Regression?**
- Target variable is binary (Good / Bad credit)
- Outputs are valid probabilities (0–1)
- Transparent and interpretable — essential for regulatory compliance in banking
- Coefficient signs and odds ratios map directly to business decisions

---

## Business Recommendations

Based on the model's findings, three policies are recommended:

1. **Automated Rejection** — Flag applicants with overdraft checking status or critical credit history for automatic rejection. These segments carry ~5x the baseline default risk.

2. **Enhanced Verification for Non-Residents** — Foreign Worker status was identified as a significant risk driver. Require additional documentation or a local guarantor for this segment.

3. **Exposure Limits** — Since credit amount is positively correlated with default, restrict high-risk segments to smaller short-term loans until a positive repayment history is established.

---


## Tools & Technologies

- **SAS Viya** — Data processing, modeling, statistical output
- **PROC LOGISTIC** — Binary Logistic Regression with stepwise selection
- **PROC SURVEYSELECT** — Stratified random sampling
- **PROC IMPORT** — Data ingestion

---

## Dataset

**Source:** South German Credit Dataset  
**Curated by:** Prof. Ulrike Grömping, Beuth University of Applied Sciences Berlin (2019)  
**Purpose:** Corrected version of the classic German Credit data, fixing known translation errors  
**Size:** 1,000 observations × 21 variables  
**Target variable:** `Default_Risk` (0 = Bad/Default, 1 = Good/Non-Default)
