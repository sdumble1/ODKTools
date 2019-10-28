
# ODKTools

<!-- badges: start -->
<!-- badges: end -->

The goal of ODKTools is to make custom modifications to long XLSForms that would be extremely tedious by hand


## Example

This is a basic example which shows you how to solve a common problem:

``` r
devtools::install_github("sdumble1/ODKTools")
library(ODKTools)
ODK_Number("data/select_multiple-count-selected-example.xlsx",language="English")
```

This will number sections (denoted by groups or repeat groups) with numbers and subsections with numbers (e.g. 1.1, 1.2 and so on).
Question groups can also be numbered with LETTERS or letters:
``` r
ODK_Number("data/select_multiple-count-selected-example.xlsx",language="English",maintype="LETTERS")
```

``` r
ODK_Number("data/select_multiple-count-selected-example.xlsx",language="English",maintype="letters")
```

Questions within groups can also be numbered using letters or LETTERS through the subtype= argument.

The language name is case sensitive and must match exactly the name of the language given in the label::language column of the XLS Form.
