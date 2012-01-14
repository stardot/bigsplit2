# Copyright 1997 Acorn Computers Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Makefile for BigSplit2
#
# ***********************************
# ***    C h a n g e   L i s t    ***
# ***********************************
# Date       Name         Description
# ----       ----         -----------
# 24 Jun 1997  NDT	  Stolen form CSFS :-)

#
# Paths
#

#
# Generic options:
#
MKDIR   = do mkdir -p
AS      = objasm
CC      = cc
CMHG    = cmhg
CP      = copy
LD      = link
RM      = remove
WIPE    = x wipe
CD	= dir
DEFMOD  = DefMod
AR	= LibFile
CHMOD	= access

OPTIONS = -DENSURE_LINE

AFLAGS = -depend !Depend -Stamp -quit
CFLAGS  = -c -depend !Depend ${THROWBACK} ${INCLUDES} ${DFLAGS} ${OPTIONS}
CMHGFLAGS = -p ${DFLAGS} ${INCLUDES}
CPFLAGS = ~cfr~v
WFLAGS  = ~c~vr
DFLAGS  =
CHMODFLAGS = RW/R
#
# Libraries
#
CLIB       = CLIB:o.stubs
RLIB       = RISCOSLIB:o.risc_oslib
RSTUBS     = RISCOSLIB:o.rstubs
ROMSTUBS   = RISCOSLIB:o.romstubs
ROMCSTUBS  = RISCOSLIB:o.romcstubs
ABSSYM     = RISC_OSLib:o.AbsSym
INETLIB    = TCPIPLibs:o.inetlib
UNIXLIB    = TCPIPLibs:o.unixlib
REMOTEDB   = <Lib$Dir>.debug.o.remote
#
# Include files
#
INCLUDES = -IC:,TCPIPLibs:,<Lib$Dir>.

# Program specific options:
#
COMPONENT = BigSplit2
TARGET    = abs.${COMPONENT} abs.CRC

.SUFFIXES:   .od

OBJS      =	o.bigsplit2
DOBJS	  =     od.bigsplit2

#
# Rule patterns
#

.c.o:;      ${CC} ${CFLAGS} -o $@ $<
.cmhg.o:;   ${CMHG} ${CMHGFLAGS} $< $@
.s.o:;      ${AS} ${AFLAGS}  $< $@
.c.od:;     ${CC} ${CFLAGS} -o $@ $< -DDEBUG
.cmhg.od:;  ${CMHG} ${CMHGFLAGS} $< $@ -DDEBUG
.s.od:;     ${AS} ${AFLAGS} $< $@
#
# build a relocatable module:
#
all: ${TARGET} dirs
	@echo ${COMPONENT}: complete

debug: abs.${COMPONENT}D
	@echo ${COMPONENT}D: complete

test: all
	ifthere Test.Image then delete Test.Image
	@echo
	@echo Starting test...
	@echo
	time
	abs.${COMPONENT} ${BIGOPTS} Test.ForBigSplt
	time
	@echo
	@echo Checking CRC...
	@echo
	abs.CRC Test.Image
	@echo
	@echo Done.

install: ${TARGET} dirs
	${MKDIR} ${INSTDIR}.Docs
	${CP} abs.${COMPONENT} ${INSTDIR}.${COMPONENT} ${CPFLAGS}
	@echo ${COMPONENT}: tool installed in library

clean:
	${WIPE} o ${WFLAGS}
	${WIPE} od ${WFLAGS}
	${WIPE} rm ${WFLAGS}
	${WIPE} linked ${WFLAGS}
	${WIPE} map ${WFLAGS}
	${WIPE} abs ${WFLAGS}
	${WIPE} Test.Image ${WFLAGS}
	@echo ${COMPONENT}: cleaned
dirs:
	${MKDIR} rm
	${MKDIR} o
	${MKDIR} od
	${MKDIR} linked
	${MKDIR} map
	${MKDIR} abs

#
# App target
#
abs.${COMPONENT}D: ${DOBJS} ${CLIB}
	${LD} -o $@ ${DOBJS} ${CLIB}
	${CHMOD} $@ ${CHMODFLAGS}

abs.${COMPONENT}: ${OBJS} ${CLIB}
	${LD} -o $@ ${OBJS} ${CLIB}
	${CHMOD} $@ ${CHMODFLAGS}

abs.CRC: o.CRC ${CLIB}
	${LD} -o $@ o.CRC ${CLIB}
	${CHMOD} $@ ${CHMODFLAGS}

#
# Dynamic dependencies:
