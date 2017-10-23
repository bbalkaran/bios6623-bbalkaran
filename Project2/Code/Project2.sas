*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project 2  - Data Cleaning                              *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-10                                                             *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                     *
*   MODIFIED:   DATE  2017-10-19                                                       *
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
	BY sixmonth;
	qqplot;
	RUN;
	
/*Create Missing Data Dataset*/ 
DATA Project2.Missing;
	set Project2.Raw;
	IF Albumin = . THEN Albumin_Miss = 1; 
		ELSE Albumin_Miss = 0; 
	RUN; 

/*Exploration of missing albumin data */ 
PROC MEANS DATA = Project2.Missing;
	CLASS death30 albumin_miss;
	VAR Weight Height BMI;
	TITLE "Descriptive Statistics for Subjects Missing vs. Not Missing Albumin Data";
	RUN; 
	

PROC FREQ DATA = project2.missing;
	TABLES Proced*death30/ missing;
	TABLES ASA*death30/ missing;  
	TABLES death30*ALbumin_Miss/ missing; 
	TABLES Proced*Albumin_miss/ missing;
	TABLES ASA*Albumin_miss/ missing;
	TABLES hospcode*Albumin_miss/ missing;
	Tables sixmonth*Albumin_miss/ missing; 
	RUN; 

/*Continuous variables*/ 
PROC SGPANEL DATA = PRoject2.Missing;
	PANELBY Death30;
		vbox Weight / group = albumin_miss; 
		title "Distribution of Weight by Albumin_Missing";
	RUN;
PROC SGPANEL DATA = PRoject2.Missing;
	PANELBY Death30;
		vbox Height / group = albumin_miss; 
		title "Distribution of Height by Albumin_Missing";
	RUN;
PROC SGPANEL DATA = PRoject2.Missing;
	PANELBY Death30;
		vbox BMI / group = albumin_miss; 
		title "Distribution of BMI by Albumin_Missing";
	RUN;
PROC SGPANEL DATA = PRoject2.Missing;
	PANELBY Death30;
		vbox BMI / group = albumin_miss; 
		title "Distribution of Death30 by Albumin_Missing";
	RUN;
	
/*Categorical*/ 
proc sgpanel data=Project2.Missing;
		panelby albumin_miss death30;
		vbarbasic ASA /stat=pct ;
		title "Distribution of ASA by Albumin_Missing";
	run;
proc sgpanel data=Project2.Missing;
		panelby albumin_miss death30;
		vbarbasic Proced /stat=pct ;
		title "Distribution of Procedure by Albumin_Missing";
	run;

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
	RUN; 
	

PROC SORT DATA= Project2.Clean2; 
	BY sixmonth; 
	RUN;

/*Recalculate BMI with Weight_New*/
DATA Project2.Clean3; 
	Set Project2.Clean2;
	BMI_Calc2 = ((Weight_New /height**2) * 703); *use bmi_calc2 in analysis;
	RUN; 

	
	
PROC EXPORT DATA = Project2.Clean3;  
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/Clean.csv'
 DBMS = CSV 
 REPLACE;  *EXPORT TO CSV TO CONFIRM CHANGES HAVE BEEN MADE;
 RUN;

PROC CORR DATA = Project2.Clean3;
	VAR hospcode sixmonth proced asa albumin bmi_calc2;
	RUN; *albumin moderately negatively correlated with asa: rho = -0.38;
	

		

	
