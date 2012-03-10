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
	
	USE ContentTable ALIAS content NEW
	SET RELATION TO content->CODE_PLAT INTO menu
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
			stockBoisson:quantite := content->QUANTITE
			stockBoisson:mCategorie := menu->CATEGORIE
			elemHash[key] := stockBoisson
			//elemHash[key] := content->QUANTITE
		ENDIF
		CONTINUE
	ENDDO
	CLOSE content
	CLOSE menu
RETURN elemHash

CLASS StockBoisson
	HIDDEN:
		DATA _codePlat
		DATA _libelle
		DATA _quantite
		DATA _categorie

	EXPORTED:
		METHOD toString
	
		ACCESS mCodePlat INLINE (::_codePlat)
		ACCESS mLibelle INLINE (::_libelle)
		ACCESS mQuantite INLINE (::_quantite)
		ACCESS mCategorie INLINE (::_categorie)
		
		ASSIGN mCodePlat(x) INLINE (::_codePlat := x, ::_codePlat)
		ASSIGN mLibelle(x) INLINE (::_libelle := x, ::_libelle)
		ASSIGN mQuantite(x) INLINE (::_quantite := x, ::_quantite)
		ASSIGN mCategorie(x) INLINE (::_categorie := x, ::_categorie)
ENDCLASS

METHOD toString CLASS StockBoisson
	LOCAL retVal := ""
	//retVal := retVal + ::_codePlat + " - " + ::_libelle + " - " + Str(::_quantite, ,0, .T.)
	retVal := Justify({::_codePlat, ::_libelle, ::_quantite}, "#", {2, 12, 50}, {.T., .T., .F.})
RETURN retVal