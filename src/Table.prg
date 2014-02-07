/*
 *
 * Classe de manipulation d'une table
 *
 */
 
#include "hbclass.ch"

/*
 * Retourne une liste d'objet table.
 *
 */
FUNCTION GetTableList
	LOCAL table
	LOCAL retVal := {}
	USE ListeTable ALIAS tables
	DO WHILE !Eof()
		table := Table():new()
		table:mId := tables->nfact
		table:mNumber := tables->num_table
		table:mCustomerNumber := tables->nb_client
		table:mDiscount := tables->taux
		table:mCreateDate := tables->date_crea
		table:mCreateTime := tables->time_crea
		table:mTicPrint := tables->status == 1
		table:mType := tables->st
		AAdd(retVal, table)
		SKIP
	ENDDO
	CLOSE tables
RETURN retVal

CLASS Table
	HIDDEN:
		DATA _id
		DATA _number
		DATA _customerNumber
		DATA _discount
		DATA _createDate
		DATA _createTime
		DATA _ticPrint
		DATA _type

	EXPORTED:
		METHOD toString
	
		ACCESS mId INLINE (::_id)
		ACCESS mNumber INLINE (::_number)
		ACCESS mCustomerNumber INLINE (::_customerNumber)
		ACCESS mDiscount INLINE (::_discount)
		ACCESS mCreateDate INLINE (::_createDate)
		ACCESS mCreateTime INLINE (::_createTime)
		ACCESS mTicPrint INLINE (::_ticPrint)
		ACCESS mType INLINE (::_type)
		
		ASSIGN mId(x) INLINE (::_id := x, ::_id)
		ASSIGN mNumber(x) INLINE (::_number := x, ::_number)
		ASSIGN mCustomerNumber(x) INLINE (::_customerNumber := x, ::_customerNumber)
		ASSIGN mDiscount(x) INLINE (::_Discount := x, ::_discount)
		ASSIGN mCreateDate(x) INLINE (::_createDate := x, ::_createDate)
		ASSIGN mCreateTime(x) INLINE (::_createTime := x, ::_createTime)
		ASSIGN mTicPrint(x) INLINE (::_ticPrint := x, ::_ticPrint)
		ASSIGN mType(x) INLINE (::_type := x, ::_type)
ENDCLASS

METHOD toString CLASS Table
	LOCAL retVal := ""
	retVal := retVal + ::_number + "/" + Str(::_customerNumber, , ,.T.)
RETURN retVal