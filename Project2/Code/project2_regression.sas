*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project 2  - Logistic Regression                       *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-22                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                        *
*   MODIFIED:   DATE  2017-10-31                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
Proc Means Data = Project2.clean4 N NMISS MEAN MEDIAN Q1 Q3;
*where sixmonth = 39;
VAR BMI_Calc2 Weight_new height albumin;
RUN; 

Proc FREQ DATA = Project2.clean4 ;
*Where sixmonth = 39;
tables death30 proced asa_cat/ missing ; 
RUN;

/*Regression - Primary Adjusted Model*/
PROC LOGISTIC data = Project2.CLEAN4 ;
	class  proced ASA_Cat; 
	model death30 (event = '1') = proced BMI_Calc2 asa_cat; /* want prob of 1*/
	output out =Project2.RegOutput1 p= pred_prob;
	run;
	quit;

/*Primary adjusted model - predicted probabilities - Adjusted Death Rates by Hospital*/
PROC MEANS  DATA=Project2.RegOutput1;
	VAR pred_prob;
	BY hospcode; 
	Where sixmonth=39;
	OUTPUT OUT=Project2.HospProb Mean=; 
	run;


**************************************************************************************************;
/*Regression - Secondary Adjusted Model - with Albumin*/
PROC LOGISTIC data = Project2.CLEAN4;
	class  proced ASA_Cat; 
	model death30 (event = '1') = proced BMI_Calc2 asa_cat albumin; /* want prob of 1*/
	output out =Project2.RegOutput2Alb p= pred_prob;
	run;
	quit;

/*Second adjusted model - predicted probabilities - adjusted death rates by hospital  - with Albumin*/
PROC MEANS  DATA=Project2.RegOutput2Alb;
	VAR pred_prob;
	BY hospcode; 
	where sixmonth=39;
	OUTPUT OUT=Project2.HospProb2Alb Mean=; 
	run;

***********************************************************************************************;

/*Sort by hospcode*/
PROC SORT DATA = Project2.Clean4;
By hospcode;
RUN;

/*observed death rates by hospital*/
Proc Means Data=Project2.clean4;
By HospCode;
where sixmonth = 39; 
Var death30 ;
output out = Project2.obsdeathrt39 mean=;
RUN; 

******************************************************************************************;

/*PRIMARY  - ratios of obs/exp*/	
DATA Project2.CompObsandExpPrimary; 
MERGE Project2.obsdeathrt39 Project2.HospProb;
ratio = death30 / pred_prob ;
If ratio => 1.2 then Results = 'FLAG';
else results = ".";
run;

/*Export observed death rates by hospital  - ovserved death rates by hospital*/
PROC EXPORT DATA = Project2.CompObsandExpPrimary
OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/CompObsandExpPrimary.csv'
DBMS = CSV 
REPLACE;  
RUN;

/*Secondary - ratios of obs/expected*/
DATA Project2.CompObsandExpSecondary; 
MERGE Project2.obsdeathrt39 Project2.HospProb2alb;
ratio = death30 / pred_prob ;
RENAME pred_prob  = pred_prob2;
If ratio => 1.2 then Results = 'FLAG';
else results = ".";
run;

/*Export observed death rates by hospital  - ovserved death rates by hospital*/
PROC EXPORT DATA = Project2.CompObsandExpSecondary
OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/CompObsandExpSecondary.csv'
DBMS = CSV 
REPLACE;  
RUN;

/*Create Percent change and load this into R to make graphs*/
DATA Project2.CalPercentChange;
MERGE Project2.CompObsandExpPrimary Project2.CompObsandExpSecondary;
PercentChange = (pred_prob2 - pred_prob)/pred_prob * 100;
RUN; 

/*Export observed death rates by hospital  - ovserved death rates by hospital*/
PROC EXPORT DATA = Project2.CompObsandExpSecondary
OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/CompObsandExpSecondary.csv'
DBMS = CSV 
REPLACE;  
RUN;

 