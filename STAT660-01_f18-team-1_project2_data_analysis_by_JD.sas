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
 Loanstat_analytic_file_h1, Loanstat_analytic_file_v1_sorted, and Loanstat_analytic_file_h1_sorted;
%include '.\STAT660-01_f18-team-1_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question:What are the top three members that had the highest annual income?'
;

title2
'Rationale: This should help identify three members that earn the most annually.'
;

footnote1
"From the output, we notice that the top three members that has the highest annual income are member 1301, 1135, and 1238, with income of 340000, 285000, and 267525, respectively."
;

footnote2
"Given the result, we can add some steps to figure out why some members with high income still borrow money from LendingClub. Try to find out the purpose of it."
;

*
Note: This compares column "annual_income" and "member_id" from dataset 
Loanstat1 and Loanstat3

Methodology: Use PROC PORT to sort the annual income in the combined dataset 
descendingly and use PROC PRINT to output the top 3 member id accordingly.

Limitations: The highest top 3 annual income data are not visualized.

Follow Up: We can add PROC SGPLOT statement to plot a bar graph, making the 
annual income differences more explicit.
;

proc sort
        data=Loanstat_analytic_file_v1
        out=Loanstat_analytic_file_v1_sorted
    ;
    by 
        descending annual_inc
    ;
run;


proc print 
        data=Loanstat_analytic_file_v1_sorted(obs=3)
    ;
    id 
        member_id
    ;
    var 
        annual_inc
    ;
run;

proc sgplot
        data=Loanstat_analytic_file_v1_sorted(obs=3)
	;
    vbar 
        member_id/response=annual_inc
	;
run;

title;
footnote;
		

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the average loan amount for each state?'
;

title2
'Rationale: This shows the lending situation from each state.'
;

footnote1
"From the output, we can see the 5-number summaries for loan amount in each state. For example, the mean loan amount for California is 15063.24."
;

footnote2
"Focusing on the mean loan amount, the lowest one is in MS. Investigation could be performed to find out the reason of it."
;

*
Note: This compares column "loan_amount", "state", and "member_id" from dataset 
Loanstat1 and Loanstat2

Methodology: Use the PROC MEANS statement to compute the mean loan amount.

Limitations: We cannot know the distribution of the loan amount for each state.

Follow Up: Add min, median, and max in the PROC MEANS statement to compute the 
five-number summaries.
;

proc means 
        data=Loanstat_analytic_file_h1
    ;
    var 
        loan_amnt
    ;
    class 
        addr_state
    ;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the purpose of the highest loan amount?'
;

title2
'Rationale: This would help identify what is the use of the largest amount of money borrowed.'
;

footnote1
"From the output, we notice that the highest loan amount is 40000. The money is used for credit card."
;

footnote2
"We should try to understand the meaning for each purpose in the datasets, since the description of purpose is not detailed"
;

*
Note: This compares column "loan_amount", "purpose",and "member_id" from dataset 
Loanstat1 and Loanstat2

Methodology: Use PROC SORT statement to sort the loan amount descendingly and 
find out the purpose of it.

Limitations: The currency symbol for the loan amount is not clear.

Follow Up: Use PROC FORMAT to add dollar sign in the data output.
;

proc sort
        data=Loanstat_analytic_file_h1
        out=Loanstat_analytic_file_h1_sorted
    ;
    by 
        descending loan_amnt
    ;
run;

proc print 
        data=Loanstat_analytic_file_h1_sorted(obs=1)
    ;
    id 
        purpose
    ;
    var 
        loan_amnt
    ;
run;

