/**********************************************************************
* PROJECT: South German Credit Risk Analysis
* AUTHOR: Nishant Pareek
* DATE: January 2026
* ALGORITHM: Binary Logistic Regression (Maximum Likelihood)
**********************************************************************/

/*1.Creating a Library*/
LIBNAME cr_risk "/export/viya/homes/2024btechaimlnishant17473@poornima.edu.in/german_bank";

/*2.Importing the data */
PROC IMPORT DATAFILE="/export/viya/homes/2024btechaimlnishant17473@poornima.edu.in/SouthGermanCredit.asc"
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
		moral	 = Credit_History
		verw	 = Purpose
		hoehe	 = Credit_Amount
		sparkont = Savings_Amount
		beszeit	 = Employment_Duration
		rate	 = Installment_Rate
		famges	 = Personal_Status_Sex
		buerge	 = Other_Debtors
		wohnzeit = Residence_Duration
		verm	 = Property
		alter	 = Age_Years
		weitkred = Other_Installment_Plans
		wohn	 = Housing
		bishkred = Number_Credits
		beruf 	 = Job_Type
		pers	 = Liable_People
		telef	 = Telephone
		gastarb	 = Foreign_Worker
		kredit	 = Default_Risk;
RUN;

/*3.Creating sample */
PROC SURVEYSELECT DATA = cr_risk.renamed_credit
		OUT = work.model_data
		METHOD = SRS
		RATE = 0.8
		SEED = 12345
		OUTALL;
RUN;

/*4.Building the Model */
PROC LOGISTIC DATA = work.model_data DESCENDING PLOTS = ROC;
		WHERE Selected = 1;

/*Categorical Variable */
	CLASS Checking_Status Credit_History Purpose Savings_Amount
		Housing Job_Type / PARAM = REF;
/*Equation*/
	MODEL Default_Risk = Duration_Months Credit_Amount Age_Years			Checking_Status Credit_History Savings_Amount;
RUN;
