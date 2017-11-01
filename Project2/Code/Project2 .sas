*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project 2  - Data Cleaning                             *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-10                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                        *
*   MODIFIED:   DATE  2017-10-31                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
/* Read in Data*/
DATA Project2.Raw;
	SET Project2.vadata2;
	RUN;

/*Data Exploration*/ 
PROC UNIVARIATE DATA= Project2.Raw;
	BY hospcode;
	VAR Proced death30 height weight BMI ASA Albumin;
	RUN;
	
PROC MEANS Data = Project2.raw;
by hospcode;
where sixmonth = 39;
VAR weight;
RUN;

/*Hospital 30 Missing all BMI, Weight, and Height Data */
PROC PRINT DATA = Project2.RAW; 
by sixmonth;
where hospcode = 30;
RUN;

/*Create missing albumin Dataset for further analysis*/	
DATA Project2.Missing;
	set Project2.Raw;
	IF Albumin = . THEN Albumin_Miss = 1; 
		ELSE Albumin_Miss = 0; 
	RUN;
*********************************************************************************************************;
/* Missing data in Albumin around 50%. Need to explore this more. Run Missing Data Analysis.sas after this file*/
*********************************************************************************************************;
/*Data Cleaning*/
DATA Project2.Clean; 
	SET Project2.Missing; 
	IF Proced = 2 THEN DELETE;
	BMI_Calc = ((Weight/height**2) * 703);         *CALCULATE BMI TO SEE IF ENTERED VALUES ARE CORRECT;
	IF BMI = 2.4379994195 THEN BMI = 24.379994195; *DECIMAL ERROR - CHANGED TO CALCULATED BMI*;
	IF BMI  = 75.1 THEN BMI  = 27.091376616;       *ENRTY ERROR  - CHANGED TO CALCULATED BMI*;
	IF BMI  = 72.3 THEN BMI  = 21.825600817;       *ENTRY ERROR - CHANGED TO CALCULATED BMI*; 
	RUN; 

/*sixmonth = 39 seems to have started recording weights in kgs - VA hospital network change in policy??? */ 
DATA Project2.Sixmonth39;
	SET Project2.Clean;
	If sixmonth = 39;
	WeightLBS  = Weight* 2.2;
	Weight_New  = Weight;       *SEE IF SOME WEIGHT VALUES ARE ENTERED IN KGS, CONVERT TO LBS TO CHECK; 
	IF Hospcode <= 16 THEN Weight_New  = WeightLBS; 
	RUN; * NEED TO FIGURE OUT HOW TO MERGE THE CONVERTED VALUES FOR SIXMONTH 39 INTO THE DATASET; 

/*Sort by HospCode*/	
PROC SORT DATA = Project2.Sixmonth39; 
By hospcode; 
RUN; 

/*check to see if weights have been corrected*/
PROC MEANS DATA = Project2.Sixmonth39;
VAR Weight WeightLBS Weight_NEW; 
BY hospcode;
RUN; 

/*Merge these Datasets*/
DATA Project2.Clean2;
	MERGE Project2.Sixmonth39  Project2.Clean;
	IF weight_new = "." THEN Weight_new = weight; 
	RUN; 
	

PROC SORT DATA= Project2.Clean2; 
	BY sixmonth; 
	RUN;

/*Recalculate BMI with Weight_New*/
DATA Project2.Clean3; 
	Set Project2.Clean2;
	BMI_Calc2 = ((Weight_New /height**2) * 703); *use bmi_calc2 in analysis;
	RUN; 

/*confirm weights are correct*/
PROC MEANS DATA = Project2.Clean3;
By Hospcode;
Run; 

/*dichotomize ASA, not enough values in asa 1 for those who did not die*/
DATA Project2.Clean4; 
	SET Project2.Clean3;
	IF  ASA  = 1 THEN ASA_CAT = 0;
	IF  ASA  = 2 THEN ASA_CAT = 0;
	IF  ASA  = 3 THEN ASA_CAT = 0;
	IF  ASA = 4 THEN ASA_CAT  = 1; 
	IF  ASA = 5 THEN ASA_CAT = 1;
		RUN; 

/*confirm changes*/ 
PROC FREQ DATA = Project2.Clean4;
Tables ASA_CAT/ nocum; 
	RUN;
	
PROC EXPORT DATA = Project2.Clean4 
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/Clean.csv'
 DBMS = CSV 
 REPLACE;  *EXPORT TO CSV TO CONFIRM CHANGES HAVE BEEN MADE;
 RUN;


PROC CORR DATA = Project2.Clean3;
	VAR death30 hospcode sixmonth proced asa albumin bmi_calc2;
	RUN; *albumin moderately negatively correlated with asa: rho = -0.38;
	* is this why albumin values are seen more in those with with higher ASA levels or 
	  are people with higher ASA levels more likely to have have bloodwork and albumin levels??;
	  
		

	
