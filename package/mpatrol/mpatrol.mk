#############################################################
#
# mpatrol
#
#############################################################
MPATROL_VERSION:=1.4.8
MPATROL_SOURCE:=mpatrol_$(MPATROL_VERSION).tar.gz
MPATROL_SITE:=http://www.cbmamiga.demon.co.uk/mpatrol/files
MPATROL_DIR:=$(BUILD_DIR)/mpatrol
MPATROL_CAT:=$(ZCAT)
MPATROL_BINARY:=mleak
MPATROL_BUILD_DIR:=$(MPATROL_DIR)/build/unix
MPATROL_TARGET_BINARY:=usr/bin/mleak

# Pick a symbol library to use. We have a choice of GDB BFD, binutils BFD, or libelf.
# If one of them is already being built, then use it, otherwise, default to GDB
ifeq ($(BR2_PACKAGE_GDB),y)
MPATROL_SYMBOL_LIBS:=-L$(GDB_TARGET_DIR)/bfd -lbfd -L$(GDB_TARGET_DIR)/libiberty -liberty
MPATROL_SYMBOL_INCS:=-I$(GDB_TARGET_DIR)/bfd -I$(GDB_DIR)/include -DMP_SYMBOL_LIBS=
MPATROL_SYMBOL_DEPS:=gdb_target
else
ifeq ($(BR2_PACKAGE_GCC_TARGET),y)
MPATROL_SYMBOL_LIBS:=-L$(BINUTILS_DIR2)/bfd -lbfd -L$(BINUTILS_DIR2)/libiberty -liberty
MPATROL_SYMBOL_INCS:=-I$(BINUTILS_DIR2)/bfd -I$(BINUTILS_DIR)/include -DMP_SYMBOL_LIBS=
MPATROL_SYMBOL_DEPS:=binutils_target
else
ifeq ($(BR2_PACKAGE_LIBELF),y)
MPATROL_SYMBOL_LIBS:=-L$(LIBELF_DIR)/lib -lelf
MPATROL_SYMBOL_INCS:=-I$(STAGING_DIR)/usr/include -DFORMAT=FORMAT_ELF32 -DMP_SYMBOL_LIBS=
MPATROL_SYMBOL_DEPS:=libelf
else # use GDB by default
MPATROL_SYMBOL_LIBS:=-L$(GDB_TARGET_DIR)/bfd -lbfd -L$(GDB_TARGET_DIR)/libiberty -liberty
MPATROL_SYMBOL_INCS:=-I$(GDB_TARGET_DIR)/bfd -I$(GDB_DIR)/include -DMP_SYMBOL_LIBS=
MPATROL_SYMBOL_DEPS:=gdb_target
endif
endif
endif

$(DL_DIR)/$(MPATROL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MPATROL_SITE)/$(MPATROL_SOURCE)

mpatrol-source: $(DL_DIR)/$(MPATROL_SOURCE)

$(MPATROL_DIR)/.unpacked: $(DL_DIR)/$(MPATROL_SOURCE)
	$(MPATROL_CAT) $(DL_DIR)/$(MPATROL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPATROL_DIR) package/mpatrol mpatrol\*.patch
	$(SED) '/LD.*MPTOBJS/s,$$, $$(LDLIBS),' $(MPATROL_BUILD_DIR)/Makefile
	$(SED) '/CFLAGS.*=/s,$$, $$(IFLAGS),' $(MPATROL_BUILD_DIR)/Makefile
	touch $(MPATROL_DIR)/.unpacked

$(MPATROL_BUILD_DIR)/$(MPATROL_BINARY): $(MPATROL_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CROSS)gcc AR=$(TARGET_CROSS)ar LD=$(TARGET_CROSS)gcc \
		IFLAGS="-g $(MPATROL_SYMBOL_INCS) -DMP_USE_ATEXIT=1 -DMP_SIGINFO_SUPPORT=1" \
		LDLIBS="$(MPATROL_SYMBOL_LIBS)" -C $(MPATROL_BUILD_DIR) all

$(TARGET_DIR)/$(MPATROL_TARGET_BINARY): $(MPATROL_BUILD_DIR)/$(MPATROL_BINARY)
	mkdir -p $(TARGET_DIR)/usr/lib
	(cd $(MPATROL_BUILD_DIR); \
		cp -dpf lib*.so* $(TARGET_DIR)/usr/lib; \
		cp -dpf mpatrol mprof mptrace mleak $(TARGET_DIR)/usr/bin)
	if [ ! -e $(TARGET_DIR)/lib/libpthread.so ]; then \
		ln -sf libpthread.so.0 $(TARGET_DIR)/lib/libpthread.so; fi
	(cd $(MPATROL_DIR); \
		cp -dpf bin/mp* bin/hexwords $(TARGET_DIR)/usr/bin; \
		cp -dpf src/mp*.h $(STAGING_DIR)/usr/include; \
		mkdir -p $(STAGING_DIR)/usr/include/mpatrol; \
		cp -dpf tools/*.h $(STAGING_DIR)/usr/include/mpatrol)
	touch $(TARGET_DIR)/$(MPATROL_TARGET_BINARY)

mpatrol: uclibc $(MPATROL_SYMBOL_DEPS) $(TARGET_DIR)/$(MPATROL_TARGET_BINARY)

mpatrol-clean:
	(cd $(TARGET_DIR)/usr/lib; rm -f libmpatrol* libmpalloc*)
	(cd $(TARGET_DIR)/usr/bin; \
		rm -f mpatrol mprof mptrace mleak mpsym mpedit hexwords)
	(cd $(STAGING_DIR)/usr/include; \
		rm -rf mpatrol.h mpalloc.h mpdebug.h mpatrol)
	$(MAKE) -C $(MPATROL_DIR)/build/unix clobber

mpatrol-dirclean:
	rm -rf $(MPATROL_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MPATROL),y)
TARGETS+=mpatrol
endif
