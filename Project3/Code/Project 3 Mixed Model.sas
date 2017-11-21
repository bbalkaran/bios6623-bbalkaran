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



**********************************************************************************************************************;
**************************************************************************************;

/*Random Intercept*/ 
*LogMemI;
PROC MIXED DATA = Project3.LogMemI;
	CLASS ID gender demind;
	MODEL logmemI = age_new gender ses demind age_new*demind changepoint/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.LogMemII;
	CLASS ID gender demind;
	MODEL logmemII = age_new gender ses demind age_new*demind changepoint/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.Animals;
	CLASS ID gender demind;
	MODEL animals = age_new gender ses demind  age_new*demind changepoint/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.BlockR;
	CLASS ID gender demind;
	MODEL BlockR = age_new gender ses demind  age_new*demind changepoint/ solution;
	RANDOM intercept / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT - BlockR on age';
	RUN; 
	
	

********************************************************************************************************************************;

 
/*Random Intercept and Random Slope*/ 
*LogMemI;
PROC MIXED DATA = Project3.LogMemI;
	CLASS ID gender demind;
	MODEL logmemI = age gender ses demind age*demind changepoint / solution;
	RANDOM intercept age changepoint / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - LogMemI on age';
	RUN; 

*LogMemII;	
PROC MIXED DATA = Project3.LogMemII;
	CLASS ID gender demind;
	MODEL logmemII = age gender ses  demind age*demind changepoint/ solution;
	RANDOM intercept age changepoint / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE- LogMemII on age';
	RUN; 

*Animals; 
PROC MIXED DATA = Project3.Animals;
	CLASS ID gender demind;
	MODEL animals = age gender ses  demind age*demind changepoint/ solution;
	RANDOM intercept age changepoint / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - Animals on age';
	RUN; 

*BlockR;
PROC MIXED DATA = Project3.BlockR;
	CLASS ID gender demind;
	MODEL BlockR = age gender ses demind age*demind changepoint/ solution;
	RANDOM intercept age changepoint / subject= id g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - BlockR on age';
	RUN; 
	
*******************************************************************************************************************************;

/*Random Intercept and Random Slope - UNSTRUCTURED VAR -> does not work for this project*/ 
/*Comparing UN and CS*/ 

*LogMemI;
PROC MIXED DATA = Project3.logmemI;                                            *Smaller AIC for un??? what did I do wrong?;
	CLASS ID gender demind / ref= first;
	MODEL logmemI = age_new gender ses demind age_new*demind changepoint/ solution;            * get different results when i change the reference????;
	RANDOM intercept age_new/ subject= id  type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - LogMemI on age';
	RUN; 





*LogMemII;	
PROC MIXED DATA = Project3.logmemII;
	CLASS ID gender demind/ ref = first;
	MODEL logmemII = age_new gender ses demind age_new*demind changepoint / solution;
	RANDOM intercept age_new/ subject= id type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - LogMemII on age';
	RUN; 





*Animals; 
PROC MIXED DATA = Project3.Animals;
	CLASS ID gender;
	MODEL animals = age_new gender ses demind age_new*demind changepoint / solution;
	RANDOM intercept age_new/ subject= id type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX -  Animals on age';
	RUN; 
PROC MIXED DATA = Project3.Animals;
	CLASS ID gender / ref = first;
	MODEL animals = age_new gender ses demind age_new*demind changepoint / solution;
	RANDOM intercept age_new/ subject= id type = un g gcorr v vcorr; 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX -  Animals on age';
	RUN; 





*BlockR;
PROC MIXED DATA = Project3.BlockR; 
	CLASS ID gender demind / ref = first;
	MODEL BlockR = age_new gender ses demind age_new*demind changepoint/ solution;
	RANDOM intercept age_new / subject= id type = un  g gcorr v vcorr;  /*take out random effect of changepoint*/ 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - BlockR on age';
	RUN; 

PROC MIXED DATA = Project3.BlockR; 
	CLASS ID gender demind;
	MODEL BlockR = age_new gender ses demind age_new*demind changepoint/ solution;
	RANDOM intercept age_new / subject= id type = un  g gcorr v vcorr;  /*take out random effect of changepoint*/ 
	title 'Mixed Model with RANDOM INTERCEPT AND SLOPE - UNSTRUCTURED G MATRIX - BlockR on age';
	RUN; 


	