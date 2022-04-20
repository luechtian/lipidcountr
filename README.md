
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lipidcountr

The goal of lipidcountr is to streamline and simplify the quantification
step of the lipidomics workflow in the Bruegger lab.

## Installation

You can install lipidcountr from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("luechtian/lipidcountr")
```

## Example

``` r
library(lipidcountr)
```

``` r
list.files(system.file("extdata", package = "lipidcountr"), pattern = ".txt", full.names = FALSE) %>% head()
#> [1] "yymmdd_XtrIL_ExampleData_CE.txt"     
#> [2] "yymmdd_XtrIL_ExampleData_Cer.txt"    
#> [3] "yymmdd_XtrIL_ExampleData_Chol.txt"   
#> [4] "yymmdd_XtrIL_ExampleData_DAG.txt"    
#> [5] "yymmdd_XtrIL_ExampleData_Hex2Cer.txt"
#> [6] "yymmdd_XtrIL_ExampleData_HexCer.txt"
```

``` r
read_lipidview_files(system.file("extdata", package = "lipidcountr"))
#> # A tibble: 16,682 x 6
#>    class mz    species scan_name        sample    intensity
#>    <chr> <chr> <chr>   <chr>            <chr>         <dbl>
#>  1 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_1  58161729.
#>  2 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_2  56223689.
#>  3 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_3  56113097.
#>  4 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_4  56459944.
#>  5 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_5  66408624.
#>  6 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_6  50757691.
#>  7 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_7  58787795.
#>  8 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_8  35023855.
#>  9 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_9  54665552.
#> 10 CE    544.6 IS 9:0  FA 20:0+C3H6O/CE sample_10 64823347.
#> # ... with 16,672 more rows
```
