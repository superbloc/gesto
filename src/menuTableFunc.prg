/* Liste ici les méthodes ou fonctions relatives à la table Menu */

/* Fonction qui retourne le libellé d'un plat selon le code */
FUNCTION GET_LIBELLE(codePlat)
	LOCAL retValue := ""
	USE Menu ALIAS menu NEW
	INDEX ON Upper(menu->code_plat) TO Menu
	DbSeek(codePlat)
	IF Found()
		retValue := menu->libelle
	ENDIF
	CLOSE Menu
RETURN retValue

FUNCTION CHECK_CODE_PLAT(codePlat)
	LOCAL retValue
	USE Menu ALIAS menu NEW
	INDEX ON Upper(menu->code_plat) TO Menu
	DbSeek(codePlat)
	retValue := Found()
	CLOSE menu
RETURN retValue

/* Méthode qui insére un nouveau plat dans la table */
PROCEDURE INSERER_PLAT(codePlat, libelle, prix, categorie, stockage)
	USE Menu ALIAS menu NEW
	APPEND BLANK
	REPLACE menu->code_plat WITH codePlat, ;
		    menu->libelle WITH libelle, ;
			menu->prix WITH prix, ;
			menu->categorie WITH categorie, ;
			menu->stockage WITH stockage
			
	CLOSE menu
RETURN

PROCEDURE UPDATE_PLAT(codePlat, libelle, prix, categorie, stockage)
	USE Menu ALIAS menu NEW
	REPLACE menu->code_plat WITH codePlat, ;
		    menu->libelle WITH libelle, ;
			menu->prix WITH prix, ;
			menu->categorie WITH categorie, ;
			menu->stockage WITH stockage ;
			FOR menu->code_plat = codePlat
			
	CLOSE menu
RETURN

PROCEDURE DELETE_PLAT(codePlat)
	USE Menu ALIAS menu NEW
	DELETE FOR menu->code_plat = codePlat
	PACK
	CLOSE menu
RETURN

/* Fonction qui retourne une liste des plats */
FUNCTION GET_ALL_PLAT()
	LOCAL itr := 1
	LOCAL str
	LOCAL listePlat := {}
	USE Menu ALIAS menu NEW
	//INDEX ON Upper(menu->code_plat) TO Menu
	
	DO WHILE .NOT. Eof()
		str := PLAT_MAKE_RECORD(itr++, menu->code_plat, menu->libelle, menu->prix, menu->categorie, menu->stockage)
		AAdd(listePlat, Upper(str))
		SKIP
	ENDDO
	CLOSE menu
RETURN listePlat

FUNCTION RECHERCHE_PLAT_PAR_CODE(codePlat)
	LOCAL retVal := -1
	USE Menu ALIAS menu NEW
	INDEX ON Upper(menu->code_plat) TO Menu
	DbSeek(codePlat)
	IF Found()
		retVal := Recno()
	ELSE
		retVal := 0
	ENDIF
	CLOSE menu
RETURN retVal

FUNCTION PLAT_MAKE_RECORD(itr, codePlat, libelle, prix, categorie, stockage)
	LOCAL retVal := JustRight(PadL(AllTrim(str(itr)), 4)) + " " +;
	                JustLeft(codePlat) + " " +;
					JustLeft(libelle) + " " +;
					JustRight(str(prix)) + " "+;
					categorie + " " +;
					stockage
					
RETURN retVal

FUNCTION GET_CODE_PLAT_FROM_RECORD(record)
	LOCAL retVal := PadR(AllTrim(SubStr(record, 6, 4)), 4)
RETURN retVal

FUNCTION GET_INFO_FROM_RECORD(record)
	LOCAL aaList := {}
	AAdd(aaList, PadR(AllTrim(SubStr(record, 6, 4)), 4))  // code plat
	AAdd(aaList, SubStr(record, 11, 32)) // libelle
	AAdd(aaList, Val(SubStr(record, 44, 10))) // prix
	AAdd(aaList, SubStr(record, 55, 1)) // categorie
	AAdd(aaList, SubStr(record, 57, 1)) // stockage
RETURN aaList