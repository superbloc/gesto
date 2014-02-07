// The example demonstrates how push buttons can be integrated
// in the Get list and are activated during READ
#include "Inkey.ch"
#include "Box.ch"

   PROCEDURE Main
	  LOCAL getList := {}
      LOCAL cLName, cFName
      LOCAL lBtn1   := .F.
      LOCAL lBtn2   := .F.
      LOCAL lBtn3   := .F.
      LOCAL nBtn    := 0
      LOCAL cGetClr := "W+/B,W+/R,N/BG,GR+/BG"
      LOCAL cBtnClr := "N/G,W+/G,GR+/N,GR+/G"

      SET EVENTMASK TO INKEY_ALL
      SET COLOR TO W+/N
      CLS

      @ 12, 20 GET lBtn1 PUSHBUTTON ;
           CAPTION " &Save " ;
             COLOR cBtnClr ;
			 STATE {|| nBtn := 1, ReadKill(.T.) } ;
			 STYLE "[]"
			 
      @ 12, 30 GET lBtn2 PUSHBUTTON ;
           CAPTION " &Undo " ;
             COLOR cBtnClr ;
			 STATE {|| nBtn := 2, ReadKill(.T.) } ;
			 STYLE B_SINGLE

      @ 12, 40 GET lBtn3 PUSHBUTTON ;
           CAPTION " E&xit " ;
             COLOR cBtnClr ;
			 STATE {|| nBtn := 3, ReadKill(.T.)} ;
			 STYLE B_DOUBLE

      READ
	  @ 2, 2 SAY "nBtn : " + Str(nBtn)
   RETURN
