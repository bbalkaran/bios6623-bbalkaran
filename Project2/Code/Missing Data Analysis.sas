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
<<<<<<< Updated upstream
*   MODIFIED:   DATE  2017-10-31                                                        *
=======
*   MODIFIED:   DATE  2017-10-26                                                        *
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
PROC MEANS DATA = Project2.Missing  N NMISS MEAN STD MIN MAX;
=======
PROC MEANS DATA = Project2.Missing;
>>>>>>> Stashed changes
	CLASS death30 albumin_miss;
	VAR Weight Height BMI;
	TITLE "Descriptive Statistics for Subjects Missing vs. Not Missing Albumin Data";
	RUN; 
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
	

PROC FREQ DATA = project2.missing;
	TABLES Proced*death30/ missing;
<<<<<<< Updated upstream
	*TABLES ASA*death30/ missing;  
=======
	TABLES ASA*death30/ missing;  
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
	run;
**************************************************************************************************************************;
DATA Project2.MissAllVars;
	SET Project2.Clean4;
	IF Proced = . THEN Proced_Miss = 1; ELSE Proced_Miss = 0;
	IF BMI_Calc2 = . THEN BMI_Miss = 1; Else BMI_Miss = 0; 
	IF ASA_Cat = . THEN ASA_CATmiss = 1; Else ASA_Catmiss = 0; 
	IF Weight_New = . THEN Weight_NewMiss = 1; Else Weight_NewMiss = 0; 
	If Height = . THEN HeightMiss = 1; ELSE HeightMiss = 0; 
	
	RUN; 
	
PROC FREQ DATA = project2.MissALLVARS;  *Unblock code to run. Only ran a few chunks at a time to make it easier to read output;
	/*TABLES Proced*death30/ missing;
	TABLES ASA*death30/ missing;  
	TABLES death30*ALbumin_Miss/ missing; 
	TABLES Proced*Albumin_miss/ missing;
	TABLES ASA*Albumin_miss/ missing;
	TABLES hospcode*Albumin_miss/ missing;
	Tables sixmonth*Albumin_miss/ missing; */
	
	
	/*TABLES death30*BMI_miss/ missing; 
	TABLES Proced*BMI_miss/ missing;
	TABLES ASA_CAT*BMI_miss/ missing;
	TABLES ASA*BMI_miss/ missing;
	TABLES hospcode*BMI_miss/ missing;
	Tables sixmonth*BMI_miss/ missing; */
	
	
	/*TABLES death30*ASA_CATmiss/ missing; 
	TABLES Proced*ASA_CATmiss/ missing;
	TABLES ASA_CAT*ASA_CATmiss/ missing;
	TABLES ASA*ASA_CATmiss/ missing;
	TABLES hospcode*ASA_CATmiss/ missing;
	Tables sixmonth*ASA_CATmiss/ missing; */
	
	/*TABLES death30*Weight_NewMiss/ missing; 
	TABLES Proced*Weight_NewMiss/ missing;
	TABLES ASA_CAT*Weight_NewMiss/ missing;
	TABLES ASA*Weight_NewMiss/ missing;
	TABLES hospcode*Weight_NewMiss/ missing;
	Tables sixmonth*Weight_NewMiss/ missing; */
	
	/*TABLES death30*HeightMiss/ missing; 
	TABLES Proced*HeightMiss/ missing;
	TABLES ASA_CAT*HeightMiss/ missing;
	TABLES ASA*HeightMiss/ missing;
	TABLES hospcode*HeightMiss/ missing;
	Tables sixmonth*HeightMiss/ missing; */
	
	TABLES death30*Proced_Miss/ missing; 
	TABLES Proced*Proced_Miss/ missing;
	TABLES ASA_CAT*Proced_Miss/ missing;
	TABLES ASA*Proced_Miss/ missing;
	TABLES hospcode*Proced_Miss/ missing;
	Tables sixmonth*Proced_Miss/ missing; 
	
	RUN; 
	
	
	
DATA PROJECT2.MissingDataPatterns;
Set Project2.clean4;
where sixmonth=39;
run;

PROC MEANS DATA = PROJECT2.Missingdatapatterns N NMISS MEAN STD MIN MAX;
by hospcode;
where death30=1;
VARS PROCED ASA_CAT BMI_CALC2;
RUN;
	
**************************************************************************************************************************;
/* Examination of missing data patterns by hospital*/ 

PROC MEANS DATA  = PROJECT2.Clean4 N NMISS MEAN STD MIN MAX;
by HospCode;
where sixmonth = 39;
VARS death30 Proced Weight Height BMI_Calc ASA;
RUN;


/* Ran through these for different hospitals and six month periods just to view patterns ok to ignore, similar results above
PROC Freq DATA = Project2.Clean4; 
by sixmonth;
where hospcode = 17;
TABLES Proced ASA_CAT death30; 
RUN;


PROC MEANS DATA  = PROJECT2.Clean4 N NMISS MEAN STD MIN MAX;
by sixmonth;
where hospcode = 17;
VARS BMI_Calc Albumin;
RUN; */ 




proc mi data=Project2.Clean4 nimpute=0;
By hospcode;
WHere sixmonth = 39 ;
VAR death30 Proced Weight_new Height BMI_Calc2 ASA albumin;
run;



=======
	run;
>>>>>>> Stashed changes
