/*
M�thodes et fonctions pour l'impression (gamme EPSON TM-T88).
*/

// Code contr�le de l'imprimante
#define PRINTER_INIT            Chr(27)+Chr(64)
#define FONT_EMPHASIS_ON        Chr(27)+Chr(69)+Chr(1)
#define FONT_EMPHASIS_Off       Chr(27)+Chr(69)+Chr(0)
#define PAPER_CUT               Chr(29)+Chr(86)+Chr(65)+Chr(0)
#define FONT_DOUBLE_HEIGHT_ON   Chr(27)+Chr(33)+Chr(16)
#define FONT_DOUBLE_HEIGHT_OFF  Chr(27)+Chr(33)+Chr(0)
#define FONT_DOUBLE_STRIKE_ON   Chr(27)+Chr(71)+Chr(1)
#define FONT_DOUBLE_STRIKE_OFF  Chr(27)+Chr(71)+Chr(0)

#define PAPER_WIDTH 42
#define PADDING_CHAR Chr(32)

GLOBAL EXTERN SOCIETE
GLOBAL EXTERN NOM_SOCIETE
GLOBAL EXTERN ADR
GLOBAL EXTERN CODE_POSTAL
GLOBAL EXTERN VILLE
GLOBAL EXTERN TEL
GLOBAL EXTERN SIRET
GLOBAL EXTERN DEFAUT_REMISE

GLOBAL EXTERN vat1ChangeDate
GLOBAL EXTERN vat1BeforeChangeDate
GLOBAL EXTERN vat1AfterChangeDate
GLOBAL EXTERN vat2Value

// On active le mode impression
PROCEDURE PRINTER_ON()
	LOCAL printerDevice := GetDefaultPrinter()
	SET PRINTER ON
    SET PRINTER TO testPrint
	SET CONSOLE OFF
	? PRINTER_INIT
RETURN

// On d�sactive le mode impression, la console reprend la main.
PROCEDURE PRINTER_OFF()
	? PAPER_CUT
	EJECT
	SET PRINTER TO
	SET PRINTER OFF
	SET CONSOLE ON
RETURN

// Impression de l'ent�te.
PROCEDURE PRINT_HEADER()
	LOCAL nom_restaurant := SOCIETE + Chr(32) + UPPER(NOM_SOCIETE)
	LOCAL adresse := UPPER(ADR)
	LOCAL localisation := CODE_POSTAL + Chr(32) + UPPER(VILLE)
	LOCAL telephone := Transform(TEL, "@LR TEL : 99 99 99 99 99")
	LOCAL num_siret := Transform(SIRET, "@LR SIRET : 999 999 999 99999")
	
	? FONT_DOUBLE_STRIKE_ON
	? FONT_DOUBLE_HEIGHT_ON
	? center(nom_restaurant, PAPER_WIDTH, PADDING_CHAR, .T.)
	? FONT_DOUBLE_STRIKE_OFF
	? FONT_DOUBLE_HEIGHT_OFF
	
	? center(adresse, PAPER_WIDTH, PADDING_CHAR, .T.)
	? center(localisation, PAPER_WIDTH, PADDING_CHAR, .T.)
	? center(telephone, PAPER_WIDTH, PADDING_CHAR, .T.)
	? center(num_siret, PAPER_WIDTH, PADDING_CHAR, .T.)
RETURN

PROCEDURE PRINT_DATE(msg, date)
	LOCAL dateStr := "LE "
	SET DATE TO FRENCH
	SET CENTURY ON
	dateStr := dateStr + DtoC(date)
	//? CharRem(",", AtAdjust(",", msg + "," + dateStr, PAPER_WIDTH - Len(dateStr), 1, 0))
	? Justify({msg, dateStr}, "#", {0, PAPER_WIDTH - 1})
RETURN

PROCEDURE PRINT_HT_BARRE
	? PadLeft("", PAPER_WIDTH, "-")
RETURN

PROCEDURE PRINT_FICHE_BODY(date, customerNumber, total, vat1Val, vat2Val)
	LOCAL bodyMsg := " repas complet"
	PRINT_HT_BARRE()
	IF customerNumber > 1
		bodyMsg := bodyMsg + "s"
	ENDIF
	? center(Str(customerNumber, , ,.T.) + bodyMsg, PAPER_WIDTH, PADDING_CHAR, .T.)
	PRINT_TOTAL(total)
	PRINT_VAT(date, vat1Val, vat2Val)
RETURN

PROCEDURE PRINT_RECEIPT_BODY(date, tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
	LOCAL content
	PRINT_HT_BARRE()
	? Justify({"Code", "Designation", "Qte", "Mont"}, "#", {0, 22,33,PAPER_WIDTH - 1})
	PRINT_HT_BARRE()
	FOR EACH content IN contentList
		? Justify(content, "#", {0, 6, 32,PAPER_WIDTH - 1},{.T., .T., .F., .F.})
	NEXT
	? ""
	? Justify({"S/TOTAL", Str(total, , 2,.T.)}, "#", {0, PAPER_WIDTH - 5})
	IF .NOT. (HB_isNIL(discountValue) .OR. discountValue == 0)
		? Justify({"Remise :", Str(discountValue/-1, ,2,.T.)}, "#", {13, PAPER_WIDTH - 5}, {.F., .F.})
		? Justify({"Total net :", Str(total - discountValue, ,2,.T.)},"#",{13, PAPER_WIDTH - 5}, {.F., .F.})
	ENDIF
	? ""
	PRINT_VAT(date, vat1, vat2)
	PRINT_TOTAL(total - discountValue)
RETURN

PROCEDURE PRINT_TOTAL(total)
	LOCAL totalStr := Str(total, 7, 2,.T.)
	? FONT_DOUBLE_STRIKE_ON
	? FONT_DOUBLE_HEIGHT_ON
	//? CharRem(",", AtAdjust(",", "*** TOTAL," + totalStr, PAPER_WIDTH - Len(totalStr), 1, 0))
	? Justify({"*** TOTAL", totalStr}, "#", {0, PAPER_WIDTH - 5})
	? FONT_DOUBLE_HEIGHT_OFF
	? FONT_DOUBLE_STRIKE_OFF
RETURN

PROCEDURE PRINT_VAT(date, vat1Value, vat2tValue)
	LOCAL vat1ValueStr := Str(vat1Value, ,2,.T.)
	LOCAL vat2ValueStr
	LOCAL vat1Str := Str(GET_VAT1_BY_DATE(date),5,2,.T.)
	LOCAL vat2Str := Str(vat2Value,5,2,.T.)
	? Justify({"Dont TVA", vat1Str+"% :", vat1ValueStr}, "#", {9, 27, PAPER_WIDTH - 7})
	IF .NOT. HB_IsNIL(vat2tValue)
	vat2ValueStr := Str(vat2tValue, ,2,.T.)
	? Justify({"Dont TVA", vat2Str+"% :", vat2ValueStr}, "#", {9, 27, PAPER_WIDTH - 7})
	ENDIF
RETURN

//M�thode imprimant une fiche
PROCEDURE PRINT_FICHE(date, customerNumber, total, vat1, vat2)
	PRINTER_ON()
	PRINT_HEADER()
	PRINT_DATE("Facture", date)
	PRINT_FICHE_BODY(date, customerNumber, total, vat1, vat2)
	PRINTER_OFF()
RETURN

// M�thode imprimant une facture
PROCEDURE PRINT_RECEIPT(date, isService, tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
	LOCAL internMsg
	PRINTER_ON()
	PRINT_HEADER()
	IF isService
		internMsg := "Table : " + tableNumber + " / " + Str(customerNumber, , ,.T.)
	ELSE
		internMsg := "Emporter : " + tableNumber
	ENDIF
	PRINT_DATE(internMsg, date)
	PRINT_RECEIPT_BODY(date, tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
	PRINTER_OFF()
RETURN