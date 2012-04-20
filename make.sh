#!/bin/bash

#
#  Script de compilation du programme gesto
#  
#
#

if [ -e setenv.sh ]; then
	. setenv.sh
else
   	echo "Erreur d'execution : le fichier setenv.sh introuvable"
	exit 1 		
fi

HARBOUR_OPT="-n -q0 -gc -i$HB_INC_INSTALL -p -w"
COMPILE_LIB="-lcommon -lxharbour -lvm -ldebug -lrtl -lzlib -lpcrepos -lcodepage -llang -lrdd -lmacro -lpp -ldbffpt -ldbfntx -ldbfcdx -lhsx -lhbsix -lct -ltip"
HARBOUR_CMD="harbour"
CC_CMD="gcc"
OUTPUT_DIR=`dirname $0`/../bin

function clean {
	echo "Suppression des fichiers générés lors de la phase de compile"
	rm -f *.{ppo,c}
}


function make_gesto {
	P=( GESTO.prg\
    	listeTableFunc.prg\
    	contentTableFunc.prg\
    	menuTableFunc.prg\
		miscUtil.prg\
		recetteFunc.prg\
		bilanFunc.prg\
		bilanMFunc.prg\
		parameterFunc.prg\
		override.prg\
		printFunc.prg\
		Table.prg\
		StockBoisson.prg)
	for i in ${P[@]}; do
		$HARBOUR_CMD $i $HARBOUR_OPT
	done

	$CC_CMD -I$HB_INC_INSTALL -L$HB_LIB_INSTALL -o $OUTPUT_DIR/gesto ${P[@]/.prg/.c} $COMPILE_LIB
}

function make_compile {
	P=(create_menu_table.prg\
	   create_listeTable_table.prg\
	   create_contentTable_table.prg\
	   create_encaissement_table.prg\
	   createBilanM.prg\
	   createBilanY.prg\
	   createRecetteJ.prg\
	   create_paramTable_table.prg\
	   create_stockTable.prg\
	   convertRecettej.prg)		   

	for i in ${P[@]}; do
		$HARBOUR_CMD $i $HARBOUR_OPT
		$CC_CMD -I$HB_INC_INSTALL -L$HB_LIB_INSTALL -o $OUTPUT_DIR/${i%.prg} ${i/prg/c} $COMPILE_LIB
	done
}

case $1 in
gesto)
	make_gesto
	;;
compile)
	make_compile
	;;
esac

clean
