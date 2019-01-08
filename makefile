#-------------------------------------------------------------------------------
# User-defined part start
#

# BIN_LIB is the destination library for the created objects.
BIN_LIB=ILEFCGI

#
# User-defined part end
#-------------------------------------------------------------------------------

OUTPUT=*NONE
CFLAGS= DBGVIEW(*LIST) OUTPUT($(OUTPUT)) INCDIR('./include') OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) STGMDL(*INHERIT)
MODULES = fcgiapp fcgi_stdio os_unix  

.SUFFIXES: .c
 
# suffix rules
.c:
	system -ik "CRTCMOD  MODULE($(BIN_LIB)/$@) SRCSTMF('$<') $(CFLAGS)" 


all: env compile bind 

env:
	-system -ik "CRTLIB $(BIN_LIB) Text('ILE Fast CGI for ILEastic')"
	system -ik "CLRLIB $(BIN_LIB)"

bind:
	-system -i "CRTBNDDIR BNDDIR($(BIN_LIB)/ILEFCGI)"
	-system -i "ADDBNDDIRE BNDDIR($(BIN_LIB)/ILEFCGI) OBJ($(BIN_LIB)/ILEFCGI)"
	system -ik "CRTSRVPGM SRVPGM($(BIN_LIB)/ILEFCGI) MODULE($(BIN_LIB)/fcgiapp $(BIN_LIB)/fcgi_stdio $(BIN_LIB)/os_unix) EXPORT(*ALL) ACTGRP(*CALLER) ALWLIBUPD(*YES) TGTRLS(*CURRENT) STGMDL(*INHERIT)"

compile: $(MODULES)

.PHONY: