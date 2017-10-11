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
*   MODIFIED:   DATE  2017-10-10                                                        *
*               ----------  --- ------------------------------------------------------- *
*                                                                                       *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;
DATA Project2.Raw;
	SET Project2.vadata2;
	RUN;

PROC UNIVARIATE DATA= Project2.Raw normaltest;
	qqplot;
	RUN;

	
	
