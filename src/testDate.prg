/*
Méthodes et fonctions pour l'impression (gamme EPSON TM-T88).
*/

// Code contrôle de l'imprimante
#define PRINTER_INIT            Chr(27)+Chr(64)
#define FONT_EMPHASIS_ON        Chr(27)+Chr(69)+Chr(1)
#define FONT_EMPHASIS_Off       Chr(27)+Chr(69)+Chr(0)
#define PAPER_CUT               Chr(29)+Chr(86)+Chr(65)+Chr(0)
#define FONT_DOUBLE_HEIGHT_ON   Chr(27)+Chr(33)+Chr(16)
#define FONT_DOUBLE_HEIGHT_OFF  Chr(27)+Chr(33)+Chr(0)
#define FONT_DOUBLE_STRIKE_ON   Chr(27)+Chr(71)+Chr(1)
#define FONT_DOUBLE_STRIKE_OFF  Chr(27)+Chr(71)+Chr(0)

#define SOCIETE "restaurant"
#define NOM_SOCIETE "china star"
#define ADR "65, rue henri laroche"
#define CODE_POSTAL "60800"
#define VILLE "crepy-en-valois"
#define TEL 0344941888
#define SIRET 44153813200013
#define DEFAUT_REMISE 10
#define PAPER_WIDTH 42
#define PADDING_CHAR Chr(32)
#define VAT1 5.5
#define VAT2 19.6

PROCEDURE MAIN
	PRINT_FICHE(Date(), 1, 12, 2, 19.58)
	? PadLeft("", 42, "@")
	PRINT_RECEIPT(Date(), 12, 4, {{42, "poulet au citron", 2, 45.23},{46, "Canard laque", 1, 23.12}}, 150, 1.23, 2, 9)
RETURN

// On active le mode impression
PROCEDURE PRINTER_ON()
	SET PRINTER ON
    SET PRINTER TO testPrint
	SET CONSOLE OFF
	? PRINTER_INIT
RETURN

// On désactive le mode impression, la console reprend la main.
PROCEDURE PRINTER_OFF()
	SET PRINTER TO
	SET PRINTER OFF
	SET CONSOLE ON
RETURN

// Impression de l'entête.
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

PROCEDURE PRINT_FICHE_BODY(customerNumber, total, vat1Val, vat2Val)
	LOCAL bodyMsg := " repas complet"
	PRINT_HT_BARRE()
	IF customerNumber > 1
		bodyMsg := bodyMsg + "s"
	ENDIF
	? center(Str(customerNumber, , ,.T.) + bodyMsg, PAPER_WIDTH, PADDING_CHAR, .T.)
	PRINT_TOTAL(total)
	PRINT_VAT(vat1Val, vat2Val)
RETURN

PROCEDURE PRINT_RECEIPT_BODY(tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
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
	PRINT_VAT(vat1, vat2)
	PRINT_TOTAL(total)
RETURN

PROCEDURE PRINT_TOTAL(total)
	LOCAL totalStr := Str(total, , 2,.T.)
	? FONT_DOUBLE_STRIKE_ON
	? FONT_DOUBLE_HEIGHT_ON
	//? CharRem(",", AtAdjust(",", "*** TOTAL," + totalStr, PAPER_WIDTH - Len(totalStr), 1, 0))
	? Justify({"*** TOTAL", totalStr}, "#", {0, PAPER_WIDTH - 5})
	? FONT_DOUBLE_HEIGHT_OFF
	? FONT_DOUBLE_STRIKE_OFF
RETURN

PROCEDURE PRINT_VAT(vat1Value, vat2Value)
	LOCAL vat1ValueStr := Str(vat1Value, ,2,.T.)
	LOCAL vat2ValueStr
	LOCAL vat1Str := Str(VAT1, ,2,.T.)
	LOCAL vat2Str := Str(VAT2, ,2,.T.)
	? Justify({"Dont TVA", vat1Str+"% :", vat1ValueStr}, "#", {9, 27, PAPER_WIDTH - 7})
	IF .NOT. HB_IsNIL(vat2Value)
	vat2ValueStr := Str(vat2Value, ,2,.T.)
	? Justify({"Dont TVA", vat2Str+"% :", vat2ValueStr}, "#", {9, 27, PAPER_WIDTH - 7})
	ENDIF
RETURN

//Méthode imprimant une fiche
PROCEDURE PRINT_FICHE(date, customerNumber, total, vat1, vat2)
	PRINTER_ON()
	PRINT_HEADER()
	PRINT_DATE("Facture", date)
	PRINT_FICHE_BODY(customerNumber, total, vat1, vat2)
	PRINTER_OFF()
RETURN

// Méthode imprimant une facture
PROCEDURE PRINT_RECEIPT(date, tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
	PRINTER_ON()
	PRINT_HEADER()
	PRINT_DATE("Table : " + Str(tableNumber, , ,.T.) + " / " + Str(customerNumber, , ,.T.), date)
	PRINT_RECEIPT_BODY(tableNumber, customerNumber, contentList, total, discountValue, vat1, vat2)
	PRINTER_OFF()
RETURN

// fonction qui justifie plusieurs morceaux de textes.
// TODO : à améliorer, notamment sur la gestion des valeurs passées en arguments.
FUNCTION Justify(strList, splitChar, positionList, justifyStyle, paddingChar)
	LOCAL lengthList := {}
	LOCAL str := ""
	LOCAL item
	LOCAL transformItem
	LOCAL itr
	LOCAL retVal
	LOCAL spaceDiff
	LOCAL padding := IF(HB_isNIL(paddingChar), Chr(32), paddingChar)
	FOR EACH item IN strList
		transformItem := AllTrim(Transform(item, "@B"))
		AAdd(lengthList, Len(transformItem))
		str := str + splitChar + transformItem
	NEXT
	FOR itr := 1 TO Len(lengthList)
		IF HB_isNIL(justifyStyle)
			IF itr == 1
				spaceDiff := positionList[itr]
			ELSE
				spaceDiff := positionList[itr] - lengthList[itr]
			ENDIF
		ELSEIF justifyStyle[itr]
			spaceDiff := positionList[itr]
		ELSE
			spaceDiff := positionList[itr] - lengthList[itr]
		ENDIF
		str := AtAdjust(splitChar, str, spaceDiff, itr, 0, padding)
	NEXT
	retVal := CharRepl(splitChar, str, padding)
RETURN retVal