#include "Box.ch"
#include "TBrowse.ch"

#define NB_CLIENT 3
#define TOTAL 4
#define ST_55 5
#define ST_196 6
#define TVA1 7
#define TVA2 8
#define SERVICE 9
#define EMPORTE 10
#define CB 11
#define CHQ 12
#define ESP 13
#define TR 14

/* référence les méthodes permettant de visualiser tous le bilan d'une année */

PROCEDURE INSERT_OR_UPDATE_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   IF EXISTS_BILAN_ANNEE_MOIS(annee, mois)
      UPDATE_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   ELSE
      INSERER_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   ENDIF
RETURN

/* Méthode créant une nouvelle entrée dans la table des bilans par année */
PROCEDURE INSERER_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   USE BILANM ALIAS bilanm NEW
   APPEND BLANK
   REPLACE bilanm->annee WITH annee, ;
         bilanm->mois WITH mois, ;
         bilanm->nb_client WITH nbClient, ;
         bilanm->total WITH total, ;
		 bilanm->st_55 WITH st_55, ;
		 bilanm->st_196 WITH st_196, ;
         bilanm->service WITH service, ;
         bilanm->emporte WITH emporte, ;
         bilanm->tva_1 WITH COMPUTE_TVA(bilanm->st_55, 5.5), ;
         bilanm->tva_2 WITH COMPUTE_TVA(bilanm->st_196, 19.6), ;
         bilanm->cb WITH cb, ;
         bilanm->chq WITH chq, ;
         bilanm->esp WITH esp, ;
         bilanm->tr WITH tr
   CLOSE bilanm
RETURN

/* Méthode qui met à jour une entrée correspondant à année et mois dans la table */
PROCEDURE UPDATE_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
   USE BILANM ALIAS bilanm NEW
   REPLACE bilanm->nb_client WITH bilanm->nb_client + nbClient, ;
         bilanm->total WITH bilanm->total + total, ;
		 bilanm->st_55 WITH bilanm->st_55 + st_55, ;
		 bilanm->st_196 WITH bilanm->st_196 + st_196, ;
         bilanm->service WITH bilanm->service + service, ;
         bilanm->emporte WITH bilanm->emporte + emporte, ;
         bilanm->tva_1 WITH COMPUTE_TVA(bilanm->st_55, 5.5), ;
         bilanm->tva_2 WITH COMPUTE_TVA(bilanm->st_196, 19.6), ;
         bilanm->cb WITH bilanm->cb + cb, ;
         bilanm->chq WITH bilanm->chq + chq, ;
         bilanm->esp WITH bilanm->esp + esp, ;
         bilanm->tr WITH bilanm->tr + tr;
         FOR bilanm->annee == annee .AND. bilanm->mois == mois
   CLOSE bilanm
RETURN

/* Fonction qui teste si une entrée correspondant à une année et un mois particulier existe dans la base */
FUNCTION EXISTS_BILAN_ANNEE_MOIS(annee, mois)
   LOCAL retVal
   USE BILANM ALIAS bilanm NEW
   LOCATE FOR bilanm->annee == annee .AND. bilanm->mois == mois
   retVal := Found()
   CLOSE bilanm
RETURN retVal 

/* Fonction qui retourne le total d'un champ selon sa position dans la table */
FUNCTION GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, position)
   LOCAL total := 0
   USE BILANM ALIAS bilanm NEW
   SUM FieldGet(position) TO total FOR bilanm->annee == annee
   CLOSE bilanm
RETURN total

PROCEDURE DISP_BILAN_ANNEE_MOIS(annee)
     LOCAL aHeader, aWidth, i
     LOCAL data := {}
     CLS
     USE BILANM ALIAS bilanm NEW
     aHeader := Array( FCount() )
     aWidth := Array( FCount() )
     AEval( aWidth, {|x, i| aWidth[i] := FieldLen(i)})
     AEval( aHeader, {|x, i| aHeader[i] := PadL(FieldName(i), aWidth[i])})
     INDEX ON bilanm->annee + bilanm->mois TO bilanm
     LOCATE FOR bilanm->annee == annee
     DO WHILE Found()
	  // Attention, si on remplace tva_1 tva_2 par la formule de calcul, il y a perte de la précision, à regarder ultérieurement.
      AAdd(data, {bilanm->annee, bilanm->mois, bilanm->nb_client, bilanm->total, bilanm->st_55, bilanm->st_196, bilanm->tva_1, bilanm->tva_2, bilanm->service, bilanm->emporte, bilanm->cb, bilanm->chq, bilanm->esp, bilanm->tr})
      CONTINUE
     ENDDO
     CLOSE bilanm
     IF Len(data) <= 0
      RETURN
     ENDIF
     DISP_RECAP_BILAN_ANNEE_MOIS(annee)
     DISP_CELLS(aHeader, aWidth, data, 0, annee, 12)
RETURN

PROCEDURE DISP_RECAP_BILAN_ANNEE_MOIS(annee)
   LOCAL total := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TOTAL)
   LOCAL nbClient := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, NB_CLIENT)
   //LOCAL tva1 := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TVA1)
   //LOCAL tva2 := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TVA2)
   LOCAL tva1 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ST_55), 5.5)
   LOCAL tva2 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ST_196), 19.6)
   LOCAL service := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, SERVICE)
   LOCAL emporte := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, EMPORTE)
   LOCAL cb := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, CB)
   LOCAL chq := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, CHQ)
   LOCAL esp := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ESP)
   LOCAL tr := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TR)
   DispBox(18, 2, MaxRow(), MaxCol() - 2, B_SINGLE, "R+/B+")
   @ 19, 3 SAY cb PICTURE "@!R cb : 999999.99"
   @ 19, 23 SAY chq PICTURE "@!R chq : 999999.99"
   @ 19, 43 SAY esp PICTURE "@!R esp : 999999.99"
   @ 19, 63 SAY tr PICTURE "@!R tr : 999999.99"
   @ 21, 3 SAY nbClient PICTURE "@!R nb clts : 999999"
   @ 21, 23 SAY "tva 5.5 % : " + AllTrim(str(tva1)) PICTURE "@!"
   @ 21, 53 SAY "tva 19.6 % : " + AllTrim(str(tva2)) PICTURE "@!"
   @ 23, 3 SAY total PICTURE "@!R total : 999999.99"
   @ 23, 23 SAY service PICTURE "@!R service : 999999.99"
   @ 23, 53 SAY emporte PICTURE "@!R emporte : 999999.99"
RETURN

PROCEDURE PRINT_BILANM(annee)
   LOCAL total := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TOTAL)
   LOCAL nbClient := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, NB_CLIENT)
   //LOCAL tva1 := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TVA1)
   //LOCAL tva2 := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TVA2)
   LOCAL tva1 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ST_55), 5.5)
   LOCAL tva2 := COMPUTE_TVA(GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ST_196), 19.6)
   LOCAL service := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, SERVICE)
   LOCAL emporte := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, EMPORTE)
   LOCAL cb := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, CB)
   LOCAL chq := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, CHQ)
   LOCAL esp := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, ESP)
   LOCAL tr := GET_TOTAL_FIELD_BILAN_ANNEE_MOIS(annee, TR)
   LOCAL data := GET_LISTE_BILANM_IMPRESSION(annee)
   LOCAL itr
   LOCAL init := Chr(27)+Chr(64)
   LOCAL emphasis := Chr(27)+Chr(69)+Chr(1)
   LOCAL emphasisOff := Chr(27)+Chr(69)+Chr(0)
   LOCAL cutting := Chr(29)+Chr(86)+Chr(65)+Chr(0)
   LOCAL doubleHeight := Chr(27)+Chr(33)+Chr(16)
   LOCAL doubleHeightOff := Chr(27)+Chr(33)+Chr(0)
   LOCAL doubleStrike := Chr(27)+Chr(71)+Chr(1)
   LOCAL doubleStrikeOff := Chr(27)+Chr(71)+Chr(0) 
 
   gprinter = GetDefaultPrinter()
   SET PRINTER ON
   SET PRINTER TO &gprinter
   SET CONSOLE OFF
   
   ? init
   ? "ANNEE MOIS NB_CLIENT TOTAL TVA-5.5% TVA-19.6%  SERVICE EMPORTE CB CHQ ESP TR"
   FOR itr := 1 TO LEN(data)
      ? data[itr]
   NEXT
   
   ? "------------------------------------------"
   ? "TOTAL : " + PadL(AllTrim(str(total)), 9) + " " + ;
     "NB CLIENT : " + AllTrim(str(nbClient)) + " " + ;
     "TVA 5.5 % : " + PadL(AllTrim(str(tva1)), 9) + " " + ;
     "TVA 19.6 % : " + PadL(AllTrim(str(tva2)), 9) + " " + ;
     "SERVICE : " + PadL(AllTrim(str(service)), 9) + " " + ;
     "EMPORTE : " + PadL(AllTrim(str(emporte)), 9) + " " + ;
     "CB : " + PadL(AllTrim(str(cb)), 9) + " " + ;
     "CHQ : " + PadL(AllTrim(str(chq)), 9) + " " + ;
     "ESP : " + PadL(AllTrim(str(esp)), 9) + " " + ;
     "TR : " + PadL(AllTrim(str(tr)), 9)
     
   ? cutting
   EJECT
   SET PRINTER TO
   SET PRINTER OFF
   SET CONSOLE ON

RETURN


FUNCTION GET_LISTE_BILANM_IMPRESSION(annee)
   LOCAL ret := {}
   USE BILANM ALIAS bilanm NEW
   INDEX ON bilanm->annee + bilanm->mois TO bilanm
   LOCATE FOR bilanm->annee == annee
   DO WHILE Found()
      AAdd(ret, PadL(AllTrim(str(bilanm->annee)), 4) + " " +;
                PadL(AllTrim(str(bilanm->mois)), 2) + " " +;
                PadL(AllTrim(str(bilanm->nb_client)), 5) + " " +;
                PadL(AllTrim(str(bilanm->total)), 9) + " " +;
                PadL(AllTrim(str(COMPUTE_TVA(bilanm->st_55, 5.5))), 9) + " " +;
                PadL(AllTrim(str(COMPUTE_TVA(bilanm->st_196, 19.6))), 9) + " " +;
                PadL(AllTrim(str(bilanm->service)), 9) + " " +;
                PadL(AllTrim(str(bilanm->emporte)), 9) + " " +;
                PadL(AllTrim(str(bilanm->cb)), 9) + " " +;
                PadL(AllTrim(str(bilanm->chq)), 9) + " "+;
                PadL(AllTrim(str(bilanm->esp)), 9) + " "+;
                PadL(AllTrim(str(bilanm->tr)), 9))
      CONTINUE
   ENDDO   
   CLOSE bilanm
RETURN ret