PROCEDURE MAIN()
	CREATE_TABLE_LISTE_TABLE()
RETURN

PROCEDURE CREATE_TABLE_LISTE_TABLE()
	CREATE TempListeTable
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "NUM_TABLE", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 3, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "NFACT", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 7, ;
			FIELD_DEC WITH 0
			
	APPEND BLANK

	REPLACE FIELD_NAME WITH "NB_CLIENT", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 2, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "TAUX", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 3, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "DATE_CREA", ;
			FIELD_TYPE WITH "D"
			
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "TIME_CREA", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 10, ;
			FIELD_DEC WITH 0
			
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "STATUS", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 1, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "ST", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 1, ;
			FIELD_DEC WITH 0
			
	CLOSE TempListeTable		
	CREATE ListeTable FROM TempListeTable
RETURN 