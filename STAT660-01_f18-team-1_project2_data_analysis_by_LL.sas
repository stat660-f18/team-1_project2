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

* load external file that generates analytic datasets Loanstat_analytic_file_v1,
Loanstat_analytic_file_h1, Loanstat_analytic_file_v1_sorted, and Loanstat_
analytic_file_h1_sorted;

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

footnote1
'Here we can see see that the average annual income for those who have a mortgage is $85,477.61, owners is $78,328 and those who rent is $67,263.64'
;

footnote2
'This makes sense as those who rent are more likely to rent due to lack of income in purchasing a house'
;

footnote3
'I would be interested in learning how the mortgage and owner labels differ as well as seeing the range of incomes'
;

* 
Note: This is compares the columns "annual_inc" and "home_ownership" from 
LoanStat_part1 to LoanStat_part3 with the same column names.

Methodology: Here I will use proc means to get the mean and median of the 
homeowners and renters from the data set.

Limitations: I might run into some issues with trying to differentiate owners 
versus mortgage and if owners might be landlords.

Follow Up: Might try to see if we can get more clarification on the homeowners 
as well as seperate by state/region.
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
 title;
 footnote;
 
title1
'Research Question: Is there a correlation between interest rate and the annual income with loan amount and grade?'
;

title2
'Rationale: This would help show what factors are considered in terms of interest rates'
;

footnote1
'here we can see that annual inc has a negative correlation to interest rate and loan amount has a positive correlation which makes sense given that the size would have a higher interest rate due to risk it also seems that grade has a negative correlation including the A grade'
;

footnote2
' we can also see that both values are greater than alpha and thus we can say that annual income and loan amount are significant to the interest rate'
;

footnote3
'we might have to include grade and find out what determines grade but currently we cannot seem to find more information on it'
;

*
Note:  This is compares the columns "annual_inc" "grade" "int_rate" and 
"loan_amnt" from LoanStat_part1 to LoanStat_part3 with the same column names
Methodology: Here I will try to use proc corr to find a correlation amongst the 
data following a model of possibly interest rate = annual income + loan amount 
+ grade with grade being a character variable so seeing how we apply log regg 
for that.
Limitations: Will try to see if we can add more variables or possibly have to 
add interactions within our model, could get messy.
Follow Up: Might have to change the question around if we find no correlation
by adding other variables.
;


proc glmmod 
  data = 
    Loanstat_analytic_file_v1 
  outdesign=
    Loanstat_analytic_file_v1_2 
  outparm=
    GLMParm
    ;
   class 
    grade
    ;
   model 
    int_rate =  grade loan_amnt annual_inc;
run
;


proc reg data =
  Loanstat_analytic_file_v1_2 
  ;
  DummyVars: model int_rate = COL2-COL9
  ;
  ods select ParameterEstimates;
  quit
  ;
 title;
 footnote;
 
title1
'Research Question: What is the distribution of the loan amounts based on the purpose of the loan?'
;

title2
'Rationale: Would help get a sense of what the majority of people require loans for and roughly the amounts requested'
;

footnote1
'here we can see that credit card loans take the highest range along with major purchases which I would wonder if they correlate with one another';

footnote2
' we can also see that medical and moving loans are the smallest of all loans which is interesting given the struggle of medical costs for those uninsured'
;

footnote3
' i would very much like to break down debt consolidation to learn whether that also goes into credit card debt and such, the house loan is not very surprising'
;

*
Note: This compares the columns "purpose" from datast LoanStat_Part2 with the 
column "loan_amnt" from datasets LoanStat_Part1 and LoanStat_Part3.

Methodology: Might want to go the box whiskerplot route for this data and 
graph it with my y being loan amounts and x being type of loan.

Limitations: Hopefully the data is clean enough to not vary in types of loans 
and similarily having to distinguish sub types of loans.

Follow Up: Same as the first question, might want to filter out through state 
in order to determine factors of cost of living and debt owed since different 
states have different home costs.
;

proc sgplot
  data = Loanstat_analytic_file_h1
  ;
    vbox loan_amnt / category = purpose
    ;
run;
title;
footnote;
