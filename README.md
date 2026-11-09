## INTRODUCTION
This repository provides the historical shrimp export dataset from Ecuador and the R script used to estimate potential solid waste and wastewater generation and perform time-series analysis and forecasting.

The repository accompanies the research study entitled:

**"Potential Shrimp Waste Generation in Ecuador: An Estimate Based on Historical Shrimp Export Data."**

The objective is to make the dataset and computational procedures publicly accessible, allowing other researchers to reproduce the analyses.

## Repository structure

```text
ecuador-shrimp-waste-estimation/
├── README.md
├── data/
│   └── shrimp_export_data.xlsx
├── scripts/
│   └── shrimp_waste_analysis.R
└── LICENSE
```

## Dataset

The Excel file contains historical information on Ecuadorian shrimp exports, including the variables used in the estimation of potential solid waste and wastewater generation.

**Dataset:** `data/shrimp_export_data.xlsx`

The original data sources are identified in the associated research study.

## R script

The script `scripts/shrimp_waste_analysis.R` contains the following procedures:

1. **Exploratory data analysis:** dataset structure, dimensions, missing values, outlier detection using the interquartile range (IQR), duplicate dates, negative values, zero values, and descriptive statistics.
2. **Data visualization:** historical shrimp export volumes, estimated solid waste generation under low-end and high-end scenarios, and wastewater generation.
3. **Time-series decomposition:** trend-cycle, seasonal, and irregular components.
4. **Stationarity assessment:** Augmented Dickey-Fuller (ADF) tests.
5. **ARIMA modeling:** automatic model selection using the `auto.arima()` function, with non-seasonal ARIMA specifications.
6. **Forecasting:** independent projections for the low-end and high-end scenarios over a 120-month horizon, including 80% and 95% prediction intervals.

## Software and dependencies

The analysis was developed using R and requires the following packages:

- readxl
- dplyr
- ggplot2
- tidyr
- forecast
- tseries
- zoo
- writexl

## How to reproduce the analysis

1. Download or clone this repository.
2. Open the repository's main directory as the working directory in RStudio.
3. Install the required R packages.
4. Open `scripts/shrimp_waste_analysis.R`.
5. Execute the script.

The script generates Excel files containing the monthly decomposition components and forecasting results in the working directory.

## Data availability

The historical dataset and R script used in this study are publicly available in this repository:

(https://github.com/mriera18/ecuador-shrimp-waste-estimation/blob/main/shrimp_export_data.xlsx)

The repository provides the input data and computational code required to reproduce the time-series analysis and forecasting procedures.

## Citation

Please cite the associated research article when using this dataset or computational code.

A permanent DOI will be provided through Zenodo after the repository is archived.

## License

The R script is distributed under the MIT License. The redistribution of the dataset is subject to the terms and conditions of its original sources.
