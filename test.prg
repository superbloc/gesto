

PROCEDURE MAIN
	/*
	LOCAL item
	LOCAL m := Menu():new()
	FOR EACH item IN m:mPlatList
		? item:toString
	NEXT
	*/
	
	/*
	LOCAL item
	LOCAL tableList := GetRecetteList()
	FOR EACH item IN tableList
		? item:toString
	NEXT
	*/
	
	
	LOCAL item
	LOCAL date := CtoD("11/28/2009")
	LOCAL stockHash := GetEncaisseStockBoissonHash(date)
	? Len(stockHash)
	FOR EACH item IN HGetValues(stockHash)
		? item:toString()
	NEXT 
RETURN

