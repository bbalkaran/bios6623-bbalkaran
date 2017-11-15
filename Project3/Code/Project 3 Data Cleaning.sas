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
*   MODIFIED:   DATE  2017-11-13                                                        *
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
	
	
PROC SORT DATA =Project3.memorydata;
by id age;
RUN;
	
/*avg age coming into study*/
DATA Project3.entryage;
	SET PROJECT3.MEMORYDATA;
	By id;
	FIRSTid = first.id;
	IF Firstid = 1;
	RUN; 
	
PROC MEANS DATA = Project3.EntryAge n nmiss mean std min max kurt skew;
VAR age;
where demind = 0; 
	RUN; 

/*Look at individuals by id*/
PROC MEANS DATA=Project3.memory2;
VARS SES Age BlockR Animals logmemI logmemII Ageonset demind;
*BY id; 
*OUTPUT OUT = project3.summarystats;
RUN; 

PROC FREQ data=Project3.Memory2;
TABLE Gender cdr blockR animals logmemI logmemII/ missing;
RUN;
DATA Work.Missing; 
	SET Project3.memory2;
	IF BlockR = . THEN BlockRmiss = 1; ELSE BlockRmiss = 0;
	IF Animals = . THEN AnimalsMiss = 1; ELSE AnimalsMiss = 0;
	IF logmemI = . THEN logmemImiss = 1; ELSE logmemImiss = 0;
	IF logmemII = . THEN logmemIImiss = 1; ELSE logmemIImiss = 0; 
	IF GENDER  = . then gendermiss = 1; else gendermiss = 0;
	RUN; 
PROC FREQ DATA = Work.Missing; 
	TABLES BlockRmiss AnimalsMiss logmemImiss logmemIImiss/ nocum;
	RUN; 


 
DATA Project3.AnalysisPop;
	SET Project3.Memorydata;
   count + 1;
  by id;
  if first.id then count = 1;
  RUN;
 
DATA Project3.AnalysisPop2;
	Set Project3.AnalysisPop;
	By id; 
	LastId = last.id;
	IF lastid = 1;   *216 ids;
	IF count > 2;     *205 < = 3; 
	RUN; 
DATA Project3.AnalysisPop3;
	SET Project3.analysispop2 (KEEP = id Lastid Count);
	RUN;

DATA Project3.Memory2;
	MERGE Project3.Memorydata Project3.analysisPop3;
	By id;
	if count = . THEN Delete;
	RUN;
	
Proc Print Data  = Project3.Memory2;	
Where count = .;
RUN; 

/*histograms and proc univariate*/

PROC UNIVARIATE DATA = Project3.Memory2;
Histogram _ALL_;
RUN;




/*Summary of Data by demind = 1*/
PROC MEANS DATA=Project3.memorydata n nmiss mean std min max  skew kurtosis;
VARS SES Age BlockR Animals logmemI logmemII Ageonset Cdr;
WHERE Demind = 1;
RUN; 

PROC FREQ DATA = Project3.Memory2;
Where demind = 1;
Tables Demind Gender ;
RUN;  

/*proc means by demind = 0*/
PROC MEANS DATA=Project3.Memory2  n nmiss mean std min max  skew kurtosis;
VARS SES Age BlockR Animals logmemI logmemII Ageonset cdr;
WHERE Demind = 0;
RUN; 

PROC FREQ DATA = Project3.Memory2;
Where demind = 0;
Tables Demind Gender  ;
RUN;

/*Examine Data*/ 	
PROC UNIVARIATE DATA = Project3.memorydata;
	QQPLOT;
	RUN; 


/*Look at longitudinal plots - original plots including all subjects*/ 	
PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= logmemI/  group = id;
	where demind =1;
	RUN; 
PROC SGplot DATA  = Project3.Memorydata;
	series x=age y= logmemI/  group = id;
	where demind =0;
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
	
	
/*longitudinal plots including only those in the analysis*/
PROC SGPANEL DATA  = Project3.Memory2;
	panelby demind;
	series x = age y=logmemI/ group = id;
	title  "Logical Memory I Story A Score by Age in those without and with MCI/Dementia";
	RUN; 

PROC SGPANEL DATA  = Project3.Memory2;
	panelby demind;
	series x = age y=logmemII/ group = id;
	title  "Logical Memory II Story A Score by Age in those without and with MCI/Dementia";
	RUN; 

PROC SGPANEL DATA  = Project3.Memory2;
	panelby demind;
	series x = age y=Animals/ group = id;
	title  "Category Fluency for Animals Score by Age in those without and with MCI/Dementia";
	RUN; 

PROC SGPANEL DATA  = Project3.Memory2;
	panelby demind;
	series x = age y=BlockR/ group = id;
	title  "Block Design Test Score by Age in those without and with MCI/Dementia";
	RUN; 
