/**********************************************************************
* PROJECT: South German Credit Risk Analysis
* AUTHOR: Nishant Pareek
* DATE: January 2026
* ALGORITHM: Binary Logistic Regression (Maximum Likelihood)
**********************************************************************/

/*1.Creating a Library*/ 
LIBNAME cr_risk 
"/export/viya/homes/2024btechaimlnishant17473@poornima.edu.in/german_bank"; 

/*2.Importing the data */ 
PROC IMPORT 
DATAFILE="/export/viya/homes/2024btechaimlnishant17473@poornima.edu.i
n/SouthGermanCredit.asc" 
 DBMS = DLM 
 OUT = cr_risk.german_credit 
 REPLACE; 
 DELIMITER = ' '; 
 GETNAMES = YES; 
RUN; 
 
/*3.Cleaning the data */ 
DATA cr_risk.renamed_credit; 
SET cr_risk.german_credit; 
 
/*Rename German variables to English Banking terms */ 
RENAME 
  laufkont = Checking_Status 
  laufzeit = Duration_Months 
  moral  = Credit_History 
  verw  = Purpose 
  hoehe  = Credit_Amount 
  sparkont = Savings_Amount 
  beszeit  = Employment_Duration 
  rate  = Installment_Rate 
  famges  = Personal_Status_Sex 
  buerge  = Other_Debtors 
  wohnzeit = Residence_Duration 
  verm  = Property 
  alter  = Age_Years 
  weitkred = Other_Installment_Plans 
  wohn  = Housing 
  bishkred = Number_Credits 
  beruf   = Job_Type 
  pers  = Liable_People 
  telef  = Telephone 
  gastarb  = Foreign_Worker 
  kredit  = Default_Risk; 
RUN; 
 
/*3. Sorting the Data */ 
PROC SORT DATA = cr_risk.renamed_credit; 
  BY Default_Risk; 
RUN; 
 
 
/*4.Creating sample */ 
PROC SURVEYSELECT DATA = cr_risk.renamed_credit  
  OUT = work.split_data 
  METHOD = SRS 
  RATE = 0.7 
  SEED = 12345 
  OUTALL; 
  STRATA Default_Risk; 
RUN; 
 
/*5. Splitting the Data */ 
DATA work.train_data work.test_data; 
 SET work.split_data; 
 IF Selected = 1 THEN OUTPUT work.train_data; 
 ELSE OUTPUT work.test_data; 
RUN; 
 
/*6. Data for Training */ 
PROC SURVEYSELECT DATA = work.train_data 
 OUT = work.train_balanced 
 METHOD = URS 
 OUTHITS 
 SEED = 12345 
 SAMPSIZE = 490; 
 STRATA Default_Risk; 
RUN; 
 
 
/*7. Model on Training Data with stepwise selection of variables */ 
PROC LOGISTIC DATA = work.train_balanced PLOTS(ONLY) = ROC; 
 CLASS Checking_Status Credit_History Purpose Savings_Amount 
  Housing Job_Type / PARAM = REF; 
 MODEL Default_Risk(EVENT = '0') =  
  Checking_Status Credit_History Duration_Months 
  Savings_Amount Age_Years Credit_Amount 
  Employment_Duration Installment_Rate 
  Personal_Status_Sex Other_Debtors 
  Residence_Duration Property 
  Other_Installment_Plans Housing 
  Number_Credits Job_Type 
  Liable_People Telephone Foreign_Worker 
 
  / SELECTION = STEPWISE 
  SLENTRY = 0.05 
  SLSTAY = 0.05; 
 TITLE "GERMAN CREDIT RISK ANALYSIS"; 
RUN; 
 
 
/*8. Scored the Data */ 
PROC LOGISTIC DATA = work.train_balanced; 
 CLASS Checking_Status Credit_History Purpose Savings_Amount 
   Housing Job_Type / PARAM = REF; 
 MODEL Default_Risk(EVENT = '0') =  
   Checking_Status Credit_History Duration_Months 
   Savings_Amount Age_Years Credit_Amount 
   Employment_Duration Installment_Rate 
   Personal_Status_Sex Other_Debtors 
   Residence_Duration Property 
   Other_Installment_Plans Housing 
   Number_Credits Job_Type 
   Liable_People Telephone Foreign_Worker 
   / SELECTION = STEPWISE 
   SLENTRY = 0.05 
   SLSTAY = 0.05; 
 SCORE DATA = work.test_data OUT = work.scored_test; 
RUN; 
 
/* 9. Running the Model on Test Data  */

PROC LOGISTIC DATA = work.scored_test PLOT(ONLY) = ROC; 
 MODEL Default_Risk(EVENT='0') = P_0; 
 TITLE "Final Result"; 
RUN; 
 
/*10. Generate the Classification Table to check Sensitivity */ 
PROC LOGISTIC DATA = work.scored_test; 
    MODEL Default_Risk(EVENT='0') = P_0  
          / CTABLE PPROB= 0.25;  
    TITLE "Test 1: Sensitivity Analysis (Did we catch the bad guys?)"; 
RUN;
