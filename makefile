
#-----------------------------------------------------------
# User-defined part start
#

# NOTE - UTF is not allowed for ILE source (yet) - so convert to WIN-1252

# BIN_LIB is the destination library for the service program.
# the rpg modules and the binder source file are also created in BIN_LIB.
# binder source file and rpg module can be remove with the clean step (make clean)
BIN_LIB=ILEFASTCGI
DBGVIEW=*ALL
TARGET_CCSID=*JOB
TARGET_RLS=V7R2M0


# Do not touch below
INCLUDE='/QIBM/include' 'include/' 

CCFLAGSOK=OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) TGTRLS($(TARGET_RLS)) STGMDL(*INHERIT) SYSIFCOPT(*IFSIO) INCDIR($(INCLUDE)) DBGVIEW($(DBGVIEW)) TGTCCSID($(TARGET_CCSID))

# For current compile:
CCFLAGS=OPTION(*STDLOGMSG) OUTPUT(*NONE) OPTIMIZE(10) ENUM(*INT) TERASPACE(*YES) TGTRLS($(TARGET_RLS)) STGMDL(*INHERIT) SYSIFCOPT(*IFSIO) DBGVIEW(*ALL) INCDIR($(INCLUDE)) 

#
# User-defined part end
#-----------------------------------------------------------

# Dependency list

all: $(BIN_LIB).lib githash ilefastcgi.srvpgm 

ilefastcgi.srvpgm: fcgiapp.c fcgi_stdio.c githash.c os_unix.c


#-----------------------------------------------------------

%.lib:
	-system -q "CRTLIB $* TYPE(*TEST)"

%.entry:
	# Basically do nothing..
	@echo "Adding binding entry $*"

# get the git hash and put it into the version file so it becomes part of the copyright notice in the service program
githash:	
	-$(eval gitshort := $(shell git rev-parse --short HEAD))
	-$(eval githash := $(shell git rev-parse --verify HEAD))
	-touch src/githash.c 
	-setccsid 1252 src/githash.c
	-echo "#pragma comment(copyright,\"System & Method A/S - Sitemule: git checkout $(gitshort) (hash: $(githash) )\")" > src/githash.c 


%.c:
	system -q "CHGATR OBJ('src/$*.c') ATR(*CCSID) VALUE(1252)"
	system "CRTCMOD MODULE($(BIN_LIB)/$(notdir $*)) SRCSTMF('src/$*.c') $(CCFLAGS)"


%.srvpgm:
	
	# You may be wondering what this ugly string is. It's a list of objects created from the dep list that end with .c or .clle.
	$(eval modules := $(patsubst %,$(BIN_LIB)/%,$(basename $(filter %.c ,$(notdir $^)))))
	
	system -q -kpieb "CRTSRVPGM SRVPGM($(BIN_LIB)/$*) MODULE($(modules)) EXPORT(*ALL) ACTGRP(QILE) ALWLIBUPD(*YES) TGTRLS($(TARGET_RLS))"

	@for module in $(modules); do\
		system -q "dltmod $$module" ; \
	done


all:
	@echo Build success!

clean:
	-system -q "CLRLIB LIB($(BIN_LIB))"
	

# For vsCode / single file then i.e.: gmake current sqlio.c  
current: 
	system -q "CRTCMOD MODULE($(BIN_LIB)/$(SRC)) SRCSTMF('src/$(SRC).c') $(CCFLAGS2) "

