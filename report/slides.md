---
author: 
    - Miklós Koren (CEU, HUN-REN KRTK, CEPR and CESifo)
    - Gergely Attila Kiss (HUN-REN KRTK, CEU and KSH)
title: "Communist Era Managers in Modern Times: A Comparison of Management Skills Across Generations"
date: March 21, 2024^[Supported by Forefront Research Excellence Grant (144193), and the European Research Council (313164 and 101097789)]
aspectratio: 1610
---

# Introduction

## Hungary, 1980 (Fortepan / Szalay Zoltán)
![](fig/fortepan_198036.jpg)

## Hungary, 1990 (MTI)
![](fig/tozsde.jpg)

## Number of Executive Positions Increased
![](fig/ceo-stock.png)

## Business Degrees Became More Prominent
![](fig/school-graduates.png)


## We know that...
### Management matters
- Firms with better management practices are more productive (Bloom et al 2010).
- Management can be improved by intensive training (Bloom et al 2013, Giorcelli 2019).

### Managers matter
- Managers are important for firm performance (Bertrand and Schoar 2003, Bennedsen et al 2007).
- Top CEOs are paid a lot (Gabaix and Landier 2008, Frydman et al 2010).

## Literature
- Large-scale management interventions: Italy (Giorcelli 2019), US (Bianchi and Giorcelli 2022, Giorcelli 2023)
- Large-scale education interventions: Italy (Bianchi and Giorcelli 2020), Colombia (Ferreyra et al 2023), Vietnam (Vu 2023)
- Selection by skill: Denmark (Akcigit, Pearce and Prato 2020)
- Calibrated models with education and selection: Guner et al 2008, Bhattacharya et al. 2013, Gomes and Kuehn 2017 and Esfahani 2019.

# Setup and Data
## Data
### Manager Data 1985-2019
Universe of corporations (1m) and their CEOs (1.3m). Firm size (employment) as proxy for manager quality.

### Biographies
Full biographies (school, work experience, etc.) for 63k people in 2013. 30k matched to CEO panel.

### College graduates
Number of gradues by degree and year.

## Measuring Manager Quality
Log employment of firm $i$ in year $t$ in industry $s$, with a mananager having entered in cohort $c$ is
$$
\ln L_{icst} = \beta_1\text{manager\_age}_{ict} + \beta_2\text{firm\_age}_{ict}  + \mu_{c} + \xi_{st} + \epsilon_{ict}.
$$

Quality: $\mu_c$

## Degree of Selection
$$
\ln \pi_{ic} = \theta\ln\lambda_i  - \theta \mu_c + \varepsilon_{ic}.
$$

Selectivity: $\theta$

## Manager Selection by Degree
\input{tables/selectivity.tex}

## Quantity Up, Quality Down
![](fig/ceo-flow-with-FE.png)



# World Management Survey
## Methodology
## Hungarian wave
Spring and Summer of 2018.

Target population: manufacturing firms with 50+ employees.

Sample: 762 firms. 

## Survey logistics
10 surveyors

### Funnel
1. 762 firms contacted by phone
2. 281 (37%) resulted in direct contact to manager
3. 144 (51%) scheduled an interview
4. 126 (87%) completed the interview
6. 118 (94%) usable responses

# Validation

## How old is your firm?
![](fig/firm_age_validation.png)

## How many employees does your firm have?
![](fig/employment_validation.png)

## ...zooming in
![](fig/employment_validation_cleaned.png)

## What percentage of your revenue is coming from exports?
![](fig/export_share_validation.png)

## Birth year of respondent and the CEO
![](fig/birth_year_validation.png)

## ...if the respondent **is** the CEO
![](fig/birth_year_validation_cleaned.png)

# Management Scores

## Larger foreign firms are better managed
\input{tables/management-lnL.tex}

## Management improves labor productivity
\input{tables/outcomes-management.tex}


# Cohort Effects
## Distribution of birth years of respondents
![](fig/cohort-respondent-histogram.png)

## Distribution of birth years of CEOs
![](fig/cohort-ceo-histogram.png)

## Older cohorts are worse managers
![](fig/cohort-respondent-marginsplot.png)

## ????
![](fig/cohort-ceo-marginsplot.png)

## ????
![](fig/cohort-respcontrol-marginsplot.png)

## Cohort effects only matter for domestic CEOs
![](fig/cohort-ceodomestic-marginsplot.png)

## ...not for expats
![](fig/cohort-ceoexpat-marginsplot.png)