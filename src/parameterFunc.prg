/************************************************/
/*                                              */
/*    Méthode d'intéraction avec la table       */
/*    paramètre 								*/
/*												*/
/************************************************/

#include "Inkey.ch"
#include "Box.ch"

GLOBAL vat1ChangeDate
GLOBAL vat1BeforeChangeDate
GLOBAL vat1AfterChangeDate
GLOBAL vat2ChangeDate
GLOBAL vat2BeforeChangeDate
GLOBAL vat2AfterChangeDate
GLOBAL defautRemise

GLOBAL EXTERN nRow
GLOBAL EXTERN nCol

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
	
	DbSeek("VAT2_CHG_DATE")
	IF Found()
		vat2ChangeDate := CtoD(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("VAT2_BF_CHG_DATE")
	IF Found()
		vat2BeforeChangeDate := Val(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("VAT2_AF_CHG_DATE")
	IF Found()
		vat2AfterChangeDate := Val(parameter->PARAM_VAL)
	ENDIF
	
	DbSeek("EMPORTE_REMISE")
	IF Found()
		defautRemise := Val(parameter->PARAM_VAL)
	ENDIF
	
	/*
	DbSeek("VAT2")
	IF Found()
		vat2Value := Val(parameter->PARAM_VAL)
	ENDIF
	*/
	
	CLOSE parameter
RETURN

// Affichage de la fenêtre de modification des paramétres
PROCEDURE DISP_PARAMETERS
	FIELD PARAM_LAB, PARAM_VAL, PARAM_DEC, PARAM_TYP in parameter
	LOCAL time := Date()
	LOCAL row := 5
	LOCAL GetList := {}
	LOCAL variables
	LOCAL recordPtr := 1
	LOCAL elem
	LOCAL validateStatus := .F.
	
	SetColor("W+/B+")
	CLS
	DispBox(0, 0, nRow - 1, nCol - 1, B_SINGLE, "BG+/B+")
	@ 0, 30 SAY "PARAMETRAGE" PICTURE "@!"
	SET CENTURY ON
	USE PARAM ALIAS parameter
	variables := Array(LastRec(), 2)
	DO WHILE .NOT. Eof()
		variables[recordPtr][1] = PARAM_DEC
		SWITCH PARAM_TYP
			CASE "D"
				variables[recordPtr++][2] = CtoD(PARAM_VAL)
				EXIT
			CASE "N"
				variables[recordPtr++][2] = Val(PARAM_VAL)
				EXIT
			DEFAULT
				variables[recordPtr++][2] = PARAM_VAL
				EXIT
		END
		SKIP
	ENDDO
	CLOSE parameter
	
	FOR EACH elem IN variables
		IF AllTrim(elem[1]) == "VAT1_CHG_DATE"
			@ row, 5 SAY elem[1] GET elem[2] PICTURE "99/99/9999" COLOR "RB/W+"
		ELSE
			@ row, 5 SAY elem[1] GET elem[2] PICTURE "99.99" COLOR "RB/W+"
		ENDIF
		row += 2
	NEXT
		@ row, 5 SAY "VALIDER" GET validateStatus PICTURE "Y"
	READ
	IF LastKey() == K_ESC
		RETURN
	ENDIF
	
	IF validateStatus
		USE PARAM ALIAS parameter NEW
		FOR EACH elem IN variables
			LOCATE FOR parameter->PARAM_DEC = AllTrim(elem[1])
			DO WHILE Found()
				SWITCH parameter->PARAM_TYP
					CASE "D"
						REPLACE parameter->PARAM_VAL WITH DtoC(elem[2])
						EXIT
					CASE "N"
						REPLACE parameter->PARAM_VAL WITH str(elem[2])
						EXIT
					DEFAULT
						REPLACE parameter->PARAM_VAL WITH elem[2]
						EXIT
				END
				CONTINUE
			ENDDO
		NEXT
		CLOSE parameter
		// On réinitialise la liste des paramétres globaux
		INIT_GLOBALVAR()
	ENDIF
RETURN