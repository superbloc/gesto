PROCEDURE MAIN()
	CREATE_CONTENU_TABLE()
RETURN

PROCEDURE CREATE_CONTENU_TABLE
	CREATE TempContentTable1
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "DATE", ;
			FIELD_TYPE WITH "D"

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
	
	REPLACE FIELD_NAME WITH "CODE_PLAT", ;
			FIELD_TYPE WITH "C", ;
			FIELD_LEN WITH 4, ;
			FIELD_DEC WITH 0
			
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "QUANTITE", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 2, ;
			FIELD_DEC WITH 0
	
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "OFFERT", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 1, ;
			FIELD_DEC WITH 0
			
	APPEND BLANK
	
	REPLACE FIELD_NAME WITH "REMISE", ;
			FIELD_TYPE WITH "N", ;
			FIELD_LEN WITH 10, ;
			FIELD_DEC WITH 4
			
	CLOSE TempContentTable1
	
	CREATE ContentTableBis FROM TempContentTable1
RETURN