# Teal: Interactive Exploratory Data Analysis with Shiny Web-Applications <a href='https://insightsengineering.github.io/teal/'><img src="man/figures/teal.png" align="right" height="139" style="max-width: 100%;"/></a  >

<!-- start badges -->
[![Check 🛠](https://github.com/insightsengineering/teal/actions/workflows/check.yaml/badge.svg)](https://insightsengineering.github.io/teal/main/unit-test-report/)
[![Docs 📚](https://github.com/insightsengineering/teal/actions/workflows/docs.yaml/badge.svg)](https://insightsengineering.github.io/teal/)
[![Code Coverage 📔](https://raw.githubusercontent.com/insightsengineering/teal/_xml_coverage_reports/data/main/badge.svg)](https://insightsengineering.github.io/teal/main/coverage-report/)

![GitHub forks](https://img.shields.io/github/forks/insightsengineering/teal?style=social)
![GitHub repo stars](https://img.shields.io/github/stars/insightsengineering/teal?style=social)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/insightsengineering/teal)
![GitHub contributors](https://img.shields.io/github/contributors/insightsengineering/teal)
![GitHub last commit](https://img.shields.io/github/last-commit/insightsengineering/teal)
![GitHub pull requests](https://img.shields.io/github/issues-pr/insightsengineering/teal)
![GitHub repo size](https://img.shields.io/github/repo-size/insightsengineering/teal)
![GitHub language count](https://img.shields.io/github/languages/count/insightsengineering/teal)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Current Version](https://img.shields.io/github/r-package/v/insightsengineering/teal/main?color=purple\&label=package%20version)](https://github.com/insightsengineering/teal/tree/main)
[![Open Issues](https://img.shields.io/github/issues-raw/insightsengineering/teal?color=red\&label=open%20issues)](https://github.com/insightsengineering/teal/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)
<!-- end badges -->

*teal* is a shiny-based interactive exploration framework for analyzing data. `teal` applications require app developers to specify:

<!-- markdownlint-disable MD007 MD030 -->
-   Data, which can be:
    -    `CDISC` data, commonly used for clinical trial reporting
    -    Independent datasets, for example from a `data.frame`
    -    Related datasets, for example a set of `data.frames` with key columns to enable data joins
    -    `MultiAssayExperiment` objects which are R data structures for representing and analyzing multi-omics experiments
-   `teal` modules:
    -   `teal modules` are shiny modules built within the `teal` framework that specify analysis to be performed. For example, it can be a module for exploring outliers in the data, or a module for visualizing the data in line plots. Although these can be created from scratch, lost of `teal` modules have been released and we recommend starting with modules found in the following packages:
        -   [`teal.modules.general`](https://insightsengineering.github.io/teal.modules.general/): general modules for exploring relational/independent/`CDISC` data
        -   [`teal.modules.clinical`](https://insightsengineering.github.io/teal.modules.clinical/): modules specific to `CDISC` data and clinical trial reporting
        -   [`teal.modules.hermes`](https://insightsengineering.github.io/teal.modules.hermes/): modules for analyzing `MultiAssayExperiment` objects

<!-- markdownlint-enable MD007 MD030 -->

A lot of the functionality of the `teal` framework derives from the following packages:

<!-- markdownlint-disable MD007 MD030 -->
-   [`teal.data`](https://insightsengineering.github.io/teal.data/): creating and loading the data needed for `teal` applications.
-   [`teal.widgets`](https://insightsengineering.github.io/teal.widgets/): shiny components used within `teal`.
-   [`teal.slice`](https://insightsengineering.github.io/teal.slice/): provides a filtering panel to allow filtering of data.
-   [`teal.code`](https://insightsengineering.github.io/teal.code/): handles reproducibility of outputs.
-   [`teal.transform`](https://insightsengineering.github.io/teal.transform/): standardizes extracting and merging data.
-   [`teal.logger`](https://insightsengineering.github.io/teal.logger/): standardizes logging within `teal` framework.
-   [`teal.reporter`](https://insightsengineering.github.io/teal.reporter/): allows `teal` applications to generate reports.

<!-- markdownlint-enable MD007 MD030 -->

See these packages for more information about how to use the different parts of the `teal` framework.

Please see [`teal` gallery](https://github.com/insightsengineering/teal.gallery) and [TLG Catalog](https://github.com/insightsengineering/tlg-catalog) to see examples of `teal` apps.

## Installation

From July 2023 `insightsengineering` packages are available on [r-universe](https://r-universe.dev/).

```r
# stable versions
install.packages('teal', repos = c('https://insightsengineering.r-universe.dev', 'https://cloud.r-project.org'))

# beta versions
install.packages('teal', repos = c('https://pharmaverse.r-universe.dev', 'https://cloud.r-project.org'))
```

See package vignettes `browseVignettes(package = "teal")` for usage of this package.

## Acknowledgment

This package is a result of a joint efforts by many developers and stakeholders. We would like to thank everyone who contributed so far!

## Stargazers and Forkers

### Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/teal.svg)](https://starchart.cc/insightsengineering/teal)

### Stargazers

[![Stargazers repo roster for @insightsengineering/teal](https://reporoster.com/stars/insightsengineering/teal)](https://github.com/insightsengineering/teal/stargazers)

### Forkers

[![Forkers repo roster for @insightsengineering/teal](https://reporoster.com/forks/insightsengineering/teal)](https://github.com/insightsengineering/teal/network/members)
