*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    Project3.sas                                                            *
*   PURPOSE:    Data Analysis of Project 3  - Data Cleaning                             *
*   AUTHOR:     Bridget Balkaran                                                        *
*   CREATED:    2017-11-06                                                              *
*                                                                                       *
*   COURSE:     BIOS 6623 - Advanced Data Analysis                                      *
*   DATA USED:  Project3Data.csv                                                        *
*   MODIFIED:   DATE  2017-11-06                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;

PROC IMPORT
		DATAFILE	= "/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project _3/Project3Data.csv"
		OUT			= Project3.MemoryData
		DBMS		= CSV
		REPLACE		;
	RUN;
	
PROC MEANS DATA=Project3.memorydata;
VARS SES Age BlockR Animals 
/*Examine Data*/ 	
PROC UNIVARIATE DATA = Project3.memorydata;
	QQPLOT;
	FREQ Gender;
	RUN; 


/*Look at longitudinal plots*/ 	
PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= logmemI/  group = id;
	RUN; 
	
PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= logmemII/  group = id;
	RUN; 

PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= animals/  group = id;
	RUN; 
	
PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= BlockR/  group = id;
	RUN; 

PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= ageonset/  group = id;
	RUN; 