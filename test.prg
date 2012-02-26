
PROCEDURE MAIN
	/*
	LOCAL item
	LOCAL m := Menu():new()
	FOR EACH item IN m:mPlatList
		? item:toString
	NEXT
	*/
	
	LOCAL item
	LOCAL tableList := GetRecetteList()
	FOR EACH item IN tableList
		? item:toString
	NEXT
RETURN

