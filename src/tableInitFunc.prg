/*******************************************************/
/*                                                     */ 
/*   Fonction utilitaire pour initialiser les tables   */
/*   lors du premier démarrage de l'appli              */  
/*                                                     */
/*******************************************************/


/* Création de la table de PARAMETRAGE */
PROCEDURE CREATE_PARAM_TABLE
	LOCAL paramTableStruct := {;
		{"PARAM_LAB", "C", 20, 0}, ;
		{"PARAM_VAL", "C", 10, 0}, ;
		{"PARAM_DEC", "C", 30, 0}, ;
		{"PARAM_TYP", "C", 1, 0}   ;
	}
		
	DbCreate( "param.dbf", paramTableStruct)
RETURN

/* Création de la table contenant la liste des tables */
PROCEDURE CREATE_LISTE_TABLE
	LOCAL listeTableStruct := {;
		{"NUM_TABLE", "C", 3, 0}, ;
		{"NFACT", "N", 7, 0}, ;
		{"NB_CLIENT", "N", 2, 0}, ;
		{"TAUX", "N", 3, 0}, ;
		{"DATE_CREA", "D", 8, 0}, ;
		{"TIME_CREA", "C", 10, 0}, ;
		{"STATUS", "N", 1, 0}, ;
		{"ST", "C", 1, 0} ;
	}
	
	DbCreate( "listeTable.dbf", listeTableStruct )
RETURN

/* Création de la table menu */
PROCEDURE CREATE_MENU_TABLE
	LOCAL menuTableStruct := {;
		{"CODE_PLAT", "C", 4, 0}, ;
		{"LIBELLE", "C", 32, 0}, ;
		{"PRIX", "N", 10, 2}, ;
		{"CATEGORIE", "C", 1, 0}, ;
		{"STOCKAGE", "C", 1, 0} ;
	}
	
	DbCreate( "menu.dbf", menuTableStruct )
RETURN

/* Création de la table des contenus */
PROCEDURE CREATE_CONTENU_TABLE
	LOCAL contenuTableStruct := {;
		{"DATE", "D", 8, 0}, ;
		{"NUM_TABLE", "C", 3, 0}, ;
		{"NFACT", "N", 7, 0}, ;
		{"CODE_PLAT", "C", 4, 0}, ;
		{"QUANTITE", "N", 2, 0}, ;
		{"OFFERT", "N", 1, 0}, ;
		{"REMISE", "N", 10, 4} ;
	}
	DbCreate( "contentTable.dbf", contenuTableStruct )
RETURN

PROCEDURE CREATE_RECETTE_JOURNALIERE_TABLE
	LOCAL recetteJournaliereTableStruct := {;
		{"DATE", "D", 10, 0}, ;
		{"NUM_TABLE", "C", 3, 0}, ;
		{"NFACT", "N", 7, 0}, ;
		{"NB_CLIENT", "N", 10, 0}, ;
		{"TOTAL", "N", 12, 2}, ;
		{"TVA", "N", 10, 2}, ;
		{"SERVICE", "N", 12, 2}, ;
		{"EMPORTE", "N", 12, 2}, ;
		{"CB", "N", 12, 2}, ;
		{"CHQ", "N", 12, 2}, ;
		{"ESP", "N", 12, 2}, ;
		{"TR", "N", 12, 2}, ;
		{"STATUS", "C", 1, 0}, ;
		{"TIC_PRINT", "N", 1, 0};
	}
		
	DbCreate( "recettej.dbf", recetteJournaliereTableStruct )
RETURN

PROCEDURE CREATE_STOCK_TABLE
	LOCAL stockTableStruct := {;
		{"DATE", "D", 10, 0}, ;
		{"CODE_PLAT", "C", 4, 0}, ;
		{"QUANTITE", "N", 4, 0}, ;
		{"ARCHIVED", "L", 1, 0} ;
	}
	
	DbCreate( "stockTable.dbf", stockTableStruct )
RETURN

PROCEDURE CREATE_BILAN_ANNEE_TABLE
	LOCAL bilanAnneeTableStruct := {;
		{"ANNEE", "N", 4, 0}, ;
		{"MOIS", "N", 2, 0}, ;
		{"NB_CLIENT", "N", 10, 0}, ;
		{"TOTAL", "N", 12, 2}, ;	
		{"ST_55", "N", 12, 2}, ;
		{"ST_196", "N", 12, 2}, ;
		{"TVA_1", "N", 10, 2}, ;
		{"TVA_2", "N", 10, 2}, ;	
		{"SERVICE", "N", 12, 2}, ;
		{"EMPORTE", "N", 12, 2}, ;
		{"CB", "N", 12, 2}, ;
		{"CHQ", "N", 12, 2}, ;
		{"ESP", "N", 12, 2}, ;
		{"TR", "N", 12, 2} ;
	}
	
	DbCreate( "bilanm.dbf", bilanAnneeTableStruct) 
RETURN

PROCEDURE CREATE_BILAN_MOIS_TABLE
	LOCAL bilanMoisTableStruct := {;
		{"DATE", "D", 10, 0}, ;
		{"NB_CLIENT", "N", 10, 0}, ;
		{"TOTAL", "N", 12, 2}, ;	
		{"ST_55", "N", 12, 2}, ;
		{"ST_196", "N", 12, 2}, ;
		{"TVA_1", "N", 10, 2}, ;
		{"TVA_2", "N", 10, 2}, ;	
		{"SERVICE", "N", 12, 2}, ;
		{"EMPORTE", "N", 12, 2}, ;
		{"CB", "N", 12, 2}, ;
		{"CHQ", "N", 12, 2}, ;
		{"ESP", "N", 12, 2}, ;
		{"TR", "N", 12, 2} ;
	}
	
	DbCreate( "bilany.dbf", bilanMoisTableStruct )
RETURN


/* Insertion des valeurs par défauts dans la table de PARAMETRAGE */
PROCEDURE POPULATE_PARAM_TABLE
	USE param ALIAS parameter NEW
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_CHG_DATE", ;
			parameter->PARAM_VAL WITH "01/01/2014", ;
			parameter->PARAM_DEC WITH "Date de bascule TVA1", ;
			parameter->PARAM_TYP WITH "D"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_BF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "7", ;
			parameter->PARAM_DEC WITH "TVA1 avant la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT1_AF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "10", ;
			parameter->PARAM_DEC WITH "TVA1 apres la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT2_CHG_DATE", ;
			parameter->PARAM_VAL WITH "01/01/2014", ;
			parameter->PARAM_DEC WITH "Date de bascule TVA2", ;
			parameter->PARAM_TYP WITH "D"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT2_BF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "19.6", ;
			parameter->PARAM_DEC WITH "TVA2 avant la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT2_AF_CHG_DATE", ;
			parameter->PARAM_VAL WITH "20", ;
			parameter->PARAM_DEC WITH "TVA2 apres la date de bascule", ;
			parameter->PARAM_TYP WITH "N"
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "EMPORTE_REMISE", ;
			parameter->PARAM_VAL WITH "0", ;
			parameter->PARAM_DEC WITH "Remise emporte", ;
			parameter->PARAM_TYP WITH "N"
	/*
	APPEND BLANK
	REPLACE parameter->PARAM_LAB WITH "VAT2", ;
			parameter->PARAM_VAL WITH "19.6", ;
			parameter->PARAM_DEC WITH "TVA2", ;
			parameter->PARAM_TYP WITH "N"
	*/
	CLOSE parameter
RETURN