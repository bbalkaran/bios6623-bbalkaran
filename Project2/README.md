Welcome to my BIOS 6623 Project 2 README. The project instructions are listed below. Here is how to navigate this repository:

In the code folder:

1. Run Project2.sas. This file contains code for reading in the data and data cleaning. Additional comments are listed throughout the code. 

2. Run Missing Data Analysis.sas. This file analyzes the missing data for the albumin variable among the rest of the variables. From this information we can deduce if missing data will bias the resulst.

3. Run project2_regression.sas. THis is the code for logistic regression, generated adjusted death rates, and generating observed death rates. 

The docs folder contains saved output or notes that I have written for myself. THese notes are not intended to guide the analysis and are just reminders for myself. They may help guide you in my thinking or you can ignore them.

The reports folder contains final reports for this project. 

Bios 6623: Project 2
Fall 2017
Interim presentation: Wednesday, October 18
Written report due: Wednesday, November 1
Final presentation: Wednesday, November 1

The data for this project are simulated to represent data from a VA surgery database.Every six months the VA reviews data from its hospitals to identify whether certain VA hospitals have unusually high (or low) death rates among patients undergoing heart surgery. If a hospital has a higher death rate than expected, we typically perform a site visit to identify and rectify potential problems. If a hospital has a much lower death ratethan expected, we like to visit to see if there is anything we can learn to improve
outcomes at the other hospitals. As the characteristics of the population of patientsserved differs from hospital to hospital, the expected death rate at each hospital also differs and is hospital specific.

In order to identify hospitals that may need a site visit, I would like you to tell me the observed death rate from surgery at each hospital for the most recent 6 month period. However, I am also providing you 3 years of past data to help you develop hospital adjusted estimates of expected risk (e.g., expected death rates for the patient population observed in each hospital).
Group 2 has the added project requirement that I need some measure of variation around the expected risk of death at each hospital, so that you can tell me whether the observed rates are statistically higher than the expected rate for that hospital.

The data: 

Every six months at the VA, a new set of data with all heart surgeries duringthat six month period is generated. Periods are numbered starting back in the 1980’s with period 1. We have about 48 hours to produce summary reports for quality monitoring at each hospital (e.g. deaths, expected deaths, trends, tables, graphs, etc).
Most of these reports are produced using the past three years of data, including the most recent six month period. In this dataset, the most recent 6 month period is #39.

The data consist of :
1) HOSPCODE: hospital number
2) SIXMONTH: six month period
3) DEATH30: 30 day mortality
4) HEIGHT: height (inches)
5) WEIGHT: weight (lbs.)
6) BMI: body mass index (kg/cm ^2)
7) PROCED: procedure (0 = valve surgery, 1 = CABG surgery (other heart
surgeries are excluded from this dataset))
8) ASA – code for patient’s condition at start of surgery, 1 = good health, 5 = near death
9) ALBUMIN: The normal range is 3.4 - 5.4 grams per deciliter (g/dL).