#############################################################
#
# mpfr
#
#############################################################
MPFR_VERSION:=2.2.1
#MPFR_PATCH:=patches
MPFR_SOURCE:=mpfr-$(MPFR_VERSION).tar.bz2
MPFR_CAT:=$(BZCAT)
MPFR_SITE:=http://www.mpfr.org/mpfr-current/
MPFR_DIR:=$(BUILD_DIR)/mpfr-$(MPFR_VERSION)
MPFR_BINARY:=libmpfr.a
MPFR_LIBVERSION:=1.0.0

ifeq ($(BR2_ENDIAN),"BIG")
MPFR_BE:=yes
else
MPFR_BE:=no
endif

$(DL_DIR)/$(MPFR_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MPFR_SITE)/$(MPFR_SOURCE)


libmpfr-source: $(DL_DIR)/$(MPFR_SOURCE)

$(MPFR_DIR)/.unpacked: $(DL_DIR)/$(MPFR_SOURCE)
	$(MPFR_CAT) $(DL_DIR)/$(MPFR_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPFR_DIR) package/mpfr/ \*.patch
	$(CONFIG_UPDATE) $(MPFR_DIR)
ifneq ($(MPFR_PATCH),)
	$(WGET) -P $(MPFR_DIR) $(MPFR_SITE)/$(MPFR_PATCH)
	( cd $(MPFR_DIR) ; patch -p1 < $(MPFR_PATCH) ; )
endif
	touch $(MPFR_DIR)/.unpacked

$(MPFR_DIR)/.configured: $(MPFR_DIR)/.unpacked
	(cd $(MPFR_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_c_bigendian=$(MPFR_BE) \
		./configure \
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec_prefix=$(STAGING_DIR) \
		--libdir=$(STAGING_DIR)/lib \
		--includedir=$(STAGING_DIR)/include \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		$(DISABLE_NLS) \
	);
	touch $(MPFR_DIR)/.configured

$(MPFR_DIR)/.libs/$(MPFR_BINARY): $(MPFR_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(MPFR_DIR)

$(STAGING_DIR)/lib/$(MPFR_BINARY): $(MPFR_DIR)/.libs/$(MPFR_BINARY)
	$(MAKE) prefix=$(STAGING_DIR) \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/libexec \
	    datadir=$(STAGING_DIR)/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    sharedstatedir=$(STAGING_DIR)/com \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    includedir=$(STAGING_DIR)/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
	    -C $(MPFR_DIR) install;

$(TARGET_DIR)/lib/libmpfr.so.$(MPFR_LIBVERSION): $(STAGING_DIR)/lib/$(MPFR_BINARY)
	cp -a $(STAGING_DIR)/lib/libmpfr.so* $(STAGING_DIR)/lib/libmpfr.a \
		$(TARGET_DIR)/lib/
ifeq ($(BR2_PACKAGE_LIBMPFR_HEADERS),y)
	cp -a $(STAGING_DIR)/include/mpfr.h $(STAGING_DIR)/include/mpf2mpfr.h \
		$(TARGET_DIR)/usr/include/
endif
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libmpfr.so* \
		$(TARGET_DIR)/lib/libmpfr.a

libmpfr: uclibc libgmp $(TARGET_DIR)/lib/libmpfr.so.$(MPFR_LIBVERSION)

libmpfr-clean:
	rm -f $(TARGET_DIR)/lib/$(MPFR_BINARY)
	-$(MAKE) -C $(MPFR_DIR) clean

libmpfr-dirclean:
	rm -rf $(MPFR_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBMPFR)),y)
TARGETS+=libmpfr
endif
