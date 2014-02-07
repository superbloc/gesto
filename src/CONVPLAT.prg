PROCEDURE MAIN
	LOCAL categorie, index
	LOCAL plat := {}
	LOCAL plat_list := {}
	
	USE PLAT ALIAS plat
	DO WHILE .NOT. Eof()
		categorie := "P"
		IF plat->TVA == "B"
			categorie := "B"
		END
		AAdd(plat, plat->CODE)
		AAdd(plat, plat->NOM)
		AAdd(plat, plat->EPRIX)
		AAdd(plat, categorie)
		AAdd(plat_list, plat)
		plat := {}
		SKIP
	ENDDO
	CLOSE plat

	USE MENU ALIAS menu
	
	FOR index := 1 TO LEN(plat_list)
		APPEND BLANK
		plat := plat_list[index]
		replace menu->CODE_PLAT WITH plat[1], ;
				menu->LIBELLE WITH plat[2], ;
				menu->PRIX WITH plat[3], ;
				menu->CATEGORIE WITH plat[4], ;
				menu->STOCKAGE WITH 'N'
	NEXT
	CLOSE menu
RETURN