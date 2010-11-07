#############################################################
#
# mpc
#
#############################################################
MPC_VERSION:=0.8.2
MPC_SOURCE:=mpc-$(MPC_VERSION).tar.gz
MPC_SITE:=http://www.multiprecision.org/mpc/download
MPC_CAT:=$(ZCAT)
MPC_DIR:=$(TOOLCHAIN_DIR)/mpc-$(MPC_VERSION)
MPC_TARGET_DIR:=$(BUILD_DIR)/mpc-$(MPC_VERSION)
MPC_BINARY:=libmpc$(LIBTGTEXT)
MPC_HOST_BINARY:=libmpc$(HOST_LIBEXT)
MPC_LIBVERSION:=2.0.0

$(DL_DIR)/$(MPC_SOURCE):
	 $(call DOWNLOAD,$(MPC_SITE),$(MPC_SOURCE))

libmpc-source: $(DL_DIR)/$(MPC_SOURCE)

$(MPC_DIR)/.unpacked: $(DL_DIR)/$(MPC_SOURCE)
	$(MPC_CAT) $(DL_DIR)/$(MPC_SOURCE) | tar -C $(TOOLCHAIN_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPC_DIR) package/mpc/ \*.patch
	$(CONFIG_UPDATE) $(@D)
	touch $@

$(MPC_TARGET_DIR)/.configured: $(MPC_DIR)/.unpacked
	mkdir -p $(MPC_TARGET_DIR)
	(cd $(MPC_TARGET_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		$(MPC_DIR)/configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(PREFERRED_LIB_FLAGS) \
		--with-mpfr-lib=$(TARGET_DIR)/usr/lib/ \
		--with-gmp-lib=$(TARGET_DIR)/usr/lib/ \
		--with-mpfr-include=$(STAGING_DIR)/usr/include/ \
		--with-gmp-include=$(STAGING_DIR)/usr/include/ \
		$(DISABLE_NLS) \
	)
	touch $@

$(MPC_TARGET_DIR)/src/.libs/$(MPC_BINARY): $(MPC_TARGET_DIR)/.configured
	#$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(MPC_TARGET_DIR)
	$(MAKE) -C $(MPC_TARGET_DIR)

$(STAGING_DIR)/usr/lib/$(MPC_BINARY): $(MPC_TARGET_DIR)/src/.libs/$(MPC_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(MPC_TARGET_DIR) install
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(STAGING_DIR)/usr/lib/libmpc$(LIBTGTEXT)*

$(TARGET_DIR)/usr/lib/libmpc.so $(TARGET_DIR)/usr/lib/libmpc.so.$(MPC_LIBVERSION): $(STAGING_DIR)/usr/lib/$(MPC_BINARY)
	cp -dpf $(STAGING_DIR)/usr/lib/libmpc$(LIBTGTEXT)* $(TARGET_DIR)/usr/lib/
ifeq ($(BR2_PACKAGE_LIBMPC_HEADERS),y)
	test -d $(TARGET_DIR)/usr/include || mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(STAGING_DIR)/usr/include/mpc.h $(TARGET_DIR)/usr/include/
endif

libmpc: libgmp libmpfr $(TARGET_DIR)/usr/lib/libmpc$(LIBTGTEXT)
stage-libmpc: $(STAGING_DIR)/usr/lib/$(MPC_BINARY)

libmpc-clean:
	rm -f $(TARGET_DIR)/usr/lib/libmpc.* $(TARGET_DIR)/usr/include/mpc.h \
		$(STAGING_DIR)/usr/lib/libmpc* $(STAGING_DIR)/usr/include/mpc.h
	-$(MAKE) -C $(MPC_TARGET_DIR) clean

libmpc-dirclean:
	rm -rf $(MPC_TARGET_DIR) $(MPC_DIR)

MPC_DIR2:=$(TOOLCHAIN_DIR)/mpc-$(MPC_VERSION)-host
MPC_HOST_DIR:=$(TOOLCHAIN_DIR)/mpc
$(MPC_DIR2)/.configured: $(MPC_DIR)/.unpacked
	mkdir -p $(MPC_DIR2)
	(cd $(MPC_DIR2); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		$(MPC_CPP_FLAGS) \
		$(MPC_DIR)/configure $(QUIET) \
		--prefix="$(MPC_HOST_DIR)" \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--disable-shared \
		--enable-static \
		--with-mpfr=$(MPFR_HOST_DIR) \
		--with-gmp=$(GMP_HOST_DIR) \
		$(DISABLE_NLS) \
	)
	touch $@

$(MPC_HOST_DIR)/lib/libmpc$(HOST_LIBEXT): $(MPC_DIR2)/.configured
	$(MAKE) -C $(MPC_DIR2) install

host-libmpc: $(MPC_HOST_DIR)/lib/$(MPC_HOST_BINARY)
host-libmpc-source: libmpc-source
host-libmpc-clean:
	rm -rf $(MPC_HOST_DIR)
	-$(MAKE) -C $(MPC_DIR2) clean
host-libmpc-dirclean:
	rm -rf $(MPC_HOST_DIR) $(MPC_DIR2)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBMPC),y)
TARGETS+=libmpc
endif
