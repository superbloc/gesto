/* Liste ici les méthodes ou fonctions relatives à la table listeTableFunc */

/* Fonction qui teste si un numéro de table existe dans la table listeTable*/

FUNCTION TEST_EXISTENCE_TABLE(numTable)
	LOCAL val
	USE ListeTable ALIAS listeTable
	INDEX ON Upper(listeTable->num_table) TO listeTable
	val := DbSeek(numTable)
	CLOSE listeTable
RETURN val

/* Fonction qui retourne une liste contenant l'ensemble des tables 
   présentes dans la table listeTable au format :
   num_table - nb_client - prix
*/
FUNCTION GET_LISTE_TABLE()
	LOCAL aaList := {}
	LOCAL itrStr
	LOCAL itr := 1
	USE ListeTable ALIAS listeTable
	DO WHILE .NOT. Eof()
		itrStr := ENCODE_LISTE_TABLE({itr++, listeTable->num_table, listeTable->nb_client, Round(GET_TOTAL(listeTable->nfact) * (listeTable->taux/100), 2)})
		AAdd(aaList, Upper(itrStr))
		SELECT listeTable
		SKIP
	ENDDO
	CLOSE listeTable
RETURN aaList

FUNCTION GET_TOTAL_CLIENT()
	LOCAL total := 0
	USE ListeTable ALIAS listeTable NEW
	SUM listeTable->nb_client TO total
	CLOSE listeTable
RETURN total

FUNCTION GET_TOTAL_AVEC_REMISE(nFact)
	LOCAL total := GET_TOTAL(nFact)
	LOCAL tauRemise := GET_TAUX(nFact)
	LOCAL ret := Round(total * tauRemise / 100, 2)
RETURN ret

/* Fonction qui retourne le taux d'une table donnée */
FUNCTION GET_TAUX(nFact)
	LOCAL retValue := 100
	USE ListeTable ALIAS listeTable NEW
	SELECT listeTable
	INDEX ON listeTable->nfact TO listeTable
	DbSeek(nFact)
	IF FOUND()
		retValue := listeTable->taux
	ENDIF
	CLOSE listeTable
RETURN retValue


/* fonction qui retourne le nombre de clients selon la table 
   Retourne -1 si le numéro de table n'existe pas
*/
FUNCTION GET_NB_CLIENT(nFact)
	LOCAL retValue := -1
	USE ListeTable ALIAS listeTable NEW
	SELECT listeTable
	INDEX ON listeTable->nfact TO listeTable
	DbSeek(nFact)
	IF Found()
		retValue := listeTable->nb_client
		CLOSE listeTable
	ELSE
		CLOSE listeTable
		USE RECETTEJ ALIAS recette NEW
		INDEX ON recette->nfact TO recette
		DbSeek(nFact)
		retValue := recette->nb_client
		CLOSE recette
	ENDIF
RETURN retValue

/*
	Fonction qui change le numéro de table dans la listeTable
*/
/*
FUNCTION UPDATE_LISTE_TABLE_NUM_TABLE(nFact, numTable)
	//IF oldNumTable == numTable
	//	RETURN -1
	//ENDIF
	USE ListeTable ALIAS listeTable
	//INDEX ON listeTable->nfact TO listeTable
	//DbSeek(PadR(AllTrim(numTable), 3))
	//IF Found()
	//	RETURN -1
	//ENDIF
	REPLACE listeTable->num_table WITH numTable FOR listeTable->nFact == nFact
	CLOSE listeTable
	UPDATE_CONTENT_TABLE_NUM_TABLE(nFact, numTable)
RETURN 0
*/

FUNCTION UPDATE_LISTE_TABLE_NUM_TABLE(nFact, numTable)
	USE ListeTable ALIAS listeTable
	INDEX ON listeTable->nFact TO listeTable
	DbSeek(PadR(AllTrim(numTable), 3))
	IF Found()
		RETURN -1
	ENDIF
	REPLACE listeTable->num_table WITH numTable FOR listeTable->nfact == nFact
	CLOSE listeTable
	UPDATE_CONTENT_TABLE_NUM_TABLE(nFact, numTable)
RETURN 0

/* Méthode qui met à jour le taux de réduction de la table liste_table */
PROCEDURE UPDATE_LISTE_TABLE_TAUX(nFact, taux)
	USE ListeTable ALIAS listeTable
	REPLACE listeTable->taux WITH taux FOR listeTable->nfact == nFact
	CLOSE listeTable
RETURN

/* Méthode qui met à jour le nombre de clients de la table liste_table */
PROCEDURE UPDATE_LISTE_TABLE_NB_CLIENT(nFact, nbClient)
	USE ListeTable ALIAS listeTable
	REPLACE listeTable->nb_client WITH nbClient FOR listeTable->nfact == nFact
	CLOSE listeTable
	USE RECETTEJ ALIAS recette
	REPLACE recette->nb_client WITH nbClient FOR recette->nfact == nFact
	CLOSE recette
RETURN

PROCEDURE UPDATE_LISTE_TABLE_STATUS(nFact, status)
	USE ListeTable ALIAS listeTable
	REPLACE listeTable->status WITH status FOR listeTable->nfact == nFact
	CLOSE listeTable
RETURN

/* Méthode d'insertion dans la table liste_table */
FUNCTION INSERER_LISTE_TABLE(numTable, nbClient)
	//IF TEST_EXISTENCE_CONTENU(numTable)
	LOCAL nFact := Round(Seconds() * 100, 0)
	USE ListeTable ALIAS listeTable
	INDEX ON Upper(listeTable->num_table) TO listeTable
	DbSeek(numTable)
	IF Found()
		RETURN nFact
	ENDIF
	APPEND BLANK
	REPLACE listeTable->num_table WITH numTable, ;
			listeTable->nfact WITH nFact, ;
			listeTable->nb_client WITH nbClient, ;
			listeTable->taux WITH 100, ;
			listeTable->date_crea WITH Date(), ;
			listeTable->time_crea WITH Time(), ;
			listeTable->status WITH 0, ;
			listeTable->st WITH "S"
	CLOSE listeTable
	//ENDIF
RETURN nFact

/* fonction qui retourne le champ st d'une facture */
FUNCTION GET_ST(nFact)
	LOCAL retVal
	USE ListeTable ALIAS listeTable NEW
	INDEX ON listeTable->nfact TO listeTable
	DbSeek(nFact)
		retVal := listeTable->st
	CLOSE listeTable
RETURN retVal

PROCEDURE UPDATE_LISTE_TABLE_ST(nFact, val)
	USE ListeTable ALIAS listeTable NEW
	REPLACE listeTable->st WITH val FOR listeTable->nfact == nFact
	CLOSE listeTable
RETURN

/* Méthode qui supprimer la table numTable */
PROCEDURE DELETING_TABLE(nFact)
	USE ListeTable ALIAS listeTable NEW
	DELETE FOR listeTable->nFact == nFact
	PACK
	CLOSE listeTable
RETURN

FUNCTION GET_NFACT(numTable)
	LOCAL retVal
	USE ListeTable ALIAS listeTable NEW
	SELECT listeTable
	INDEX ON Upper(listeTable->num_table) TO listeTable
	DbSeek(numTable)
	retVal := listeTable->nfact
	CLOSE listeTable
RETURN  retVal

FUNCTION GET_DATE_CREATION(nFact)
	LOCAL date
	USE ListeTable ALIAS listeTable NEW
	INDEX ON listeTable->nfact TO listeTable
	DbSeek(nFact)
	IF Found()
		date := listeTable->date_crea
		CLOSE listeTable
	ELSE
		CLOSE listeTable
		USE RECETTEJ ALIAS recette NEW
		INDEX ON recette->nfact TO recette
		DbSeek(nFact)
		date := recette->date
		CLOSE recette
	ENDIF	
RETURN date

FUNCTION GET_NUM_TABLE(nFact)
	LOCAL retVal
	USE ListeTable ALIAS listeTable NEW
	INDEX ON listeTable->nfact TO listeTable
	DbSeek(nFact)
	IF Found()
		retVal := listeTable->num_table
		CLOSE listeTable
	ELSE
		CLOSE listeTable
		USE RECETTEJ ALIAS recette NEW
		INDEX ON recette->nfact TO recette
		DbSeek(nFact)
		retVal := recette->num_table	
		CLOSE recette
	ENDIF
RETURN retVal