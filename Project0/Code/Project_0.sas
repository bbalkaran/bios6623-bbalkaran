**********************************************************************
* Program Name: BIOS6623Project0DataClean.SAS                        *
* Purpose: To read in the dataset and label the variables;           * 
*			Create any new variables.                      			 *
* Created by: Bridget Balkaran									     *
*********************************************************************;

*No Interim Presentation
Written Report Due and Final Presentation: September 13

 

Dental researchers were interested in a new gel treatment for gum disease.  
In their study, subjects were randomly assigned to one of 5 treatments: no treatment and four levels 
of an active substance in a gel. The lowest level was a placebo (=1) and then another control group (=2),
 like the "no treatment" group. The remaining three levels were low(=3), medium(=4), and 
 high(=5) concentrations of the active ingredient in the gel.  The patients were recruited via a single
 midwestern dental research clinic.  There were 130 participants.  Participants were asked to rub the 
 gel on their gums twice daily.  The measurements being followed over time were whole-mouth average 
 pocket depth and whole mouth average attachment loss. Visits were at baseline and 1 year. Pocket depth 
 and attachment loss were measured at many sites within each participant's mouth and then averaged 
 (at each visit).  The variable called “sites” gives the number of sites used in the averages.  Pocket 
 depth and attachment loss are both measures of how far the gums have pulled away from the teeth, hence 
 smaller values are better.  Whole-mouth average is used because the measurements within mouth are highly
 correlated in a complicated way, which is not yet fully understood by dental researchers.

Additional demographic information was collected on 
race(5=white,4=Asian,2=African American,1=Native American), 
gender(1=male,2=female), age, and smoking status (yes=1/no=0).  
Site is the number of sites measured to get the average outcome measurement.  
Missing values are denoted by an “NA”. 

 

The primary question of interest is whether treatment results in lower average pocket depth and 
attachment loss at one year.;


***READ IN THE RAW DATA AND CREATE VARIABLE TRANSFORMS****;
***Note: This is the place where I would come back to ****;
***      for any data cleaning, outlier removal more  ****;
***      transforms.  This keeps all data cleaning    ****;
***		 and variable decisions in one place.		  ****;
***
***;
**********************************************************;
*Import data*;
PROC IMPORT DATAFILE ='/home/bridgetbalkaran0/my_courses/BIOS_6623 Advanced Data Analysis/Project_0/Project0_dental_data.csv' 
	OUT = Project0Raw; 
	DBMS=CSV;
	REPLACE;
	RUN;
	
*Print data set for viewing*;
*PROC PRINT DATA = Project0Raw;      
	*TITLE 'Project 0 Dental Data Raw';
	*RUN;

*look at metadata*;
*PROC CONTENTS DATA=Project0Raw;
*	RUN;
	*attach1year and pd1year are imported as characters. Need to change to numeric.;

*Change NAs to " ", then print to view*;
DATA Project0Clean;
	SET Project0Raw ;
	If attach1year='NA' Then attach1year=''; 
	If pd1year='NA' Then pd1year='';
	RUN;

*Confirm NAs removed;
*PROC PRINT DATA=Project0Clean;
*	RUN;

*Data types still need to be changed from character to numeric; 
*PROC CONTENTS DATA=Project0Clean;
	*RUN;

*Frequency Tables*;
*PROC FREQ DATA=work.project0Clean;
	*TABLES TRTGROUP SEX RACE AGE SMOKER SITES ATTACHBASE ATTACH1YEAR PDBASE PD1YEAR /NOCUM;
	*RUN;

*Changed data types all to numeric. Created difference variables;
DATA Project0Clean1;
	SET Project0Clean;
	attach1yearNum = INPUT (attach1year, best12.);
	DROP attach1year;
	pd1yearNum = INPUT (pd1year, best12.);
	DROP pd1year;
	attachdiff = attach1yearNum - attachbase;
	pddiff = pd1yearNum - pdbase;
	RUN;
*PROC PRINT DATA=Project0Clean1;
*	Title "Project 0 Dental Data Cleaned";
*	RUN;
*PROC CONTENTS DATA=Project0Clean1;
*	RUN;

*Data cleaned. Dummy code variables;
DATA Project0Clean2;
	SET Project0Clean1;
	IF trtgroup=2 THEN trtgroup=0;
	IF trtgroup=1 THEN trtgroup=1;
	If trtgroup=3 THEN trtgroup=2;
	IF trtgroup=4 THEN trtgroup=3;
	IF trtgroup=5 THEN trtgroup=4;
	If sex=1 THEN sex=0;
	IF sex=2 THEN sex=1;
	IF race=1 THEN race=0;
	IF race=2 THEN race=1;
	IF race=4 THEN race=2;
	IF race=5 THEN race=3;
	IF trtgroup=0 THEN notreatment=1; Else notreatment=0;
	IF trtgroup=1 THEN placeboBlankGel=1; Else placeboBlankGel=0;
	IF trtgroup=2 THEN low=1; Else low=0;
	IF trtgroup=3 THEN medium=1; ELse medium=0;
	IF trtgroup=4 THEN high=1; ELSE high=0;
	If sex=0 Then male =1; Else male=0;
	IF sex=1 THEN female=1; ELSE female=0;
	IF race=0 THEN NativeAmerican =1; ELSE NativeAmerican=0;
	If race=1 THEN AfricanAmerican=1; ELse AfricanAmerican=0;
	If race=2 THEN Asian=1; ELSE Asian=0;
	IF race=3 THEN white=1; ELSE white=0;
	Run;
	
PROC PRINT DATA=Project0Clean2;
Run;

PROC FREQ Data=Project0Clean2;
TABLES trtgroup sex race smoker /nocum;
	RUN;

*Summary Statistics*;
PROC MEANS DATA=Project0Clean2 N MEAN VAR STD NMISS MIN MAX;
	VAR  attachbase attachdiff pdbase pddiff age;
	RUN;	
PROC REG DATA=Project0Clean2;
	model attachdiff = trtgroup;
	title "Model of Attachment Difference and Treatment Group";
	RUN;title;
PROC REG DATA=Project0Clean2;
	model pddiff = trtgroup;
	title "Model of Pocket Depth Difference and Treatment Group";
	RUN;title;

*Boxplots - attachdiff;
/*--Set output size--*/
ods graphics / reset imagemap;

/*--SGPLOT proc statement--*/
proc sgplot data=WORK.PROJECT0CLEAN2;
	/*--TITLE and FOOTNOTE--*/
	title "Attachment Loss Differences by Treatment Group";

	/*--Box Plot settings--*/
	vbox attachdiff / category=trtgroup fillattrs=(color=CX5dadd3) boxwidth=0.7 
		name='Box';

	/*--Category Axis--*/
	xaxis fitpolicy=splitrotate label="Treatment Group";

	/*--Response Axis--*/
	yaxis label="Attachment Loss Difference" grid;
run;


ods graphics / reset;
title;

*Boxplot - pddiff;
/*--Set output size--*/
ods graphics / reset imagemap;

/*--SGPLOT proc statement--*/
proc sgplot data=WORK.PROJECT0CLEAN2;
	/*--TITLE and FOOTNOTE--*/
	title "Pocket Depth Differences by Treatment Group";

	/*--Box Plot settings--*/
	vbox pddiff / category=trtgroup fillattrs=(color=CX905dd3) boxwidth=0.7 
		name='Box';

	/*--Category Axis--*/
	xaxis fitpolicy=splitrotate label="Treatment Group";

	/*--Response Axis--*/
	yaxis label="Pocket Depth Difference" grid;
run;

ods graphics / reset;
title;



*Variables dummy coded. Run regression; 
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base";
	RUN;
	*Include attachbase in model. Increases significance, adjR^2, decreaeses MSE;
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base";
	RUN;
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high; 
	Title"Model of Difference in Pocket Depth from Year 1 Follow Up and Base";
	RUN;	
	*Include pdbase in base model. Makes overall model significant.; 
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase; 
	Title"Model of Difference in Pocket Depth from Year 1 Follow Up and Base";
	RUN;
	
PROC CORR DATA=WORK.PROJECT0CLEAN2 pearson nosimple plots=none;
	var trtgroup sex race age smoker sites attachbase pdbase attach1yearNum 
		pd1yearNum attachdiff pddiff notreatment placeboBlankGel low medium high male 
		female NativeAmerican AfricanAmerican Asian white;
	RUN;
	
	
	
	
	
*Full models*;
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase sex age race smoker; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Full Model";
	RUN;
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase sex age race smoker; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Full Model";
	RUN;
	
	
	
	
		
*model selection using partial F tests for Attachdiff*;
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase sex age race smoker; *Ho:B_sex=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestSex: TEST sex=0; *p=0.4896 cannot reject Ho:B_sex=0, drop sex from model;
		RUN;	

PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase age race smoker; *Ho:B_age=0; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestAge: TEST age=0; *p=0.2632 cannot reject Ho:B_age=0 drop age from model;
	RUN;

PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase race smoker;run; *Ho:B_race=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestRace: TEST race=0; *p=0.3402 cannot reject Ho:B_race=0 drop race from model;
	RUN;

PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase smoker;*Ho:B_smoker=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
	TestSmoker: TEST smoker=0; *p=0.0525, overall F test more significant but Partial F marginally significant. MSE increases, SE increases, adj R^2 decreases when dropping smoker;
		*leave smoker in model as precision variable;
	RUN; 
	
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
	RUN;








*model selection using partial F tests for pddiff;
PROC REG DATA= Project0Clean2;
	MODEL pddiff= placeboBlankGel low medium high pdbase sex age race smoker; *Ho:B_smoker=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestSmoker: TEST smoker=0; *p=0.8118 cannot reject Ho:B_smoker=0, drop smoker from model;
		RUN;	

PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase sex age race; *Ho:B_race=0; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestRace: TEST race=0; *p=0.3202 cannot reject Ho:B_race=0 drop race from model;
	RUN;
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase sex age; *Ho:B_age=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestAge: TEST age=0; *p=0.2900 cannot reject Ho:B_age=0 drop age from model;
	RUN;	
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase sex; *Ho:B_sex=0;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
		TestSex: TEST sex=0; *p=0.1111 reject Ho:B_sex=0  drop sex from model;
	RUN;

PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase; 
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base with Covariates - Partial F test";
	RUN;



***FINAL MODEL ATTACHFDIFF***;
PROC REG DATA= Project0Clean2;
	MODEL attachdiff = placeboBlankGel low medium high attachbase smoker / clb;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base";
	RUN;
	

	
***FINAL MODEL PDDIFF***;
PROC REG DATA= Project0Clean2;
	MODEL pddiff = placeboBlankGel low medium high pdbase/clb;
	Title"Model of Difference in Attachment from Year 1 Follow Up and Base";
	RUN;

*Look at differences between low and med;
*PROC REG DATA=Project0Clean2;
*model attachdiff = placeboBlankGel low medium high attachbase;
*TEST low = medium;
*Run;


Title;
ods noproctitle;
ods graphics / imagemap=on;

proc glm data=WORK.PROJECT0CLEAN2;
	class trtgroup;
	model attachdiff=trtgroup/ clm;
	means trtgroup / hovtest=levene welch plots=none;
	lsmeans trtgroup / adjust=tukey pdiff alpha=.05;
	run;
quit;