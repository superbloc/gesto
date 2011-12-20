/*********************************************************/
/*                                                       */
/*  Source g�rant la cr�ation de la table des param�tres */
/*                                                       */  
/*********************************************************/

// La liste des valeurs � stocker sont :
// la date charni�re de changement de TVA : VAT_CHG_DATE
// la valeur de la tva avant la date : VAT_ 
// la valeur de la tva apr�s la date


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

	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "PARAM_DEC", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 30, ;
			FIELD_DEC WITH 0
			
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "PARAM_TYP", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 1, ;
			FIELD_DEC WITH 0
	CLOSE TempParam
	CREATE PARAM FROM TempParam
	CLOSE PARAM
RETURN

PROCEDURE POPULATE_PARAM_TABLE
	USE PARAM ALIAS parameter NEW
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_CHG_DATE", ;
			parameter->PARAM_VAL WITH "01/01/2012", ;
			parameter->PARAM_DEC WITH "Date de bascule TVA1", ;
			parameter->PARAM_TYP WITH "D"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_BF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "5.5", ;
			parameter->PARAM_DEC WITH "TVA1 avant la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_AF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "7", ;
			parameter->PARAM_DEC WITH "TVA1 apres la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT2", ;
			parameter->PARAM_VAL WITH "19.6", ;
			parameter->PARAM_DEC WITH "TVA2", ;
			parameter->PARAM_TYP WITH "N"
	CLOSE parameter
RETURN