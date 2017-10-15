*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project  - Data Cleaning                              *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-10                                                             *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                     *
*   MODIFIED:   DATE  2017-10-13                                                        *
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
	WeightLBS  = Weight* 2.2;  *SEE IF SOME WEIGHT VALUES ARE ENTERED IN KGS, CONVERT TO LBS TO CHECK; 
	RUN;                       * NEED TO FIGURE OUT HOW TO MERGE THE CONVERTED VALUES FOR SIXMONTH 39 INTO THE DATASET; 


PROC SORT DATA= Project2.Clean; 
	BY sixmonth; 
	RUN;
	
PROC EXPORT DATA = Project2.Clean 
 OUTFILE = '/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_2/Clean.csv'
 DBMS = CSV 
 REPLACE;  *EXPORT TO CSV TO CONFIRM CHANGES HAVE BEEN MADE;
 RUN;




	 
		

	
