
## cleaningtools

<!-- badges: start -->

[![R-CMD-check](https://github.com/impact-initiatives/cleaningtools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/impact-initiatives/cleaningtools/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/impact-initiatives/cleaningtools/branch/master/graph/badge.svg?token=SOH3NGXQDU)](https://codecov.io/gh/impact-initiatives/cleaningtools)

<!-- badges: end -->

## Overview

The `cleaningtools` package focuses on cleaning, and has three
components:
<p>

**1. Check**, which includes a set of functions that flag values, such
as check_outliers and check_logical. <br> **2. Create**, which includes
a set of functions to create different items for use in cleaning, such
as the cleaning log from the checks, clean data, and enumerator
performance. <br> **3. Review**, which includes a set of functions to
review the cleaning, such as reviewing the cleaning.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("impact-initiatives/cleaningtools")
```

## Examples

### Example:: Check for duplicates

``` r
library(cleaningtools)
testdata <- data.frame(uuid = c(letters[1:4], "a", "b", "c"),
                       col_a = runif(7),
                       col_b = runif(7)) %>%
 dplyr::rename(`_uuid` = uuid)
testdata
#>   _uuid      col_a     col_b
#> 1     a 0.47007392 0.9451143
#> 2     b 0.91786903 0.8329028
#> 3     c 0.24185904 0.3345257
#> 4     d 0.08229578 0.4455870
#> 5     a 0.72045902 0.4548305
#> 6     b 0.01439013 0.5075493
#> 7     c 0.68804453 0.9302401
check_duplicate(testdata)
#> $checked_dataset
#>   _uuid      col_a     col_b
#> 1     a 0.47007392 0.9451143
#> 2     b 0.91786903 0.8329028
#> 3     c 0.24185904 0.3345257
#> 4     d 0.08229578 0.4455870
#> 5     a 0.72045902 0.4548305
#> 6     b 0.01439013 0.5075493
#> 7     c 0.68804453 0.9302401
#> 
#> $duplicate_log
#>   uuid value variable           issue
#> 1    a     a    _uuid duplicated uuid
#> 2    b     b    _uuid duplicated uuid
#> 3    c     c    _uuid duplicated uuid
```

### Example:: Creating cleaning log from raw data and clean data

`create_cleaning_log` function takes raw data and clean data as inputs
and its identify any changes bwtween them and finally provide the output
as cleaning log format.

``` r
cleaning_log <- create_cleaning_log(
  raw_data = raw_data, raw_data_uuid = "X_uuid",
  clean_data = clean_data, clean_data_uuid = "X_uuid",
  check_for_deletion_log = T, check_for_variable_name = T
)
```

### Example:: Comparing cleaning log with clean data and raw data

`compare_cl_with_datasets` function takes raw data, clean data and
cleaning log as inputs, and it first creates the cleaning log by
comparing raw data and clean data, then compares it with the
user-provided cleaning log. Finally, flagged the discrepancies between
them (if any).

``` r
compare_cl_with_datasets(
  raw_data = raw_data, raw_data_uuid = "X_uuid",
  clean_data = clean_data, clean_data_uuid = "X_uuid",
  cleaning_log = cleaning_log2, cleaning_log_uuid = "X_uuid",
  cleaning_log_question_name = "questions",
  cleaning_log_new_value = "new_value", cleaning_log_old_value = "old_value",
  deletion_log = deletaion_log, deletion_log_uuid = "X_uuid",
  check_for_deletion_log = T, check_for_variable_name = T
)
```

### Example:: Check of PII

`check_for_pii()` function takes raw data (input can be dataframe or
list. However incase of list, you must specify the element name in
`element_name` parameter!) and looks for potential PII in the dataset.
By default, the function will look for following words but you can also
add additional words to look by using `words_to_look` parameter.The
default words
are-`c("telephone","contact","name","gps","neighbourhood","latitude","logitude","contact","nom","gps","voisinage")`.
The function will give a list with two element. One will be the data and
second one will be the list of potential PII

- Using dataframe as input

``` r
output_from_data <- check_for_pii(df = raw_data,words_to_look = "date")
output_from_data$potential_PII
#> # A tibble: 7 × 3
#>   uuid  question                              issue        
#>   <chr> <chr>                                 <chr>        
#> 1 all   date_assessment                       Potential PII
#> 2 all   neighbourhood                         Potential PII
#> 3 all   return_date                           Potential PII
#> 4 all   water_supply_rest_neighbourhood       Potential PII
#> 5 all   water_supply_other_neighbourhoods     Potential PII
#> 6 all   water_supply_other_neighbourhoods_why Potential PII
#> 7 all   consent_telephone_number              Potential PII
```

- Using list as input

``` r
### from list
df_list <- list(raw_data=raw_data)
output_from_list <- check_for_pii(df = df_list,element_name = "raw_data",words_to_look = "date")
output_from_list$potential_PII
#> # A tibble: 7 × 3
#>   uuid  question                              issue        
#>   <chr> <chr>                                 <chr>        
#> 1 all   date_assessment                       Potential PII
#> 2 all   neighbourhood                         Potential PII
#> 3 all   return_date                           Potential PII
#> 4 all   water_supply_rest_neighbourhood       Potential PII
#> 5 all   water_supply_other_neighbourhoods     Potential PII
#> 6 all   water_supply_other_neighbourhoods_why Potential PII
#> 7 all   consent_telephone_number              Potential PII
```

### Example:: Check of duration from audits

#### Reading the audits files

It will read only the compressed file.

``` r
my_audit_list <- create_audit_list(audit_zip_path = "audit_for_tests_100.zip")
```

#### Adding the duration to the dataset

Once you have read your audit file from the zip, you will get a list of
audit. You can use this list to calculate and add the duration. You have
2 options with a start and end question or summing all the durations.

``` r
list_audit <- list(uuid1 = data.frame(event = c("form start", rep("question", 5)),
                                      node = c("", paste0("/xx/question", 1:5)),
                                      start = c(1661415887295, 1661415887301,
                                                1661415890819, 1661415892297,
                                                1661415893529, 1661415894720),
                                      end = c(NA, 1661415890790, 1661415892273,
                                              1661415893506, 1661415894703,
                                              1661415896452)),
                   uuid2 = data.frame(event = c("form start", rep("question", 5)),
                                      node = c("", paste0("/xx/question", 1:5)),
                                      start = c(1661415887295, 1661415887301, 1661415890819, 1661415892297, 1661415893529, 1661415894720),
                                      end = c(NA, 1661415890790, 1661415892273, 1661415893506, 1661415894703, 1661415896452)))
some_dataset <- data.frame(X_uuid = c("uuid1", "uuid2"),
                          question1 = c("a","b"),
                          question2 = c("a","b"),
                          question3 = c("a","b"),
                          question4 = c("a","b"),
                          question5 = c("a","b"))
```

If you want to sum all the duration.

``` r
add_duration_from_audit(some_dataset, uuid_var = "X_uuid", audit_list = list_audit)
#>   X_uuid question1 question2 question3 question4 question5
#> 1  uuid1         a         a         a         a         a
#> 2  uuid2         b         b         b         b         b
#>   duration_audit_sum_all_ms duration_audit_sum_all_minutes
#> 1                      9058                            0.2
#> 2                      9058                            0.2
```

If you want to use calculate duration between 2 questions.

``` r
add_duration_from_audit(some_dataset, uuid_var = "X_uuid", audit_list = list_audit,
                         start_question = "question1",
                         end_question = "question3",
                         sum_all = F)
#>   X_uuid question1 question2 question3 question4 question5
#> 1  uuid1         a         a         a         a         a
#> 2  uuid2         b         b         b         b         b
#>   duration_audit_start_end_ms duration_audit_start_end_minutes
#> 1                        6205                              0.1
#> 2                        6205                              0.1
```

If you want to do both.

``` r
add_duration_from_audit(some_dataset, uuid_var = "X_uuid", audit_list = list_audit,
                         start_question = "question1",
                         end_question = "question3",
                         sum_all = T)
#>   X_uuid question1 question2 question3 question4 question5
#> 1  uuid1         a         a         a         a         a
#> 2  uuid2         b         b         b         b         b
#>   duration_audit_sum_all_ms duration_audit_sum_all_minutes
#> 1                      9058                            0.2
#> 2                      9058                            0.2
#>   duration_audit_start_end_ms duration_audit_start_end_minutes
#> 1                        6205                              0.1
#> 2                        6205                              0.1
```

#### checking the duration of the dataset

Once you have added the duration to the dataset, you can check if
duration are between the threshold you are looking for.

``` r
testdata <- data.frame(
  uuid = c(letters[1:7]),
  duration_audit_start_end_ms = c(2475353, 375491, 2654267, 311585, 817270,
                                  2789505, 8642007),
  duration_audit_start_end_minutes = c(41, 6, 44, 5, 14, 46, 144)
) %>%
  dplyr::rename(`_uuid` = uuid)
check_duration(testdata,
               .col_to_check = "duration_audit_start_end_minutes")
#> $checked_dataset
#>   _uuid duration_audit_start_end_ms duration_audit_start_end_minutes
#> 1     a                     2475353                               41
#> 2     b                      375491                                6
#> 3     c                     2654267                               44
#> 4     d                      311585                                5
#> 5     e                      817270                               14
#> 6     f                     2789505                               46
#> 7     g                     8642007                              144
#> 
#> $duration_log
#>   uuid value                         variable
#> 1    b     6 duration_audit_start_end_minutes
#> 2    d     5 duration_audit_start_end_minutes
#> 3    e    14 duration_audit_start_end_minutes
#> 4    g   144 duration_audit_start_end_minutes
#>                                             issue
#> 1 Duration is lower or higher than the thresholds
#> 2 Duration is lower or higher than the thresholds
#> 3 Duration is lower or higher than the thresholds
#> 4 Duration is lower or higher than the thresholds
check_duration(
  testdata,
  .col_to_check = "duration_audit_start_end_ms",
  lower_bound = 375490,
  higher_bound = 8642000
)
#> $checked_dataset
#>   _uuid duration_audit_start_end_ms duration_audit_start_end_minutes
#> 1     a                     2475353                               41
#> 2     b                      375491                                6
#> 3     c                     2654267                               44
#> 4     d                      311585                                5
#> 5     e                      817270                               14
#> 6     f                     2789505                               46
#> 7     g                     8642007                              144
#> 
#> $duration_log
#>   uuid   value                    variable
#> 1    d  311585 duration_audit_start_end_ms
#> 2    g 8642007 duration_audit_start_end_ms
#>                                             issue
#> 1 Duration is lower or higher than the thresholds
#> 2 Duration is lower or higher than the thresholds
testdata %>% check_duration(.col_to_check = "duration_audit_start_end_minutes") %>%
  check_duration(
    .col_to_check = "duration_audit_start_end_ms",
    name_log = "duration_in_ms",
    lower_bound = 375490,
    higher_bound = 8642000
  )
#> $checked_dataset
#>   _uuid duration_audit_start_end_ms duration_audit_start_end_minutes
#> 1     a                     2475353                               41
#> 2     b                      375491                                6
#> 3     c                     2654267                               44
#> 4     d                      311585                                5
#> 5     e                      817270                               14
#> 6     f                     2789505                               46
#> 7     g                     8642007                              144
#> 
#> $duration_log
#>   uuid value                         variable
#> 1    b     6 duration_audit_start_end_minutes
#> 2    d     5 duration_audit_start_end_minutes
#> 3    e    14 duration_audit_start_end_minutes
#> 4    g   144 duration_audit_start_end_minutes
#>                                             issue
#> 1 Duration is lower or higher than the thresholds
#> 2 Duration is lower or higher than the thresholds
#> 3 Duration is lower or higher than the thresholds
#> 4 Duration is lower or higher than the thresholds
#> 
#> $duration_in_ms
#>   uuid   value                    variable
#> 1    d  311585 duration_audit_start_end_ms
#> 2    g 8642007 duration_audit_start_end_ms
#>                                             issue
#> 1 Duration is lower or higher than the thresholds
#> 2 Duration is lower or higher than the thresholds
```

#### Example:: Check outliers

`check_outliers()` takes raw data set and look for potential outlines.
It can both data frame or list. However you must specify the element
name (name of your data set in the given list) in `element_name`
parameter!

``` r
set.seed(122)
### from list
df_outlier<- data.frame(
  uuid = paste0("uuid_", 1:100),
  one_value = c(round(runif(90, min = 45,max =55)), round(runif(5)), round(runif(5,99,100))),
  expense = c(sample(200:500,replace = T,size = 95),c(600,100,80,1020,1050)),
  income = c(c(60,0,80,1020,1050),sample(20000:50000,replace = T,size = 95)),
  yy = c(rep(100,99),10)
)
outliers <- check_outliers(df = df_outlier,uuid_col_name = "uuid")
#> [1] "checking_one_value"
#> [1] "checking_expense"
#> [1] "checking_income"
#> [1] "checking_yy"
outliers$potential_outliers
#> # A tibble: 18 × 4
#>    uuid     issue                         question  old_value
#>    <chr>    <chr>                         <chr>         <dbl>
#>  1 uuid_91  outlier (normal distribution) one_value         1
#>  2 uuid_92  outlier (normal distribution) one_value         0
#>  3 uuid_93  outlier (normal distribution) one_value         0
#>  4 uuid_94  outlier (normal distribution) one_value         0
#>  5 uuid_95  outlier (normal distribution) one_value         0
#>  6 uuid_96  outlier (normal distribution) one_value       100
#>  7 uuid_97  outlier (normal distribution) one_value        99
#>  8 uuid_98  outlier (normal distribution) one_value       100
#>  9 uuid_99  outlier (normal distribution) one_value       100
#> 10 uuid_100 outlier (normal distribution) one_value        99
#> 11 uuid_99  outlier (normal distribution) expense        1020
#> 12 uuid_100 outlier (normal distribution) expense        1050
#> 13 uuid_97  outlier (log distribution)    expense         100
#> 14 uuid_98  outlier (log distribution)    expense          80
#> 15 uuid_1   outlier (log distribution)    income           60
#> 16 uuid_2   outlier (log distribution)    income            0
#> 17 uuid_3   outlier (log distribution)    income           80
#> 18 uuid_100 outlier (normal distribution) yy               10
```

#### Example:: Create clean data

`create_clean_data()` function applies cleaning log to the raw data set
and returns a clean data set.

``` r
cleaning_log_test <- data.frame(
  uuid = paste0("uuid",1:4),
  question= c("age","gender","pop_group","strata"),
  change_type = c("blank_response","no_change","Delete","change_res"),
  new_value = c(NA_character_,NA_character_,NA_character_,"st-a")
)
test_data <- data.frame(
  uuid =  paste0("uuid",1:4),
  age = c(180,23,45,67),
  gender = c("male","female","male","female"),
  pop_group = c("idp","refugee","host","idp"),
  strata = c("a","b","c","d")
)

clean_dataset <- create_clean_data(df = test_data,df_uuid = "uuid",cl = cleaning_log_test,
                                   cl_change_type_col =  "change_type",
                                   values_for_change_response = "change_res",
                                   values_for_blank_response = "blank_response",
                                   values_for_no_change = "no_change",
                                   values_for_remove_survey = "Delete",
                                   cl_change_col =  "question",
                                   cl_uuid = "uuid",
                                   cl_new_val = "new_value" )
#> [1] "age"
#> [1] "strata"
```

#### Example:: Check for value

`check_for_value()` function look for specified value in the given data
set and return in a cleaning log format. The function can take a data
frame or a list as input.

``` r
set.seed(122)

df <- data.frame(
    X_uuid = paste0("uuid_",1:100),
    age = c(sample(18:80,replace = T,size = 96),99,99,98,88),
    gender = c("99",sample(c("male","female"),replace = T,size = 95),"98","98","88","888"))

output <- check_for_value(df = df,uuid_col_name = "X_uuid",element_name = "checked_dataset",values_to_look = c(99,98,88,888))

output$flaged_value
#> # A tibble: 9 × 3
#>   uuid     question old_value
#>   <chr>    <chr>    <chr>    
#> 1 uuid_1   gender   99       
#> 2 uuid_97  age      99       
#> 3 uuid_97  gender   98       
#> 4 uuid_98  age      99       
#> 5 uuid_98  gender   98       
#> 6 uuid_99  age      98       
#> 7 uuid_99  gender   88       
#> 8 uuid_100 age      88       
#> 9 uuid_100 gender   888
```

#### Example:: Recreate parent column for choice multiple

`recreate_parent_column()` recreates the concerted columns for select
multiple questions

``` r
test_data <- dplyr::tibble(
  uuid = paste0("uuid_",1:6),
  gender = rep(c("male","female"),3),
  reason = c("xx,yy","xx,zy",
             "zy","xx,xz,zy",
             NA_character_,"xz"),
  reason.x.x. = c(0,1,0,1,0,0),
  reason.yy = c(1,0,0,0,1,0),
  reason.x.z = c(0,0,0,1,0,1),
  reason.zy = c(0,1,1,1,0,0),
  reason_zy = c(NA_character_,"A","B","C",NA_character_,NA_character_))

recreate_parent_column(df = test_data,uuid = "uuid",sm_sep = ".")
#> Warning in recreate_parent_column(df = test_data, uuid = "uuid", sm_sep = "."):
#> Column(s) names are renamed as multiple separators are found in dataset column
#> names. Please see the above table with the new name.
#> # A tibble: 2 × 2
#>   old_name    new_name   
#>   <chr>       <chr>      
#> 1 reason.x.x. reason.x_x_
#> 2 reason.x.z  reason.x_z
#> # A tibble: 6 × 8
#>   uuid   gender reason      reason.x_x_ reason.yy reason.x_z reason.zy reason_zy
#>   <chr>  <chr>  <chr>             <dbl>     <dbl>      <dbl>     <dbl> <chr>    
#> 1 uuid_1 male   yy                    0         1          0         0 <NA>     
#> 2 uuid_2 female x_x_ zy               1         0          0         1 A        
#> 3 uuid_3 male   zy                    0         0          0         1 B        
#> 4 uuid_4 female x_x_ x_z zy           1         0          1         1 C        
#> 5 uuid_5 male   yy                    0         1          0         0 <NA>     
#> 6 uuid_6 female x_z                   0         0          1         0 <NA>
```

#### Example:: Logical checks

``` r
test_data <- data.frame(uuid = c(1:10) %>% as.character(),
                        today = rep("2023-01-01", 10),
                        location = rep(c("villageA", "villageB"),5),
                        distance_to_market = c(rep("less_30", 5), rep("more_30",5)),
                        access_to_market = c(rep("yes",4), rep("no",6)),
                        number_children_05 = c(rep(c(0,1),4),5,6))
check_for_logical(test_data,
                  uuid_var = "uuid",
                  check_to_perform = "distance_to_market == \"less_30\" & access_to_market == \"no\"",
                   variables_to_clean = "distance_to_market, access_to_market",
                   description = "distance to market less than 30 and no access")
#> $checked_dataset
#>    uuid      today location distance_to_market access_to_market
#> 1     1 2023-01-01 villageA            less_30              yes
#> 2     2 2023-01-01 villageB            less_30              yes
#> 3     3 2023-01-01 villageA            less_30              yes
#> 4     4 2023-01-01 villageB            less_30              yes
#> 5     5 2023-01-01 villageA            less_30               no
#> 6     6 2023-01-01 villageB            more_30               no
#> 7     7 2023-01-01 villageA            more_30               no
#> 8     8 2023-01-01 villageB            more_30               no
#> 9     9 2023-01-01 villageA            more_30               no
#> 10   10 2023-01-01 villageB            more_30               no
#>    number_children_05 logical_xx
#> 1                   0      FALSE
#> 2                   1      FALSE
#> 3                   0      FALSE
#> 4                   1      FALSE
#> 5                   0       TRUE
#> 6                   1      FALSE
#> 7                   0      FALSE
#> 8                   1      FALSE
#> 9                   5      FALSE
#> 10                  6      FALSE
#> 
#> $logical_xx
#> # A tibble: 2 × 6
#>   uuid  question           old_value issue                check_id check_binding
#>   <chr> <chr>              <chr>     <chr>                <chr>    <chr>        
#> 1 5     distance_to_market less_30   distance to market … logical… logical_xx ~…
#> 2 5     access_to_market   no        distance to market … logical… logical_xx ~…
```

``` r
test_data <- data.frame(uuid = c(1:10) %>% as.character(),
                       distance_to_market = rep(c("less_30","more_30"),5),
                       access_to_market = c(rep("yes",4), rep("no",6)),
                       number_children_05 = c(rep(c(0,1),4),5,6),
                       number_children_618 = c(rep(c(0,1),4),5,6))
check_list <- data.frame(name = c("logical_xx", "logical_yy", "logical_zz"),
                         check = c("distance_to_market == \"less_30\" & access_to_market == \"no\"",
                                   "number_children_05 > 3",
                                   "rowSums(across(starts_with(\"number\")), na.rm = T) > 9"),
                         description = c("distance to market less than 30 and no access",
                                         "number of children under 5 seems high",
                                         "number of children very high"),
                         variables_to_clean = c("distance_to_market, access_to_market",
                                                "number_children_05",
                                                ""))
check_for_logical_with_list(test_data,
                            uuid_var = "uuid",
                            list_of_check = check_list,
                            check_id_column = "name",
                            check_to_perform_column = "check",
                            variables_to_clean_column = "variables_to_clean",
                            description_column = "description")
#> Warning in check_for_logical(.dataset = .dataset, uuid_var = uuid_var,
#> variables_to_add = variables_to_add, : variables_to_clean not shared, results
#> may not be accurate
#> $checked_dataset
#>    uuid distance_to_market access_to_market number_children_05
#> 1     1            less_30              yes                  0
#> 2     2            more_30              yes                  1
#> 3     3            less_30              yes                  0
#> 4     4            more_30              yes                  1
#> 5     5            less_30               no                  0
#> 6     6            more_30               no                  1
#> 7     7            less_30               no                  0
#> 8     8            more_30               no                  1
#> 9     9            less_30               no                  5
#> 10   10            more_30               no                  6
#>    number_children_618 logical_xx logical_yy logical_zz
#> 1                    0      FALSE      FALSE      FALSE
#> 2                    1      FALSE      FALSE      FALSE
#> 3                    0      FALSE      FALSE      FALSE
#> 4                    1      FALSE      FALSE      FALSE
#> 5                    0       TRUE      FALSE      FALSE
#> 6                    1      FALSE      FALSE      FALSE
#> 7                    0       TRUE      FALSE      FALSE
#> 8                    1      FALSE      FALSE      FALSE
#> 9                    5       TRUE       TRUE       TRUE
#> 10                   6      FALSE       TRUE       TRUE
#> 
#> $logical_all
#> # A tibble: 10 × 6
#>    uuid  question           old_value               issue check_id check_binding
#>    <chr> <chr>              <chr>                   <chr> <chr>    <chr>        
#>  1 5     distance_to_market less_30                 dist… logical… logical_xx ~…
#>  2 5     access_to_market   no                      dist… logical… logical_xx ~…
#>  3 7     distance_to_market less_30                 dist… logical… logical_xx ~…
#>  4 7     access_to_market   no                      dist… logical… logical_xx ~…
#>  5 9     distance_to_market less_30                 dist… logical… logical_xx ~…
#>  6 9     access_to_market   no                      dist… logical… logical_xx ~…
#>  7 9     number_children_05 5                       numb… logical… logical_yy ~…
#>  8 10    number_children_05 6                       numb… logical… logical_yy ~…
#>  9 9     unable to identify please check this uuid… numb… logical… logical_zz ~…
#> 10 10    unable to identify please check this uuid… numb… logical… logical_zz ~…
```
