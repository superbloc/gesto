PROCEDURE MAIN
	LOCAL oldArea
	LOCAL newArea
	USE RECETTEJOLD ALIAS recetteOld NEW 
	oldArea := Select()
	USE RECETTEJ ALIAS recette NEW
	newArea := Select()
	SELECT recetteOld
	DO WHILE .NOT. Eof()
		SELECT recette
		APPEND BLANK
		SELECT recetteOld
		REPLACE recette->DATE WITH recetteOld->DATE, ;
				recette->NUM_TABLE WITH recetteOld->NUM_TABLE, ;
				recette->NFACT WITH recetteOld->NFACT, ;
				recette->NB_CLIENT WITH recetteOld->NB_CLIENT, ;
				recette->TOTAL WITH recetteOld->TOTAL, ;
				recette->TVA WITH recetteOld->TVA, ;
				recette->SERVICE WITH recetteOld->SERVICE, ;
				recette->EMPORTE WITH recetteOld->EMPORTE, ;
				recette->CB WITH recetteOld->CB, ;
				recette->CHQ WITH recetteOld->CHQ, ;
				recette->ESP WITH recetteOld->ESP, ;
				recette->TR WITH recetteOld->TR, ;
				recette->STATUS WITH recetteOld->STATUS, ;
				recette->TIC_PRINT WITH 0
		SKIP
	ENDDO
	CLOSE recette
	CLOSE recetteOld
	? "old : " + Str(oldArea)
	? "new : " + Str(newArea)
	//
	//
RETURN