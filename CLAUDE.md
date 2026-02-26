# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains descriptive analysis of World Management Survey (WMS) data for Hungary. The codebase is in transition from Stata to Julia, with both implementations existing side-by-side. The project merges multiple datasets (WMS survey data, CEO panel data, balance sheet data, and global WMS data) to analyze management practices and their relationship to firm characteristics.

## Dual Language Implementation

**Important:** This codebase contains parallel implementations in both Stata (.do files) and Julia (.jl files). The Julia implementation is actively being developed to replace the Stata code.

- **Stata files**: `.do` files in `src/` and subdirectories - legacy implementation
- **Julia files**: `.jl` files using the Kezdi.jl package - newer implementation
- When modifying code, check if both versions exist and keep them in sync if required
- The Julia version uses Kezdi.jl, which provides a Stata-like syntax in Julia

## Build System

The project uses `make` to orchestrate the data pipeline:

```bash
# Build all outputs (plots, tables, slides)
make all

# Build specific outputs
make output/fig/management-means.png
make validate.log
make practices.log
make cohorts.log
make output/slides.pdf
```

## Running Analysis

### Stata
```bash
# Run a specific Stata script
stata -b do src/read/wms.do

# Main analysis scripts
stata -b do src/practices.do
stata -b do src/cohorts.do
stata -b do src/validate.do
```

### Julia
```bash
# Activate the project environment
julia --project=.

# Run a Julia script from the Julia REPL
include("src/read/wms.jl")
include("src/merge/data.jl")
```

## Data Pipeline Architecture

The data processing follows a strict dependency chain managed by the Makefile:

1. **Read Phase** (`src/read/*.{do,jl}`)
   - `wms.jl/do`: Reads and cleans WMS Hungary survey data
   - `ceo.jl/do`: Processes CEO panel data, identifies entrepreneurs vs outsiders
   - `balance.jl/do`: Processes balance sheet data
   - `wmsglobal.jl/do`: Reads global WMS data
   - `gdp.jl/do`: Processes GDP data
   - Output: Individual `.dta` files in `temp/`

2. **Merge Phase** (`src/merge/*.{do,jl}`)
   - `sample.jl/do`: Creates the analysis sample by merging WMS, balance, and CEO data
   - `data.jl/do`: Final merge that combines all datasets
   - Output: `temp/sample.dta` and `temp/data.dta`
   - **Critical:** All merges use strict assertions (`assert _merge == 3`) to ensure complete matches

3. **Create Phase** (`src/create/variables.{do,jl}`)
   - Generates derived variables (TFP, log employment, exporter dummy, etc.)
   - Called by analysis scripts, not run independently

4. **Analysis Phase** (`src/*.do`)
   - `practices.do`: Regressions of management on firm characteristics
   - `cohorts.do`: Cohort analysis based on birth years (CEO, firm, market entry)
   - `validate.do`: Data validation checks

5. **Plot Phase** (`src/plot/*.{do,jl}`)
   - Generates figures in `output/fig/`

## Key Implementation Details

### WMS Data Processing (`src/read/wms.jl`)
- Handles age variables that may be reported as years or foundation dates
- Fixes ages >1900 by converting to age (2018 - year)
- Identifies respondent positions (CEO, production, other) using Hungarian keywords
- Manually corrects one firm ID that changed due to reorganization (tax_id 14444032 → 25546286)

### CEO Data Processing (`src/read/ceo.jl`)
- Distinguishes entrepreneurs (owner-managers) from outsider CEOs
- Keeps only the most senior outsider per firm-year
- Selects the last year before 2017 for each firm
- **Special case:** Manually adds 2017 data for firm 20702230 (missing from ceo-panel)

### Merge Logic (`src/merge/data.jl`)
- Uses `join()` in Julia or `merge` in Stata with strict 1:1 matching
- All merges must result in complete matches (merge == 3)
- When CEO and respondent birth years differ, uses the maximum if respondent is CEO

### Cohort Analysis (`src/cohorts.do`)
- Applies 25-year offset to birth years for analysis
- Bins cohorts into 5-year intervals
- Defines "modern" cohort: birth year >= 1965
- Defines "goldrush" cohort: birth years 1965-1974
- Cohorts: CEO, respondent, firm founding, market entry

## Directory Structure

```
├── src/
│   ├── read/          # Data ingestion scripts
│   ├── merge/         # Data merging scripts
│   ├── create/        # Variable creation
│   ├── plot/          # Plotting scripts
│   └── *.do           # Main analysis scripts
├── input/             # Raw data files (gitignored)
├── temp/              # Intermediate data files (gitignored)
├── output/
│   ├── fig/           # Generated plots
│   └── tables/        # Regression tables
├── external/          # External data sources
│   ├── gdp-per-capita.csv
│   └── wms-special-access/
├── literature/        # Reference papers
└── report/            # Markdown source for slides and papers
```

## Julia Dependencies

Key packages (defined in Project.toml):
- **Kezdi.jl**: Stata-like data manipulation syntax
- **DataFrames.jl**: Data manipulation
- **CSV.jl, Arrow.jl**: Data I/O
- **Plots.jl, StatsPlots.jl**: Visualization

## Data Sources

Per README.md:
- CEU MicroData Hungarian Manager Database (`ceo-panel_20231130T200524472589+0100.zip`)
- WMS Hungary 2018 (`wms-Hungary-2018_20200505T221635610430+0200.zip`)
- Global WMS 2004-2015 (downloaded from worldmanagementsurvey.org)

## Common Patterns

### Handling Missing Values
- Stata: `mvdecode _all, mv(-99)` converts -99 to missing
- Julia: `@mvencode` and `@mvdecode` macros from Kezdi.jl

### Creating Categorical Variables
Both implementations convert continuous employment to categorical bins (50-100, 101-250, etc.)

### String Matching in Julia
Uses `any(list in string)` pattern to check if any keyword appears in position strings

## Notes on Julia-Stata Translation

The Julia code closely mirrors Stata syntax using Kezdi.jl:
- `@use`, `@keep`, `@drop`, `@rename`, `@generate`, `@replace`, `@save` macros
- `getdf()` and `setdf()` to switch between Kezdi context and DataFrames
- Type conversions needed for `Any` columns after manipulation
- `unique!()` instead of `duplicates drop`
- `join()` instead of `merge`, but merge indicators not yet implemented
