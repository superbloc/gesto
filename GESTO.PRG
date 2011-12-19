#include "Inkey.ch"
#include "Achoice.ch"
#include "Box.ch"
#include "Set.ch"

REQUEST HB_LANG_FR

/* Déclaration des constantes pour paramétrer les infos concernant le restaurant */
#define SOCIETE "restaurant"
#define NOM_SOCIETE "china star"
#define ADR "65, rue henri laroche"
#define CODE_POSTAL "60800"
#define VILLE "crepy-en-valois"
#define TEL 0344941888
#define SIRET 44153813200013
#define DEFAUT_REMISE 10

STATIC nRow := 25
STATIC nCol := 80
STATIC listePaiement := {"CBleue", "Cheque", "Especes", "TRestaurant"}

GLOBAL EXTERN vatChangeDate
GLOBAL EXTERN vatBeforeChangeDate
GLOBAL EXTERN vatAfterChangeDate

PROCEDURE MAIN()
	LOCAL aaParam := {}
	LOCAL aSet
	LOCAL actualisation
	LOCAL listeTable
	LOCAL numTable // utiliser seulement dans l'ajout d'un plat, code à revoir
	SetMode(nRow, nCol)
	HB_SetCodePage("FR")
	SET DATE TO FRENCH
	INIT_GLOBALVAR()         // initialisation des variables globales des paramétres.
	KEYBOARD Chr(255)        // pour que la première fois qu'on entre dans l'appli, on applique une réactualisation de l'écran
	Inkey()
	DO WHILE LastKey() <> 81 .AND. LastKey() <> 113
		actualisation := .T.
		SWITCH LastKey()
			CASE 65   // code ASCII pour 'A'
			CASE 97   // code ASCII pour 'a'
				numTable := DISP_VIEW_TABLE()
				IF numTable <> NIL
					ADD_MENU_TO_TABLE(GET_NFACT(numTable), numTable, GET_NB_CLIENT(GET_NFACT(numTable)))
					KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
					Inkey()
					VIEW_TABLE(GET_NFACT(numTable))
				ENDIF
				EXIT
			CASE 70   // code ASCII pour 'F'
			CASE 102  // code ASCII pour 'f'
				DISP_FICHE_INFO_WINDOW()
				EXIT
			CASE 78   // code ASCII pour 'N'
			CASE 110  // code ASCII pour 'n'
				aaParam := DISP_CREATION_TABLE()
				IF(aaParam[1] <> -1)
					ADD_MENU_TO_TABLE(aaParam[1], aaParam[2], aaParam[3])
					VIEW_TABLE(aaParam[1])
				ENDIF
				EXIT
			CASE 77   // code ASCII pour 'M'
			CASE 109  // code ASCII pour 'm'
				numTable = DISP_VIEW_TABLE()
				IF numTable <> NIL
					VIEW_TABLE(GET_NFACT(numTable))
				ENDIF
				EXIT
			CASE 84   // code ASCII pour 'T'
			CASE 116  // code ASCII pour 't'
				VIEW_LISTE_TABLE(listeTable)
				EXIT
			CASE 69   // code ASCII pour 'E'
			CASE 101  // code ASCII pour 'e'
				DISP_ENCAISSEMENT_WINDOW()
				EXIT
			CASE 71   // code ASCII pour 'G'
			CASE 103  // code ASCII pour 'g'
				VIEW_EDIT_MENU()
				EXIT
			CASE 74   // code ASCII pour 'J'
			CASE 106  // code ASCII pour 'j'
				DISP_BILAN(Year(Date()), Month(Date()))
				EXIT
			CASE 85   // code ASCII pour 'U'
			CASE 117  // code ASCII pour 'u' 
				DISP_BILAN_ENTRY_WINDOW()
				EXIT
			CASE 89   // code ASCII pour 'Y'
			CASE 121  // code ASCII pour 'y'
				DISP_BILAN_ANNEE_MOIS_ENTRY_WINDOW()
				EXIT
			CASE 72   // code ASCII pour 'H'
			CASE 104  // code ASCII pour 'h'
				DISP_BILAN_ANNEE_MOIS(Year(Date()))
				EXIT
			CASE 66  //  code ASCII pour 'B'
			CASE 98  //  code ASCII pour 'b'
				VIEW_LISTE_RECETTE()
				EXIT
			CASE 80  //  code ASCII pour 'P'
			CASE 112 //  code ASCII pour 'p'
				DISP_PARAMETERS()
				EXIT
			CASE 255 
				EXIT
			DEFAULT
				actualisation := .F.
				EXIT
		END
		IF actualisation
			DISP_MAIN_WINDOW()
			listeTable := GET_LISTE_TABLE() // on stocke la liste des tables ici afin de gagner en rapidité
		ENDIF
		Inkey(0)
	ENDDO
	SetColor("W+/N")
	CLS
RETURN

PROCEDURE DISP_MAIN_WINDOW()
	SetColor( "W+/B+,B+/W" )
	CLS
	DispBox(0, 0, nRow - 1, nCol - 1, B_DOUBLE, "G+/B+")
	HB_LangSelect("FR")
	SET CENTURY ON
	SET DATE TO AMERICAN
	@ 10, 10 SAY vatChangeDate
	@ 11, 10 SAY vatBeforeChangeDate
	@ 12, 10 SAY vatAfterChangeDate
	DISP_DATE()
	DISP_TABLE()
	DISP_HEADER()
RETURN

PROCEDURE DISP_HEADER()
	@ 10, 50 SAY SOCIETE + " " + NOM_SOCIETE PICTURE "@!" COLOR "W+/B+"
	@ 11, 50 SAY ADR PICTURE "@!" COLOR "W+/B+"
	@ 12, 50 SAY CODE_POSTAL + " " + VILLE PICTURE "@!" COLOR "W+/B+"
	@ 13, 50 SAY TEL PICTURE "@LR TEL : 99 99 99 99 99" COLOR "W+/B+" 
	@ 14, 50 SAY SIRET PICTURE "@LR SIRET : 999 999 999 99999" COLOR "W+/B+"
RETURN

PROCEDURE DISP_DATE()
	LOCAL date := DATE()
	@ 3, 5 SAY CDoW(date) + " " + str(Day(date)) + " " + CMonth(date) + " " + str(Year(date)) COLOR "GR+/B+"
	@ 4, 5 SAY Time() COLOR "GR+/B+"
RETURN

PROCEDURE DISP_TABLE()
	LOCAL beginRow := 16
	LOCAL beginCol := 3
	LOCAL color
	@ beginRow, beginCol SAY "table : " PICTURE "@!" COLOR "RB+/B+"
	DispBox(beginRow - 1, 1, nRow - 2, nCol - 2, B_SINGLE, "R+/B+")
	USE ListeTable NEW
	DO WHILE .NOT. Eof()
		color := "W+/B+"
		IF FieldGet(7) == 1
			color := "G/B+"
		ENDIF
		@ beginRow + 2, beginCol SAY FieldGet(1) COLOR color
	SKIP
	IF beginCol >= 75
		beginCol := 3
		beginRow++
	ELSE
		beginCol += 4
	ENDIF
	ENDDO
	CLOSE ListeTable
RETURN

PROCEDURE VIEW_EDIT_MENU()
	LOCAL nSelect
	LOCAL listePlat := {}
	LOCAL position := 1
	CLS
	DispBox(0, 6, nRow - 1, nCol - 6, B_SINGLE, "RB+/B+")
	DO WHILE LastKey() <> K_ESC
		@ 1, 7 CLEAR TO nRow - 2, nCol - 7
		listePlat := GET_ALL_PLAT()
		IF LEN(listePlat) == 0
			ADD_PLAT()
		ELSE
			nSelect := Achoice(1, 7, nRow - 2, nCol - 7, listePlat, {} , "gestion_edition_plat", position)
			SWITCH LastKey()
				CASE 83    // code ASCII pour 'S'
				CASE 115   // code ASCII pour 's'
					DELETE_PLAT(GET_CODE_PLAT_FROM_RECORD(listePlat[nSelect]))
					KEYBOARD Chr(255)
					Inkey()
					EXIT
				CASE 65   // code ASCII pour 'A'
				CASE 97   // code ASCII pour 'a'
					ADD_PLAT()
					KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
					Inkey()
					EXIT
				CASE 77   // code ASCII pour 'M'
				CASE 109  // code ASCII pour 'm'
					MODIF_PLAT(listePlat[nSelect])
					KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
					Inkey()
					EXIT
				CASE 82   // code ASCII pour 'R'
				CASE 114  // code ASCII pour 'r'
					position := RECHERCHE_PLAT()
					KEYBOARD Chr(255)
					Inkey()
					EXIT
			END
		ENDIF
	ENDDO
RETURN

PROCEDURE ADD_PLAT()
	LOCAL codePlat := space(4)
	LOCAL libelle := space(32)
	LOCAL prix := 0
	LOCAL categorie := "P"
	LOCAL stockage := "N"
	LOCAL GetList := {}
	@ 5, 8 CLEAR TO 20, 72
	DispBox(5, 8, 20, 72, B_SINGLE, "G+/B+")
	DO WHILE LastKey() <> K_ESC
		@ 10, 15 SAY "code : " PICTURE "@!" COLOR "RB+/B+" GET codePlat PICTURE "@!"
		@ 11, 15 SAY "libelle : " PICTURE "@!" COLOR "RB+/B+" GET libelle PICTURE "@!"
		@ 12, 15 SAY "prix : " PICTURE "@!" COLOR "RB+/B+" GET prix PICTURE "9999999.99"
		@ 13, 15 SAY "categorie : " PICTURE "@!" COLOR "RB+/B+" GET categorie PICTURE "@!"
		@ 14, 15 SAY "stockage : " PICTURE "@!" COLOR "RB+/B+" GET stockage PICTURE "@!"
		READ
		IF codePlat == space(4)
			@ 16, 15 SAY "code plat vide !!" PICTURE "@!" COLOR "R+/B+"
			LOOP
		ENDIF
		IF LastKey() == K_ESC
			EXIT
		ENDIF
		IF CHECK_CODE_PLAT(PadR(AllTrim(codePlat), 4))
			@ 16, 15 SAY "code plat deja existant !!" PICTURE "@!" COLOR "R+/B+"
			LOOP
		ENDIF
		INSERER_PLAT(codePlat, libelle, prix, categorie, stockage)
		EXIT
	ENDDO
RETURN

PROCEDURE MODIF_PLAT(record)
	LOCAL info := GET_INFO_FROM_RECORD(record)
	LOCAL codePlat := info[1]
	LOCAL libelle := info[2]
	LOCAL prix := info[3]
	LOCAL categorie := info[4]
	LOCAL stockage := info[5]
	LOCAL GetList := {}
	@ 5, 8 CLEAR TO 20, 72
	DispBox(5, 8, 20, 72, B_SINGLE, "G+/B+")
	DO WHILE LastKey() <> K_ESC
		@ 10, 15 SAY "code : " PICTURE "@!" COLOR "RB+/B+" GET codePlat PICTURE "@!" WHEN .F.
		@ 11, 15 SAY "libelle : " PICTURE "@!" COLOR "RB+/B+" GET libelle PICTURE "@!"
		@ 12, 15 SAY "prix : " PICTURE "@!" COLOR "RB+/B+" GET prix PICTURE "9999999.99"
		@ 13, 15 SAY "categorie : " PICTURE "@!" COLOR "RB+/B+" GET categorie PICTURE "@!"
		@ 14, 15 SAY "stockage : " PICTURE "@!" COLOR "RB+/B+" GET stockage PICTURE "@!"
		READ
		UPDATE_PLAT(codePlat, libelle, prix, categorie, stockage)
		EXIT
	ENDDO
RETURN

FUNCTION RECHERCHE_PLAT()
	LOCAL GetList := {}
	LOCAL codePlat := space(4)
	LOCAL position
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	@ 12, 30 SAY "code plat : " PICTURE "@!" GET codePlat PICTURE "@!"
	READ
	IF LastKey() <> K_ESC
		position := RECHERCHE_PLAT_PAR_CODE(codePlat)
		IF position <= 0
			@ 13, 30 SAY "code inexistant !!"
			position := 1
			Inkey(0)
		ENDIF
	ENDIF
	SetColor("W+/B+")
RETURN position

FUNCTION DISP_CREATION_TABLE
	LOCAL GetList := {}
	LOCAL numTable := space(3)
	LOCAL nbClient := 0
	LOCAL nFact := -1
	SetColor("W+/RG")
	@ 7, 20 CLEAR TO 17, 60
	DispBox(7, 20, 17, 60, B_DOUBLE, "BG+/RG")
	@ 7, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	DO WHILE LastKey() <> K_ESC
		@ 10, 25 SAY "numero table : " PICTURE "@!" GET numTable PICTURE "@!"
		@ 12, 25 SAY "nombre de clients : " PICTURE "@!" GET nbClient PICTURE "99"
		READ
		IF LastKey() == K_ESC
			EXIT
		ENDIF
		IF numTable == space(3)
			@ 11, 25 SAY "numero table vide !!" PICTURE "@!" COLOR "R+/RG"
 			LOOP
		ELSE
			IF TEST_EXISTENCE_TABLE(numTable)
				@ 13, 25 SAY "table deja existante !!" PICTURE "@!" COLOR "R+/RG"
				LOOP
			ELSE
				nFact := INSERER_LISTE_TABLE(numTable, nbClient)
				EXIT
			ENDIF
		ENDIF
		USE
	ENDDO
RETURN {nFact, numTable, nbClient}

FUNCTION DISP_VIEW_TABLE
	LOCAL GetList := {}
	LOCAL numTable := space(3)
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	DO WHILE LastKey() <> K_ESC
		@ 12, 25 SAY "numero table : " PICTURE "@!" GET numTable PICTURE "@!"
		READ
		IF LastKey() == K_ESC
			numTable := NIL
			EXIT
		ENDIF
		IF TEST_EXISTENCE_TABLE(numTable)
			EXIT
		ELSE
			@ 13, 25 SAY "table inexistante !!" PICTURE "@!" COLOR "R+/RG"
		ENDIF
	ENDDO
RETURN numTable

PROCEDURE DISP_ENCAISSEMENT_WINDOW
	LOCAL GetList := {}
	LOCAL numTable := space(3)
	
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	//@ 8, 15 CLEAR TO 12, 60
	//DispBox(8, 15, 12, 60, B_SINGLE, "G+/B+")
	@ 12, 25 SAY "encaissement table : " PICTURE "@!" GET numTable PICTURE "@!"
	READ
	IF TEST_EXISTENCE_TABLE(numTable)
		ENCAISSEMENT_TABLE(GET_NFACT(numTable), numTable)
	ENDIF
RETURN

PROCEDURE ENCAISSEMENT_TABLE(nFact, numTable)
	LOCAL nLength := Round(nCol / Len(listePaiement), 0)
	LOCAL beginRow := 2
	LOCAL beginCol := 2
	LOCAL itr
	LOCAL totalCarteBleue := 0
	LOCAL totalCheque := 0
	LOCAL totalEspece := 0
	LOCAL totalTicketResto := 0
	LOCAL totalAregler := Round(GET_TOTAL(nFact) - GET_TOTAL_REMISE(nFact), 2)
	LOCAL restantAregler := totalAregler
	LOCAL date := GET_DATE_CREATION(nFact)
	LOCAL reglementPanier := {"CB" => 0, "CHQ" => 0, "ESP" => 0, "TR" => 0, "TOTAL" => 0, "AREGLER" => restantAregler, "TOTAL_A_REGLER" => totalAregler}
	LOCAL quit
	DISP_ENCAISSEMENT_TABLE(numTable)
	FOR EACH itr IN listePaiement
		@ beginRow, beginCol + (HB_EnumIndex() - 1) * nLength SAY itr  
	NEXT
	DO WHILE LastKey() <> K_ESC
		DISP_REGLEMENT(reglementPanier)
		SWITCH LastKey()
			CASE 66  	// code ASCII pour 'B'
			CASE 98     // code ASCII pour 'b'
				reglementPanier["TOTAL"] -= reglementPanier["CB"]
				reglementPanier["AREGLER"] += reglementPanier["CB"]
				reglementPanier["CB"] = 0
				DISP_REGLEMENT(reglementPanier)
				totalCarteBleue := CARTE_BLEUE_PAIEMENT(beginCol, @reglementPanier)
				EXIT
			CASE 67	    // code ASCII pour 'C'
			CASE 99     // code ASCII pour 'c'
				reglementPanier["TOTAL"] -= reglementPanier["CHQ"]
				reglementPanier["AREGLER"] += reglementPanier["CHQ"]
				reglementPanier["CHQ"] = 0
				DISP_REGLEMENT(reglementPanier)
				totalCheque := CHEQUE_PAIEMENT(beginCol + nLength, @reglementPanier)
				EXIT
			CASE 69     // code ASCII pour 'E'
			CASE 101    // code ASCII pour 'e'
				reglementPanier["TOTAL"] -= reglementPanier["ESP"]
				reglementPanier["AREGLER"] += reglementPanier["ESP"]
				reglementPanier["ESP"] = 0
				DISP_REGLEMENT(reglementPanier)
				totalEspece := ESPECE_PAIEMENT(beginCol + 2 * nLength, @reglementPanier)
				EXIT
			CASE 84     // code ASCII pour 'T'
			CASE 116    // code ASCII pour 't'
				reglementPanier["TOTAL"] -= reglementPanier["TR"]
				reglementPanier["AREGLER"] += reglementPanier["TR"]
				reglementPanier["TR"] = 0
				DISP_REGLEMENT(reglementPanier)
				totalTicketResto := TICKET_RESTO_PAIEMENT(beginCol + 3 * nLength, @reglementPanier)
				EXIT
		END
		quit := Round(reglementPanier["AREGLER"], 2) <= 0
	Inkey(0)
	IF quit
		ENCAISSER(nFact, numTable, reglementPanier, date)
		EXIT
	ENDIF
	ENDDO
RETURN

PROCEDURE ENCAISSER(nFact, numTable, panier, date)
	LOCAL nbClient := GET_NB_CLIENT(nFact)
	LOCAL typeService := GET_ST(nFact)
	DELETING_TABLE(nFact)
	USE RECETTEJ ALIAS recette NEW
	APPEND BLANK
	REPLACE recette->date WITH date, ;
			recette->num_table WITH numTable, ;
			recette->nfact WITH nFact, ;
			recette->nb_client WITH nbClient, ;
			recette->total WITH panier["TOTAL"] + panier["AREGLER"], ;
			recette->cb WITH panier["CB"], ;
			recette->chq WITH panier["CHQ"], ;
			recette->esp WITH panier["ESP"] + panier["AREGLER"], ;
			recette->tr WITH panier["TR"], ;
			recette->status WITH typeService
	CLOSE recette
RETURN

FUNCTION CHECK_REGLEMENT(totalCarteBleue, totalCheque, totalEspece, totalTicketResto, restantAregler)
	LOCAL cumul := totalCarteBleue + totalCheque + totalEspece + totalTicketResto
	LOCAL dispSomme := restantAregler - cumul
	LOCAL quit := dispSomme <= 0
	//@ 22, 20 SAY "somme a regler : " + str(dispSomme) PICTURE "@!"
RETURN quit


PROCEDURE DISP_REGLEMENT(panier)
	@ 17, 2 SAY "CB : "
	@ 17, 5 SAY panier["CB"] PICTURE "9999.99" COLOR "BG+/G" 
	@ 17, 20 SAY "CHQ : "
	@ 17, 25 SAY panier["CHQ"] PICTURE "9999.99" COLOR "BG+/G"
	@ 17, 40 SAY "ESP : "
	@ 17, 45 SAY panier["ESP"] PICTURE "9999.99" COLOR "BG+/G"
	@ 17, 60 SAY "TR : "
	@ 17, 65 SAY panier["TR"] PICTURE "9999.99" COLOR "BG+/G"
	@ 20, 2 SAY "Total recu : " + AllTrim(str(panier["TOTAL"]))
	@ 20, 30 SAY "somme a regler : " + AllTrim(str(panier["AREGLER"]))
	@ 22, 15 SAY "total a regler : " + AllTrim(str(panier["TOTAL_A_REGLER"]))
RETURN

FUNCTION CARTE_BLEUE_PAIEMENT(startCol, panier)
	LOCAL totalCarteBleue := 0
	LOCAL cpt := 12
	LOCAL beginRow := 4
	LOCAL GetList := {}
	LOCAL nCarteBleue
	DO WHILE cpt > 0 .AND. LastKey() <> K_ESC
		nCarteBleue := 0
		@ beginRow, startCol GET nCarteBleue PICTURE "9999.99"
		READ
		panier["CB"] += nCarteBleue
		panier["TOTAL"] += nCarteBleue
		panier["AREGLER"] -= nCarteBleue
		totalCarteBleue += nCarteBleue
		IF panier["AREGLER"] <= 0
			EXIT
		ENDIF
		DISP_REGLEMENT(panier)
		beginRow ++
		cpt--
	ENDDO
	DISP_REGLEMENT(panier)
RETURN totalCarteBleue

FUNCTION CHEQUE_PAIEMENT(startCol, panier)
	LOCAL totalCheque := 0
	LOCAL cpt := 12
	LOCAL beginRow := 4
	LOCAL GetList := {}
	LOCAL nCheque
	DO WHILE cpt > 0 .AND. LastKey() <> K_ESC
		nCheque := 0
		@ beginRow, startCol GET nCheque PICTURE "9999.99"
		READ
		panier["CHQ"] += nCheque
		panier["TOTAL"] += nCheque
		panier["AREGLER"] -= nCheque
		totalCheque += nCheque
		IF panier["AREGLER"] <= 0
			EXIT
		ENDIF
		DISP_REGLEMENT(panier)
		beginRow ++
		cpt--
	ENDDO
	DISP_REGLEMENT(panier)
RETURN totalCheque

FUNCTION ESPECE_PAIEMENT(startCol, panier)
	LOCAL totalEspece := 0
	LOCAL beginRow := 4
	LOCAL GetList := {}
	@ beginRow, startCol GET totalEspece PICTURE "9999.99"
	READ
	panier["ESP"] += totalEspece
	panier["TOTAL"] += totalEspece
	panier["AREGLER"] -= totalEspece
	DISP_REGLEMENT(panier)
RETURN totalEspece

FUNCTION TICKET_RESTO_PAIEMENT(startCol, panier)
	LOCAL totalTicketResto := 0
	LOCAL GetList := {}
	LOCAL beginRow := 4
	LOCAL nTicketResto
	LOCAL quantite
	LOCAL totalIntermediaire
	LOCAL cpt := 12
	DO WHILE cpt > 0 .AND. LastKey() <> K_ESC
		nTicketResto := 0
		quantite := 1
		@ beginRow, startCol GET nTicketResto PICTURE "99.99"
		READ
		@ beginRow, startCol + 6 GET quantite PICTURE "99"
		READ
		totalIntermediaire := nTicketResto * quantite
		@ beginRow, startCol + 9 SAY totalIntermediaire PICTURE "9999.99"
		panier["TR"] += totalIntermediaire
		panier["TOTAL"] += totalIntermediaire
		panier["AREGLER"] -= totalIntermediaire
		IF panier["AREGLER"] <= 0
			EXIT
		ENDIF
		DISP_REGLEMENT(panier)
		totalTicketResto += totalIntermediaire
		beginRow ++
		cpt--
	ENDDO
	DISP_REGLEMENT(panier)
RETURN totalTicketResto

PROCEDURE DISP_ENCAISSEMENT_TABLE(numTable)
	SetColor( "W+/B+,B+/W" )
	CLS
	DispBox(0, 0, nRow - 1, nCol -1, B_DOUBLE, "RB+/B+")
	@ 0, 20 SAY "encaissement de la table : " + numTable PICTURE "@!" 
	DispBox(19, 1, 19, 78, B_SINGLE, "RB+/B+") 
RETURN

PROCEDURE DISP_FICHE_INFO_WINDOW()
	LOCAL GetList := {}
	LOCAL nbClient := 0
	LOCAL date := Date()
	LOCAL prix := 0
	setColor("W+/RB+")
	@ 6, 10 CLEAR TO 20, 70
	DispBox(6, 10, 20, 70, B_SINGLE, "G+/B+")
	@ 7, 20 SAY "impression fiche !" PICTURE "@!" COLOR "RB+/B+"
	@ 10, 15 SAY "date : " PICTURE "@!" COLOR "RB+/B+" GET date PICTURE "@D"
	@ 12, 15 SAY "nb client : " PICTURE "@!" COLOR "RB+/B+" GET nbClient PICTURE "999" RANGE 0, 100
	@ 14, 15 SAY "prix : " PICTURE "@!" COLOR "RB+/B+" GET prix PICTURE "9999.99" RANGE 0, 1000
	READ
	IMPRIME_FICHE(date, nbClient, prix, 5.5)
RETURN 

PROCEDURE VIEW_TABLE(nFact)
	LOCAL nbClient
	LOCAL platListe
	LOCAL total
	LOCAL dispTotal
	LOCAL totalBoisson
	LOCAL totalPlat
	LOCAL index 
	LOCAL beginRow
	LOCAL nSelectPlat
	LOCAL tauRemise
	LOCAL totalRemise
	LOCAL realNumTable := GET_NUM_TABLE(nFact)
	//LOCAL defaultRemise := 10
	LOCAL exitCondition := (GET_NB_PLAT(nFact) == 0)
	DO WHILE LastKey() <> K_ESC .AND. .NOT. exitCondition
		nbClient := GET_NB_CLIENT(nFact)
		platListe := GET_LISTE_PLAT(nFact)
		totalBoisson := platListe[Len(platListe)]
		totalPlat := platListe[Len(platListe) - 1]
		total := totalBoisson + totalPlat
		totalRemise := Round(GET_TOTAL_REMISE(nFact), 2)
		tauRemise := GET_TAUX(nFact)
		//dispTotal := Round(total * (tauRemise / 100), 2)
		dispTotal := Round(total - totalRemise, 2)
		index := 1
		beginRow := 3
		nSelectPlat := 0
		exitCondition := GET_NB_PLAT(nFact) == 0
		IF(exitCondition)
			EXIT
		ENDIF
		SetColor("W+/B+")
		CLS
		DispBox(0, 0, nRow - 1, nCol - 1, B_SINGLE, "BG+/B+")
		DispBox(beginRow, 3, 22, 78, B_DOUBLE, "G+/B+")
		@1, 1 SAY "table : " + realNumTable PICTURE "@!" COLOR "R+/B+"
		@1, 20 SAY "nb client : " + str(nbClient) PICTURE "@!" COLOR "R+/B+"
		@1, 50 SAY "total : " + str(dispTotal) PICTURE "@!" COLOR "R+/B+"
		@2, 1 SAY "tva 19.6% : " PICTURE "@!" COLOR "R+/B+"
		@2, 12 SAY Round(totalBoisson * (tauRemise / 100) * 0.196 / 1.196, 2) PICTURE "999.99"
		@2, 20 SAY "tva 5.5% : " PICTURE "@!" COLOR "R+/B+"
		@2, 30 SAY Round(totalPlat * (tauRemise / 100) * 0.055 / 1.055, 2) PICTURE "999.99"
		//@2, 45 SAY "tau remise : " + str(100 - tauRemise) + "%" PICTURE "@!" COLOR "R+/B+"
		@2, 45 SAY "remise : " + AllTrim(str(totalRemise)) PICTURE "@!" COLOR "R+/B+"
		nSelectPlat := Achoice(beginRow + 1, 6, 20, 75, platListe, {}, "USERFUNC")
		SWITCH LastKey()
			CASE 83    // code ASCII pour 'S'
			CASE 115   // code ASCII pour 's'
				DELETING_RECORD(nFact, platListe[nSelectPlat])
				EXIT
			CASE 65   // code ASCII pour 'A'
			CASE 97   // code ASCII pour 'a'
				ADD_MENU_TO_TABLE(nFact, realNumTable, nbClient)
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 77   // code ASCII pour 'M'
			CASE 109  // code ASCII pour 'm'
				MODIF_RECORD(nFact, platListe[nSelectPlat])
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 87   // code ASCII pour 'W'
			CASE 119  // code ASCII pour 'w'
				MODIF_NB_CLIENT(nFact, nbClient)
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 84   // code ASCII pour 'T'
			CASE 116  // code ASCII pour 't'
				realNumTable := MODIF_NUM_TABLE(nFact, nbClient)
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 82   // code ASCII pour 'R'
			CASE 114  // code ASCII pour 'r'
				APPLICATION_REDUCTION(nFact, DEFAUT_REMISE)
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 70   // code ASCII pour 'F'
			CASE 102  // code ASCII pour 'f'
				IMPRIME_FICHE(GET_DATE_CREATION(nFact), nbClient, dispTotal, 5.5)
				KEYBOARD Chr(255)  // Pour que le ESC de l'annulation ne soit pas intercepté par la boucle principale
				Inkey()
				EXIT
			CASE 69   // code ASCII pour 'E'
			CASE 101  // code ASCII pour 'e'
				IMPRIME_ADDITION_TVA1(nFact)
				KEYBOARD Chr(255)
				Inkey()
				EXIT
			CASE 73   // code ASCII pour 'I'
			CASE 105  // code ASCII pour 'i'
				IMPRIME_ADDITION_TVA2(nFact)
				KEYBOARD Chr(255)
				Inkey()
				EXIT
			CASE 45  // code ASCII pour '-'
				SET_OFFERT_STATUS(nFact, DECODE_GET_CODE_PLAT(platListe[nSelectPlat]))
				EXIT
			CASE K_F5 // code ASCII pour 'F5'
				UPDATE_REMISE(nFact, DECODE_GET_CODE_PLAT(platListe[nSelectPlat]), DEFAUT_REMISE)
				EXIT
		END
	ENDDO
RETURN

PROCEDURE VIEW_LISTE_TABLE(listeTable)
	LOCAL nSelectTable
	LOCAL dataList
	CLS
	DispBox(0, 0, nRow - 1, nCol - 1, B_SINGLE, "BG+/B+")
	@ 0, 30 SAY "affichage liste table " PICTURE "@!"
	DispBox(nRow - 5, 1, nRow - 5, nCol - 2, B_SINGLE, "BG+/B+")
	@ nRow - 5, 60 SAY "total : " + AllTrim(str(DECODE_GET_ALL_TOTAL(listeTable))) PICTURE "@!"
	@ nRow - 5, 20 SAY "clients : " + AllTrim(str(GET_TOTAL_CLIENT())) PICTURE "@!"
	nSelectTable := Achoice(2, 2, nRow - 6, nCol - 2, listeTable)
	IF nSelectTable > 0
		VIEW_TABLE(GET_NFACT(DECODE_GET_NUM_TABLE(listeTable[nSelectTable])))
	ENDIF
RETURN

PROCEDURE VIEW_LISTE_RECETTE()
	LOCAL hash := GET_ALL_DATE()
	LOCAL listeDate := {}
	LOCAL i, nSelectDate
	CLS
	FOR i := 1 TO Len(hash)
		AAdd(listeDate, DtoC(HGetKeyAt(hash, i)))
	NEXT
	DispBox(5, 5, 15, 15, B_SINGLE, "G+/B+")
	@ 5, 8 SAY "RECETTE"
	nSelectDate := Achoice(6, 6, 14, 14, listeDate)
	IF nSelectDate > 0
		VIEW_LISTE_RECETTE_BY_DATE(HGetKeyAt(hash, nSelectDate))
	ENDIF
RETURN

PROCEDURE VIEW_LISTE_RECETTE_BY_DATE(date)
	LOCAL nSelectFact
	LOCAL retVal
	LOCAL mapping
	LOCAL listeRecette
	DO WHILE LastKey() <> K_ESC
		CLS
		DispBox(0, 0, nRow - 1, nCol - 1, B_SINGLE, "BG+/B+")
		@ 0, 30 SAY "bilan de la journee " + DtoC(date) PICTURE "@!"
		DispBox(nRow - 8, 1, nRow - 8, nCol - 2, B_SINGLE, "BG+/B+")
		DISP_RECETTE_TITLE_HEADER()
	
		retVal := GET_LISTE_RECETTE(date)
		listeRecette := retVal[1]
		mapping := retVal[2]
		IF LEN(listeRecette) == 0
			EXIT
		ENDIF
		DISP_RECETTE_TOTAL(date)
		nSelectFact := Achoice(2, 2, nRow - 9, nCol - 2, listeRecette, {}, "recetteUserFunc")
		SWITCH LastKey()
			CASE 83      //code ASCII pour "S"
			CASE 115     //code ASCII pour "s"
				DELETE_RECETTE(mapping[nSelectFact])   // supprime la recette de la facture 
				DELETING_MULTI_RECORD(mapping[nSelectFact])   // supprime tous les plats de la facture 
				KEYBOARD Chr(255)
				Inkey()
				EXIT
			CASE 77      //code ASCII pour "M"
			CASE 109     //code ASCII pour "m"
				EDIT_RECETTE(mapping[nSelectFact])
				KEYBOARD Chr(255)
				Inkey()
				EXIT
			CASE 67      // code ASCII pour "C"
			CASE 99      // code ASCII pour "c"
				CLOTURER(date)
				KEYBOARD Chr(255)
				Inkey()
				EXIT
			CASE K_RETURN
				VIEW_TABLE(mapping[nSelectFact])
				KEYBOARD Chr(255)
				Inkey()
				EXIT
		END
	ENDDO
RETURN

PROCEDURE DISP_RECETTE_TITLE_HEADER()
	@ 1, 2 SAY "   #  tbl clt       cb          chq           esp           tr           total" PICTURE "@!"
RETURN

PROCEDURE CLOTURER(date)
	LOCAL nbClient := GET_NB_CLIENT_RECETTE(date)
	LOCAL total := GET_TOTAL_RECETTE(date)
	LOCAL st_55 := GET_TVA_1(date)
	LOCAL st_196 := GET_TVA_2(date)
	LOCAL tva1 := COMPUTE_TVA(GET_TVA_1(date), 5.5)
	LOCAL tva2 := COMPUTE_TVA(GET_TVA_2(date), 19.6)
	LOCAL service := GET_TOTAL_RECETTE_SERVICE(date)
	LOCAL emporte := GET_TOTAL_RECETTE_EMPORTE(date)
	LOCAL cb := GET_TOTAL_CB(date)
	LOCAL chq := GET_TOTAL_CHQ(date)
	LOCAL esp := GET_TOTAL_ESP(date)
	LOCAL tr := GET_TOTAL_TR(date)
	LOCAL annee := Year(date)
	LOCAL mois := Month(date)
	LOCAL getList := {}
	@ 5, 5 CLEAR TO 20, 70
	DispBox(6, 6, 19, 69, B_SINGLE, "G+")
	@ 7, 8 SAY "date : " PICTURE "@!" GET date PICTURE "@D" COLOR "W+/GB+" WHEN .F.
	@ 8, 8 SAY "total : " PICTURE "@!" GET total PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 9, 8 SAY "service : " PICTURE "@!" GET service PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 10, 8 SAY "emporte : " PICTURE "@!" GET emporte PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 11, 8 SAY "ST tva 5.5% : " PICTURE "@!" GET st_55 PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 12, 8 SAY "ST tva 19.6% : " PICTURE "@!" GET st_196 PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 13, 8 SAY "carte bleue : " PICTURE "@!" GET cb PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 14, 8 SAY "cheque : " PICTURE "@!" GET chq PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 15, 8 SAY "especes : " PICTURE "@!" GET esp PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	@ 16, 8 SAY "ticket restaurant : " PICTURE "@!" GET tr PICTURE "9999999.99" COLOR "W+/GB+" WHEN .F.
	DO WHILE LastKey() <> K_ENTER
		IF LastKey() == K_ESC
			RETURN
		ENDIF
		Inkey(0)
	ENDDO
	CREATE_OR_UPDATE_BILAN(date, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
	INSERT_OR_UPDATE_BILAN_ANNEE_MOIS(annee, mois, nbClient, total, st_55, st_196, service, emporte, cb, chq, esp, tr)
	CLEAN_RECETTE(date)
	CLEAN_CONTENT(date)
RETURN

PROCEDURE EDIT_RECETTE(nFact)
	LOCAL GetList := {}
	LOCAL numTable
	LOCAL nbClient
	LOCAL cb
	LOCAL chq
	LOCAL esp
	LOCAL tr
	LOCAL total
	
	USE RECETTEJ ALIAS recette NEW
	INDEX ON recette->nfact TO recette
	DbSeek(nFact)
	numTable := recette->num_table
	nbClient := recette->nb_client
	cb := recette->cb
	chq := recette->chq
	esp := recette->esp
	tr := recette->tr
	total := recette->total
	CLOSE recette
	
	@ 5, 5 CLEAR TO 20, 75
	DispBox(5, 5, 20, 75, B_SINGLE, "G+/B+")
	@ 6, 8 SAY "numero table : " PICTURE "@!" GET numTable PICTURE "@!"
	@ 7, 8 SAY "nb clients : " PICTURE "@!" GET nbClient PICTURE "@!"
	@ 8, 8 SAY "carte bleue : " PICTURE "@!" GET cb PICTURE "@!"
	@ 9, 8 SAY "cheque : " PICTURE "@!" GET chq PICTURE "@!"
	@ 10, 8 SAY "especes : " PICTURE "@!" GET esp PICTURE "@!"
	@ 11, 8 SAY "ticket restaurant : " PICTURE "@!" GET tr PICTURE "@!"
	@ 12, 8 SAY "total : " PICTURE "@!" GET total PICTURE "@!"
	READ
	MODIF_RECETTE(nFact, numTable, nbClient, cb, chq, esp, tr, total)
	UPDATE_CONTENT_TABLE_NUM_TABLE(nFact, numTable)
	
RETURN

PROCEDURE DISP_RECETTE_TOTAL(date)
	@ 19, 2 SAY "cb : " + PadL(AllTrim(str(GET_TOTAL_CB(date))), 7) PICTURE "@!"
	@ 19, 20 SAY "cheque : " + PadL(AllTrim(str(GET_TOTAL_CHQ(date))), 7) PICTURE "@!"
	@ 19, 40 SAY "espece : " + PadL(AllTrim(str(GET_TOTAL_ESP(date))), 7) PICTURE "@!"
	@ 19, 60 SAY "tr : " + PadL(AllTrim(str(GET_TOTAL_TR(date))), 7) PICTURE "@!"
	@ 22, 2 SAY "total : " + PadL(AllTrim(str(GET_TOTAL_RECETTE(date))), 7) PICTURE "@!"
	@ 22, 20 SAY "CL : " + AllTrim(str(GET_NB_CLIENT_RECETTE(date))) PICTURE "@!"
	@ 22, 30 SAY "{ service : " + PadL(AllTrim(str(GET_TOTAL_RECETTE_SERVICE(date))), 7) PICTURE "@!"
	@ 22, 55 SAY "emporte : " + PadL(ALLTrim(str(GET_TOTAL_RECETTE_EMPORTE(date))), 7) + " }" PICTURE "@!"
RETURN

PROCEDURE DISP_BILAN_MOIS_HEADER()
	@ 0, 0 SAY "   date     cl    total service  emporte tva 5.5%  tva 19.6%  cb   chq  esp   tr" PICTURE "@!"
RETURN

PROCEDURE MODIF_RECORD(nFact, record)
	//LOCAL tab := HB_RegExSplit(" - ", record)
	LOCAL GetList := {}
	LOCAL codePlat := DECODE_GET_CODE_PLAT(record)
	LOCAL quantite := DECODE_GET_QUANTITE(record)
	LOCAL oldPlat := codePlat
	@ 5, 5 CLEAR TO 20, 75
	DispBox(5, 5, 20, 75, B_SINGLE, "G+/B+")
	@ 10, 10 SAY "code : " PICTURE "@!" COLOR "R+/B+" GET codePlat PICTURE "@!"
	@ 15, 10 SAY "quantite : " PICTURE "@!" COLOR "R+/B+" GET quantite PICTURE "99"
	READ
	MODIF_CONTENT_RECORD(nFact, oldPlat, codePlat, quantite)
RETURN

PROCEDURE MODIF_NB_CLIENT(nFact, oldNbClient)
	LOCAL GetList := {}
	LOCAL nbClient := oldNbClient
	@ 5, 5 CLEAR TO 20, 75
	DispBox(5, 5, 20, 75, B_SINGLE, "G+/B+")
	@ 10, 10 SAY "nombre clients : " PICTURE "@!" COLOR "R+/B+" GET nbClient PICTURE "99"
	READ
	IF nbClient <> oldNbClient
		UPDATE_LISTE_TABLE_NB_CLIENT(nFact, nbClient)
	ENDIF
RETURN

FUNCTION MODIF_NUM_TABLE(nFact, nbClient)
	LOCAL GetList := {}
	LOCAL oldNumTable := GET_NUM_TABLE(nFact)
	LOCAL numTable := oldNumTable
	LOCAL retUpdateTable := -1
	LOCAL retVal
	@ 5, 5 CLEAR TO 20, 75
	DispBox(5, 5, 20, 75, B_SINGLE, "G+/R+")
	@ 10, 10 SAY "numero table : " PICTURE "@!" COLOR "R+/B+" GET numTable PICTURE "@!"
	READ
	IF numTable <> oldNumTable
		retUpdateTable := UPDATE_LISTE_TABLE_NUM_TABLE(nFact, numTable)
	ENDIF
	SWITCH retUpdateTable
	CASE -1
		retVal := oldNumTable
		EXIT
	CASE 0
		retVal := numTable
		EXIT
	END
RETURN retVal

PROCEDURE DISP_BILAN_ENTRY_WINDOW()
	LOCAL GetList := {}
	LOCAL annee := Year(Date())
	LOCAL mois := Month(Date())
	
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	
	@ 11, 30 SAY "annee : " PICTURE "@!" GET annee PICTURE "9999"
	@ 13, 30 SAY "mois : " PICTURE "@!" GET mois PICTURE "99" RANGE 1, 12
	READ
	IF LastKey() == K_ESC
		RETURN
	ENDIF
	SetColor("W+/B+")
	DISP_BILAN(annee, mois)
RETURN

PROCEDURE DISP_BILAN_ANNEE_MOIS_ENTRY_WINDOW()
	LOCAL GetList := {}
	LOCAL annee := Year(Date())
	
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	@ 12, 30 SAY "annee : " PICTURE "@!" GET annee PICTURE "9999"
	READ
	IF LastKey() == K_ESC
		RETURN
	ENDIF
	SetColor("W+/B+")
	DISP_BILAN_ANNEE_MOIS(annee)
RETURN

PROCEDURE IMPRIME_FICHE(date, nbClient, prix, tva)
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
	//? emphasis
	? doubleStrike
	? doubleHeight
	? "        Restaurant CHINA STAR             "
	//? emphasisOff
	? doubleHeightOff
	? doubleStrikeOff
	? "        65 bis, Rue Henri Laroche         "
	? "          60800 CREPY-EN-VALOIS           " 
	? "           Tel: 03.44.94.18.88            "
	? "         Siret : 441 538 132 00013        "
	? "Facture                 LE ", PadL(AllTrim(str(Day(date))), 2, "0")+ "/"+ PadL(AllTrim(str(Month(date))), 2, "0") + "/" + AllTrim(str(Year(date)))
	? "------------------------------------------"
	? "         ", AllTrim(str(nbClient)), " REPAS Complet(s)"
	? doubleStrike
	? doubleHeight
	//? emphasis
	? "*** TOTAL                     " + PadL(AllTrim(str(Round(prix, 2))), 7)
	? doubleStrikeOff
	? doubleHeightOff
	//? emphasisOff
	? "   Dont TVA ", AllTrim(str(tva)), "% :       ", AllTrim(str(Round((prix * tva / 100) / (1 + tva / 100), 2)))
	? ""
	? doubleStrike
	? "          Restaurant CHINA STAR           "
	? "        VOUS REMERCIE ET A BIENTOT        "
	? doubleStrikeOff
	? cutting
	EJECT
	SET PRINTER TO
	SET PRINTER OFF
	SET CONSOLE ON
RETURN

PROCEDURE IMPRIME_ADDITION_TVA1(nFact)
	// Imprime la facture de la table numTable TVA : 5.5
	LOCAL GetList := {}
	LOCAL remise := DEFAUT_REMISE
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	@ 12, 30 SAY "remise : " PICTURE "@!" GET remise PICTURE "999" RANGE 0, 100
	READ
	IF LastKey() == K_ESC
		RETURN
	ENDIF
	UPDATE_LISTE_TABLE_TAUX(nFact, 100 - remise)
	UPDATE_CONTENT_TABLE_REMISE(nFact, 100 - remise)
	UPDATE_LISTE_TABLE_STATUS(nFact, 1)
	UPDATE_LISTE_TABLE_ST(nFact, "E")
	SPOOL_FACTURE(nFact, "E")
RETURN

PROCEDURE IMPRIME_ADDITION_TVA2(nFact)
	// Imprime la facture de la table numTable TVA : 19.6
	
	UPDATE_LISTE_TABLE_STATUS(nFact, 1)
	UPDATE_LISTE_TABLE_ST(nFact, "S")
	SPOOL_FACTURE(nFact, "S")
RETURN

PROCEDURE SPOOL_FACTURE(nFact, type)
	LOCAL liste := GET_LISTE_PLAT_IMPRESSION(nFact)
	LOCAL itr
	LOCAL init := Chr(27)+Chr(64)
	LOCAL emphasis := Chr(27)+Chr(69)+Chr(1)
	LOCAL emphasisOff := Chr(27)+Chr(69)+Chr(0)
	LOCAL cutting := Chr(29)+Chr(86)+Chr(65)+Chr(0)
	LOCAL doubleHeight := Chr(27)+Chr(33)+Chr(16)
	LOCAL doubleHeightOff := Chr(27)+Chr(33)+Chr(0)
	LOCAL doubleStrike := Chr(27)+Chr(71)+Chr(1)
	LOCAL doubleStrikeOff := Chr(27)+Chr(71)+Chr(0)
	LOCAL date := GET_DATE_CREATION(nFact)
	LOCAL remise := GET_TOTAL_REMISE(nFact) > 0
	gprinter = GetDefaultPrinter()
	SET PRINTER ON
    SET PRINTER TO &gprinter
	SET CONSOLE OFF
	? init
	? doubleStrike
	? doubleHeight
	? "        Restaurant CHINA STAR             "
	? doubleHeightOff
	? doubleStrikeOff
	? "        65 bis, Rue Henri Laroche         "
	? "          60800 CREPY-EN-VALOIS           " 
	? "           Tel: 03.44.94.18.88            "
	? "         Siret : 441 538 132 00013        "
	IF type == "S"
	? "TABLE : ", AllTrim(GET_NUM_TABLE(nFact)), " / ", AllTrim(str(GET_NB_CLIENT(nFact))), "         LE ", PadL(AllTrim(str(Day(date))), 2, "0")+ "/"+ PadL(AllTrim(str(Month(date))), 2, "0") + "/" + AllTrim(str(Year(date)))
	ELSEIF type == "E"
	? "EMPORTER : ", AllTrim(GET_NUM_TABLE(nFact)), "             LE ", PadL(AllTrim(str(Day(date))), 2, "0")+ "/"+ PadL(AllTrim(str(Month(date))), 2, "0") + "/" + AllTrim(str(Year(date)))	
	ENDIF
	? "------------------------------------------"
	? "Code      designation        Qte    Mont"
	FOR itr := 1 TO LEN(liste)
	? liste[itr]
	NEXT
	? ""
	? "S/TOTAL                       " + PadL(AllTrim(str(GET_TOTAL(nFact))), 7)
	IF remise
	? "    Remise :                  " + PadL(AllTrim(str(Round(GET_TOTAL_REMISE(nFact)/-1, 2))), 7)
	? " Total net :                  " + PadL(AllTrim(str(Round(GET_TOTAL(nFact) - GET_TOTAL_REMISE(nFact), 2))), 7)
	ENDIF
	? ""
	/********** Modification du 27/11/2009 : changement TVA Emporter à 19.6 *****************/
	? "       Dont TVA   5.50% : " + PadL(AllTrim(str(Round(((GET_TOTAL_55(nFact) - GET_TOTAL_REMISE_55(nFact)) * 0.055)/1.055, 2))), 7)
	? "       Dont TVA  19.60% : " + PadL(AllTrim(str(Round(((GET_TOTAL_196(nFact) - GET_TOTAL_REMISE_196(nFact)) * 0.196)/1.196, 2))), 7)
	
	/**************** old code *****************************************/
	/*
	IF type == "S" 
	? "       Dont TVA   5.50% : " + PadL(AllTrim(str(Round(((GET_TOTAL_55(nFact) - GET_TOTAL_REMISE_55(nFact)) * 0.055)/1.055, 2))), 7)
	? "       Dont TVA  19.60% : " + PadL(AllTrim(str(Round(((GET_TOTAL_196(nFact) - GET_TOTAL_REMISE_196(nFact)) * 0.196)/1.196, 2))), 7)
	ELSEIF type == "E"
	? "       Dont TVA   5.50% : " + PadL(AllTrim(str(Round(((GET_TOTAL(nFact) - GET_TOTAL_REMISE(nFact)) * 0.055)/1.055, 2))), 7)
	ENDIF
	*/
	/*****************************************************************************************/
	? doubleStrike
	? doubleHeight
	? emphasis
	? "*** TOTAL                     " + PadL(AllTrim(str(Round(GET_TOTAL(nFact) - GET_TOTAL_REMISE(nFact), 2))), 7)
	? ""
	? "          MERCI DE VOTRE VISITE        "
	? "              A BIENTOT                "
	? cutting
	EJECT
	SET PRINTER TO
	SET PRINTER OFF
	SET CONSOLE ON
RETURN

PROCEDURE ADD_MENU_TO_TABLE(nFact, numTable, nbClient)
	LOCAL beginRow := 3
	LOCAL beginCol := 3
	LOCAL GetList := {}
	LOCAL codePlat := space(4)
	LOCAL libelle := space(25)
	LOCAL quantite := 1
	LOCAL prix := 0
	LOCAL date := GET_DATE_CREATION(nFact)
	SetColor("W+/B+")
	CLS
	@ 1, 2 SAY "table : " + numTable PICTURE "@!" 
	@ 1, 15 SAY "clients : " + AllTrim(str(nbClient)) PICTURE "@!"
	DispBox(0, 0, nRow - 1, nCol - 1, B_DOUBLE, "G+/B+")
	DispBox(2, 2, nRow - 2, 38, B_SINGLE, "RB+/B+")
	DispBox(2, 40, nRow - 2, 78, B_SINGLE, "RB+/B+")
	DO WHILE LastKey() <> K_ESC
		codePlat := space(4) /* repositionne le champ du code à vide */
		quantite := 1 /* repositionne la quantité à 1 */
		@ beginRow, beginCol GET codePlat PICTURE "@!"
		READ
		USE Menu ALIAS menu
		SELECT menu
		INDEX ON Upper(menu->code_plat) TO Menu
		DbSeek(codePlat)
		IF Found()
			libelle := menu->libelle
			prix := menu->prix
			@ beginRow, beginCol + 5 SAY libelle PICTURE "@!S20"
			@ beginRow, beginCol + 26 GET quantite PICTURE "99"
			READ
			@ beginRow, beginCol + 29 SAY prix * quantite PICTURE "999.99"
			INSERER_CONTENT_TABLE(nFact, numTable, date, codePlat, quantite, nbClient)
			IF beginRow >= nRow - 4
				@ 3, 3 CLEAR TO nRow - 3, 37
				beginRow := 3
			ENDIF
			beginRow++
		ELSE
			IF codePlat == space(4)
				EXIT
				//CLOSE menu
			ENDIF
			@ beginRow, beginCol + 5 SAY "code inexistant" PICTURE "@!"
		ENDIF
		//CLOSE menu
	ENDDO
	CHECK_NFACT(nFact)
	USE
RETURN

PROCEDURE APPLICATION_REDUCTION(nFact, pourcent)
	LOCAL GetList := {}
	LOCAL newPourcent := pourcent
	LOCAL savePourcent
	SetColor("W+/RG")
	@ 9, 20 CLEAR TO 15, 60
	DispBox(9, 20, 15, 60, B_DOUBLE, "BG+/RG")
	@ 9, 25 SAY "appuyez sur ESC pour annuler" PICTURE "@!" COLOR "W/RG"
	@ 12, 30 SAY "remise : " PICTURE "@!" GET newPourcent PICTURE "999"
	READ
	IF LastKey() == K_ESC
		RETURN
	ENDIF
	IF newPourcent > 100 .OR. newPourcent < 0
		savePourcent := 100
	ELSE
		savePourcent := 100 - newPourcent
	ENDIF
	UPDATE_LISTE_TABLE_TAUX(nFact, savePourcent)
	UPDATE_CONTENT_TABLE_REMISE(nFact, savePourcent)
RETURN


/* Méthode de navigation dans la liste des plats */
FUNCTION UserFunc(nMode, nElement, nRow)
	LOCAL key := LastKey()
	LOCAL ret := AC_CONT	
	DO CASE
	CASE nMode == AC_IDLE
	CASE nMode == AC_EXCEPT
		IF key == K_ESC
			ret := AC_ABORT
		ELSEIF key == 65 .OR. key == 97
			ret := AC_ABORT
		ELSEIF key == 83 .OR. key == 115
			ret := AC_SELECT
		ELSEIF key == 77 .OR. key == 109
			ret := AC_SELECT
		ELSEIF key == 87 .OR. key == 119
			ret := AC_ABORT
		ELSEIF key == 84 .OR. key == 116
			ret := AC_ABORT
		ELSEIF key == 82 .OR. key == 114
			ret := AC_ABORT
		ELSEIF key == 70 .OR. key == 102
			ret := AC_ABORT
		ELSEIF key == 69 .OR. key == 101
			ret := AC_ABORT
		ELSEIF key == 73 .OR. key == 105
			ret := AC_ABORT
		ELSEIF key == 45
			ret := AC_SELECT
		ELSEIF key == K_F5
			ret := AC_SELECT
		ENDIF
	ENDCASE
RETURN ret

FUNCTION gestion_edition_plat(nMode, nElement, nRow)
	LOCAL key := LastKey()
	LOCAL ret := AC_CONT
	DO CASE
	CASE nMode == AC_IDLE
	CASE nMode == AC_EXCEPT
		IF key == K_ESC
			ret := AC_ABORT
		ELSEIF key == 65 .OR. key == 97    // touche A
			ret := AC_ABORT
		ELSEIF key == 83 .OR. key == 115   // touche S
			ret := AC_SELECT
		ELSEIF key == 77 .OR. key == 109   //touche M
			ret := AC_SELECT
		ELSEIF key == 82 .OR. key == 114   //touche R
			ret := AC_ABORT
		ENDIF
	ENDCASE
RETURN ret

FUNCTION recetteUserFunc(nMode, nElement, nRow)
	LOCAL key := LastKey()
	LOCAL ret := AC_CONT
	DO CASE
	CASE nMode == AC_IDLE
	CASE nMode == AC_EXCEPT
		IF key == K_ESC
			ret := AC_ABORT
		ELSEIF key == 83 .OR. key == 115   // touche S
			ret := AC_SELECT
		ELSEIF key == 77 .OR. key == 109   //touche M
			ret := AC_SELECT
		ELSEIF key == K_RETURN
			ret := AC_SELECT
		ELSEIF 	key == 67 .OR. key == 99 // touche c
			ret := 	AC_ABORT	
		ENDIF
	ENDCASE
RETURN ret

FUNCTION BILAN_USER_FUNC(nMode, nElement, nRow)
	LOCAL key := LastKey()
	LOCAL ret := AC_CONT
	DO CASE
	CASE nMode == AC_IDLE
	CASE nMode == AC_EXCEPT
		IF key == K_LEFT
			ret := AC_CONT
			Scrollfixed(1, 1, nRow - 2, nCol - 2, 20, 0)
		ELSEIF key == K_RIGHT
			ret := AC_CONT
			Scrollfixed(1, 1, nRow - 2, nCol - 2, -20, 0)
		ELSEIF key == K_ESC
			ret := AC_ABORT
		ENDIF
	ENDCASE
RETURN ret

PROCEDURE DISP_PRINT_HEADER()
	LOCAL nom_restaurant := SOCIETE + Chr(32) + UPPER(NOM_SOCIETE)
	LOCAL localisation := CODE_POSTAL + Chr(32) + UPPER(VILLE)
	LOCAL telephone := Transform(TEL, "@LR TEL : 99 99 99 99 99")
	LOCAL num_siret := Transform(SIRET, "@LR SIRET : 999 999 999 99999")
	
	? center(nom_restaurant, 42, Chr(32), .T.)
	? center(localisation, 42, Chr(32), .T.)
	? center(telephone, 42, Chr(32), .T.)
	? center(num_siret, 42, Chr(32), .T.)
	WAIT
RETURN
