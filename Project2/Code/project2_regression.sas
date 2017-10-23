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
*   MODIFIED:   DATE  2017-10-22                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
/*Regression*/
PROC LOGISTIC data = Project2.CLEAN3;
class  proced ASA; 
model death30 (event = '1') = proced BMI_Calc2 asa ALbumin; /* want prob of 1*/
output out =Project2.RegOutput1 p= pred_prob;
run;
quit;

PROC MEANS  DATA=Project2.Clean3;
VAR pred_prob;
BY hospcode; 
OUTPUT OUT= Project2. = 
run;

DATA Project2.Hosp1Subset;
	SET Project2.RegOutput1;
	If hospcode =1; 
	RUN;
	
PROC EXPORT DATA = Project2.Hosp1Subset
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/Hosp1Subset.csv'
 DBMS = CSV 
 REPLACE;  
 RUN;
	

 