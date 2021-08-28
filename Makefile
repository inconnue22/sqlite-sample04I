#!/usr/make
#
# Makefile for SQLITE
#
# This makefile is suppose to be configured automatically using the
# autoconf.  But if that does not work for you, you can configure
# the makefile manually.  Just set the parameters below to values that
# work well for your system.
#
# If the configure script does not work out-of-the-box, you might
# be able to get it to work by giving it some hints.  See the comment
# at the beginning of configure.in for additional information.
#

# The toplevel directory of the source tree.  This is the directory
# that contains this "Makefile.in" and the "configure.in" script.
#
TOP = /github/sqlite

# C Compiler and options for use in building executables that
# will run on the platform that is doing the build.
#
BCC = gcc  -g -O2

# TCC is the C Compile and options for use in building executables that
# will run on the target platform.  (BCC and TCC are usually the
# same unless your are cross-compiling.)  Separate CC and CFLAGS macros
# are provide so that these aspects of the build process can be changed
# on the "make" command-line.  Ex:  "make CC=clang CFLAGS=-fsanitize=undefined"
#
CC = gcc
CFLAGS =   -g -O2 -DSQLITE_OS_UNIX=1
TCC = ${CC} ${CFLAGS} -I. -I${TOP}/src -I${TOP}/ext/rtree -I${TOP}/ext/icu
TCC += -I${TOP}/ext/fts3 -I${TOP}/ext/async -I${TOP}/ext/session
TCC += -I${TOP}/ext/userauth

# Define this for the autoconf-based build, so that the code knows it can
# include the generated config.h
#
TCC += -D_HAVE_SQLITE_CONFIG_H -DBUILD_sqlite

# Define -DNDEBUG to compile without debugging (i.e., for production usage)
# Omitting the define will cause extra debugging code to be inserted and
# includes extra comments when "EXPLAIN stmt" is used.
#
TCC += -DNDEBUG

# Compiler options needed for programs that use the TCL library.
#
TCC += 

# The library that programs using TCL must link against.
#
LIBTCL = 

# Compiler options needed for programs that use the readline() library.
#
READLINE_FLAGS = -DHAVE_READLINE=0 
READLINE_FLAGS += -DHAVE_EDITLINE=0

# The library that programs using readline() must link against.
#
LIBREADLINE = 

# Should the database engine be compiled threadsafe
#
TCC += -DSQLITE_THREADSAFE=1

# Any target libraries which libsqlite must be linked against
#
TLIBS = -lm -lm -lz -lpthread  $(LIBS)

# Flags controlling use of the in memory btree implementation
#
# SQLITE_TEMP_STORE is 0 to force temporary tables to be in a file, 1 to
# default to file, 2 to default to memory, and 3 to force temporary
# tables to always be in memory.
#
TEMP_STORE = -DSQLITE_TEMP_STORE=2

# Enable/disable loadable extensions, and other optional features
# based on configuration. (-DSQLITE_OMIT*, -DSQLITE_ENABLE*).
# The same set of OMIT and ENABLE flags should be passed to the
# LEMON parser generator and the mkkeywordhash tool as well.
OPT_FEATURE_FLAGS = -DSQLITE_OMIT_LOAD_EXTENSION=1 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_GEOPOLY -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK

TCC += $(OPT_FEATURE_FLAGS)

# Add in any optional parameters specified on the make commane line
# ie.  make "OPTS=-DSQLITE_ENABLE_FOO=1 -DSQLITE_OMIT_FOO=1".
TCC += $(OPTS)

# Add in compile-time options for some libraries used by extensions
TCC += -DSQLITE_HAVE_ZLIB=1

# Version numbers and release number for the SQLite being compiled.
#
VERSION = 3.35
VERSION_NUMBER = @VERSION_NUMBER@
RELEASE = 3.35.4

# Filename extensions
#
BEXE = 
TEXE = 

# The following variable is "1" if the configure script was able to locate
# the tclConfig.sh file.  It is an empty string otherwise.  When this
# variable is "1", the TCL extension library (libtclsqlite3.so) is built
# and installed.
#
HAVE_TCL = 

# This is the command to use for tclsh - normally just "tclsh", but we may
# know the specific version we want to use
#
TCLSH_CMD = tclsh8.6

# Where do we want to install the tcl plugin
#
TCLLIBDIR = /usr/share/tcl8.6/sqlite3

# The suffix used on shared libraries.  Ex:  ".dll", ".so", ".dylib"
#
SHLIB_SUFFIX = 

# If gcov support was enabled by the configure script, add the appropriate
# flags here.  It's not always as easy as just having the user add the right
# CFLAGS / LDFLAGS, because libtool wants to use CFLAGS when linking, which
# causes build errors with -fprofile-arcs -ftest-coverage with some GCCs.
# Supposedly GCC does the right thing if you use --coverage, but in
# practice it still fails.  See:
#
# http://www.mail-archive.com/debian-gcc@lists.debian.org/msg26197.html
#
# for more info.
#
GCOV_CFLAGS1 = -DSQLITE_COVERAGE_TEST=1 -fprofile-arcs -ftest-coverage
GCOV_LDFLAGS1 = -lgcov
USE_GCOV = 0
LTCOMPILE_EXTRAS += $(GCOV_CFLAGS$(USE_GCOV))
LTLINK_EXTRAS += $(GCOV_LDFLAGS$(USE_GCOV))


# The directory into which to store package information for

# Some standard variables and programs
#
prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib
pkgconfigdir = $(libdir)/pkgconfig
bindir = ${exec_prefix}/bin
includedir = ${prefix}/include
INSTALL = /usr/bin/install -c
LIBTOOL = ./libtool
ALLOWRELEASE = -release 3.35.4

# libtool compile/link/install
LTCOMPILE = $(LIBTOOL) --mode=compile --tag=CC $(TCC) $(LTCOMPILE_EXTRAS)
LTLINK = $(LIBTOOL) --mode=link $(TCC) $(LTCOMPILE_EXTRAS)  $(LTLINK_EXTRAS)
LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)

# You should not have to change anything below this line
###############################################################################

USE_AMALGAMATION = 0

# Object files for the SQLite library (non-amalgamation).
#
LIBOBJS0 = alter.lo analyze.lo attach.lo auth.lo \
         backup.lo bitvec.lo btmutex.lo btree.lo build.lo \
         callback.lo complete.lo ctime.lo \
         date.lo dbpage.lo dbstat.lo delete.lo \
         expr.lo fault.lo fkey.lo \
         fts3.lo fts3_aux.lo fts3_expr.lo fts3_hash.lo fts3_icu.lo \
         fts3_porter.lo fts3_snippet.lo fts3_tokenizer.lo fts3_tokenizer1.lo \
         fts3_tokenize_vtab.lo \
         fts3_unicode.lo fts3_unicode2.lo fts3_write.lo \
	 fts5.lo \
         func.lo global.lo hash.lo \
         icu.lo insert.lo json1.lo legacy.lo loadext.lo \
         main.lo malloc.lo mem0.lo mem1.lo mem2.lo mem3.lo mem5.lo \
         memdb.lo memjournal.lo \
         mutex.lo mutex_noop.lo mutex_unix.lo mutex_w32.lo \
         notify.lo opcodes.lo os.lo os_unix.lo os_win.lo \
         pager.lo parse.lo pcache.lo pcache1.lo pragma.lo prepare.lo printf.lo \
         random.lo resolve.lo rowset.lo rtree.lo \
         sqlite3session.lo select.lo sqlite3rbu.lo status.lo stmt.lo \
         table.lo threads.lo tokenize.lo treeview.lo trigger.lo \
         update.lo userauth.lo upsert.lo util.lo vacuum.lo \
         vdbe.lo vdbeapi.lo vdbeaux.lo vdbeblob.lo vdbemem.lo vdbesort.lo \
         vdbetrace.lo vdbevtab.lo \
         wal.lo walker.lo where.lo wherecode.lo whereexpr.lo \
         window.lo utf.lo vtab.lo

# Object files for the amalgamation.
#
LIBOBJS1 = sqlite3.lo

# Determine the real value of LIBOBJ based on the 'configure' script
#
LIBOBJ = $(LIBOBJS$(USE_AMALGAMATION))


# All of the source code files.
#
SRC = \
  $(TOP)/src/alter.c \
  $(TOP)/src/analyze.c \
  $(TOP)/src/attach.c \
  $(TOP)/src/auth.c \
  $(TOP)/src/backup.c \
  $(TOP)/src/bitvec.c \
  $(TOP)/src/btmutex.c \
  $(TOP)/src/btree.c \
  $(TOP)/src/btree.h \
  $(TOP)/src/btreeInt.h \
  $(TOP)/src/build.c \
  $(TOP)/src/callback.c \
  $(TOP)/src/complete.c \
  $(TOP)/src/ctime.c \
  $(TOP)/src/date.c \
  $(TOP)/src/dbpage.c \
  $(TOP)/src/dbstat.c \
  $(TOP)/src/delete.c \
  $(TOP)/src/expr.c \
  $(TOP)/src/fault.c \
  $(TOP)/src/fkey.c \
  $(TOP)/src/func.c \
  $(TOP)/src/global.c \
  $(TOP)/src/hash.c \
  $(TOP)/src/hash.h \
  $(TOP)/src/hwtime.h \
  $(TOP)/src/insert.c \
  $(TOP)/src/legacy.c \
  $(TOP)/src/loadext.c \
  $(TOP)/src/main.c \
  $(TOP)/src/malloc.c \
  $(TOP)/src/mem0.c \
  $(TOP)/src/mem1.c \
  $(TOP)/src/mem2.c \
  $(TOP)/src/mem3.c \
  $(TOP)/src/mem5.c \
  $(TOP)/src/memdb.c \
  $(TOP)/src/memjournal.c \
  $(TOP)/src/msvc.h \
  $(TOP)/src/mutex.c \
  $(TOP)/src/mutex.h \
  $(TOP)/src/mutex_noop.c \
  $(TOP)/src/mutex_unix.c \
  $(TOP)/src/mutex_w32.c \
  $(TOP)/src/notify.c \
  $(TOP)/src/os.c \
  $(TOP)/src/os.h \
  $(TOP)/src/os_common.h \
  $(TOP)/src/os_setup.h \
  $(TOP)/src/os_unix.c \
  $(TOP)/src/os_win.c \
  $(TOP)/src/os_win.h \
  $(TOP)/src/pager.c \
  $(TOP)/src/pager.h \
  $(TOP)/src/parse.y \
  $(TOP)/src/pcache.c \
  $(TOP)/src/pcache.h \
  $(TOP)/src/pcache1.c \
  $(TOP)/src/pragma.c \
  $(TOP)/src/pragma.h \
  $(TOP)/src/prepare.c \
  $(TOP)/src/printf.c \
  $(TOP)/src/random.c \
  $(TOP)/src/resolve.c \
  $(TOP)/src/rowset.c \
  $(TOP)/src/select.c \
  $(TOP)/src/status.c \
  $(TOP)/src/shell.c.in \
  $(TOP)/src/sqlite.h.in \
  $(TOP)/src/sqlite3ext.h \
  $(TOP)/src/sqliteInt.h \
  $(TOP)/src/sqliteLimit.h \
  $(TOP)/src/table.c \
  $(TOP)/src/tclsqlite.c \
  $(TOP)/src/threads.c \
  $(TOP)/src/tokenize.c \
  $(TOP)/src/treeview.c \
  $(TOP)/src/trigger.c \
  $(TOP)/src/utf.c \
  $(TOP)/src/update.c \
  $(TOP)/src/upsert.c \
  $(TOP)/src/util.c \
  $(TOP)/src/vacuum.c \
  $(TOP)/src/vdbe.c \
  $(TOP)/src/vdbe.h \
  $(TOP)/src/vdbeapi.c \
  $(TOP)/src/vdbeaux.c \
  $(TOP)/src/vdbeblob.c \
  $(TOP)/src/vdbemem.c \
  $(TOP)/src/vdbesort.c \
  $(TOP)/src/vdbetrace.c \
  $(TOP)/src/vdbevtab.c \
  $(TOP)/src/vdbeInt.h \
  $(TOP)/src/vtab.c \
  $(TOP)/src/vxworks.h \
  $(TOP)/src/wal.c \
  $(TOP)/src/wal.h \
  $(TOP)/src/walker.c \
  $(TOP)/src/where.c \
  $(TOP)/src/wherecode.c \
  $(TOP)/src/whereexpr.c \
  $(TOP)/src/whereInt.h \
  $(TOP)/src/window.c

# Source code for extensions
#
SRC += \
  $(TOP)/ext/fts1/fts1.c \
  $(TOP)/ext/fts1/fts1.h \
  $(TOP)/ext/fts1/fts1_hash.c \
  $(TOP)/ext/fts1/fts1_hash.h \
  $(TOP)/ext/fts1/fts1_porter.c \
  $(TOP)/ext/fts1/fts1_tokenizer.h \
  $(TOP)/ext/fts1/fts1_tokenizer1.c
SRC += \
  $(TOP)/ext/fts2/fts2.c \
  $(TOP)/ext/fts2/fts2.h \
  $(TOP)/ext/fts2/fts2_hash.c \
  $(TOP)/ext/fts2/fts2_hash.h \
  $(TOP)/ext/fts2/fts2_icu.c \
  $(TOP)/ext/fts2/fts2_porter.c \
  $(TOP)/ext/fts2/fts2_tokenizer.h \
  $(TOP)/ext/fts2/fts2_tokenizer.c \
  $(TOP)/ext/fts2/fts2_tokenizer1.c
SRC += \
  $(TOP)/ext/fts3/fts3.c \
  $(TOP)/ext/fts3/fts3.h \
  $(TOP)/ext/fts3/fts3Int.h \
  $(TOP)/ext/fts3/fts3_aux.c \
  $(TOP)/ext/fts3/fts3_expr.c \
  $(TOP)/ext/fts3/fts3_hash.c \
  $(TOP)/ext/fts3/fts3_hash.h \
  $(TOP)/ext/fts3/fts3_icu.c \
  $(TOP)/ext/fts3/fts3_porter.c \
  $(TOP)/ext/fts3/fts3_snippet.c \
  $(TOP)/ext/fts3/fts3_tokenizer.h \
  $(TOP)/ext/fts3/fts3_tokenizer.c \
  $(TOP)/ext/fts3/fts3_tokenizer1.c \
  $(TOP)/ext/fts3/fts3_tokenize_vtab.c \
  $(TOP)/ext/fts3/fts3_unicode.c \
  $(TOP)/ext/fts3/fts3_unicode2.c \
  $(TOP)/ext/fts3/fts3_write.c
SRC += \
  $(TOP)/ext/icu/sqliteicu.h \
  $(TOP)/ext/icu/icu.c
SRC += \
  $(TOP)/ext/rtree/rtree.h \
  $(TOP)/ext/rtree/rtree.c \
  $(TOP)/ext/rtree/geopoly.c
SRC += \
  $(TOP)/ext/session/sqlite3session.c \
  $(TOP)/ext/session/sqlite3session.h
SRC += \
  $(TOP)/ext/userauth/userauth.c \
  $(TOP)/ext/userauth/sqlite3userauth.h
SRC += \
  $(TOP)/ext/rbu/sqlite3rbu.h \
  $(TOP)/ext/rbu/sqlite3rbu.c
SRC += \
  $(TOP)/ext/misc/json1.c \
  $(TOP)/ext/misc/stmt.c

# Generated source code files
#
SRC += \
  keywordhash.h \
  opcodes.c \
  opcodes.h \
  parse.c \
  parse.h \
  config.h \
  shell.c \
  sqlite3.h

# Source code to the test files.
#
TESTSRC = \
  $(TOP)/src/test1.c \
  $(TOP)/src/test2.c \
  $(TOP)/src/test3.c \
  $(TOP)/src/test4.c \
  $(TOP)/src/test5.c \
  $(TOP)/src/test6.c \
  $(TOP)/src/test7.c \
  $(TOP)/src/test8.c \
  $(TOP)/src/test9.c \
  $(TOP)/src/test_autoext.c \
  $(TOP)/src/test_async.c \
  $(TOP)/src/test_backup.c \
  $(TOP)/src/test_bestindex.c \
  $(TOP)/src/test_blob.c \
  $(TOP)/src/test_btree.c \
  $(TOP)/src/test_config.c \
  $(TOP)/src/test_delete.c \
  $(TOP)/src/test_demovfs.c \
  $(TOP)/src/test_devsym.c \
  $(TOP)/src/test_fs.c \
  $(TOP)/src/test_func.c \
  $(TOP)/src/test_hexio.c \
  $(TOP)/src/test_init.c \
  $(TOP)/src/test_intarray.c \
  $(TOP)/src/test_journal.c \
  $(TOP)/src/test_malloc.c \
  $(TOP)/src/test_md5.c \
  $(TOP)/src/test_multiplex.c \
  $(TOP)/src/test_mutex.c \
  $(TOP)/src/test_onefile.c \
  $(TOP)/src/test_osinst.c \
  $(TOP)/src/test_pcache.c \
  $(TOP)/src/test_quota.c \
  $(TOP)/src/test_rtree.c \
  $(TOP)/src/test_schema.c \
  $(TOP)/src/test_server.c \
  $(TOP)/src/test_superlock.c \
  $(TOP)/src/test_syscall.c \
  $(TOP)/src/test_tclsh.c \
  $(TOP)/src/test_tclvar.c \
  $(TOP)/src/test_thread.c \
  $(TOP)/src/test_vdbecov.c \
  $(TOP)/src/test_vfs.c \
  $(TOP)/src/test_windirent.c \
  $(TOP)/src/test_window.c \
  $(TOP)/src/test_wsd.c       \
  $(TOP)/ext/fts3/fts3_term.c \
  $(TOP)/ext/fts3/fts3_test.c  \
  $(TOP)/ext/session/test_session.c \
  $(TOP)/ext/rbu/test_rbu.c

# Statically linked extensions
#
TESTSRC += \
  $(TOP)/ext/expert/sqlite3expert.c \
  $(TOP)/ext/expert/test_expert.c \
  $(TOP)/ext/misc/amatch.c \
  $(TOP)/ext/misc/appendvfs.c \
  $(TOP)/ext/misc/carray.c \
  $(TOP)/ext/misc/cksumvfs.c \
  $(TOP)/ext/misc/closure.c \
  $(TOP)/ext/misc/csv.c \
  $(TOP)/ext/misc/decimal.c \
  $(TOP)/ext/misc/eval.c \
  $(TOP)/ext/misc/explain.c \
  $(TOP)/ext/misc/fileio.c \
  $(TOP)/ext/misc/fuzzer.c \
  $(TOP)/ext/fts5/fts5_tcl.c \
  $(TOP)/ext/fts5/fts5_test_mi.c \
  $(TOP)/ext/fts5/fts5_test_tok.c \
  $(TOP)/ext/misc/ieee754.c \
  $(TOP)/ext/misc/mmapwarm.c \
  $(TOP)/ext/misc/nextchar.c \
  $(TOP)/ext/misc/normalize.c \
  $(TOP)/ext/misc/percentile.c \
  $(TOP)/ext/misc/prefixes.c \
  $(TOP)/ext/misc/regexp.c \
  $(TOP)/ext/misc/remember.c \
  $(TOP)/ext/misc/series.c \
  $(TOP)/ext/misc/spellfix.c \
  $(TOP)/ext/misc/totype.c \
  $(TOP)/ext/misc/unionvtab.c \
  $(TOP)/ext/misc/wholenumber.c \
  $(TOP)/ext/misc/zipfile.c \
  $(TOP)/ext/userauth/userauth.c

# Source code to the library files needed by the test fixture
#
TESTSRC2 = \
  $(TOP)/src/attach.c \
  $(TOP)/src/backup.c \
  $(TOP)/src/bitvec.c \
  $(TOP)/src/btree.c \
  $(TOP)/src/build.c \
  $(TOP)/src/ctime.c \
  $(TOP)/src/date.c \
  $(TOP)/src/dbpage.c \
  $(TOP)/src/dbstat.c \
  $(TOP)/src/expr.c \
  $(TOP)/src/func.c \
  $(TOP)/src/global.c \
  $(TOP)/src/insert.c \
  $(TOP)/src/wal.c \
  $(TOP)/src/main.c \
  $(TOP)/src/mem5.c \
  $(TOP)/src/os.c \
  $(TOP)/src/os_unix.c \
  $(TOP)/src/os_win.c \
  $(TOP)/src/pager.c \
  $(TOP)/src/pragma.c \
  $(TOP)/src/prepare.c \
  $(TOP)/src/printf.c \
  $(TOP)/src/random.c \
  $(TOP)/src/pcache.c \
  $(TOP)/src/pcache1.c \
  $(TOP)/src/select.c \
  $(TOP)/src/tokenize.c \
  $(TOP)/src/utf.c \
  $(TOP)/src/util.c \
  $(TOP)/src/vdbeapi.c \
  $(TOP)/src/vdbeaux.c \
  $(TOP)/src/vdbe.c \
  $(TOP)/src/vdbemem.c \
  $(TOP)/src/vdbetrace.c \
  $(TOP)/src/vdbevtab.c \
  $(TOP)/src/where.c \
  $(TOP)/src/wherecode.c \
  $(TOP)/src/whereexpr.c \
  $(TOP)/src/window.c \
  parse.c \
  $(TOP)/ext/fts3/fts3.c \
  $(TOP)/ext/fts3/fts3_aux.c \
  $(TOP)/ext/fts3/fts3_expr.c \
  $(TOP)/ext/fts3/fts3_term.c \
  $(TOP)/ext/fts3/fts3_tokenizer.c \
  $(TOP)/ext/fts3/fts3_write.c \
  $(TOP)/ext/async/sqlite3async.c \
  $(TOP)/ext/session/sqlite3session.c \
  $(TOP)/ext/misc/stmt.c

# Header files used by all library source files.
#
HDR = \
   $(TOP)/src/btree.h \
   $(TOP)/src/btreeInt.h \
   $(TOP)/src/hash.h \
   $(TOP)/src/hwtime.h \
   keywordhash.h \
   $(TOP)/src/msvc.h \
   $(TOP)/src/mutex.h \
   opcodes.h \
   $(TOP)/src/os.h \
   $(TOP)/src/os_common.h \
   $(TOP)/src/os_setup.h \
   $(TOP)/src/os_win.h \
   $(TOP)/src/pager.h \
   $(TOP)/src/pcache.h \
   parse.h  \
   $(TOP)/src/pragma.h \
   sqlite3.h  \
   $(TOP)/src/sqlite3ext.h \
   $(TOP)/src/sqliteInt.h  \
   $(TOP)/src/sqliteLimit.h \
   $(TOP)/src/vdbe.h \
   $(TOP)/src/vdbeInt.h \
   $(TOP)/src/vxworks.h \
   $(TOP)/src/whereInt.h \
   config.h

# Header files used by extensions
#
EXTHDR += \
  $(TOP)/ext/fts1/fts1.h \
  $(TOP)/ext/fts1/fts1_hash.h \
  $(TOP)/ext/fts1/fts1_tokenizer.h
EXTHDR += \
  $(TOP)/ext/fts2/fts2.h \
  $(TOP)/ext/fts2/fts2_hash.h \
  $(TOP)/ext/fts2/fts2_tokenizer.h
EXTHDR += \
  $(TOP)/ext/fts3/fts3.h \
  $(TOP)/ext/fts3/fts3Int.h \
  $(TOP)/ext/fts3/fts3_hash.h \
  $(TOP)/ext/fts3/fts3_tokenizer.h
EXTHDR += \
  $(TOP)/ext/rtree/rtree.h \
  $(TOP)/ext/rtree/geopoly.c
EXTHDR += \
  $(TOP)/ext/icu/sqliteicu.h
EXTHDR += \
  $(TOP)/ext/rtree/sqlite3rtree.h
EXTHDR += \
  $(TOP)/ext/userauth/sqlite3userauth.h

# executables needed for testing
#
TESTPROGS = \
  testfixture$(TEXE) \
  sqlite3$(TEXE) \
  sqlite3_analyzer$(TEXE) \
  sqldiff$(TEXE) \
  dbhash$(TEXE) \
  sqltclsh$(TEXE)

# Databases containing fuzzer test cases
#
FUZZDATA = \
  $(TOP)/test/fuzzdata1.db \
  $(TOP)/test/fuzzdata2.db \
  $(TOP)/test/fuzzdata3.db \
  $(TOP)/test/fuzzdata4.db \
  $(TOP)/test/fuzzdata5.db \
  $(TOP)/test/fuzzdata6.db \
  $(TOP)/test/fuzzdata7.db \
  $(TOP)/test/fuzzdata8.db

# Standard options to testfixture
#
TESTOPTS = --verbose=file --output=test-out.txt

# Extra compiler options for various shell tools
#
SHELL_OPT = -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS4
#SHELL_OPT += -DSQLITE_ENABLE_FTS5
SHELL_OPT += -DSQLITE_ENABLE_RTREE
SHELL_OPT += -DSQLITE_ENABLE_EXPLAIN_COMMENTS
SHELL_OPT += -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION
SHELL_OPT += -DSQLITE_ENABLE_STMTVTAB
SHELL_OPT += -DSQLITE_ENABLE_DBPAGE_VTAB
SHELL_OPT += -DSQLITE_ENABLE_DBSTAT_VTAB
SHELL_OPT += -DSQLITE_ENABLE_BYTECODE_VTAB
SHELL_OPT += -DSQLITE_ENABLE_OFFSET_SQL_FUNC
SHELL_OPT += -DSQLITE_ENABLE_DESERIALIZE
FUZZERSHELL_OPT = -DSQLITE_ENABLE_JSON1
FUZZCHECK_OPT = -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_OSS_FUZZ
FUZZCHECK_OPT += -DSQLITE_MAX_MEMORY=50000000
FUZZCHECK_OPT += -DSQLITE_PRINTF_PRECISION_LIMIT=1000
FUZZCHECK_OPT += -DSQLITE_ENABLE_DESERIALIZE
FUZZCHECK_OPT += -DSQLITE_ENABLE_FTS4
FUZZCHECK_OPT += -DSQLITE_ENABLE_FTS3_PARENTHESIS
#FUZZCHECK_OPT += -DSQLITE_ENABLE_FTS5
FUZZCHECK_OPT += -DSQLITE_ENABLE_RTREE
FUZZCHECK_OPT += -DSQLITE_ENABLE_GEOPOLY
FUZZCHECK_OPT += -DSQLITE_ENABLE_DBSTAT_VTAB
FUZZCHECK_OPT += -DSQLITE_ENABLE_BYTECODE_VTAB
FUZZCHECK_SRC = $(TOP)/test/fuzzcheck.c $(TOP)/test/ossfuzz.c
DBFUZZ_OPT =

# This is the default Makefile target.  The objects listed here
# are what get build when you type just "make" with no arguments.
#
all:	sqlite3.h libsqlite3.la sqlite3$(TEXE) $(HAVE_TCL:1=libtclsqlite3.la)

Makefile: $(TOP)/Makefile.in
	./config.status

sqlite3.pc: $(TOP)/sqlite3.pc.in
	./config.status

libsqlite3.la:	$(LIBOBJ)
	$(LTLINK) -no-undefined -o $@ $(LIBOBJ) $(TLIBS) \
		${ALLOWRELEASE} -rpath "$(libdir)" -version-info "8:6:8"

libtclsqlite3.la:	tclsqlite.lo libsqlite3.la
	$(LTLINK) -no-undefined -o $@ tclsqlite.lo \
		libsqlite3.la  $(TLIBS) \
		-rpath "$(TCLLIBDIR)" \
		-version-info "8:6:8" \
		-avoid-version

sqlite3$(TEXE):	shell.c sqlite3.c
	$(LTLINK) $(READLINE_FLAGS) $(SHELL_OPT) -o $@ \
		shell.c sqlite3.c \
		$(LIBREADLINE) $(TLIBS) -rpath "$(libdir)"

sqldiff$(TEXE):	$(TOP)/tool/sqldiff.c sqlite3.lo sqlite3.h
	$(LTLINK) -o $@ $(TOP)/tool/sqldiff.c sqlite3.lo $(TLIBS)

dbhash$(TEXE):	$(TOP)/tool/dbhash.c sqlite3.lo sqlite3.h
	$(LTLINK) -o $@ $(TOP)/tool/dbhash.c sqlite3.lo $(TLIBS)

scrub$(TEXE):	$(TOP)/ext/misc/scrub.c sqlite3.lo
	$(LTLINK) -o $@ -I. -DSCRUB_STANDALONE \
		$(TOP)/ext/misc/scrub.c sqlite3.lo $(TLIBS)

srcck1$(BEXE):	$(TOP)/tool/srcck1.c
	$(BCC) -o srcck1$(BEXE) $(TOP)/tool/srcck1.c

sourcetest:	srcck1$(BEXE) sqlite3.c
	./srcck1 sqlite3.c

fuzzershell$(TEXE):	$(TOP)/tool/fuzzershell.c sqlite3.c sqlite3.h
	$(LTLINK) -o $@ $(FUZZERSHELL_OPT) \
	  $(TOP)/tool/fuzzershell.c sqlite3.c $(TLIBS)

fuzzcheck$(TEXE):	$(FUZZCHECK_SRC) sqlite3.c sqlite3.h
	$(LTLINK) -o $@ $(FUZZCHECK_OPT) $(FUZZCHECK_SRC) sqlite3.c $(TLIBS)

ossshell$(TEXE):	$(TOP)/test/ossfuzz.c $(TOP)/test/ossshell.c sqlite3.c sqlite3.h
	$(LTLINK) -o $@ $(FUZZCHECK_OPT) $(TOP)/test/ossshell.c \
             $(TOP)/test/ossfuzz.c sqlite3.c $(TLIBS)

sessionfuzz$(TEXE):	$(TOP)/test/sessionfuzz.c sqlite3.c sqlite3.h
	$(LTLINK) -o $@ $(TOP)/test/sessionfuzz.c $(TLIBS)

dbfuzz$(TEXE):	$(TOP)/test/dbfuzz.c sqlite3.c sqlite3.h
	$(LTLINK) -o $@ $(DBFUZZ_OPT) $(TOP)/test/dbfuzz.c sqlite3.c $(TLIBS)

DBFUZZ2_OPTS = \
  -DSQLITE_THREADSAFE=0 \
  -DSQLITE_OMIT_LOAD_EXTENSION \
  -DSQLITE_ENABLE_DESERIALIZE \
  -DSQLITE_DEBUG \
  -DSQLITE_ENABLE_DBSTAT_VTAB \
  -DSQLITE_ENABLE_BYTECODE_VTAB \
  -DSQLITE_ENABLE_RTREE \
  -DSQLITE_ENABLE_FTS4 \
  -DSQLITE_ENABLE_FTS5

dbfuzz2$(TEXE):	$(TOP)/test/dbfuzz2.c sqlite3.c sqlite3.h
	$(CC) $(OPT_FEATURE_FLAGS) $(OPTS) -I. -g -O0 \
		-DSTANDALONE -o dbfuzz2 \
		$(DBFUZZ2_OPTS) $(TOP)/test/dbfuzz2.c sqlite3.c $(TLIBS)
	mkdir -p dbfuzz2-dir
	cp $(TOP)/test/dbfuzz2-seed* dbfuzz2-dir

dbfuzz2-asan:	$(TOP)/test/dbfuzz2.c sqlite3.c sqlite3.h
	clang-6.0 $(OPT_FEATURE_FLAGS) $(OPTS) -I. -g -O0 \
		-fsanitize=fuzzer,undefined,address -o dbfuzz2-asan \
		$(DBFUZZ2_OPTS) $(TOP)/test/dbfuzz2.c sqlite3.c $(TLIBS)
	mkdir -p dbfuzz2-dir
	cp $(TOP)/test/dbfuzz2-seed* dbfuzz2-dir

dbfuzz2-msan:	$(TOP)/test/dbfuzz2.c sqlite3.c sqlite3.h
	clang-6.0 $(OPT_FEATURE_FLAGS) $(OPTS) -I. -g -O0 \
		-fsanitize=fuzzer,undefined,memory -o dbfuzz2-msan \
		$(DBFUZZ2_OPTS) $(TOP)/test/dbfuzz2.c sqlite3.c $(TLIBS)
	mkdir -p dbfuzz2-dir
	cp $(TOP)/test/dbfuzz2-seed* dbfuzz2-dir

mptester$(TEXE):	sqlite3.lo $(TOP)/mptest/mptest.c
	$(LTLINK) -o $@ -I. $(TOP)/mptest/mptest.c sqlite3.lo \
		$(TLIBS) -rpath "$(libdir)"

MPTEST1=./mptester$(TEXE) mptest.db $(TOP)/mptest/crash01.test --repeat 20
MPTEST2=./mptester$(TEXE) mptest.db $(TOP)/mptest/multiwrite01.test --repeat 20
mptest:	mptester$(TEXE)
	rm -f mptest.db
	$(MPTEST1) --journalmode DELETE
	$(MPTEST2) --journalmode WAL
	$(MPTEST1) --journalmode WAL
	$(MPTEST2) --journalmode PERSIST
	$(MPTEST1) --journalmode PERSIST
	$(MPTEST2) --journalmode TRUNCATE
	$(MPTEST1) --journalmode TRUNCATE
	$(MPTEST2) --journalmode DELETE


# This target creates a directory named "tsrc" and fills it with
# copies of all of the C source code and header files needed to
# build on the target system.  Some of the C source code and header
# files are automatically generated.  This target takes care of
# all that automatic generation.
#
.target_source:	$(SRC) $(TOP)/tool/vdbe-compress.tcl fts5.c
	rm -rf tsrc
	mkdir tsrc
	cp -f $(SRC) tsrc
	rm tsrc/sqlite.h.in tsrc/parse.y
	$(TCLSH_CMD) $(TOP)/tool/vdbe-compress.tcl $(OPTS) <tsrc/vdbe.c >vdbe.new
	mv vdbe.new tsrc/vdbe.c
	cp fts5.c fts5.h tsrc
	touch .target_source

sqlite3.c:	.target_source $(TOP)/tool/mksqlite3c.tcl
	$(TCLSH_CMD) $(TOP)/tool/mksqlite3c.tcl
	cp tsrc/sqlite3ext.h .
	cp $(TOP)/ext/session/sqlite3session.h .

sqlite3ext.h:	.target_source
	cp tsrc/sqlite3ext.h .

tclsqlite3.c:	sqlite3.c
	echo '#ifndef USE_SYSTEM_SQLITE' >tclsqlite3.c
	cat sqlite3.c >>tclsqlite3.c
	echo '#endif /* USE_SYSTEM_SQLITE */' >>tclsqlite3.c
	cat $(TOP)/src/tclsqlite.c >>tclsqlite3.c

sqlite3-all.c:	sqlite3.c $(TOP)/tool/split-sqlite3c.tcl
	$(TCLSH_CMD) $(TOP)/tool/split-sqlite3c.tcl

# Rule to build the amalgamation
#
sqlite3.lo:	sqlite3.c
	$(LTCOMPILE) $(TEMP_STORE) -c sqlite3.c

# Rules to build the LEMON compiler generator
#
lemon$(BEXE):	$(TOP)/tool/lemon.c $(TOP)/tool/lempar.c
	$(BCC) -o $@ $(TOP)/tool/lemon.c
	cp $(TOP)/tool/lempar.c .

# Rules to build the program that generates the source-id
#
mksourceid$(BEXE):	$(TOP)/tool/mksourceid.c
	$(BCC) -o $@ $(TOP)/tool/mksourceid.c

# Rules to build individual *.o files from generated *.c files. This
# applies to:
#
#     parse.o
#     opcodes.o
#
parse.lo:	parse.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c parse.c

opcodes.lo:	opcodes.c
	$(LTCOMPILE) $(TEMP_STORE) -c opcodes.c

# Rules to build individual *.o files from files in the src directory.
#
alter.lo:	$(TOP)/src/alter.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/alter.c

analyze.lo:	$(TOP)/src/analyze.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/analyze.c

attach.lo:	$(TOP)/src/attach.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/attach.c

auth.lo:	$(TOP)/src/auth.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/auth.c

backup.lo:	$(TOP)/src/backup.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/backup.c

bitvec.lo:	$(TOP)/src/bitvec.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/bitvec.c

btmutex.lo:	$(TOP)/src/btmutex.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/btmutex.c

btree.lo:	$(TOP)/src/btree.c $(HDR) $(TOP)/src/pager.h
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/btree.c

build.lo:	$(TOP)/src/build.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/build.c

callback.lo:	$(TOP)/src/callback.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/callback.c

complete.lo:	$(TOP)/src/complete.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/complete.c

ctime.lo:	$(TOP)/src/ctime.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/ctime.c

date.lo:	$(TOP)/src/date.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/date.c

dbpage.lo:	$(TOP)/src/dbpage.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/dbpage.c

dbstat.lo:	$(TOP)/src/dbstat.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/dbstat.c

delete.lo:	$(TOP)/src/delete.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/delete.c

expr.lo:	$(TOP)/src/expr.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/expr.c

fault.lo:	$(TOP)/src/fault.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/fault.c

fkey.lo:	$(TOP)/src/fkey.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/fkey.c

func.lo:	$(TOP)/src/func.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/func.c

global.lo:	$(TOP)/src/global.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/global.c

hash.lo:	$(TOP)/src/hash.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/hash.c

insert.lo:	$(TOP)/src/insert.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/insert.c

legacy.lo:	$(TOP)/src/legacy.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/legacy.c

loadext.lo:	$(TOP)/src/loadext.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/loadext.c

main.lo:	$(TOP)/src/main.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/main.c

malloc.lo:	$(TOP)/src/malloc.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/malloc.c

mem0.lo:	$(TOP)/src/mem0.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mem0.c

mem1.lo:	$(TOP)/src/mem1.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mem1.c

mem2.lo:	$(TOP)/src/mem2.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mem2.c

mem3.lo:	$(TOP)/src/mem3.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mem3.c

mem5.lo:	$(TOP)/src/mem5.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mem5.c

memdb.lo:	$(TOP)/src/memdb.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/memdb.c

memjournal.lo:	$(TOP)/src/memjournal.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/memjournal.c

mutex.lo:	$(TOP)/src/mutex.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mutex.c

mutex_noop.lo:	$(TOP)/src/mutex_noop.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mutex_noop.c

mutex_unix.lo:	$(TOP)/src/mutex_unix.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mutex_unix.c

mutex_w32.lo:	$(TOP)/src/mutex_w32.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/mutex_w32.c

notify.lo:	$(TOP)/src/notify.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/notify.c

pager.lo:	$(TOP)/src/pager.c $(HDR) $(TOP)/src/pager.h
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/pager.c

pcache.lo:	$(TOP)/src/pcache.c $(HDR) $(TOP)/src/pcache.h
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/pcache.c

pcache1.lo:	$(TOP)/src/pcache1.c $(HDR) $(TOP)/src/pcache.h
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/pcache1.c

os.lo:	$(TOP)/src/os.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/os.c

os_unix.lo:	$(TOP)/src/os_unix.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/os_unix.c

os_win.lo:	$(TOP)/src/os_win.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/os_win.c

pragma.lo:	$(TOP)/src/pragma.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/pragma.c

prepare.lo:	$(TOP)/src/prepare.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/prepare.c

printf.lo:	$(TOP)/src/printf.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/printf.c

random.lo:	$(TOP)/src/random.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/random.c

resolve.lo:	$(TOP)/src/resolve.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/resolve.c

rowset.lo:	$(TOP)/src/rowset.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/rowset.c

select.lo:	$(TOP)/src/select.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/select.c

status.lo:	$(TOP)/src/status.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/status.c

table.lo:	$(TOP)/src/table.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/table.c

threads.lo:	$(TOP)/src/threads.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/threads.c

tokenize.lo:	$(TOP)/src/tokenize.c keywordhash.h $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/tokenize.c

treeview.lo:	$(TOP)/src/treeview.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/treeview.c

trigger.lo:	$(TOP)/src/trigger.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/trigger.c

update.lo:	$(TOP)/src/update.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/update.c

upsert.lo:	$(TOP)/src/upsert.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/upsert.c

utf.lo:	$(TOP)/src/utf.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/utf.c

util.lo:	$(TOP)/src/util.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/util.c

vacuum.lo:	$(TOP)/src/vacuum.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vacuum.c

vdbe.lo:	$(TOP)/src/vdbe.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbe.c

vdbeapi.lo:	$(TOP)/src/vdbeapi.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbeapi.c

vdbeaux.lo:	$(TOP)/src/vdbeaux.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbeaux.c

vdbeblob.lo:	$(TOP)/src/vdbeblob.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbeblob.c

vdbemem.lo:	$(TOP)/src/vdbemem.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbemem.c

vdbesort.lo:	$(TOP)/src/vdbesort.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbesort.c

vdbetrace.lo:	$(TOP)/src/vdbetrace.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbetrace.c

vdbevtab.lo:	$(TOP)/src/vdbevtab.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vdbevtab.c

vtab.lo:	$(TOP)/src/vtab.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/vtab.c

wal.lo:	$(TOP)/src/wal.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/wal.c

walker.lo:	$(TOP)/src/walker.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/walker.c

where.lo:	$(TOP)/src/where.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/where.c

wherecode.lo:	$(TOP)/src/wherecode.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/wherecode.c

whereexpr.lo:	$(TOP)/src/whereexpr.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/whereexpr.c

window.lo:	$(TOP)/src/window.c $(HDR)
	$(LTCOMPILE) $(TEMP_STORE) -c $(TOP)/src/window.c

tclsqlite.lo:	$(TOP)/src/tclsqlite.c $(HDR)
	$(LTCOMPILE) -DUSE_TCL_STUBS=1 -c $(TOP)/src/tclsqlite.c

tclsqlite-shell.lo:	$(TOP)/src/tclsqlite.c $(HDR)
	$(LTCOMPILE) -DTCLSH -o $@ -c $(TOP)/src/tclsqlite.c

tclsqlite-stubs.lo:	$(TOP)/src/tclsqlite.c $(HDR)
	$(LTCOMPILE) -DUSE_TCL_STUBS=1 -o $@ -c $(TOP)/src/tclsqlite.c

tclsqlite3$(TEXE):	tclsqlite-shell.lo libsqlite3.la
	$(LTLINK) -o $@ tclsqlite-shell.lo \
		 libsqlite3.la $(LIBTCL)

# Rules to build opcodes.c and opcodes.h
#
opcodes.c:	opcodes.h $(TOP)/tool/mkopcodec.tcl
	$(TCLSH_CMD) $(TOP)/tool/mkopcodec.tcl opcodes.h >opcodes.c

opcodes.h:	parse.h $(TOP)/src/vdbe.c $(TOP)/tool/mkopcodeh.tcl
	cat parse.h $(TOP)/src/vdbe.c | $(TCLSH_CMD) $(TOP)/tool/mkopcodeh.tcl >opcodes.h

# Rules to build parse.c and parse.h - the outputs of lemon.
#
parse.h:	parse.c

parse.c:	$(TOP)/src/parse.y lemon$(BEXE)
	cp $(TOP)/src/parse.y .
	./lemon$(BEXE) $(OPT_FEATURE_FLAGS) $(OPTS) -S parse.y

sqlite3.h:	$(TOP)/src/sqlite.h.in $(TOP)/manifest mksourceid$(BEXE) $(TOP)/VERSION
	$(TCLSH_CMD) $(TOP)/tool/mksqlite3h.tcl $(TOP) >sqlite3.h

sqlite3rc.h:	$(TOP)/src/sqlite3.rc $(TOP)/VERSION
	echo '#ifndef SQLITE_RESOURCE_VERSION' >$@
	echo -n '#define SQLITE_RESOURCE_VERSION ' >>$@
	cat $(TOP)/VERSION | $(TCLSH_CMD) $(TOP)/tool/replace.tcl exact . , >>$@
	echo '#endif' >>sqlite3rc.h

keywordhash.h:	$(TOP)/tool/mkkeywordhash.c
	$(BCC) -o mkkeywordhash$(BEXE) $(OPT_FEATURE_FLAGS) $(OPTS) $(TOP)/tool/mkkeywordhash.c
	./mkkeywordhash$(BEXE) >keywordhash.h

# Source files that go into making shell.c
SHELL_SRC = \
	$(TOP)/src/shell.c.in \
        $(TOP)/ext/misc/appendvfs.c \
	$(TOP)/ext/misc/completion.c \
        $(TOP)/ext/misc/decimal.c \
	$(TOP)/ext/misc/fileio.c \
        $(TOP)/ext/misc/ieee754.c \
        $(TOP)/ext/misc/series.c \
	$(TOP)/ext/misc/shathree.c \
	$(TOP)/ext/misc/sqlar.c \
        $(TOP)/ext/misc/uint.c \
	$(TOP)/ext/expert/sqlite3expert.c \
	$(TOP)/ext/expert/sqlite3expert.h \
	$(TOP)/ext/misc/zipfile.c \
	$(TOP)/ext/misc/memtrace.c \
        $(TOP)/src/test_windirent.c

shell.c:	$(SHELL_SRC) $(TOP)/tool/mkshellc.tcl
	$(TCLSH_CMD) $(TOP)/tool/mkshellc.tcl >shell.c




# Rules to build the extension objects.
#
icu.lo:	$(TOP)/ext/icu/icu.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/icu/icu.c

fts2.lo:	$(TOP)/ext/fts2/fts2.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2.c

fts2_hash.lo:	$(TOP)/ext/fts2/fts2_hash.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2_hash.c

fts2_icu.lo:	$(TOP)/ext/fts2/fts2_icu.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2_icu.c

fts2_porter.lo:	$(TOP)/ext/fts2/fts2_porter.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2_porter.c

fts2_tokenizer.lo:	$(TOP)/ext/fts2/fts2_tokenizer.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2_tokenizer.c

fts2_tokenizer1.lo:	$(TOP)/ext/fts2/fts2_tokenizer1.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts2/fts2_tokenizer1.c

fts3.lo:	$(TOP)/ext/fts3/fts3.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3.c

fts3_aux.lo:	$(TOP)/ext/fts3/fts3_aux.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_aux.c

fts3_expr.lo:	$(TOP)/ext/fts3/fts3_expr.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_expr.c

fts3_hash.lo:	$(TOP)/ext/fts3/fts3_hash.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_hash.c

fts3_icu.lo:	$(TOP)/ext/fts3/fts3_icu.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_icu.c

fts3_porter.lo:	$(TOP)/ext/fts3/fts3_porter.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_porter.c

fts3_snippet.lo:	$(TOP)/ext/fts3/fts3_snippet.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_snippet.c

fts3_tokenizer.lo:	$(TOP)/ext/fts3/fts3_tokenizer.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_tokenizer.c

fts3_tokenizer1.lo:	$(TOP)/ext/fts3/fts3_tokenizer1.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_tokenizer1.c

fts3_tokenize_vtab.lo:	$(TOP)/ext/fts3/fts3_tokenize_vtab.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_tokenize_vtab.c

fts3_unicode.lo:	$(TOP)/ext/fts3/fts3_unicode.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_unicode.c

fts3_unicode2.lo:	$(TOP)/ext/fts3/fts3_unicode2.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_unicode2.c

fts3_write.lo:	$(TOP)/ext/fts3/fts3_write.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/fts3/fts3_write.c

rtree.lo:	$(TOP)/ext/rtree/rtree.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/rtree/rtree.c

userauth.lo:	$(TOP)/ext/userauth/userauth.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/userauth/userauth.c

sqlite3session.lo:	$(TOP)/ext/session/sqlite3session.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/session/sqlite3session.c

json1.lo:	$(TOP)/ext/misc/json1.c
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/misc/json1.c

stmt.lo:	$(TOP)/ext/misc/stmt.c
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/misc/stmt.c

# FTS5 things
#
FTS5_SRC = \
   $(TOP)/ext/fts5/fts5.h \
   $(TOP)/ext/fts5/fts5Int.h \
   $(TOP)/ext/fts5/fts5_aux.c \
   $(TOP)/ext/fts5/fts5_buffer.c \
   $(TOP)/ext/fts5/fts5_main.c \
   $(TOP)/ext/fts5/fts5_config.c \
   $(TOP)/ext/fts5/fts5_expr.c \
   $(TOP)/ext/fts5/fts5_hash.c \
   $(TOP)/ext/fts5/fts5_index.c \
   fts5parse.c fts5parse.h \
   $(TOP)/ext/fts5/fts5_storage.c \
   $(TOP)/ext/fts5/fts5_tokenize.c \
   $(TOP)/ext/fts5/fts5_unicode2.c \
   $(TOP)/ext/fts5/fts5_varint.c \
   $(TOP)/ext/fts5/fts5_vocab.c  \

fts5parse.c:	$(TOP)/ext/fts5/fts5parse.y lemon$(BEXE)
	cp $(TOP)/ext/fts5/fts5parse.y .
	rm -f fts5parse.h
	./lemon$(BEXE) $(OPTS) -S fts5parse.y

fts5parse.h: fts5parse.c

fts5.c: $(FTS5_SRC)
	$(TCLSH_CMD) $(TOP)/ext/fts5/tool/mkfts5c.tcl
	cp $(TOP)/ext/fts5/fts5.h .

fts5.lo:	fts5.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c fts5.c

sqlite3rbu.lo:	$(TOP)/ext/rbu/sqlite3rbu.c $(HDR) $(EXTHDR)
	$(LTCOMPILE) -DSQLITE_CORE -c $(TOP)/ext/rbu/sqlite3rbu.c


# Rules to build the 'testfixture' application.
#
# If using the amalgamation, use sqlite3.c directly to build the test
# fixture.  Otherwise link against libsqlite3.la.  (This distinction is
# necessary because the test fixture requires non-API symbols which are
# hidden when the library is built via the amalgamation).
#
TESTFIXTURE_FLAGS  = -DSQLITE_TEST=1 -DSQLITE_CRASH_TEST=1
TESTFIXTURE_FLAGS += -DTCLSH_INIT_PROC=sqlite3TestInit
TESTFIXTURE_FLAGS += -DSQLITE_SERVER=1 -DSQLITE_PRIVATE="" -DSQLITE_CORE
TESTFIXTURE_FLAGS += -DBUILD_sqlite
TESTFIXTURE_FLAGS += -DSQLITE_SERIES_CONSTRAINT_VERIFY=1
TESTFIXTURE_FLAGS += -DSQLITE_DEFAULT_PAGE_SIZE=1024
TESTFIXTURE_FLAGS += -DSQLITE_ENABLE_STMTVTAB
TESTFIXTURE_FLAGS += -DSQLITE_ENABLE_DBPAGE_VTAB
TESTFIXTURE_FLAGS += -DSQLITE_ENABLE_BYTECODE_VTAB
TESTFIXTURE_FLAGS += -DSQLITE_ENABLE_DESERIALIZE
TESTFIXTURE_FLAGS += -DSQLITE_CKSUMVFS_STATIC

TESTFIXTURE_SRC0 = $(TESTSRC2) libsqlite3.la
TESTFIXTURE_SRC1 = sqlite3.c
TESTFIXTURE_SRC = $(TESTSRC) $(TOP)/src/tclsqlite.c
TESTFIXTURE_SRC += $(TESTFIXTURE_SRC$(USE_AMALGAMATION))

testfixture$(TEXE):	$(TESTFIXTURE_SRC)
	$(LTLINK) -DSQLITE_NO_SYNC=1 $(TEMP_STORE) $(TESTFIXTURE_FLAGS) \
		-o $@ $(TESTFIXTURE_SRC) $(LIBTCL) $(TLIBS)

coretestprogs:	$(TESTPROGS)

testprogs:	coretestprogs srcck1$(BEXE) fuzzcheck$(TEXE) sessionfuzz$(TEXE)

# A very detailed test running most or all test cases
fulltest:	$(TESTPROGS) fuzztest
	./testfixture$(TEXE) $(TOP)/test/all.test $(TESTOPTS)

# Really really long testing
soaktest:	$(TESTPROGS)
	./testfixture$(TEXE) $(TOP)/test/all.test -soak=1 $(TESTOPTS)

# Do extra testing but not everything.
fulltestonly:	$(TESTPROGS) fuzztest
	./testfixture$(TEXE) $(TOP)/test/full.test

# Fuzz testing
fuzztest:	fuzzcheck$(TEXE) $(FUZZDATA) sessionfuzz$(TEXE) $(TOP)/test/sessionfuzz-data1.db
	./fuzzcheck$(TEXE) $(FUZZDATA)
	./sessionfuzz$(TEXE) run $(TOP)/test/sessionfuzz-data1.db

valgrindfuzz:	fuzzcheck$(TEXT) $(FUZZDATA) sessionfuzz$(TEXE) $(TOP)/test/sessionfuzz-data1.db
	valgrind ./fuzzcheck$(TEXE) --cell-size-check --limit-mem 10M $(FUZZDATA)
	valgrind ./sessionfuzz$(TEXE) run $(TOP)/test/sessionfuzz-data1.db

# The veryquick.test TCL tests.
#
tcltest:	./testfixture$(TEXE)
	./testfixture$(TEXE) $(TOP)/test/veryquick.test $(TESTOPTS)

# Minimal testing that runs in less than 3 minutes
#
quicktest:	./testfixture$(TEXE)
	./testfixture$(TEXE) $(TOP)/test/extraquick.test $(TESTOPTS)

# This is the common case.  Run many tests that do not take too long,
# including fuzzcheck, sqlite3_analyzer, and sqldiff tests.
#
test:	fuzztest sourcetest $(TESTPROGS) tcltest

# Run a test using valgrind.  This can take a really long time
# because valgrind is so much slower than a native machine.
#
valgrindtest:	$(TESTPROGS) valgrindfuzz
	OMIT_MISUSE=1 valgrind -v ./testfixture$(TEXE) $(TOP)/test/permutations.test valgrind $(TESTOPTS)

# A very fast test that checks basic sanity.  The name comes from
# the 60s-era electronics testing:  "Turn it on and see if smoke
# comes out."
#
smoketest:	$(TESTPROGS) fuzzcheck$(TEXE)
	./testfixture$(TEXE) $(TOP)/test/main.test $(TESTOPTS)

shelltest: $(TESTPROGS)
	./testfixture$(TEXT) $(TOP)/test/permutations.test shell

sqlite3_analyzer.c: sqlite3.c $(TOP)/src/tclsqlite.c $(TOP)/tool/spaceanal.tcl $(TOP)/tool/mkccode.tcl $(TOP)/tool/sqlite3_analyzer.c.in
	$(TCLSH_CMD) $(TOP)/tool/mkccode.tcl $(TOP)/tool/sqlite3_analyzer.c.in >sqlite3_analyzer.c

sqlite3_analyzer$(TEXE): sqlite3_analyzer.c
	$(LTLINK) sqlite3_analyzer.c -o $@ $(LIBTCL) $(TLIBS)

sqltclsh.c: sqlite3.c $(TOP)/src/tclsqlite.c $(TOP)/tool/sqltclsh.tcl $(TOP)/ext/misc/appendvfs.c $(TOP)/tool/mkccode.tcl $(TOP)/tool/sqltclsh.c.in
	$(TCLSH_CMD) $(TOP)/tool/mkccode.tcl $(TOP)/tool/sqltclsh.c.in >sqltclsh.c

sqltclsh$(TEXE): sqltclsh.c
	$(LTLINK) sqltclsh.c -o $@ $(LIBTCL) $(TLIBS)

sqlite3_expert$(TEXE): $(TOP)/ext/expert/sqlite3expert.h $(TOP)/ext/expert/sqlite3expert.c $(TOP)/ext/expert/expert.c sqlite3.c
	$(LTLINK)	$(TOP)/ext/expert/sqlite3expert.h $(TOP)/ext/expert/sqlite3expert.c $(TOP)/ext/expert/expert.c sqlite3.c -o sqlite3_expert $(TLIBS)

CHECKER_DEPS =\
  $(TOP)/tool/mkccode.tcl \
  sqlite3.c \
  $(TOP)/src/tclsqlite.c \
  $(TOP)/ext/repair/sqlite3_checker.tcl \
  $(TOP)/ext/repair/checkindex.c \
  $(TOP)/ext/repair/checkfreelist.c \
  $(TOP)/ext/misc/btreeinfo.c \
  $(TOP)/ext/repair/sqlite3_checker.c.in

sqlite3_checker.c:	$(CHECKER_DEPS)
	$(TCLSH_CMD) $(TOP)/tool/mkccode.tcl $(TOP)/ext/repair/sqlite3_checker.c.in >$@

sqlite3_checker$(TEXE):	sqlite3_checker.c
	$(LTLINK) sqlite3_checker.c -o $@ $(LIBTCL) $(TLIBS)

dbdump$(TEXE): $(TOP)/ext/misc/dbdump.c sqlite3.lo
	$(LTLINK) -DDBDUMP_STANDALONE -o $@ \
           $(TOP)/ext/misc/dbdump.c sqlite3.lo $(TLIBS)

dbtotxt$(TEXE): $(TOP)/tool/dbtotxt.c
	$(LTLINK)-o $@ $(TOP)/tool/dbtotxt.c

showdb$(TEXE):	$(TOP)/tool/showdb.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/tool/showdb.c sqlite3.lo $(TLIBS)

showstat4$(TEXE):	$(TOP)/tool/showstat4.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/tool/showstat4.c sqlite3.lo $(TLIBS)

showjournal$(TEXE):	$(TOP)/tool/showjournal.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/tool/showjournal.c sqlite3.lo $(TLIBS)

showwal$(TEXE):	$(TOP)/tool/showwal.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/tool/showwal.c sqlite3.lo $(TLIBS)

showshm$(TEXE):	$(TOP)/tool/showshm.c
	$(LTLINK) -o $@ $(TOP)/tool/showshm.c

index_usage$(TEXE): $(TOP)/tool/index_usage.c sqlite3.lo
	$(LTLINK) $(SHELL_OPT) -o $@ $(TOP)/tool/index_usage.c sqlite3.lo $(TLIBS)

changeset$(TEXE):	$(TOP)/ext/session/changeset.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/ext/session/changeset.c sqlite3.lo $(TLIBS)

changesetfuzz$(TEXE):	$(TOP)/ext/session/changesetfuzz.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/ext/session/changesetfuzz.c sqlite3.lo $(TLIBS)

rollback-test$(TEXE):	$(TOP)/tool/rollback-test.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/tool/rollback-test.c sqlite3.lo $(TLIBS)

atrc$(TEXX): $(TOP)/test/atrc.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/test/atrc.c sqlite3.lo $(TLIBS)

LogEst$(TEXE):	$(TOP)/tool/logest.c sqlite3.h
	$(LTLINK) -I. -o $@ $(TOP)/tool/logest.c

wordcount$(TEXE):	$(TOP)/test/wordcount.c sqlite3.lo
	$(LTLINK) -o $@ $(TOP)/test/wordcount.c sqlite3.lo $(TLIBS)

speedtest1$(TEXE):	$(TOP)/test/speedtest1.c sqlite3.c
	$(LTLINK) $(ST_OPT) -o $@ $(TOP)/test/speedtest1.c sqlite3.c $(TLIBS)

startup$(TEXE):	$(TOP)/test/startup.c sqlite3.c
	$(CC) -Os -g -DSQLITE_THREADSAFE=0 -o $@ $(TOP)/test/startup.c sqlite3.c $(TLIBS)

KV_OPT += -DSQLITE_DIRECT_OVERFLOW_READ

kvtest$(TEXE):	$(TOP)/test/kvtest.c sqlite3.c
	$(LTLINK) $(KV_OPT) -o $@ $(TOP)/test/kvtest.c sqlite3.c $(TLIBS)

rbu$(EXE): $(TOP)/ext/rbu/rbu.c $(TOP)/ext/rbu/sqlite3rbu.c sqlite3.lo
	$(LTLINK) -I. -o $@ $(TOP)/ext/rbu/rbu.c sqlite3.lo $(TLIBS)

loadfts$(EXE): $(TOP)/tool/loadfts.c libsqlite3.la
	$(LTLINK) $(TOP)/tool/loadfts.c libsqlite3.la -o $@ $(TLIBS)

# This target will fail if the SQLite amalgamation contains any exported
# symbols that do not begin with "sqlite3_". It is run as part of the
# releasetest.tcl script.
#
VALIDIDS=' sqlite3(changeset|changegroup|session)?_'
checksymbols: sqlite3.o
	nm -g --defined-only sqlite3.o
	nm -g --defined-only sqlite3.o | egrep -v $(VALIDIDS); test $$? -ne 0
	echo '0 errors out of 1 tests'

# Build the amalgamation-autoconf package.  The amalamgation-tarball target builds
# a tarball named for the version number.  Ex:  sqlite-autoconf-3110000.tar.gz.
# The snapshot-tarball target builds a tarball named by the SHA1 hash
#
amalgamation-tarball: sqlite3.c sqlite3rc.h
	TOP=$(TOP) sh $(TOP)/tool/mkautoconfamal.sh --normal

snapshot-tarball: sqlite3.c sqlite3rc.h
	TOP=$(TOP) sh $(TOP)/tool/mkautoconfamal.sh --snapshot

# The next two rules are used to support the "threadtest" target. Building
# threadtest runs a few thread-safety tests that are implemented in C. This
# target is invoked by the releasetest.tcl script.
#
THREADTEST3_SRC = $(TOP)/test/threadtest3.c    \
                  $(TOP)/test/tt3_checkpoint.c \
                  $(TOP)/test/tt3_index.c      \
                  $(TOP)/test/tt3_vacuum.c      \
                  $(TOP)/test/tt3_stress.c      \
                  $(TOP)/test/tt3_lookaside1.c

threadtest3$(TEXE): sqlite3.lo $(THREADTEST3_SRC)
	$(LTLINK) $(TOP)/test/threadtest3.c $(TOP)/src/test_multiplex.c sqlite3.lo -o $@ $(TLIBS)

threadtest: threadtest3$(TEXE)
	./threadtest3$(TEXE)

releasetest:
	$(TCLSH_CMD) $(TOP)/test/releasetest.tcl

# Standard install and cleanup targets
#
lib_install:	libsqlite3.la
	$(INSTALL) -d $(DESTDIR)$(libdir)
	$(LTINSTALL) libsqlite3.la $(DESTDIR)$(libdir)

install:	sqlite3$(TEXE) lib_install sqlite3.h sqlite3.pc ${HAVE_TCL:1=tcl_install}
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(LTINSTALL) sqlite3$(TEXE) $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(includedir)
	$(INSTALL) -m 0644 sqlite3.h $(DESTDIR)$(includedir)
	$(INSTALL) -m 0644 $(TOP)/src/sqlite3ext.h $(DESTDIR)$(includedir)
	$(INSTALL) -d $(DESTDIR)$(pkgconfigdir)
	$(INSTALL) -m 0644 sqlite3.pc $(DESTDIR)$(pkgconfigdir)

pkgIndex.tcl:
	echo 'package ifneeded sqlite3 $(RELEASE) [list load [file join $$dir libtclsqlite3[info sharedlibextension]] sqlite3]' > $@
tcl_install:	lib_install libtclsqlite3.la pkgIndex.tcl
	$(INSTALL) -d $(DESTDIR)$(TCLLIBDIR)
	$(LTINSTALL) libtclsqlite3.la $(DESTDIR)$(TCLLIBDIR)
	rm -f $(DESTDIR)$(TCLLIBDIR)/libtclsqlite3.la $(DESTDIR)$(TCLLIBDIR)/libtclsqlite3.a
	$(INSTALL) -m 0644 pkgIndex.tcl $(DESTDIR)$(TCLLIBDIR)

clean:
	rm -f *.lo *.la *.o sqlite3$(TEXE) libsqlite3.la
	rm -f sqlite3.h opcodes.*
	rm -rf .libs .deps
	rm -f lemon$(BEXE) lempar.c parse.* sqlite*.tar.gz
	rm -f mkkeywordhash$(BEXE) keywordhash.h
	rm -f *.da *.bb *.bbg gmon.out
	rm -rf tsrc .target_source
	rm -f tclsqlite3$(TEXE)
	rm -f testfixture$(TEXE) test.db
	rm -f LogEst$(TEXE) fts3view$(TEXE) rollback-test$(TEXE) showdb$(TEXE)
	rm -f showjournal$(TEXE) showstat4$(TEXE) showwal$(TEXE) speedtest1$(TEXE)
	rm -f wordcount$(TEXE) changeset$(TEXE)
	rm -f sqlite3.dll sqlite3.lib sqlite3.exp sqlite3.def
	rm -f sqlite3.c
	rm -f sqlite3rc.h
	rm -f shell.c sqlite3ext.h
	rm -f sqlite3_analyzer$(TEXE) sqlite3_analyzer.c
	rm -f sqlite-*-output.vsix
	rm -f mptester mptester.exe
	rm -f rbu rbu.exe
	rm -f srcck1 srcck1.exe
	rm -f fuzzershell fuzzershell.exe
	rm -f fuzzcheck fuzzcheck.exe
	rm -f sqldiff sqldiff.exe
	rm -f dbhash dbhash.exe
	rm -f fts5.* fts5parse.*

distclean:	clean
	rm -f config.h config.log config.status libtool Makefile sqlite3.pc

#
# Windows section
#
dll: sqlite3.dll

REAL_LIBOBJ = $(LIBOBJ:%.lo=.libs/%.o)

$(REAL_LIBOBJ): $(LIBOBJ)

sqlite3.def: $(REAL_LIBOBJ)
	echo 'EXPORTS' >sqlite3.def
	nm $(REAL_LIBOBJ) | grep ' T ' | grep ' _sqlite3_' \
		| sed 's/^.* _//' >>sqlite3.def

sqlite3.dll: $(REAL_LIBOBJ) sqlite3.def
	$(TCC) -shared -o $@ sqlite3.def \
		-Wl,"--strip-all" $(REAL_LIBOBJ)
