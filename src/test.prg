

PROCEDURE MAIN
	LOCAL printer := PrinterPortToName("LPT1:")
	? printer
	
	SET PRINTER ON
	SET PRINTER TO LTP1
		? "Hello World"
		? "Coucou"
	SET PRINTER TO
	SET PRINTER OFF
RETURN

