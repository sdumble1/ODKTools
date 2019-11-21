
# ODKTools

<!-- badges: start -->
<!-- badges: end -->

The goal of ODKTools is to make custom modifications to long XLSForms that would be extremely tedious by hand


## Example


``` r
library(ODKTools)

ODKForm<-read.odk("data/EvaluationQuestionnaire2018.xlsx") 
add_question_numbers(ODKForm) 
```


``` r
library(ODKTools)

ODKForm<-read.odk("data/EvaluationQuestionnaire2018.xlsx") 
trigger_blanks(ODKForm) 

```

``` r
library(ODKTools)

ODKForm<-read.odk("data/EvaluationQuestionnaire2018.xlsx") 
remove_dropped_lists(ODKForm) 

```

``` r
library(ODKTools)

ODKForm<-read.odk("data/EvaluationQuestionnaire2018.xlsx") 
cross_reference_lists(ODKForm) 

```

You can pipe together all of the functions in this package if you want:

``` r
library(ODKTools)

read.odk("data/EvaluationQuestionnaire2018.xlsx") %>%
add_question_numbers() %>%
trigger_blanks() %>%
remove_dropped_lists() %>%
cross_reference_lists() %>%
write.odk("data/EvaluationQuestionnaire2018_updated.xlsx")

```

