@echo off

rem positionnement de la plateforme.
set HB_ARCHITECTURE=w32
set HB_COMPILER=bcc32

if "%HB_INSTALL%" == "" set HB_INSTALL=C:\xharbour-1.20.01.bin.w32.bcc32.5.51
if "%HB_BIN_INSTALL%" == "" set HB_BIN_INSTALL=%HB_INSTALL%\bin
if "%HB_LIB_INSTALL%" == "" set HB_LIB_INSTALL=%HB_INSTALL%\lib
if "%HB_INC_INSTALL%" == "" set HB_INC_INSTALL=%HB_INSTALL%\include
if "%HB_LIBLIST%" == "" set HB_LIBLIST=common.lib debug.lib vm.lib rtl.lib zlib.lib pcrepos.lib gtwin.lib codepage.lib lang.lib rdd.lib macro.lib pp.lib dbffpt.lib dbfntx.lib dbfcdx.lib hsx.lib hbsix.lib ct.lib tip.lib

set CURRENT_DIR=%CD%

rem call %CURRENT_DIR%\..\..\script\initenv.bat

set BIN_DIR=%CURRENT_DIR%\..\bin
if "%1" == "gesto" GOTO making_gesto
if "%1" == "compile" GOTO compile
if "%1" == "clean" GOTO clean

:making_gesto

echo Compiling application gesto...
%HB_BIN_INSTALL%\harbour gesto.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour listeTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour contentTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour menuTableFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour miscUtil.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour recetteFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour bilanFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour bilanMFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour parameterFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour override.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour printFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w

bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% gesto.c listeTableFunc.c contentTableFunc.c menuTableFunc.c miscUtil.c recetteFunc.c bilanFunc.c bilanMFunc.c parameterFunc.c override.c printFunc.c %HB_LIBLIST%

GOTO clean

:compile
echo Compiling...
%HB_BIN_INSTALL%\harbour create_menu_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour create_listeTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour create_contentTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour create_encaissement_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour createBilanM.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour createBilanY.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour createRecetteJ.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
%HB_BIN_INSTALL%\harbour create_paramTable_table.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w
rem %HB_BIN_INSTALL%\harbour parameterFunc.prg -n -q0 -gc -i%HB_INC_INSTALL% -p -w


bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_menu_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_listeTable_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_contentTable_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_encaissement_table.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createBilanM.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createBilanY.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% createRecetteJ.c %HB_LIBLIST%
bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% create_paramTable_table.c %HB_LIBLIST%
rem bcc32 -O2 -I%HB_INC_INSTALL% -L%HB_LIB_INSTALL% parameterFunc.c %HB_LIBLIST%

:clean
del *.c *.ppo *.obj *.tds
move *.exe %BIN_DIR%\.
