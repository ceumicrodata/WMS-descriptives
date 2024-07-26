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

## Would you like to be an entrepreneur?
![Lengyel, 1997, Fig 1](fig/lengyel1997.png)


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
- Attitudes and histories of entrepreneurs in the transition period: Lengyel György et al (1989...), Laki and Szalai (2004, 2013), Alas and Aarna (2016)
- Long-lasting effects of socialism: Fuchs-Schündeln and Masella (2016), Fuchs-Schündeln and Schündeln (2020)

## This paper
1. Study Hungarian managers and their management practices
    - administrative data (1985-2019)
    - original survey (2018)
2. Explore cohort effects: how old was the manager in 1990?

# Data
## Administrative Data
### Manager Data 1985-2019
Universe of corporations (1m) and their CEOs (1.3m). Firm size (employment) as proxy for manager quality.

### Biographies
Full biographies (school, work experience, etc.) for 63k people in 2013. 30k matched to CEO panel.

### College graduates
Number of gradues by degree and year.

### World Management Survey
Survey of Hungarian manufacturing firms, 2018.

## Large Firms are Overrepresented in Who is Who
![](fig/firm-wiw.png)


## Measuring Manager Quality
Log employment of firm $i$ in year $t$ in industry $s$, with a mananager having entered in cohort $c$ is
$$
\ln L_{icst} = \beta_1\text{manager\_age}_{ict} + \beta_2\text{firm\_age}_{ict}  + \mu_{c} + \xi_{st} + \epsilon_{ict}.
$$

Quality: $\mu_c$

## Quantity Up, Quality Down
![](fig/ceo-flow-with-FE.png)



# World Management Survey
## Methodology
Structured phone interview with operations manager or CEO. 40-60 minutes.

"What do you do when there is a production problem?" "How do you motivate your employees?" "What happens if you don't meet your target?"

Scored on 18 dimensions, 1-5 scale. Higher is better.

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

## Where is Hungary?
![](fig/management-means.png)

## Richer countries have better management
![](fig/management-vs-gdp.png)


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

## Older respondents are worse managers
![](fig/cohort-respondent-marginsplot.png)

## Older CEOs are worse managers
![](fig/cohort-ceo-marginsplot.png)

## Cohort effects only matter for domestic CEOs
![](fig/cohort-ceodomestic-marginsplot.png)

## ...not for expats
![](fig/cohort-ceoexpat-marginsplot.png)

# Conclusion
## Summary
1. Management scores meanigfully correlate with firm outcomes.
2. Hungarian managers are worse than in richer countries.
3. Especially those born before 1955.

## Next Steps
1. Collect data from other countries: Germany, Poland.
2. Investigate the role of education and training in management quality.