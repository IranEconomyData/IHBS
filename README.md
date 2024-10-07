# IHBS
## Introduction
 This GitHub repository present a carefully compiled collection of datasets extracted from the Iran Household Budget Survey (IHBS), diligently gathered and organized by the Statistical Center of Iran (SCI).
 Since the 1960s, the Statistical Center of Iran (SCI) has been conducting the Household Expenditure and Income Survey (HEIS), initially concentrating on rural areas and later incorporating urban areas as of the late 1960s. The initial focus being exclusively on household expenditures, the survey expanded to include income inquiries in 1974–75.
 This data enables research on various aspects, including the composition of household income and expenditure, consumption patterns, poverty thresholds, and disparities in income distribution.
## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Data Description](#data-description)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Contact Information](#contact-information)
- [Support](#support)
- [References](#references)

## Installation <a name="installation"></a>

To install the data packages in R, you should run these commands:

```
install.packages("devtools")

devtools::install_github("IranEconomyData/IHBS/Repository-Name")

library(Repository-Name)
```

<small>The Repository-Name is IHBS.##, where ## refers to the year of reference in the Persian calendar.</small>


## Usage <a name="usage"></a>

**1- Install the packages**

**2- `?IHBS.##::Table-Name`**

Returns the documentation for the specified table

 Replace "Table-Name" with the name of the table

**3- `??IHBS.##::Table-Name`**

Returns the clickable list of tables for access to their documentation

 Replace "Table-Name" with the name of the table

  example

   ![example](https://github.com/IranEconomyData/IHBS/blob/main/example.png)

**4- `data(package = "IHBS.91")`**

Returns the list of tables in the data package

  example

   ![example](https://github.com/IranEconomyData/IHBS/blob/main/example2.png)
    
## Data Description <a name="data-description"></a>

The datasets are organized chronologically and categorized into urban and rural segments in Rd format. Each dataset represents a specific year of the IHBS and includes (tens of tables) information on household income, expenditure, and demographic variables.

## Documentation <a name="documentation"></a>

In the Documentation-Data file in the R section, you can find detailed insights into the tables and columns of the data package, based on the Statistical Center of Iran. You will find comprehensive explanations, definitions, and insights into the structure and purpose of each table and column, empowering you to navigate and utilize the data effectively. It provides users with essential information necessary for a thorough understanding of the dataset's underlying architecture and functionalities, facilitating informed utilization and analysis.

## Contributing <a name="contributing"></a>

Contributions to this repository, such as additional datasets and documentation improvements, are welcome.

## License <a name="license"></a>

This data package (IHBS) is licensed under the MIT.

## Contact Information <a name="contact-information"></a>

For inquiries or suggestions, please feel free to contact [IranEconomyData@gmail.com](mailto:IranEconomyData@gmail.com). You can also reach out via

## Support <a name="support"></a>

Information about support options.

## References <a name="references"></a>

•	Statistical Center of Iran (SCI) - https://amar.org.ir

•	Iran Household Expenditure and Income Surveys - <a href="https://m-hoseini.github.io/HEIS/introduction.html" target="_blank">https://m-hoseini.github.io/HEIS/introduction.html</a>




