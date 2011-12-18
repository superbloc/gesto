#include "TBrowse.ch"
#include "Inkey.ch"

/* Méthode et fonction en tout genre */

FUNCTION ENCODE_PRESENTATION_PLAT(aaListePlat)
   LOCAL indice := aaListePlat[1]
   LOCAL codePlat := aaListePlat[2]      
   LOCAL libellePlat := aaListePlat[3]    
   LOCAL quantite := aaListePlat[4]     
   LOCAL prix := aaListePlat[5]       
   LOCAL total := aaListePlat[6]
   LOCAL offert := {"", "*"}[aaListePlat[7] + 1]
   LOCAL remise := ""
   LOCAL output
   IF(aaListePlat[8] > 0)
      remise := "/"
   ENDIF
   output :=   PadL(AllTrim(str(indice)), 2) + " - " +;
            PadL(AllTrim(str(quantite)), 2) + " - " +;
            PadL(AllTrim(codePlat), 4) + " - " +;
            PadR(libellePlat, 32) + " - " +;
            PadL(AllTrim(str(prix)), 7) + " - " +;
            PadL(AllTrim(str(total)), 7) + offert + remise
RETURN output

FUNCTION DECODE_PRESENTATION_PLAT(cString)
   LOCAL tab := HB_RegExSplit(" - ", cString)
RETURN tab

FUNCTION DECODE_GET_CODE_PLAT(cString)
   LOCAL ret := DECODE_PRESENTATION_PLAT(cString)
RETURN PadR(AllTrim(ret[3]), 4)

FUNCTION DECODE_GET_QUANTITE(cString)
   LOCAL ret := DECODE_PRESENTATION_PLAT(cString)
RETURN Val(ret[2])

FUNCTION ENCODE_LISTE_TABLE(aaListeTable)
   LOCAL indice := aaListeTable[1]
   LOCAL numTable := aaListeTable[2]
   LOCAL nbClient := aaListeTable[3]
   LOCAL total := aaListeTable[4]
   
   LOCAL output := PadL(AllTrim(str(indice)), 2) + " -- " + ;
                PadL(AllTrim(numTable), 3) + " / " + ;
               PadL(AllTrim(str(nbClient)), 2) + " | " + ;
               PadL("", 50) + " | " +;
               PadL(AllTrim(str(total)), 7)
RETURN output

FUNCTION DECODE_GET_NUM_TABLE(cString)
   LOCAL retVal := PadR(AllTrim(SubStr(cString, 7, 3)), 3)
RETURN retVal

FUNCTION DECODE_GET_TOTAL(cString)
   LOCAL retVal := Val(SubStr(cString, 70))
RETURN retVal

FUNCTION DECODE_GET_ALL_TOTAL(aaListeTable)
   LOCAL itr
   LOCAL accu := 0
   FOR EACH itr in aaListeTable
      accu += DECODE_GET_TOTAL(itr)
   NEXT
RETURN accu

FUNCTION ENCODE_IMPRESSION_PLATS(aaListePlat)
   LOCAL codePlat := aaListePlat[1]
   LOCAL libelle := aaListePlat[2]
   LOCAL quantite := aaListePlat[3]
   LOCAL prix := PadL(AllTrim(str(aaListePlat[4])), 7)
   LOCAL offert := aaListePlat[5]
   LOCAL output
   IF offert == 1
      prix := PadL("OFFERT", 10)  
   ENDIF
   output := PadR(AllTrim(codePlat), 4) + " " + ;
               PadR(AllTrim(libelle), 24) + " " + ;
               PadR(AllTrim(str(quantite)), 2) + " " + ;
               prix
RETURN output

/* fonction qui calcule la tva selon le taux */

FUNCTION COMPUTE_TVA(somme, tva)
   
   LOCAL retVal := 0
   LOCAL pourcent := tva / 100
   retVal := Round(somme * pourcent / (1 + pourcent), 2)
RETURN retVal


   #xtrans  :data   =>   :cargo\[1]
   #xtrans  :recno  =>   :cargo\[2]

   PROCEDURE DISP_CELLS(aHeading, aWidth, data, type, annee, mois)
     LOCAL i, nKey, bBlock, oTBrowse, oTBColumn   
      // Create TBrowse object   
      // data source is the Directory() array
      oTBrowse := TBrowse():new( 2, 2, MaxRow()-8, MaxCol()-2 )
      //oTBrowse:cargo         := { Directory( "*.*" ), 1 }
     oTBrowse:cargo := {data, 1}
      
      oTBrowse:headSep       := "-"
      oTBrowse:colorSpec     := "N/BG,W+/R"
     oTBrowse:border        := "R"

      // Navigation code blocks for array
      oTBrowse:goTopBlock    := {|| oTBrowse:recno := 1 }
      oTBrowse:goBottomBlock := {|| oTBrowse:recno := Len( oTBrowse:data ) }
      oTBrowse:skipBlock     := {|nSkip| ArraySkipper( nSkip, oTBrowse ) }

      // create TBColumn objects and add them to TBrowse object
      FOR i:=1 TO Len( aHeading )

         // code block for individual columns of the array
         bBlock    := ArrayBlock( oTBrowse, i )

         oTBColumn := TBColumn():new( aHeading[i], bBlock )
         oTBColumn:width := aWidth[i]

         oTBrowse:addColumn( oTBColumn )
      NEXT

      // display browser and process user input
      DO WHILE .T.
         oTBrowse:forceStable()
         nKey := Inkey(0)

         IF oTBrowse:applyKey( nKey ) == TBR_EXIT
            EXIT
         ENDIF
       IF nKey == 105 .OR. nKey == 75   // touche ascii pour la lettre i
         SWITCH type
            case 0
               PRINT_BILANM(annee)
            case 1
               PRINT_BILAN(annee, mois)
         END
       ENDIF
      ENDDO

   RETURN

   // This code block uses detached LOCAL variables to
   // access single elements of a two-dimensional array.
   FUNCTION ArrayBlock( oTBrowse, nSubScript )
   RETURN {|| oTBrowse:data[ oTBrowse:recno, nSubScript ] }

   // This function navigates the row pointer of the
   // the data source (array)
   FUNCTION ArraySkipper( nSkipRequest, oTBrowse )
      LOCAL nSkipped
      LOCAL nLastRec := Len( oTBrowse:data ) // Length of array

      IF oTBrowse:recno + nSkipRequest < 1
         // skip requested that navigates past first array element
         nSkipped := 1 - oTBrowse:recno

      ELSEIF oTBrowse:recno + nSkipRequest > nLastRec
         // skip requested that navigates past last array element
         nSkipped := nLastRec - oTBrowse:recno

      ELSE
         // skip requested that navigates within array
         nSkipped := nSkipRequest
      ENDIF

      // adjust row pointer
      oTBrowse:recno += nSkipped

   // tell TBrowse how many rows are actually skipped.
   RETURN nSkipped