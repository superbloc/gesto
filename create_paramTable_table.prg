/*********************************************************/
/*                                                       */
/*  Source gérant la création de la table des paramétres */
/*                                                       */  
/*********************************************************/

// La liste des valeurs à stocker sont :
// la date charnière de changement de TVA : VAT_CHG_DATE
// la valeur de la tva avant la date : VAT_ 
// la valeur de la tva après la date


PROCEDURE MAIN()
	CREATE_PARAM_TABLE()
	POPULATE_PARAM_TABLE()
RETURN

PROCEDURE CREATE_PARAM_TABLE
	CREATE TempParam
	APPEND BLANK
			
	REPLACE FIELD_NAME WITH "PARAM_LAB", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 20, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK

	REPLACE FIELD_NAME WITH "PARAM_VAL", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 10, ;
			FIELD_DEC WITH 0			
	CLOSE TempParam
	CREATE PARAM FROM TempParam
	CLOSE PARAM
RETURN

PROCEDURE POPULATE_PARAM_TABLE
	USE PARAM ALIAS parameter NEW
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT_CHG_DATE", ;
			parameter->PARAM_VAL WITH "01/01/2012"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT_BF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "5.5"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT_AF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "7"
	CLOSE parameter
RETURN