@echo off

rem positionnement de la plateforme.
set HB_ARCHITECTURE=w32
set HB_COMPILER=bcc32

set PATH=%PATH%;"C:\dev\programs\BCC55\Bin"

if "%HB_INSTALL%" == "" set HB_INSTALL=C:\dev\programs\xharbour-1.20.01.bin.w32.bcc32.5.51
if "%HB_BIN_INSTALL%" == "" set HB_BIN_INSTALL=%HB_INSTALL%\bin
if "%HB_LIB_INSTALL%" == "" set HB_LIB_INSTALL=%HB_INSTALL%\lib
if "%HB_INC_INSTALL%" == "" set HB_INC_INSTALL=%HB_INSTALL%\include
if "%HB_LIBLIST%" == "" set HB_LIBLIST=common.lib debug.lib vm.lib rtl.lib zlib.lib pcrepos.lib gtwin.lib codepage.lib lang.lib rdd.lib macro.lib pp.lib dbffpt.lib dbfntx.lib dbfcdx.lib hsx.lib hbsix.lib ct.lib tip.lib
rem if "%HB_LIBLIST%" == "" set HB_LIBLIST=common.lib debug.lib vm.lib rtl.lib zlib.lib pcrepos.lib codepage.lib lang.lib rdd.lib macro.lib pp.lib dbffpt.lib dbfntx.lib dbfcdx.lib hsx.lib hbsix.lib ct.lib tip.lib

set CURRENT_DIR=%CD%

rem call %CURRENT_DIR%\..\..\script\initenv.bat

set BIN_DIR=%CURRENT_DIR%\bin
set SRC_DIR=%CURRENT_DIR%\src
set SAND_DIR=%CURRENT_DIR%\sandbox
if "%1" == "gesto" GOTO making_gesto
if "%1" == "compile" GOTO compile
if "%1" == "clean" GOTO clean
if "%1" == "sandbox" GOTO sandbox


:making_gesto
echo Compiling application gesto...
%HB_BIN_INSTALL%\harbour %SRC_DIR%\gesto.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\listeTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\contentTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\menuTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\miscUtil.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\recetteFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\bilanFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\bilanMFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\parameterFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\override.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\printFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\Table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\StockBoisson.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\test.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\tableInitFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% gesto.c listeTableFunc.c contentTableFunc.c menuTableFunc.c miscUtil.c recetteFunc.c bilanFunc.c bilanMFunc.c parameterFunc.c override.c printFunc.c Table.c StockBoisson.c tableInitFunc.c %HB_LIBLIST%
rem bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% test.c StockBoisson.c %HB_LIBLIST%
GOTO clean

:compile
echo Compiling...
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_menu_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_listeTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_contentTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_encaissement_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\createBilanM.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\createBilanY.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\createRecetteJ.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_paramTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\create_stockTable.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\convertRecettej.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\test.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\loadMenu.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour %SRC_DIR%\CONVPLAT.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
rem %HB_BIN_INSTALL%\harbour parameterFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w

bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_menu_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_listeTable_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_contentTable_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_encaissement_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createBilanM.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createBilanY.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createRecetteJ.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_paramTable_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_stockTable.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% convertRecettej.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% test.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% loadMenu.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% CONVPLAT.c %HB_LIBLIST%
rem bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% parameterFunc.c %HB_LIBLIST%
GOTO clean

:sandbox
echo Compiling sandbox...
%HB_BIN_INSTALL%\harbour %SAND_DIR%\testFileCreate.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% testFileCreate.c %HB_LIBLIST%

:clean
del *.c *.ppo *.obj *.tds
del %SRC_DIR%\*.c %SRC_DIR%\*.ppo %SRC_DIR%\*.obj %SRC_DIR%\*.tds
move *.exe %BIN_DIR%\.
