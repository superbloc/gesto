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
 /*
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
	LOCATE FOR content->DATE == date .AND. menu->STOCKAGE == "O" .AND. stock->ARCHIVED == .F.
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
*/

FUNCTION GetStockBoissonHash(date)
	LOCAL mergeHash := Hash()
	LOCAL key
	LOCAL stockBoisson
	HSetAACompatibility(mergeHash, .T.)
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	
	USE ContentTable ALIAS content NEW
	SET RELATION TO content->CODE_PLAT INTO menu
	INDEX ON content->DATE TO content
	LOCATE FOR content->DATE == date .AND. menu->STOCKAGE == "O"
	DO WHILE Found()
		key := AllTrim(content->CODE_PLAT)
		IF HHasKey(mergeHash, key)
			stockBoisson := HGet(mergeHash, key)
			stockBoisson:mQuantite += content->QUANTITE
		ELSE
			stockBoisson := StockBoisson():New()
			stockBoisson:mCodePlat := key
			stockBoisson:mLibelle := menu->LIBELLE
			stockBoisson:mQuantite := content->QUANTITE
			stockBoisson:mInitialQuantite := 0
			stockBoisson:mTotalQuantite := 0
			stockBoisson:mCategorie := menu->CATEGORIE
			mergeHash[key] := stockBoisson
			//elemHash[key] := content->QUANTITE
		ENDIF
		CONTINUE
	ENDDO
	CLOSE content
	CLOSE menu
	
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	
	USE StockTable ALIAS stock NEW
	SET RELATION TO stock->CODE_PLAT INTO menu
	INDEX ON stock->DATE TO STOCKINDEX
	LOCATE FOR stock->DATE == date .OR. stock->ARCHIVED == .T.
	DO WHILE Found()
		key := AllTrim(stock->CODE_PLAT)
		IF stock->ARCHIVED
			// on est dans le cas d'une quantité totale
			IF HHasKey(mergeHash, key)
				stockBoisson := HGet(mergeHash, key)
				stockBoisson:mTotalQuantite += stock->QUANTITE
			ELSE
				stockBoisson := StockBoisson():New()
				stockBoisson:mCodePlat := key
				stockBoisson:mLibelle := menu->LIBELLE
				stockBoisson:mQuantite := 0
				stockBoisson:mInitialQuantite := 0
				stockBoisson:mTotalQuantite := stock->QUANTITE
				stockBoisson:mCategorie := menu->CATEGORIE
				mergeHash[key] := stockBoisson
			ENDIF
		ELSE
			IF HHasKey(mergeHash, key)
				stockBoisson := HGet(mergeHash, key)
				stockBoisson:mInitialQuantite += stock->QUANTITE
			ELSE
				stockBoisson := StockBoisson():New()
				stockBoisson:mCodePlat := key
				stockBoisson:mLibelle := menu->LIBELLE
				stockBoisson:mQuantite := 0
				stockBoisson:mTotalQuantite := 0
				stockBoisson:mInitialQuantite := stock->QUANTITE
				stockBoisson:mCategorie := menu->CATEGORIE
				mergeHash[key] := stockBoisson
			ENDIF		
		
		ENDIF
		CONTINUE
	ENDDO
	CLOSE stock
	CLOSE menu
RETURN mergeHash

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

FUNCTION GetStockHashByYear(year)
	LOCAL elemHash := Hash()
	LOCAL stockBoisson
	LOCAL key
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	USE StockTable ALIAS stock NEW
	//INDEX ON (Year(stock->DATE) + stock->CODE_PLAT) TO STOCKINDEX
	
	SET RELATION TO stock->CODE_PLAT INTO menu
	LOCATE FOR Year(stock->date) == year
	DO WHILE Found()
		key := AllTrim(stock->CODE_PLAT)
		IF HHasKey(elemHash, key)
			stockBoisson := HGet(elemHash, key)
			stockBoisson:mQuantite += stock->QUANTITE
		ELSE
			stockBoisson := StockBoisson():New()
			stockBoisson:mCodePlat := key
			stockBoisson:mLibelle := menu->LIBELLE
			stockBoisson:mQuantite := stock->QUANTITE
			stockBoisson:mCategorie := menu->CATEGORIE
			elemHash[key] := stockBoisson
		ENDIF
		CONTINUE
	ENDDO
	CLOSE stock
	CLOSE menu
return elemHash

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
		DELETE FOR stock->DATE == date .AND. .NOT. stock->ARCHIVED
		PACK
	CLOSE stock
RETURN

PROCEDURE ARCHIVE_STOCK(date)
	LOCAL mergeHash := Hash()
	LOCAL key
	LOCAL stockBoisson
	CLEAN_STOCK(date)
	HSetAACompatibility(mergeHash, .T.)
	USE Menu ALIAS menu NEW
	INDEX ON menu->CODE_PLAT TO MENUINDEX
	
	USE ContentTable ALIAS content NEW
	SET RELATION TO content->CODE_PLAT INTO menu
	INDEX ON content->DATE TO content
	LOCATE FOR content->DATE == date .AND. menu->STOCKAGE == "O"
	DO WHILE Found()
		key := AllTrim(content->CODE_PLAT)
		IF HHasKey(mergeHash, key)
			stockBoisson := HGet(mergeHash, key)
			stockBoisson:mQuantite += content->QUANTITE
		ELSE
			stockBoisson := StockBoisson():New()
			stockBoisson:mCodePlat := key
			stockBoisson:mLibelle := menu->LIBELLE
			stockBoisson:mQuantite := content->QUANTITE
			stockBoisson:mInitialQuantite := 0
			stockBoisson:mTotalQuantite := 0
			stockBoisson:mCategorie := menu->CATEGORIE
			stockBoisson:mArchived := .T.
			mergeHash[key] := stockBoisson
			//elemHash[key] := content->QUANTITE
		ENDIF
		CONTINUE
	ENDDO
	CLOSE content
	CLOSE menu
	
	USE StockTable ALIAS stock NEW
	FOR EACH stockBoisson IN HGetValues(mergeHash)
		APPEND BLANK
		REPLACE stock->DATE WITH date, ;
				stock->CODE_PLAT WITH stockBoisson:mCodePlat, ;
				stock->QUANTITE WITH stockBoisson:mQuantite, ;
				stock->ARCHIVED WITH stockBoisson:mArchived
				
	NEXT
	CLOSE stock
	
RETURN

CLASS StockBoisson
	HIDDEN:
		DATA _codePlat
		DATA _libelle
		DATA _quantite
		DATA _initialQuantite
		DATA _totalQuantite
		DATA _categorie
		DATA _archived

	EXPORTED:
		METHOD toString
		METHOD toStringTotal
		METHOD toPrintString
	
		ACCESS mCodePlat INLINE (::_codePlat)
		ACCESS mLibelle INLINE (::_libelle)
		ACCESS mQuantite INLINE (::_quantite)
		ACCESS mInitialQuantite INLINE (::_initialQuantite)
		ACCESS mTotalQuantite INLINE (::_totalQuantite)
		ACCESS mCategorie INLINE (::_categorie)
		ACCESS mArchived INLINE (::_archived)
		
		ASSIGN mCodePlat(x) INLINE (::_codePlat := x, ::_codePlat)
		ASSIGN mLibelle(x) INLINE (::_libelle := x, ::_libelle)
		ASSIGN mQuantite(x) INLINE (::_quantite := x, ::_quantite)
		ASSIGN mInitialQuantite(x) INLINE (::_initialQuantite := x, ::_initialQuantite)
		ASSIGN mTotalQuantite(x) INLINE (::_totalQuantite := x, ::_totalQuantite)
		ASSIGN mCategorie(x) INLINE (::_categorie := x, ::_categorie)
		ASSIGN mArchived(x) INLINE (::_archived := x, ::_archived)
ENDCLASS

METHOD toString CLASS StockBoisson
	LOCAL retVal := ""
	//retVal := retVal + ::_codePlat + " - " + ::_libelle + " - " + Str(::_quantite, ,0, .T.)
	retVal := Justify({::_codePlat, ::_libelle, ::_totalQuantite, ::_initialQuantite, ::_quantite}, "#", {2, 12, 40, 50, 60}, {.T., .T., .T., .T., .F.})
RETURN retVal

METHOD toStringTotal CLASS StockBoisson
	LOCAL retVal := ""
	//retVal := retVal + ::_codePlat + " - " + ::_libelle + " - " + Str(::_quantite, ,0, .T.)
	retVal := Justify({::_codePlat, ::_libelle, ::_quantite}, "#", {2, 12, 45}, {.T., .T., .F.})

RETURN retVal

METHOD toPrintString CLASS StockBoisson
	LOCAL retVal := ""
	retVal := Justify({::_codePlat, SubStr(::_libelle, 0, 18), ::_initialQuantite, ::_quantite}, "#", {3, 10, 33, 39}, {.T., .T., .T., .F.})
RETURN retVal