PROCEDURE MAIN
	LOCAL paramTableStruct
	? "HELLO WORLD"
	IF !File("param.dbf")
		paramTableStruct := {;
			{"PARAM_LAB", "C", 20, 0}, ;
			{"PARAM_VAL", "C", 10, 0}, ;
			{"PARAM_DEC", "C", 30, 0}, ;
			{"PARAM_TYP", "C", 1, 0}   ;
		}
		
		DbCreate( "param.dbf", paramTableStruct)
	ENDIF
	
	USE param ALIAS parameter NEW
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