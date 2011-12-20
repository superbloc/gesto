/************************************************/
/*                                              */
/*    Méthode d'intéraction avec la table       */
/*    paramètre 								*/
/*												*/
/************************************************/

#include "Inkey.ch"

GLOBAL vat1ChangeDate
GLOBAL vat1BeforeChangeDate
GLOBAL vat1AfterChangeDate
GLOBAL vat2Value

// A enlever pour intégration dans gesto
/*
PROCEDURE MAIN()
	SET DATE TO FRENCH
	SET FIXED on
	INIT_GLOBALVAR()
	? vatChangeDate
	? vatBeforeChangeDate
	? vatAfterChangeDate
RETURN
*/

// Procédure d'initialisation des variables globales.
PROCEDURE INIT_GLOBALVAR
	USE PARAM NEW ALIAS parameter
	INDEX ON parameter->PARAM_LAB TO PARAM_INDEX

	DbSeek("VAT1_CHG_DATE")
	IF Found()
		vat1ChangeDate := CtoD(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("VAT1_BF_CHG_DATE")
	IF Found()
		vat1BeforeChangeDate := Val(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("VAT1_AF_CHG_DATE")
	IF Found()
		vat1AfterChangeDate := Val(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("VAT2")
	IF Found()
		vat2Value := Val(parameter->PARAM_VAL)
	ENDIF

	CLOSE parameter
RETURN

PROCEDURE DISP_PARAMETERS
	FIELD PARAM_LAB, PARAM_VAL in parameter
	LOCAL time := Date()
	LOCAL row := 5
	LOCAL GetList := {}
	LOCAL variables
	LOCAL recordPtr := 1
	LOCAL elem
	LOCAL validateStatus := .F.
	
	CLS
	USE PARAM ALIAS parameter
	variables := Array(LastRec(), 2)
	DO WHILE .NOT. Eof()
		variables[recordPtr][1] = PARAM_LAB
		variables[recordPtr++][2] = PARAM_VAL
		SKIP
	ENDDO
	CLOSE parameter
	
	DO WHILE Lastkey() <> K_ESC	.AND. Lastkey() <> K_RETURN	
		FOR EACH elem IN variables
			@ row, 5 SAY elem[1] GET elem[2]
			row += 2
		NEXT
		@ row, 5 SAY "VALIDER" GET validateStatus PICTURE "Y"
		READ
	ENDDO
	
	IF validateStatus
		USE PARAM ALIAS parameter NEW
		FOR EACH elem IN variables
			LOCATE FOR parameter->PARAM_LAB = AllTrim(elem[1])
			DO WHILE Found()
				REPLACE parameter->PARAM_VAL WITH elem[2]
				CONTINUE
			ENDDO
		NEXT
		CLOSE parameter
	ENDIF
RETURN