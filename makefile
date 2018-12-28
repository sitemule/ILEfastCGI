
#-------------------------------------------------------------------------------
# User-defined part start
#

# BIN_LIB is the destination library for the demo programs.
# NOTE: LIBLIST can be overwritten from the commandline, but defaults to the BIN_LIB
BIN_LIB=ILEFCGI
LIBLIST=$(BIN_LIB)

# The shell we use
SHELL=/QOpenSys/usr/bin/qsh

#
# add this after CRTBNDRPG for build in vsCode:
# | grep '*RNF' | grep -v '*RNF7031' | sed  "s!*!$<: &!"
# NOTE that OUTPUT are overridden by the make in the vsCode task.json 
# to compile a single file and get erros to the editor
# User-defined part end
#-------------------------------------------------------------------------------
OUTPUT=*NONE
CFLAGS= DBGVIEW(*LIST)  OUTPUT($(OUTPUT)) INCDIR('./include')
MODULES = fcgiapp fcgi_stdio os_unix  

.SUFFIXES: .c
 
# suffix rules
.c:
	liblist -a $(LIBLIST)
	system -iK "CRTCMOD  MODULE($(BIN_LIB)/$@) SRCSTMF('$<') $(CFLAGS)" 



all: env compile bind 

env:
	-system -iK -kpieb "CRTLIB $(BIN_LIB) Text('ILE Fast CGI for ILEastic')"
	system -iK -kpieb "CLRLIB $(BIN_LIB)"
	

bind:
	liblist -a $(LIBLIST);\
	system -iK -kpieb "CRTBNDDIR  BNDDIR($(BIN_LIB)/ILEFCGI)";\
	system -iK -kpieb "ADDBNDDIRE BNDDIR($(BIN_LIB)/ILEFCGI) OBJ($(BIN_LIB)/ILEFCGI) ";\
	system -i -kpieb "CRTSRVPGM  SRVPGM($(BIN_LIB)/ILEFCGI) MODULE($(MODULES)) EXPORT(*ALL) ACTGRP(QILE) ALWLIBUPD(*YES) TGTRLS(*current)"

compile: $(MODULES)

.PHONY:
