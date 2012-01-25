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
	PRINT_FICHE(Date(), 1, 12, 2)
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
	dateStr := dateStr + DtoC(date)
	? CharRem(",", AtAdjust(",", msg + "," + dateStr, PAPER_WIDTH - Len(dateStr), 1, 0))
RETURN

PROCEDURE PRINT_FICHE_BODY(date, customerNumber, total, vat1Val, vat2Val)
	LOCAL bodyMsg := " repas complet"
	? PadLeft("", PAPER_WIDTH, "-")
	IF customerNumber > 1
		bodyMsg := bodyMsg + "s"
	ENDIF
	? center(Str(customerNumber, , ,.T.) + bodyMsg, PAPER_WIDTH, PADDING_CHAR, .T.)
	PRINT_VAT(vat1Val, vat2Val)
	PRINT_TOTAL(total)
RETURN

PROCEDURE PRINT_TOTAL(total)
	LOCAL totalStr := Str(total, , 2,.T.)
	? FONT_DOUBLE_STRIKE_ON
	? FONT_DOUBLE_HEIGHT_ON
	? CharRem(",", AtAdjust(",", "*** TOTAL," + totalStr, PAPER_WIDTH - Len(totalStr), 1, 0))
	? FONT_DOUBLE_HEIGHT_OFF
	? FONT_DOUBLE_STRIKE_OFF
RETURN

PROCEDURE PRINT_VAT(vat1Value, vat2Value)
	LOCAL vat1ValueStr := Str(vat1Value, ,2,.T.)
	LOCAL vat2ValueStr
	LOCAL vat1Str := Str(VAT1, ,2,.T.)
	LOCAL vat2Str := Str(VAT2, ,2,.T.)
	?CharRem(",",AtAdjust(",", "     Dont TVA " + vat1Str + "," + vat1ValueStr, PAPER_WIDTH - Len(vat1ValueStr), 1, 0))
	IF .NOT. HB_IsNIL(vat2Value)
		vat2ValueStr := Str(vat2Value, ,2,.T.)
		?CharRem(",",AtAdjust(",", "     Dont TVA " + vat2Str + "," + vat2ValueStr, PAPER_WIDTH - Len(vat2ValueStr), 1, 0))
	ENDIF
RETURN

PROCEDURE PRINT_FICHE(date, customerNumber, total, vat1, vat2)
	PRINTER_ON()
	PRINT_HEADER()
	PRINT_DATE("Facture", Date())
	PRINT_FICHE_BODY(date, customerNumber, total, vat1, vat2)
	PRINTER_OFF()
RETURN