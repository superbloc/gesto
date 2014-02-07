#include "FileIO.ch"

PROCEDURE MAIN
	LOCAL filename := HB_ArgV(1)
	LOCAL aText := FParse(filename, ';')
	LOCAL arec, adata
	
	USE menu ALIAS menu
	FOR EACH arec IN aText
		APPEND BLANK
		REPLACE menu->CODE_PLAT WITH arec[1], ;
				menu->LIBELLE WITH arec[2], ;
				menu->PRIX WITH Val(arec[3]), ;
				menu->CATEGORIE WITH arec[4], ;
				menu->STOCKAGE WITH arec[5]
		
	NEXT
	
	CLOSE menu
RETURN