*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project3.sas                                                            *
*   PURPOSE:    Data Analysis of Project 3  - Creating Mixed Models and Structures      *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-11-15                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  Project3Data.csv                                                        *
*   MODIFIED:   DATE  2017-11-15                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;

/*Random Intercept*/ 
*LogMemI;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemI = age gender ses ageonset demind/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemII = age gender ses ageonset demind/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL animals = age gender ses ageonset demind/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL BlockR = age gender ses ageonset demind/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - BlockR on age';
	RUN; 
	
	
**********************************************************************************************************************;
	
/*Repeated Measures*/ 

*LogMemI;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemI = age gender ses ageonset demind/ solution;
	REPEATED / subject = id type = cs r rcorr; 
	title 'Mixed Model with CS error structure - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemII = age gender ses ageonset demind/ solution;
	REPEATED / subject = id type = cs r rcorr; 
	title 'Mixed Model with CS error structure - LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL animals = age gender ses ageonset demind/ solution;
	REPEATED / subject = id type = cs r rcorr;  
	title 'Mixed Model with CS error structure - Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL BlockR = age gender ses ageonset demind/ solution;
	REPEATED / subject = id type = cs r rcorr;  
	title 'Mixed Model with CS error structure - BlockR on age';
	RUN;

********************************************************************************************************************************;

 
/*Random Intercept and Random Slope*/ 
*LogMemI;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemI = age gender ses ageonset demind/ solution;
	RANDOM intercept age / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemII = age gender ses ageonset demind/ solution;
	RANDOM intercept age/ subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE- LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL animals = age gender ses ageonset demind/ solution;
	RANDOM intercept age / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL BlockR = age gender ses ageonset demind/ solution;
	RANDOM intercept age/ subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - BlockR on age';
	RUN; 
	
*******************************************************************************************************************************;

/*Random Intercept and Random Slope - UNSTRUCTURED VAR*/ 
*LogMemI;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemI = age gender ses ageonset demind/ solution;
	RANDOM intercept age / subject= id  type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL logmemII = age gender ses ageonset demind/ solution;
	RANDOM intercept age/ subject= id type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURES G MATRIX - LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL animals = age gender ses ageonset demind/ solution;
	RANDOM intercept age / subject= id type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX -  Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.memory2;
	CLASS ID gender demind;
	MODEL BlockR = age gender ses ageonset demind/ solution;
	RANDOM intercept age/ subject= id type = un  g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - BlockR on age';
	RUN; 
	

/*how to include a change point of 4 years???*/ 
	