/* 
 * Classe d'initialisation du menu et d'un plat.
 * Une classe Menu contient une liste de plat.
 *
 */

#include "hbclass.ch"

CLASS Menu
	HIDDEN:
		DATA _platList INIT {}
		METHOD init
	EXPORTED:
		ACCESS mPlatList
		ASSIGN mPlatList( x ) INLINE ::mPlatList(x)
ENDCLASS

METHOD mPlatList( platListValue ) CLASS Menu
	IF PCount() != 0
		::platList := platListValue
	ENDIF
RETURN ::_platList

METHOD init CLASS Menu
	LOCAL plate
	USE "..\bin\Menu" ALIAS menu
	DO WHILE !Eof()
		plate := Plat():new()
		plate:mCode := menu->code_plat
		plate:mLabel := menu->libelle
		plate:mPrice := menu->prix
		plate:mCategory := menu->categorie
		plate:mStorable := menu->stockage == "Y"
		AAdd(::_platList, plate)
		SKIP
	ENDDO
	CLOSE menu
RETURN self

CLASS Plat
	HIDDEN:
		DATA _code
		DATA _label
		DATA _price
		DATA _category
		DATA _storable
	EXPORTED:
		METHOD toString
	
		ACCESS mCode
		ASSIGN mCode( x ) INLINE ::mCode(x)
		
		ACCESS mLabel
		ASSIGN mLabel( x ) INLINE ::mLabel(x)
		
		ACCESS mPrice
		ASSIGN mPrice( x ) INLINE ::mPrice(x)
		
		ACCESS mCategory
		ASSIGN mCategory( x ) INLINE ::mCategory(x)
		
		ACCESS mStorable
		ASSIGN mStorable( x ) INLINE ::mStorable(x)
ENDCLASS

METHOD toString CLASS Plat
	LOCAL retVal := ""
	retVal := retVal + ::_code + "-"
	retVal := retVal + Upper(::_label) + "-"
	retVal := retVal + Str(::_price, ,2,.T.) + "-"
	retVal := retVal + ::_category + "-"
	retVal := retVal + LtoC(::_storable)
RETURN retVal

METHOD mCode ( codeValue ) CLASS Plat
	IF PCount() != 0
		::_code := codeValue
	ENDIF
RETURN ::_code

METHOD mLabel ( labelValue ) CLASS Plat
	IF PCount() != 0
		::_label := labelValue
	ENDIF
RETURN ::_label

METHOD mPrice ( priceValue ) CLASS Plat
	IF PCount() != 0
		::_price := priceValue
	ENDIF
RETURN ::_price

METHOD mCategory ( categoryValue ) CLASS Plat
	IF PCount() != 0
		::_category := categoryValue
	ENDIF
RETURN ::_category

METHOD mStorable ( storableValue ) CLASS Plat
	IF PCount() != 0
		::_storable := storableValue
	ENDIF
RETURN ::_storable