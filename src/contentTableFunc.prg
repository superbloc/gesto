/* Liste ici les méthodes ou fonctions relatives à la table ContentTable */
/* la table contentTable présente le contenu pour chaque table */

/* procedure qui insére dans la table contentTable les nouvelles valeurs 
 * On réactualise la remise si nécessaire.
 */
PROCEDURE MODIF_CONTENT_RECORD(nFact, oldCodePlat, newCodePlat, quantite)
	LOCAL tableTaux := GET_TAUX(nFact)
	
	USE ContentTable ALIAS contenu
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	REPLACE contenu->code_plat WITH newCodePlat, ;
			contenu->quantite WITH quantite, ;
			contenu->remise WITH menu->prix * quantite * (100 - tableTaux) / 100 ;
			FOR contenu->nfact == nFact .AND. contenu->code_plat == oldCodePlat
	CLOSE menu
	CLOSE contenu
RETURN

/* fonction qui retourne le prix total (hors application de la remise) d'une table */
FUNCTION GET_TOTAL(nFact)
	LOCAL total := 0
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	SUM menu->prix * contenu->quantite TO total ;
		FOR contenu->nfact == nFact .AND. contenu->offert == 0
	CLOSE menu
	CLOSE contenu
RETURN total

/* fonction qui teste si une table a au moins un plat de saisi */
FUNCTION TEST_EXISTENCE_CONTENU(nFact)
	LOCAL val
	USE ContentTable ALIAS contenu
	INDEX ON contenu->nfact TO Contenu
	val := DbSeek(nFact)
	CLOSE contenu
RETURN val

/* fonction qui retourne le nb de plats pour chaque table */
FUNCTION GET_NB_PLAT(nFact)
	LOCAL retValue := 0
	USE ContentTable ALIAS contenu NEW
	COUNT TO retValue FOR contenu->nFact == nFact
	CLOSE contenu
RETURN retValue

/* Méthode d'insertion dans la table content_table */
PROCEDURE INSERER_CONTENT_TABLE(nFact, numTable, date, codePlat, quantite, nbClient, nTaux)
	LOCAL tableTaux := 100
	IF nTaux <> NIL
		tableTaux := nTaux
	ENDIF
	
	USE ContentTable ALIAS contenu
	INDEX ON Upper(str(contenu->nfact) + contenu->code_plat) TO Contenu
	
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	DbSeek(PadL(AllTrim(str(nFact)), 7) + codePlat)
	IF Found()
		REPLACE contenu->quantite WITH contenu->quantite + quantite
	ELSE
		APPEND BLANK
		REPLACE contenu->date WITH date, ;
				contenu->num_table WITH numTable, ;
				contenu->nfact WITH nFact, ;
				contenu->code_plat WITH codePlat, ;
				contenu->quantite WITH quantite, ;
				contenu->offert WITH 0, ;
				contenu->remise WITH menu->prix * contenu->quantite * (100 - tableTaux) / 100
	END
	CLOSE menu
	CLOSE contenu
RETURN

PROCEDURE CHECK_NFACT(nFact)
	IF GET_NB_PLAT(nFact) == 0
		DELETING_TABLE(nFact)
	ENDIF
RETURN

PROCEDURE SET_OFFERT_STATUS(nFact, codePlat)
	USE ContentTable ALIAS contenu
	REPLACE contenu->offert WITH Abs(contenu->offert - 1), contenu->remise WITH 0 FOR contenu->nfact == nFact .AND. contenu->code_plat == codePlat 
	CLOSE contenu
RETURN

FUNCTION GET_TOTAL_REMISE(nFact)
	LOCAL val := 0
	USE ContentTable ALIAS contenu NEW
	SUM contenu->remise TO val FOR contenu->nfact == nFact
	CLOSE contenu
RETURN val

FUNCTION GET_TOTAL_REMISE_55(nFact)
	LOCAL val := 0
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	SUM contenu->remise TO val FOR contenu->nfact == nFact .AND. menu->categorie == "P"
	
	CLOSE menu
	CLOSE contenu
RETURN val

FUNCTION GET_TOTAL_REMISE_196(nFact)
	LOCAL val := 0
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	SUM contenu->remise TO val FOR contenu->nfact == nFact .AND. menu->categorie == "B"
	
	CLOSE menu
	CLOSE contenu
RETURN val

FUNCTION GET_TOTAL_55(nFact)
	LOCAL val := 0
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	SUM contenu->quantite * menu->prix TO val FOR contenu->nfact == nFact .AND. contenu->offert == 0 .AND. menu->categorie == "P"
	
	CLOSE menu
	CLOSE contenu
RETURN val

FUNCTION GET_TOTAL_196(nFact)
	LOCAL val := 0
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	SUM contenu->quantite * menu->prix TO val FOR contenu->nfact == nFact .AND. contenu->offert == 0 .AND. menu->categorie == "B"
	
	CLOSE menu
	CLOSE contenu
RETURN val

/* Méthode qui met à jour le numéro de table 
   Toutes les entrées dont le num_table = oldNumTable devient numTable
*/
PROCEDURE UPDATE_CONTENT_TABLE_NUM_TABLE(nFact, numTable)
	USE ContentTable ALIAS contenu
	REPLACE contenu->num_table WITH numTable FOR contenu->nfact == nFact
	CLOSE contenu
RETURN

/* Méthode qui supprime toutes les entrées correspondant à un numéro de table */
PROCEDURE DELETING_MULTI_RECORD(nFact)
	USE ContentTable ALIAS contenu NEW
	DELETE FOR contenu->nfact == nFact
	PACK
	CLOSE contenu
RETURN

/* Méthode qui supprime toutes les entrées correspondant à une date donnée */
PROCEDURE CLEAN_CONTENT(date)
	USE ContentTable ALIAS contenu NEW
	DELETE FOR contenu->date == date
	PACK
	CLOSE contenu
RETURN

/* Méthode qui calcule la remise pour chaque plat */
PROCEDURE UPDATE_CONTENT_TABLE_REMISE(nFact, pourcent)
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	REPLACE contenu->remise WITH menu->prix * contenu->quantite * (100 - pourcent) / 100 FOR contenu->nfact == nFact .AND. contenu->offert == 0
	CLOSE menu
	CLOSE contenu
RETURN

/* Méthode qui calcule la remise pour un plat donné */
PROCEDURE UPDATE_REMISE(nFact, codePlat, pourcent)
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	REPLACE contenu->remise WITH Abs(contenu->remise - menu->prix * contenu->quantite * pourcent / 100) FOR contenu->nfact == nFact .AND. contenu->code_plat == codePlat .AND. contenu->offert == 0
	CLOSE menu
	CLOSE contenu
RETURN

/* Méthode qui supprime une entrée particulière 
    Méthode peut-être à optimiser
*/
PROCEDURE DELETING_RECORD(nFact, record)
	LOCAL codePlat := DECODE_GET_CODE_PLAT(record)
	LOCAL retValue := .F.
	USE ContentTable ALIAS contenu NEW
	DELETE FOR contenu->code_plat == codePlat .AND. contenu->nfact == nFact
	PACK
	INDEX ON contenu->nfact TO Contenu
	DbGoto(1)
	DbSeek(nFact)
	IF .NOT. Found()
		DELETING_TABLE(nFact)
		retValue := .T.
	ENDIF
	CLOSE contenu
RETURN

/* Fonction qui extrait tous les plats pour une table donnée */
FUNCTION GET_LISTE_PLAT(nFact)
	LOCAL aaList := {}
	//LOCAL total := 0
	LOCAL totalPlat := 0
	LOCAL totalBoisson := 0
	LOCAL outputStr
	LOCAL itr := 1
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu
	
	//SUM menu->prix * contenu->quantite TO totalBoisson FOR contenu->num_table == numTable .AND. menu->categorie == "B" .AND. contenu->offert == 0
	//SUM menu->prix * contenu->quantite TO totalPlat FOR contenu->num_table == numTable .AND. menu->categorie == "P" .AND. contenu->offert == 0
	LOCATE FOR contenu->nfact == nFact
	DO WHILE Found()
		SWITCH menu->categorie
		CASE "B"
			IF contenu->offert == 0
				totalBoisson += menu->prix * contenu->quantite
			ENDIF
			EXIT
		CASE "P"
			IF contenu->offert == 0
				totalPlat += menu->prix * contenu->quantite
			ENDIF
			EXIT
		END
		outputStr := ENCODE_PRESENTATION_PLAT({itr, contenu->code_plat, menu->libelle, contenu->quantite, menu->prix, menu->prix * contenu->quantite, contenu->offert, contenu->remise})
		itr++
		AAdd(aaList, Upper(outputStr))
		CONTINUE
	ENDDO
	
	CLOSE menu
	CLOSE contenu
	AAdd(aaList, totalPlat)
	AAdd(aaList, totalBoisson)
RETURN aaList

FUNCTION GET_LISTE_PLAT_IMPRESSION(nFact)
	LOCAL retVal := {}
	LOCAL priceDisplay
	
	USE ContentTable ALIAS contenu NEW
	USE Menu ALIAS menu NEW
	SELECT menu
	INDEX ON Upper(menu->code_plat) TO menu
	
	SELECT contenu
	SET RELATION TO Upper(contenu->code_plat) INTO menu

	LOCATE FOR contenu->nfact == nFact
	DO WHILE Found()
		IF(contenu->offert == 0)
			priceDisplay := menu->prix * contenu->quantite
		ELSE
			priceDisplay := "OFFERT"
		ENDIF
		AAdd(retVal, {contenu->code_plat, Upper(SubStr(menu->libelle, 1, 24)), contenu->quantite, priceDisplay})
		CONTINUE
	ENDDO
	
	CLOSE menu
	CLOSE contenu
RETURN retVal