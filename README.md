
# ODKTools

<!-- badges: start -->
<!-- badges: end -->

The goal of ODKTools is to be able to take common and time consuming ODK form creation tasks, that are possible by hand but can be sped up by some automation.

These functions are designed to be used at the end of creating a form - in the tidying, checking and formatting phase of form creation. Please do not use R for creating the ODK form - that doesn't sounds like a very good idea. 

## Examples

Importing:

``` r
library(ODKTools)

ODKForm<-read.odk("data/EvaluationQuestionnaire2018.xlsx") 

summary(ODKForm)

```
NOTE: Default assumption is that columns will have either the language defined in a settings tab or no langauge options. This can be overwritten inside the functions (e.g. to add question numbers to multiple language columns will require multiple calls to add_question_number with the language being defined in the relevant arguments) 


Adding question numbers
Takes existing labels from an ODK XLS form and attach automatically generated question numbers based on groups and questions within groups New numbers will  be generated for each new section (group or repeat) - nesting of sections not currently implemented. Questions will be assigned to the following ODK elements: "integer","decimal", "select_one", "select_multiple","text","date","datetime","time", "image","geopoint".

Can use the options maintype and subtype to give mixed alpha numeric question numbering 

``` r
add_question_numbers(ODKForm) 

#e.g.
add_question_numbers(ODKForm,maintype="LETTERS",subtype="numbers") 

#will give questions A.1, A.2 and so on
```

Adding triggers for missed inputs:
This is useful if you do not want to force all questions to be required, but still want to make sure that all questions are being addressed and not left blank accidentally

``` r
trigger_blanks(ODKForm) 
```

Remove any lists from the choices tabs that do not appear in the main survey

These will be moved into a new tab called unused_choices. Standard ODK validations check if all lists from survey are in choices but not the other way around. The reverse is useful to prevent translation of obsolete lists and for form checking

``` r
remove_dropped_lists(ODKForm) 
```

cross reference the choices tab with information from the survey tab

This is useful for checking and translation purposes to have the question text next to the answer text to provide additional context and make sure wording is appropriate. Multiple questions mapping to same list set will be concatenated.

``` r
cross_reference_lists(ODKForm) 
```

Exporting file back from R - after functions have been applied:

``` r
ODKForm2<-add_question_numbers(ODKForm) 
write.odk(ODKForm2,"data/EvaluationQuestionnaire2018_updated.xlsx")
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

