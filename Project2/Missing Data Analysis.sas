*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project2.sas                                                            *
*   PURPOSE:    Data Analysis of Project 2 - Missing Data Exploration of Albumin        *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-10-19                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  vadata2.sas7bdat                                                        *
*   MODIFIED:   DATE  2017-10-26                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;

/*albumin missing around 50% of data. Further exploration to see which variables 
and levels are affected most. Other variables missing at around 2%. This should not bias results.*/ 

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