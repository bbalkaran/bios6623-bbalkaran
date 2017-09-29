*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project1.sas                                                            *
*   PURPOSE:    Data Analysis of Project 1 - Data Cleaning                              *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-09-15                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  hiv_6623_final.csv                                                      *
*   MODIFIED:   DATE  2017-09-27      Read in Data                                      *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
/*Import Data*/
PROC IMPORT
		DATAFILE	= "/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_1/hiv_6623_final.csv"
		OUT			= hivdata
		DBMS		= CSV
		REPLACE		;
	RUN;

/*remove Nas*/
DATA Project1Raw;
	SET hivdata;
	IF HASHV ='NA' THEN HASHV= '';
	IF BMI ='NA' THEN BMI= '';
	IF TCHOL ='NA' THEN TCHOL= '';
	IF TRIG ='NA' THEN TRIG= '';
	IF LDL ='NA' THEN LDL= '';
	IF LEU3N ='NA' THEN LEU3N= '';
	IF VLOAD ='NA' THEN VLOAD= '';
	IF ADH ='NA' THEN ADH= '';
	RUN;

/*change character variables to numeric*/	
DATA Project1Clean;
	SET Project1Raw;
	HASHVnum = INPUT (HASHV, best12.);
		DROP HASHV; 
	BMInum = INPUT (BMI, best12.);
		DROP BMI;
	TCHOLnum = INPUT (TCHOL, best12.);
		DROP TCHOL;
	TRIGnum = INPUT (TRIG, best12.);
		DROP TRIG; 
	LDLnum = INPUT (LDL, best12.);
		DROP LDL;
	LEU3Nnum = INPUT (LEU3N, best12.);
		DROP LEU3N;	
	 VLOADnum = INPUT (VLOAD, best12.);
		DROP VLOAD;	
	RUN;

/*rename to original labels*/
DATA Project1Clean2;
	SET Project1Clean;
	RENAME HASHVnum=HASHV
	 BMInum=BMI
	 TCHOLnum=TCHOL
	 TRIGnum=TRIG
	 LDLnum=LDL
	 LEU3Nnum=LEU3N
	 VLOADnum= VLOAD;
	RUN;
	

/*Covariates to include as per investigator

Baseline value of the outcome
Baseline age 
Baseline BMI 
Race - NHW vs. Other
Baseline marijuana use
Baseline alcohol use - > 13 drinks per week vs. 13 or less
Baseline smoking - Current smokers vs. never/former
Baseline income level - < $10,000, $10,000 - $40,000, >$40,000
Education - >HS vs. HS or less
ART Adherence, >95% vs. <95%*/



/*create year 0 subset data*/	
DATA Project1SubsetYear0;
	SET Project1Clean2;
	If Years =0;
	 YEARS_0 = YEARS;
	 HARD_DRUGS_0 = HARD_DRUGS;
	 VLOAD_0 = VLOAD;
	 LEU3N_0 = LEU3N;
	 AGG_PHYS_0 = AGG_PHYS;
	 AGG_MENT_0 = AGG_MENT;
	 SMOKE_0 = SMOKE;
	 AGE_0 = age;
	 BMI_0 = BMI;
	 RACE_0 = RACE;
	 HASHV_0 = HASHV;
	 DKGRP_0 = DKGRP;
	 INCOME_0 = INCOME;
	 EDUCBAS_0 = EDUCBAS;
	DROP VLOAD LEU3N AGG_PHYS AGG_MENT SMOKE AGE BMI RACE HASHV DKGRP 
	INCOME EDUCBAS YEARS HARD_DRUGS HASHF HBP DIAB LIV34 KID FRP FP
	DYSLIP CESD HEROPIATE IDU HIVPOS ART EVERART TCHOL TRIG LDL ADH;
	RUN;


/*create year 2 subset data*/
DATA Project1SubsetYear2;
	SET Project1Clean2;
	If Years = 2;
	YEARS_2 = YEARS;
    VLOAD_2 = VLOAD;
    LEU3N_2 = LEU3N;
    AGG_PHYS_2  = AGG_PHYS;
    AGG_MENT_2 = AGG_MENT;
    ADH_2 = ADH;
	DROP VLOAD LEU3N AGG_PHYS AGG_MENT YEARS SMOKE AGE 
	BMI RACE HASHV DKGRP INCOME EDUCBAS HARD_DRUGS
	HASHF HBP DIAB LIV34 KID FRP FP DYSLIP CESD 
	HEROPIATE IDU HIVPOS ART EVERART TCHOL TRIG LDL ADH;   
	RUN; 



/*sort by id*/	
PROC SORT  DATA=Project1SubsetYear0;
	BY newid;
	RUN;



/*sort by id*/
PROC SORT DATA=Project1SubsetYear2;
	BY newid;
	RUN;



/*merge year 0 subset and year 2 subset*/
DATA Project1_Years0and2;
	MERGE Project1SubsetYear0 Project1SubsetYear2;
	BY newid;
	RUN;


/*Create difference variables*/	
DATA Project1_Years0and2_1;
	SET Project1_Years0and2;
	VLOADdiff = VLOAD_2 - VLOAD_0;
	log10VLOADdiff = log10(VLOAD_2) - log10(VLOAD_0);   *used log10 difference as per investigator;
	log10VLOAD_0 = log10(VLOAD_0);
	LEU3Ndiff = LEU3N_2 - LEU3N_0;
	AGG_MENTdiff = AGG_MENT_2 - AGG_MENT_0;
	AGG_PHYSdiff = AGG_PHYS_2 - AGG_PHYS_0;
	RUN;

/*Recode variables as per investigator's interest, Final Clean and Coded Dataset*/	
DATA Project1.Project1_Years0and2_2;
	Set Project1_Years0and2_1;
	IF RACE_0=1 THEN RACE_NHW =1; ELSE RACE_NHW = 0;
	IF HASHV_0 = 2 THEN POTUSE = 1; ELSE POTUSE = 0;
	DKgr13prWk = 0;
	IF DKGRP_0 = 3 THEN DKgr13prWK = 1;
	IF SMOKE_0 = 3 THEN CURSMOKE = 1; ELSE CURSMOKE = 0;
	IF INCOME_0 = 1 THEN BaseINC = 0;
	IF INCOME_0 = 2 THEN BaseINC = 1;
	IF INCOME_0 =3 THEN BaseINC = 1;
	IF INCOME_0 = 4 THEN BaseINC = 1;
	IF INCOME_0 = 5 THEN BaseINC = 2;
	IF INCOME_0 = 6 THEN BaseINC = 2;
	IF INCOME_0 = 7 THEN BaseINC = 2;
	IF INCOME_0 = 9 THEN BaseINC = .;
	IF EDUCBAS_0 = 4 THEN GRthanHS = 1;ELSE GRthanHS=0;
	IF EDUCBAS_0 = 5 THEN GRthanHS = 1;
	IF EDUCBAS_0 = 6 THEN GRthanHS = 1;
	IF EDUCBAS_0 = 7 THEN GRthanHS = 1;
	IF ADH_2 = 1 THEN ADH2gr95 = 1;
	IF ADH_2 = 2 THEN ADH2gr95 = 1;
	IF ADH_2 = 3 THEN ADH2gr95 = 0;
	IF ADH_2 = 4 THEN ADH2gr95 = 0;
	IF ADH_2 = . THEN ADH2gr95 = .;
	RUN; 
	


/*Summarize Data - 9/20/17 */
PROC FREQ Data=Project1.Project1_Years0and2_2;
TABLES hard_drugs_0 race_0 income_0 educbas_0 adh_2 hashv_0 smoke_0 BaseINC years_2 /nocum;
	RUN;		
PROC MEANS DATA=Project1_Years0and2_1 N MEAN VAR STD NMISS MIN MAX;
	VAR  VLOADdiff LEU3Ndiff AGG_PHYSdiff AGG_MENTdiff AGE_0 BMI_0;
	RUN;
	
**********************************************************************************************;
*Graphs for Interim Presentation;
**********************************************************************************************;

/*histogram of VLOADdiff*/
title "Distribution of Viral Load Difference from Year 0 to Year 2";
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	histogram VLOADdiff / scale=COUNT fillattrs=(color=CXc50d23);
	xaxis label="Difference in Viral Load";
	yaxis grid;
run;	
title;	

********************************************************************************************;
/* histogram of LEU3Ndiff*/
title "Distribution of CD4+ T Cell Difference, Year 2 - Year 0";
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	histogram LEU3Ndiff / scale=COUNT fillattrs=(color=CXfcfc20);
	xaxis label="Difference in CD4+ T Cells";
	yaxis grid;
run;
title;

*********************************************************************************************;
/*histogram of AGG_MENTdiff*/
title "Distribution of Aggregate Mental Quality of Life Score Difference, Year 2 - Year 0";
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	histogram AGG_MENTdiff / scale=COUNT fillattrs=(color=CX20fc4c);
	xaxis label="Difference in Aggregate Mental Quality of Life Score";
	yaxis grid;
run;
title;

**********************************************************************************************;
/*histogram of AGG_PHYSdiff*/
title "Distribution of Aggregate Physical Quality of Life Score Difference, Year 2 - Year 0";
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	histogram AGG_MENTdiff / scale=COUNT fillattrs=(color=CX2720fc);
	xaxis label="Difference in Aggregate Physical Quality of Life Score";
	yaxis grid;
run;
title;

***********************************************************************************************;
/*scatterplot of Viral load vs age*/
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	title "Age at Year 0 and Viral Load Difference";
	scatter x=AGE_0 y=VLOADdiff / markerattrs=(symbol=Circle) transparency=0.0 
		name='Scatter';
	xaxis grid label="Age at Year 0";
	yaxis grid label="Viral Load Difference";
run;
title;

**********************************************************************************************;
/*scatterplot of CD4+ T Cells vs age*/



/*RUN THIS LATER 
 * PROC CORR DATA= Project1_Years0and2_1 Pearson nomiss;
 
	Var VLOADdiff LEU3Ndiff AGG_MENTdiff AGG_PHYSdiff VLOAD_0 LEU3N_0 
		AGG_MENT_0 AGG_PHYS_0 AGE_0 BMI_0 RACE_0 HASHV_0 DKGRP_0 SMOKE_0 EDUCBAS_0
		ADH_2 INCOME_0; *need to change ADH to numeric;
		RUN;*/ 


********************************************************************************************;

/*Boxplot of VLOADdiff*/
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	title "Difference in HIV Viral Load Between Year 2 and Year 0 Among Patients Who Reported Using Hard Drugs at Year 0 vs Not";
	vbox VLOADdiff / category=HARD_DRUGS_0 fillattrs=(color=CXc50d23) name= 'Box';
	xaxis fitpolicy=splitrotate label="Use of Hard Drugs at Year 0";
	yaxis label="Difference in Viral Load" grid;
run;
title;

***********************************************************************************************;

/*Boxplot of LEU3Ndiff*/
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	title "Difference in CD4+ T Cells Between Year 2 and Year 0 Among Patients Who 
	Reported Using Hard Drugs vs Not";
	vbox LEU3Ndiff / category=HARD_DRUGS_0 fillattrs=(color=CXfcfc20) 
		DataSkin=sheen name='Box';
	xaxis fitpolicy=splitrotate label="Use of Hard Drugs at Year 0";
	yaxis label="Difference in CD4+ T Cells" grid;
run;
title; 


************************************************************************************************;

/*boxplot of agg_mentdiff*/
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	title "Difference in Aggregate Mental Quality of Life Score Between Year 2 and Year 0
	Among Patients Who Reported Using Hard Drugs vs Not";
	vbox AGG_MENTdiff / category=HARD_DRUGS_0 fillattrs=(color=CX20fc4c) 
		name='Box';
	xaxis fitpolicy=splitrotate label="Use of Hard Drugs at Year 0";
	yaxis label="Difference in Aggregate Mental Quality of Life Score" grid;
run;
title;

***********************************************************************************************;
/*boxplot of AGG_PHYSdiff*/
proc sgplot data=WORK.PROJECT1_YEARS0AND2_1;
	title "Difference in Aggregate Physical Quality of Life Score Between Year 2 
	and Year 0 Among Patients Who Reported Using Hard Drugs vs Not";
	vbox AGG_PHYSdiff / category=HARD_DRUGS_0 fillattrs=(color=CX2720fc) 
		name='Box';
	xaxis fitpolicy=splitrotate label="Use of Hard Drugs at Year 0";
	yaxis label="Difference in Aggregate Physical Quality of Life Score" grid;
run;
title;
***************************************************************************************************;
*End Graphs for Interim Presentation;
***************************************************************************************************;




/*Run regression  - logVLOADdiff*/

*Full Model;
PROC GLM DATA = Project1.Project1_Years0and2_2;
	CLASS Hard_Drugs_0 Race_NHW POTUSE DKgr13prWK CURSMOKE BaseINC GRthanHS ADH2gr95 / REF = FIRST;
	MODEL log10VLOADdiff = Hard_Drugs_0 log10VLOAD_0 Race_NHW POTUSE DKgr13prWK 
	CURSMOKE BaseINC GRthanHS ADH2gr95 AGE_0 BMI_0 / solution ; 
	QUIT;

/*Run regression  - LEU3ndiff */
PROC GLM DATA = Project1.Project1_Years0and2_2;
	CLASS Hard_Drugs_0 Race_NHW POTUSE DKgr13prWK CURSMOKE BaseINC GRthanHS ADH2gr95/ REF = FIRST ;
	MODEL LEU3Ndiff = Hard_Drugs_0 LEU3N_0 Race_NHW POTUSE DKgr13prWK 
	CURSMOKE BaseINC GRthanHS ADH2gr95 AGE_0 BMI_0 / solution;
	QUIT;
	
/* Run Regression - AGGMENTdiff */
PROC GLM DATA = Project1.Project1_Years0and2_2;
	CLASS Hard_Drugs_0 Race_NHW POTUSE DKgr13prWK CURSMOKE BaseINC GRthanHS ADH2gr95/ REF = FIRST ;
	MODEL AGG_MENTdiff = Hard_Drugs_0 AGG_MENT_0 Race_NHW POTUSE DKgr13prWK 
	CURSMOKE BaseINC GRthanHS ADH2gr95 AGE_0 BMI_0 / solution;
	QUIT;

/*Run Regression  - AGGPHYSdiff*/
PROC GLM DATA = Project1.Project1_Years0and2_2;
	CLASS Hard_Drugs_0 Race_NHW POTUSE DKgr13prWK CURSMOKE BaseINC GRthanHS ADH2gr95/ REF = FIRST ;
	MODEL AGG_PHYSdiff = Hard_Drugs_0 AGG_PHYS_0 Race_NHW POTUSE DKgr13prWK 
	CURSMOKE BaseINC GRthanHS ADH2gr95 AGE_0 BMI_0 / solution;
	QUIT;