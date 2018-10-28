
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] LoanStat_part1

[Dataset Description] 
Complete LendingClub loan data for all loans issued in 2018 quarter 2

[Experimental Unit Description] LendingClub loans issued in 2018 Q2

[Number of Observations] 109

[Number of Features] 12

[Data Source] https://resources.lendingclub.com/LoanStats_2018Q2.csv.zip

[Data Dictionary] https://www.lendingclub.com/info/download-data.action

[Unique ID Schema] The column member_id is a unique id.

--

[Dataset 2 Name] LoanStat_part2

[Dataset Description] 
Complete LendingClub loan data for all loans issued in 2018 quarter 2

[Experimental Unit Description] LendingClub loans issued in 2018 Q2

[Number of Observations] 109

[Number of Features] 14

[Data Source] https://resources.lendingclub.com/LoanStats_2018Q2.csv.zip

[Data Dictionary] https://www.lendingclub.com/info/download-data.action

[Unique ID Schema] The column member_id is a unique id.

--

[Dataset 3 Name] LoanStat_part3

[Dataset Description] 
Complete LendingClub loan data for all loans issued in 2018 quarter 2

[Experimental Unit Description] LendingClub loans issued in 2018 Q2

[Number of Observations] 126

[Number of Features] 12

[Data Source] https://resources.lendingclub.com/LoanStats_2018Q2.csv.zip

[Data Dictionary] https://www.lendingclub.com/info/download-data.action

[Unique ID Schema] The column member_id is a unique id.
;

* environmental setup;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat660/team-1_project2/blob/master/data/LoanStats_part1.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = loanstat1_raw;

%let inputDataset2URL =
https://github.com/stat660/team-1_project2/blob/master/data/LoanStats_part2.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = loanstat2_raw;

%let inputDataset3URL =
https://github.com/stat660/team-1_project2/blob/master/data/LoanStats_part3.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = loanstat3_raw;

* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)

* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;


