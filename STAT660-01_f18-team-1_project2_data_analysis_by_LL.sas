*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding loan amounts and statistics on loans

Dataset Name: STAT660-01_f18-team-1_project2_data_preparation.sas
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets cde_2014_analytic_file,
  cde_2014_analytic_file_sort_frpm, and cde_2014_analytic_file_sort_sat;
%include '.\STAT660-01_f18-team-1_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question:What is the average annual income for those who rent and those who own?'
;

title2
'Rationale: This shows the buying power and cost of living for someone to own a home'
;

*
Methodology: Here I will use proc means to get the mean and median of the homeowners 
and renters from the data set.

Note: This is compares the columns "annual_inc" and "home_ownership" from LoanStat_part1
to LoanStat_part3 with the same column names.

Limitations: I might run into some issues with trying to differentiate owners versus 
mortgage and if owners might be landlords.

Follow Up: Might try to see if we can get more clarification on the homeowners as 
well as seperate by state/region.
;

proc means
  data = Loanstat_analytic_file_v1;
    class 
      home_ownership
    ;
    var
      annual_inc
    ;
 run
 ;
 
title1
'Research Question: Is there a correlation between interest rate and the annual income with loan amount and grade?'
;

title2
'Rationale: This would help show what is considered in terms of interest rates'
;

*
Methodology: Here I will try to use proc corr to find a correlation amongst the data
following a model of possibly interest rate = annual income + loan amount + grade
with grade being a character variable so seeing how we apply log regg for that.

Note:  This is compares the columns "annual_inc" "grade" "int_rate" and "loan_amnt" 
from LoanStat_part1 to LoanStat_part3 with the same column names

Limitations: Will try to see if we can add more variables or possibly have to 
add interactions within our model, could get messy.

Follow Up: Might have to change the question around if we find no correlation
by adding other variables.
;

proc corr
    data = loanstats
      model 
        int_rate = annual_inc + loan_amnt + grade
        ;
 run;
 
title1
'Research Question: What is the distribution of the loan amounts based on the purpose of the loan?'
;

title2
'Rationale: Would help get a sense of what the majority of people require loans for and roughly the amounts requested'
;

*
Methodology: Might want to go the box whiskerplot route for this data and graph it with 
my y being loan amounts and x being type of loan.

Note: This compares the columns "purpose" from datast LoanStat_Part2 with the column 
"loan_amnt" from datasets LoanStat_Part1 and LoanStat_Part3.

Limitations: Hopefully the data is clean enough to not vary in types of loans and
similarily having to distinguish sub types of loans.

Follow Up: Same as the first question, might want to filter out through state in order
to determine factors of cost of living and debt owed since different states have different
home costs.
;

proc sgplot
  data = loanstats
    vbox loan_amnt / category purpose
    ;
run;
