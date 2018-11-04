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
*
Question:What are the top three members that had the highest annual income?

Rationale: This should help identify three members that earn the most annually.

Note: This compares column "annual_income" and "member_id" from dataset Loanstat1
and Loanstat3

Methodology: Use PROC PORT to sort the annual income in the combined dataset 
descendingly and use PROC PRINT to output the top 3 member id accordingly.

Limitations: The highest top 3 annual income data are not visualized.

Follow Up: We can add PROC SGPLOT statement to plot a bar graph, making the annual 
income differences more explicit.
;

proc sort
        data=Loanstat_analytic_file_v1
        out=Loanstat_analytic_file_v1_sorted
    ;
    by descending annual_inc;
run;

proc print data=Loanstat_analytic_file_v1_sorted(obs=3);
    id member_id;
    var annual_inc;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the average loan amount for each state?

Rationale: This shows the lending situation from each state.

Note: This compares column "loan_amount", "state", and "member_id" from dataset 
Loanstat1 and Loanstat2

Methodology: Use the PROC MEANS statement to compute the mean loan amount.

Limitations: We cannot know the distribution of the loan amount for each state.

Follow Up: Add min, median, and max in the PROC MEANS statement to compute the 
five-number summaries.
;

proc means data=Loanstat_analytic_file_h1;
	var loan_amnt;
	class addr_state;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the purpose of the highest loan amount?

Rationale: This would help identify what is the use of the largest amount of money borrowed.

Note: This compares column "loan_amount", "purpose",and "member_id" from dataset 
Loanstat1 and Loanstat2

Methodology: Use PROC SORT statement to sort the loan amount descendingly and find
out the purpose of it.

Limitations: The currency symbol for the loan amount is not clear.

Follow Up: Use PROC FORMAT to add dollar sign in the data output.
;

proc sort
        data=Loanstat_analytic_file_h1
        out=Loanstat_analytic_file_h1_sorted
    ;
    by descending loan_amnt;
run;

proc print data=Loanstat_analytic_file_h1_sorted(obs=1);
    id purpose;
    var loan_amnt;
run;
