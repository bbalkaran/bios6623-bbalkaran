*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project 2 - Missing Data Exploration                    *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-19                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                        *
*   MODIFIED:   DATE  2017-10-19                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;

DATA Project2.Missing_AllVars;
	set Project2.Clean3;
	IF Albumin = . THEN Albumin_Miss = 1; 
		ELSE Albumin_Miss = 0; 
	IF Proced = . THEN Proced_Miss = 1; 
		ELSE Proced_Miss = 0; 
	IF ASA = . THEN ASA_Miss = 1; 
		ELSE ASA_Miss = 0;
	IF Weight_New = . THEN Weight_New_Miss = 1; 
		ELSE Weight_New_Miss = 0;
	IF Height = . Then Height_Miss = 1; 
		ELSE Height_Miss = 0;
	IF BMI_Calc2 = . Then BMI_Calc2_Miss = 1; 
		ELSE BMI_Calc2_Miss = 0;
	IF Death30 = . THEN Death30_Miss = 1; 
		ELSE Death30_Miss = 0;
	RUN; 

PROC FREQ DATA = Project2.Missing_AllVars;
/*Proced_Miss*/
TABLES Proced_Miss*ASA/ missing;  
TABLES Proced_Miss*Death30/ missing; 
TABLES Proced_Miss*HospCode/ missing; 
TABLES Proced_Miss*Sixmonth/ missing;
RUN; 

TABLES Proced*death30/ missing;
	TABLES ASA*death30/ missing;  
	TABLES death30*ALbumin_Miss/ missing; 
	TABLES Proced*Albumin_miss/ missing;
	TABLES ASA*Albumin_miss/ missing;
	TABLES hospcode*Albumin_miss/ missing;
	Tables sixmonth*Albumin_miss/ missing; 
TABLES  Albumin_Miss Proced_Miss ASA_Miss Weight_New_Miss Height_Miss BMI_Calc2_Miss; 
BY hospcode;
RUN; 