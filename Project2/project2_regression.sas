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
*   MODIFIED:   DATE  2017-10-26                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
/*Regression - Primary Adjusted Model*/
PROC LOGISTIC data = Project2.CLEAN4;
	class  proced ASA_Cat; 
	model death30 (event = '1') = proced BMI_Calc2 asa_cat; /* want prob of 1*/
	output out =Project2.RegOutput1 p= pred_prob;
	run;
	quit;

/*Primary adjusted model - predicted probabilities - Adjusted Death Rates by Hospital*/
PROC MEANS  DATA=Project2.RegOutput1;
	VAR pred_prob;
	BY hospcode; 
	OUTPUT OUT=Project2.HospProb Mean=; 
	run;

/*Export Adjusted Death Rates by hospital*/ 
PROC EXPORT DATA = Project2.HospProb
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/HospProb Adjusted Death Rates Primary.csv'
 DBMS = CSV 
 REPLACE;  
 RUN;
	

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
	OUTPUT OUT=Project2.HospProb2Alb Mean=; 
	run;

/*Export Adjusted Death Rates by hospital - adjusted death rates by hospital*/ 
PROC EXPORT DATA = Project2.HospProb2Alb
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/HospProb Adjusted Death Rates Secondary with ALbumin.csv'
 DBMS = CSV 
 REPLACE;  
 RUN;

***********************************************************************************************;
/*Sort by hospcode*/
PROC SORT DATA = Project2.Clean4;
By hospcode;
RUN;

/*observed death rates by hospital*/
Proc Means Data=Project2.clean4;
By HospCode;
where sixmonth = 39; 
Var death30;
output out = Project2.obsdeathrt39 mean=;
RUN; 

/*Export observed death rates by hospital  - ovserved death rates by hospital*/
PROC EXPORT DATA = Project2.Obsdeathrt39
OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/Obsdeathrt39.csv'
DBMS = CSV 
REPLACE;  
RUN;
	

 