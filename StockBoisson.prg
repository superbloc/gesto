/*
 *
 * Classe de comptabilisation du stock des boissons
 * envisager peut-être de l'étendre pour tous les plats.
 */
 
#include "hbclass.ch"

/*
 * Retourne une liste d'objet table.
 *
 */
FUNCTION GetStockBoissonHash(date)
	LOCAL elemHash := Hash()
	LOCAL key
	LOCAL stockBoisson
	HSetAACompatibility(elemHash, .T.)
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	
	USE StockTable ALIAS stock NEW
	INDEX ON (DtoC(stock->DATE) + stock->CODE_PLAT) TO STOCKINDEX
	
	USE ContentTable ALIAS content NEW
	SET RELATION TO content->CODE_PLAT INTO menu, TO (DtoC(content->DATE) + content->CODE_PLAT) INTO stock
	INDEX ON content->DATE TO content
	LOCATE FOR content->DATE == date .AND. menu->STOCKAGE == "O"
	DO WHILE Found()
		key := AllTrim(content->CODE_PLAT)
		IF HHasKey(elemHash, key)
			stockBoisson := HGet(elemHash, key)
			stockBoisson:mQuantite += content->QUANTITE
			//elemHash[key] += content->QUANTITE
		ELSE
			stockBoisson := StockBoisson():New()
			stockBoisson:mCodePlat := key
			stockBoisson:mLibelle := menu->LIBELLE
			stockBoisson:mQuantite := content->QUANTITE
			stockBoisson:mInitialQuantite := stock->QUANTITE
			stockBoisson:mCategorie := menu->CATEGORIE
			elemHash[key] := stockBoisson
			//elemHash[key] := content->QUANTITE
		ENDIF
		CONTINUE
	ENDDO
	CLOSE stock
	CLOSE content
	CLOSE menu
RETURN elemHash

FUNCTION GetEncaisseStockBoissonHash(date)
	LOCAL elemHash := Hash()
	LOCAL key
	LOCAL stockBoisson
	HSetAACompatibility(elemHash, .T.)
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	
	USE RECETTEJ ALIAS recette NEW
	INDEX ON recette->NFACT TO RECETTEINDEX
	USE ContentTable ALIAS content NEW
	
	SET RELATION TO content->CODE_PLAT INTO menu, TO content->NFACT INTO recette
	INDEX ON content->DATE TO content
	LOCATE FOR content->DATE == date .AND. menu->STOCKAGE == "O" .AND. recette->NFACT == content->NFACT
	DO WHILE Found()
		key := AllTrim(content->CODE_PLAT)
		IF HHasKey(elemHash, key)
			stockBoisson := HGet(elemHash, key)
			stockBoisson:mQuantite += content->QUANTITE
			//elemHash[key] += content->QUANTITE
		ELSE
			stockBoisson := StockBoisson():New()
			stockBoisson:mCodePlat := key
			stockBoisson:mLibelle := menu->LIBELLE
			stockBoisson:mQuantite := content->QUANTITE
			stockBoisson:mCategorie := menu->CATEGORIE
			elemHash[key] := stockBoisson
			//elemHash[key] := content->QUANTITE
		ENDIF
		CONTINUE
	ENDDO
	CLOSE recette
	CLOSE content
	CLOSE menu
RETURN elemHash

PROCEDURE InsertStockBoisson(stockBoisson, date)
	LOCAL stock
	USE StockTable ALIAS stock NEW
	INDEX ON (stock->DATE) TO stock_idx
	DELETE FOR stock->DATE == date
	PACK
	FOR EACH stock IN HGetValues(stockBoisson)
		APPEND BLANK
		REPLACE stock->DATE WITH date, ;
				stock->CODE_PLAT WITH stock:mCodePlat, ;
				stock->QUANTITE WITH stock:mQuantite
	NEXT
	CLOSE stock
RETURN

/**
 * Méthode de nettoyage du stock
 *
 */
 PROCEDURE CLEAN_STOCK(date)
	USE StockTable ALIAS stock NEW
		DELETE FOR stock->DATE == date
		PACK
	CLOSE stock
RETURN

CLASS StockBoisson
	HIDDEN:
		DATA _codePlat
		DATA _libelle
		DATA _quantite
		DATA _initialQuantite
		DATA _categorie

	EXPORTED:
		METHOD toString
		METHOD toPrintString
	
		ACCESS mCodePlat INLINE (::_codePlat)
		ACCESS mLibelle INLINE (::_libelle)
		ACCESS mQuantite INLINE (::_quantite)
		ACCESS mInitialQuantite INLINE (::_initialQuantite)
		ACCESS mCategorie INLINE (::_categorie)
		
		ASSIGN mCodePlat(x) INLINE (::_codePlat := x, ::_codePlat)
		ASSIGN mLibelle(x) INLINE (::_libelle := x, ::_libelle)
		ASSIGN mQuantite(x) INLINE (::_quantite := x, ::_quantite)
		ASSIGN mInitialQuantite(x) INLINE (::_initialQuantite := x, ::_initialQuantite)
		ASSIGN mCategorie(x) INLINE (::_categorie := x, ::_categorie)
ENDCLASS

METHOD toString CLASS StockBoisson
	LOCAL retVal := ""
	//retVal := retVal + ::_codePlat + " - " + ::_libelle + " - " + Str(::_quantite, ,0, .T.)
	retVal := Justify({::_codePlat, ::_libelle, ::_initialQuantite, ::_quantite}, "#", {2, 12, 45, 55}, {.T., .T., .T., .F.})
RETURN retVal

METHOD toPrintString CLASS StockBoisson
	LOCAL retVal := ""
	retVal := Justify({::_codePlat, SubStr(::_libelle, 0, 18), ::_initialQuantite, ::_quantite}, "#", {3, 10, 33, 39}, {.T., .T., .T., .F.})
RETURN retVal