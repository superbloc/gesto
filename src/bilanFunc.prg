#include "Box.ch"
#include "TBrowse.ch"

#define NB_CLIENT 2
#define TOTAL 3
#define ST_55 4
#define ST_196 5
#define TVA1 6
#define TVA2 7
#define SERVICE 8
#define EMPORTE 9
#define CB 10
#define CHQ 11
#define ESP 12
#define TR 13

/* référence les méthodes et fonctions liées au bilan */
GLOBAL EXTERN vat1ChangeDate
GLOBAL EXTERN vat1BeforeChangeDate
GLOBAL EXTERN vat1AfterChangeDate
GLOBAL EXTERN vat2ChangeDate
GLOBAL EXTERN vat2BeforeChangeDate
GLOBAL EXTERN vat2AfterChangeDate
//GLOBAL EXTERN vat2Value

/* Méthode qui insére une nouvelle entrée dans le bilan si la date est nouvelle sinon, elle la met à jour */
PROCEDURE CREATE_OR_UPDATE_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   IF EXISTS_BILAN(date)
      UPDATE_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   ELSE
      INSERER_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   ENDIF
RETURN

/* Méthode qui insére une nouvelle ligne dans la table des bilans */
PROCEDURE INSERER_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   LOCAL vat1 := GET_VAT1_BY_DATE(date)
   LOCAL vat2 := GET_VAT2_BY_DATE(date)
   USE BILANY ALIAS bilany NEW
   APPEND BLANK
   REPLACE bilany->date WITH date, ;
         bilany->nb_client WITH nbClient, ;
         bilany->total WITH total, ;
		 bilany->st_55 WITH st_55, ;
		 bilany->st_196 WITH st_196, ;
		 bilany->tva_1 WITH COMPUTE_TVA(bilany->st_55, vat1), ;
         bilany->tva_2 WITH COMPUTE_TVA(bilany->st_196, vat2), ;
         bilany->service WITH service, ;
         bilany->emporte WITH emporte, ;
         bilany->cb WITH cb, ;
         bilany->chq WITH chq, ; 
         bilany->esp WITH esp, ;
         bilany->tr WITH tr
   CLOSE bilany
RETURN

/* Fonction qui teste si une date existe dans le bilan */
FUNCTION EXISTS_BILAN(date)
   LOCAL retVal
   USE BILANY ALIAS bilany NEW
   INDEX ON bilany->date TO BILANY
   DbSeek(date)
   retVal := Found()
   CLOSE bilany
RETURN retVal

/* Fonction qui retourne le total d'un champ selon sa position dans la table */
FUNCTION GET_TOTAL_FIELD_BILAN(annee, mois, position)
   LOCAL total := 0
   USE BILANY ALIAS bilany NEW
   SUM FieldGet(position) TO total FOR Month(bilany->date) == mois .AND. Year(bilany->date) == annee
   CLOSE bilany
RETURN total

/* Méthode qui met à jour les données correspondant à la date */
PROCEDURE UPDATE_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   LOCAL vat1 := GET_VAT1_BY_DATE(date)
   LOCAL vat2 := GET_VAT2_BY_DATE(date)
   USE BILANY ALIAS bilany NEW
   REPLACE bilany->nb_client WITH bilany->nb_client + nbClient, ;
         bilany->total WITH bilany->total + total, ;
		 bilany->st_55 WITH bilany->st_55 + st_55, ;
		 bilany->st_196 WITH bilany->st_196 + st_196, ;
		 bilany->tva_1 WITH COMPUTE_TVA(bilany->st_55, vat1), ;
         bilany->tva_2 WITH COMPUTE_TVA(bilany->st_196, vat2), ;
         bilany->service WITH bilany->service + service, ;
         bilany->emporte WITH bilany->emporte + emporte, ;
         bilany->cb WITH bilany->cb + cb, ;
         bilany->chq WITH bilany->chq + chq, ;
         bilany->esp WITH bilany->esp + esp, ;
         bilany->tr WITH bilany->tr + tr ;
         FOR bilany->date == date
   CLOSE bilany
RETURN

PROCEDURE DISP_BILAN(annee, mois)
     LOCAL aHeader, aWidth, i
     LOCAL data := {}
     CLS
     USE BILANY ALIAS bilany NEW
     aHeader := Array( FCount() )
     aWidth := Array( FCount() )
     AEval( aWidth, {|x, i| aWidth[i] := FieldLen(i)})
     AEval( aHeader, {|x, i| aHeader[i] := PadL(FieldName(i), aWidth[i])})
     INDEX ON bilany->date TO bilany
     LOCATE FOR AllTrim(str(Year(bilany->date))) + AllTrim(str(Month(bilany->date))) == AllTrim(str(annee)) + AllTrim(str(mois))
     DO WHILE Found()
	  // Attention, si on remplace tva_1 tva_2 par la formule de calcul, il y a perte de la précision, à regarder ultérieurement.
      AAdd(data, {bilany->date, bilany->nb_client, bilany->total, bilany->st_55, bilany->st_196, bilany->tva_1, bilany->tva_2, bilany->service, bilany->emporte, bilany->cb, bilany->chq, bilany->esp, bilany->tr})
      CONTINUE
	 ENDDO
     CLOSE BILANY
     IF Len(data) <= 0
      RETURN
     ENDIF
     DISP_RECAP_BILAN(annee, mois)
     DISP_CELLS(aHeader, aWidth, data, 1, annee, mois)
RETURN

PROCEDURE DISP_RECAP_BILAN(annee, mois)
   LOCAL date := CtoD("01/" + str(mois) + "/" + str(annee))
   LOCAL vat1 := GET_VAT1_BY_DATE(date)
   LOCAL vat2 := GET_VAT2_BY_DATE(date)
   LOCAL total := GET_TOTAL_FIELD_BILAN(annee, mois, TOTAL)
   LOCAL nbClient := GET_TOTAL_FIELD_BILAN(annee, mois, NB_CLIENT)
   LOCAL tva1 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN(annee, mois, ST_55), vat1)
   LOCAL tva2 := COMPUTE_TVA(GEt_TOTAL_FIELD_BILAN(annee, mois, ST_196), vat2)
   LOCAL service := GET_TOTAL_FIELD_BILAN(annee, mois, SERVICE)
   LOCAL emporte := GET_TOTAL_FIELD_BILAN(annee, mois, EMPORTE)
   LOCAL cb := GET_TOTAL_FIELD_BILAN(annee, mois, CB)
   LOCAL chq := GET_TOTAL_FIELD_BILAN(annee, mois, CHQ)
   LOCAL esp := GET_TOTAL_FIELD_BILAN(annee, mois, ESP)
   LOCAL tr := GET_TOTAL_FIELD_BILAN(annee, mois, TR)
   DispBox(18, 2, MaxRow(), MaxCol() - 2, B_SINGLE, "R+/B+")
   @ 19, 3 SAY cb PICTURE "@!R cb : 999999.99"
   @ 19, 23 SAY chq PICTURE "@!R chq : 999999.99"
   @ 19, 43 SAY esp PICTURE "@!R esp : 999999.99"
   @ 19, 63 SAY tr PICTURE "@!R tr : 999999.99"
   @ 21, 3 SAY nbClient PICTURE "@!R nb clts : 999999"
   @ 21, 23 SAY "tva " + str(vat1, 5, 2) + " % : " + AllTrim(str(tva1)) PICTURE "@!"
   @ 21, 53 SAY "tva " + str(vat2, 5, 2) + " % : " + AllTrim(str(tva2)) PICTURE "@!"
   @ 23, 3 SAY total PICTURE "@!R total : 999999.99"
   @ 23, 23 SAY service PICTURE "@!R service : 999999.99"
   @ 23, 53 SAY emporte PICTURE "@!R emporte : 999999.99"
RETURN


PROCEDURE PRINT_BILAN(annee, mois)
   LOCAL date := CtoD("01/" + str(mois) + "/" + str(annee))
   LOCAL vat1 := GET_VAT1_BY_DATE(date)
   LOCAL vat2 := GET_VAT2_BY_DATE(date)
   LOCAL total := GET_TOTAL_FIELD_BILAN(annee, mois, TOTAL)
   LOCAL nbClient := GET_TOTAL_FIELD_BILAN(annee, mois, NB_CLIENT)
   LOCAL st_55 := GET_TOTAL_FIELD_BILAN(annee, mois, ST_55)
   LOCAL st_196 := GET_TOTAL_FIELD_BILAN(annee, mois, ST_196)
   LOCAL tva1 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN(annee, mois, ST_55), vat1)
   LOCAL tva2 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN(annee, mois, ST_196), vat2)
   LOCAL service := GET_TOTAL_FIELD_BILAN(annee, mois, SERVICE)
   LOCAL emporte := GET_TOTAL_FIELD_BILAN(annee, mois, EMPORTE)
   LOCAL cb := GET_TOTAL_FIELD_BILAN(annee, mois, CB)
   LOCAL chq := GET_TOTAL_FIELD_BILAN(annee, mois, CHQ)
   LOCAL esp := GET_TOTAL_FIELD_BILAN(annee, mois, ESP)
   LOCAL tr := GET_TOTAL_FIELD_BILAN(annee, mois, TR)
   LOCAL data := GET_LISTE_BILAN_IMPRESSION(annee, mois)
   LOCAL itr
   LOCAL init := Chr(27)+Chr(64)
   LOCAL emphasis := Chr(27)+Chr(69)+Chr(1)
   LOCAL emphasisOff := Chr(27)+Chr(69)+Chr(0)
   LOCAL cutting := Chr(29)+Chr(86)+Chr(65)+Chr(0)
   LOCAL doubleHeight := Chr(27)+Chr(33)+Chr(16)
   LOCAL doubleHeightOff := Chr(27)+Chr(33)+Chr(0)
   LOCAL doubleStrike := Chr(27)+Chr(71)+Chr(1)
   LOCAL doubleStrikeOff := Chr(27)+Chr(71)+Chr(0)
   
   //gprinter = GetDefaultPrinter()
   //gprinter = COM1
   SET PRINTER ON
   SET PRINTER TO LPT1
   SET CONSOLE OFF
   
   ? init
   ? " La recette de : " + AllTrim(str(mois)) + "/" + AllTrim(str(annee))
   ? "------------------------------------------"
   ? "Date   NbClt     Total   St_" + str(vat1 * 10, 2, 0) + "    St_" + str(vat2 * 10, 3, 0) + "  "
   ? "------------------------------------------"
   FOR itr := 1 TO LEN(data)
      ? data[itr][1] + " " + data[itr][2] + " " + data[itr][3] + " " + data[itr][6] + " " + data[itr][7]
	  ? PadL("CB:", 8) + data[itr][8] + PadL("CQ:", 8) + data[itr][9]
	  ? PadL("ES:", 8) + data[itr][10] + PadL("TR:", 8) + data[itr][11]
   NEXT
   
   ? "------------------------------------------"
   ? "  NbClient:" + AllTrim(str(nbClient)) +           "    TOTAL:" + PadL(AllTrim(str(total)), 10)
   ? "{   St_" + str(vat1*10, 2, 0) + ":" + PadL(AllTrim(str(st_55)), 10) +    "   St_" + str(vat2*10, 3, 0) + ":" + PadL(AllTrim(str(st_196)), 10) + " }"
   ? "{      CB:" + PadL(AllTrim(str(cb)), 10) +        "       CQ:" + PadL(AllTrim(str(chq)), 10) + " }"
   ? "{      ES:" + PadL(AllTrim(str(esp)), 10) +     "       TR:" + PadL(AllTrim(str(tr)), 10) + " }"
   ?
   ? "TOTAL TVA:" + PadL(AllTrim(str(tva1 + tva2)), 10)
   ? "{  " + str(vat1, 5, 2) + "%:" + PadL(AllTrim(str(tva1)), 10) +    "   " + str(vat2, 5, 2) + "%:" + PadL(AllTrim(str(tva2)), 10) + " }"
   ? "------------------------------------------"
   ? cutting
   EJECT
   SET PRINTER TO
   SET PRINTER OFF
   SET CONSOLE ON
RETURN


FUNCTION GET_LISTE_BILAN_IMPRESSION(annee, mois)
	 LOCAL date := CtoD("01/" + str(mois) + "/" + str(annee))
	 LOCAL vat1 := GET_VAT1_BY_DATE(date)
	 LOCAL vat2 := GET_VAT2_BY_DATE(date)
     LOCAL ret := {}
     USE BILANY ALIAS bilany NEW
     INDEX ON bilany->date TO bilany
     LOCATE FOR AllTrim(str(Year(bilany->date))) + AllTrim(str(Month(bilany->date))) == AllTrim(str(annee)) + AllTrim(str(mois))
     DO WHILE Found()
      AAdd(ret, {PadL(AllTrim(str(Day(bilany->date))), 2, "0")+ "/"+ PadL(AllTrim(str(Month(bilany->date))), 2, "0"),;
                 PadL(AllTrim(str(bilany->nb_client)), 3),;
                 PadL(AllTrim(str(bilany->total)), 10),;
				 PadL(AllTrim(str(COMPUTE_TVA(bilany->st_55, vat1))), 10),;
                 PadL(AllTrim(str(COMPUTE_TVA(bilany->st_196, vat2))), 10),;
				 PadL(AllTrim(str(bilany->st_55)), 10),;
				 PadL(AllTrim(str(bilany->st_196)), 10),;
                 PadL(AllTrim(str(bilany->cb)), 10),;
                 PadL(AllTrim(str(bilany->chq)), 10),;
                 PadL(AllTrim(str(bilany->esp)), 10),;
                 PadL(AllTrim(str(bilany->tr)), 10)})      
      CONTINUE
     ENDDO
     CLOSE BILANY
RETURN ret
