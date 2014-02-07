FUNCTION GET_LISTE_RECETTE(date)
	LOCAL recetteListe := {}
	LOCAL mapping := {}
	LOCAL str
	LOCAL itr := 1
	USE RECETTEJ ALIAS recette NEW
	LOCATE FOR recette->date == date
	DO WHILE Found()
		str := MAKE_RECETTE_RECORD({itr++, recette->num_table, recette->nb_client, recette->cb, recette->chq, recette->esp, recette->tr, recette->total, recette->tic_print})
		AAdd(recetteListe, Upper(str))
		AAdd(mapping, recette->nfact)
		CONTINUE
	ENDDO	
	CLOSE recette
RETURN	{recetteListe, mapping}

FUNCTION GET_LISTE_RECETTE_PRINT(date)
	LOCAL printRecette
	LOCAL printRecetteListe := {}
	LOCAL modePaiement
	LOCAL detailPaiement
	LOCAL detailPaiement1
	LOCAL cpt := 1
	LOCAL nbPaiement := 0
	USE RECETTEJ ALIAS recette NEW
	LOCATE FOR recette->date == date
	DO WHILE Found()
		modePaiement := ""
		detailPaiement := ""
		detailPaiement1 := ""
		nbPaiement := 0
		printRecette := Str(cpt, 3)
		printRecette := printRecette + "    " + recette->num_table
		printRecette := printRecette + Str(recette->nb_client, 2)
		printRecette := printRecette + Str(recette->total, 10, 2)
		IF recette->cb > 0 
			nbPaiement++
			modePaiement := modePaiement + "B "
			IF nbPaiement > 2
				detailPaiement1 := detailPaiement1 + "   CB:" + Str(recette->cb, 7, 2) 
			ELSEIF nbPaiement > 0
				detailPaiement := detailPaiement + "   CB:" + Str(recette->cb, 7, 2)
			ENDIF
		ENDIF
		
		IF recette->chq > 0
			nbPaiement++
			modePaiement := modePaiement + "C "
			IF nbPaiement > 2
				detailPaiement1 := detailPaiement1 + "   CQ:" + Str(recette->chq, 7, 2)
			ELSEIF nbPaiement > 0
				detailPaiement := detailPaiement + "   CQ:" + Str(recette->chq, 7, 2)
			ENDIF
		ENDIF
		
		IF recette->esp > 0
			nbPaiement++
			modePaiement := modePaiement + "E "
			IF nbPaiement > 2
				detailPaiement1 := detailPaiement1 + "   ES:" + Str(recette->esp, 7, 2)
			ELSEIF nbPaiement > 0
				detailPaiement := detailPaiement + "   ES:" + Str(recette->esp, 7, 2)
			ENDIF
		ENDIF
		
		IF recette->tr > 0
			nbPaiement++
			modePaiement := modePaiement + "T"
			IF nbPaiement > 2
				detailPaiement1 := detailPaiement1 + "   TR:" + Str(recette->TR, 7, 2)			
			ELSEIF nbPaiement > 0
				detailPaiement := detailPaiement + "   TR:" + Str(recette->TR, 7, 2)
			ENDIF
		ENDIF
		printRecette := printRecette + "    " + modePaiement
		AAdd(printRecetteListe, printRecette)
		IF nbPaiement > 1
			AAdd(printRecetteListe, detailPaiement)
		ENDIF
		IF nbPaiement > 2
			AAdd(printRecetteListe, detailPaiement1)
		ENDIF
		cpt++
		CONTINUE
	ENDDO
	CLOSE recette
RETURN printRecetteListe

FUNCTION MAKE_RECETTE_RECORD(aaListe)
	LOCAL indice := aaListe[1]
	LOCAL numTable := aaListe[2]
	LOCAL nb_client := aaListe[3]
	LOCAL cb := aaListe[4]
	LOCAL chq := aaListe[5]
	LOCAL esp := aaListe[6]
	LOCAL tr := aaListe[7]
	LOCAL total := aaListe[8]
	LOCAL output := PadL(AllTrim(str(indice)), 4) + " " +;
					PadL(AllTrim(numTable), 3) + " " +;
					PadL(AllTrim(str(nb_client)), 2) + " "+;
					PadL(AllTrim(str(cb)), 12) + " "+;
					PadL(AllTrim(str(chq)), 12) + " "+;
					PadL(AllTrim(str(esp)), 12) + " "+;
					PadL(AllTrim(str(tr)), 12) + " "+;
					PadL(AllTrim(str(total)), 12)
	IF aaListe[9] == 0
		output := "*" + output
	ENDIF
RETURN output

/* Méthode qui supprime une facture particulière */
PROCEDURE DELETE_RECETTE(nFact)
	USE RECETTEJ ALIAS recette NEW
	DELETE FOR recette->nfact == nFact
	PACK
	CLOSE recette
RETURN

/* Méthode qui supprime toutes les factures de la journée date */
PROCEDURE CLEAN_RECETTE(date)
	USE RECETTEJ ALIAS recette NEW
	DELETE FOR recette->date == date
	PACK
	CLOSE recette
RETURN

PROCEDURE MODIF_RECETTE(nFact, numTable, nbClient, cb, chq, esp, tr, total)
	USE RECETTEJ ALIAS recette NEW
	REPLACE recette->num_table WITH numTable, ;
			recette->nb_client WITH nbClient, ;
			recette->cb WITH cb, ;
			recette->chq WITH chq, ;
			recette->esp WITH esp, ;
			recette->tr WITH tr, ;
                        recette->total WITH total ;
			FOR recette->nFact == nFact
	CLOSE recette
RETURN

/* Récupère le total sur lequel est calculé les 5.5% */
/* Si la commande est une emporté, alors le total = le total de la commande*/
/************ changement du 27/11/2009 TVA pour les emporter **************/
FUNCTION GET_TVA_1(date)
	LOCAL total := 0
	LOCAL status
	USE RECETTEJ ALIAS recette NEW
	SUM Round(GET_TOTAL_55(recette->nfact) - GET_TOTAL_REMISE_55(recette->nFact), 2) TO total FOR recette->date == date
	CLOSE recette
RETURN total

/* Récupère le total sur lequel est calculé les 19.6% */
/* Si la commande est une emporté, alors le montant est nul */
FUNCTION GET_TVA_2(date)
	LOCAL total := 0
	LOCAL status
	USE RECETTEJ ALIAS recette NEW
	SUM Round(GET_TOTAL_196(recette->nfact) - GET_TOTAL_REMISE_196(recette->nFact), 2) TO total FOR recette->date == date
	CLOSE recette
RETURN total
/****************************************************/

FUNCTION GET_TOTAL_CB(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->cb TO total FOR recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_CHQ(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->chq TO total FOR recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_ESP(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->esp TO total FOR recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_TR(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->tr TO total FOR recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_RECETTE_SERVICE(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->total TO total FOR recette->status == "S" .AND. recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_RECETTE_EMPORTE(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->total TO total FOR recette->status == "E" .AND. recette->date == date
	CLOSE recette
RETURN total

FUNCTION GET_TOTAL_RECETTE(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->total TO total FOR recette->date == date
	CLOSE recette
RETURN total

/* Fonction qui renvoie le nombre de client par date */
FUNCTION GET_NB_CLIENT_RECETTE(date)
	LOCAL total := 0
	USE RECETTEJ ALIAS recette NEW
	SUM recette->nb_client TO total FOR recette->date == date
	CLOSE recette
RETURN total

/* Fonction qui renvoie toutes les dates présentes dans la table recettej */
FUNCTION GET_ALL_DATE()
	LOCAL date_hash := Hash()
	HSetAACompatibility(date_hash, .T.)
	USE RECETTEJ ALIAS recette NEW
	DO WHILE .NOT. Eof()
		date_hash[recette->date] := 1
		SKIP
	ENDDO
	CLOSE recette
RETURN date_hash

FUNCTION GET_DATE_RECETTE(nFact)
	LOCAL date
	USE RECETTEJ ALIAS recette NEW
	INDEX ON recette->nfact TO recette
	DbSeek(nFact)
	date := recette->date
	CLOSE recette
RETURN date
