*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project1.sas                                                            *
*   PURPOSE:    Data Analysis of Project 1                                              *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-09-15                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  hiv_6623_final.csv                                                                                *
*   MODIFIED:   DATE  2017-09-15      Read in Data                                      *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
/*Import Data*/
PROC IMPORT
		DATAFILE	= "/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_1/hiv_6623_final.csv"
		OUT			= Project1.hivdata
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
	ADHnum = INPUT (ADH, best.12);
		DROP ADH;	
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
	 VLOADnum= VLOAD
	 ADHnum=ADH; 
	RUN;
	
		

