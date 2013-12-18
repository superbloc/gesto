/*
 *
 * Classe implémentant les recettes journalières
 *
 */
 
#include "hbclass.ch"
 
FUNCTION GetRecetteList
	LOCAL recetteObj
	LOCAL retVal := {}
	USE "../bin/Recettej.dbf" ALIAS recette
	DO WHILE ! Eof()
		recetteObj := Recette():new()
		recetteObj:mDate := recette->date
		recetteObj:mTableNumber := recette->num_table
		recetteObj:mFactureNumber := recette->nfact
		recetteObj:mCustomerNumber := recette->nb_client
		recetteObj:mTotal := recette->total
		recetteObj:mCreditCard := recette->cb
		recetteObj:mCheck := recette->chq
		recetteObj:mCash := recette->esp
		recetteObj:mTr := recette->tr
		recetteObj:mType := recette->status
		recetteObj:mTicPrint := recette->tic_print == 1
		AAdd(retVal, recetteObj)
		SKIP
	ENDDO
	CLOSE recette
RETURN retVal

CLASS Recette
	HIDDEN:
		DATA _date
		DATA _tableNumber
		DATA _factureNumber
		DATA _customerNumber
		DATA _total
		DATA _creditCard
		DATA _check
		DATA _cash
		DATA _tr
		DATA _type
		DATA _ticPrint
	EXPORTED:
		METHOD toString
	
		ACCESS mDate INLINE (::_date)
		ACCESS mTableNumber INLINE (::_tableNumber)
		ACCESS mFactureNumber INLINE (::_factureNumber)
		ACCESS mCustomerNumber INLINE (::_customerNumber)
		ACCESS mTotal INLINE (::_total)
		ACCESS mCreditCard INLINE (::_creditCard)
		ACCESS mCheck INLINE (::_check)
		ACCESS mCash INLINE (::_cash)
		ACCESS mTr INLINE (::_tr)
		ACCESS mType INLINE (::_type)
		ACCESS mTicPrint INLINE (::_ticPrint)
		
		ASSIGN mDate(x) INLINE (::_date := x, ::_date)
		ASSIGN mTableNumber(x) INLINE (::_tableNumber := x, ::_tableNumber)
		ASSIGN mFactureNumber(x) INLINE (::_factureNumber := x, ::_factureNumber)
		ASSIGN mCustomerNumber(x) INLINE (::_customerNumber := x, ::_customerNumber)
		ASSIGN mTotal(x) INLINE (::_total := x, ::_total)
		ASSIGN mCreditCard(x) INLINE (::_creditCard := x, ::_creditCard)
		ASSIGN mCheck(x) INLINE (::_check := x, ::_check)
		ASSIGN mCash(x) INLINE (::_cash := x, ::_cash)
		ASSIGN mTr(x) INLINE (::_tr := x, ::_tr)
		ASSIGN mType(x) INLINE (::_type := x, ::_type)
		ASSIGN mTicPrint(x) INLINE (::_ticPrint := x, ::_ticPrint)
ENDCLASS 

METHOD toString CLASS Recette
	LOCAL retVal := ""
	retVal := retVal + DtoC(::_date) + "-"
	retVAl := retVal + ::_tableNumber + "-"
	retVAl := retVal + Str(::_customerNumber, , ,.T.) + "-"
	retVal := retVal + Str(::_total, ,2,.T.) + "-"
	retVal := retVal + Str(::_creditCard, ,2,.T.) + "-"
	retVal := retVal + Str(::_check, ,2,.T.) + "-"
	retVal := retVal + Str(::_cash, ,2,.T.) + "-"
	retVal := retVal + Str(::_tr, ,2,.T.)
RETURN retVal