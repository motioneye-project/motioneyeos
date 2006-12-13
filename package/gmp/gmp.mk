#############################################################
#
# gmp
#
#############################################################
GMP_VERSION:=4.2.1
GMP_SOURCE:=gmp-$(GMP_VERSION).tar.bz2
GMP_SITE:=http://ftp.sunet.se/pub/gnu/gmp/
GMP_CAT:=$(BZCAT)
GMP_DIR:=$(BUILD_DIR)/gmp-$(GMP_VERSION)
GMP_BINARY:=libgmp.a
GMP_LIBVERSION:=3.4.1

ifeq ($(BR2_ENDIAN),"BIG")
GMP_BE:=yes
else
GMP_BE:=no
endif

$(DL_DIR)/$(GMP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GMP_SITE)/$(GMP_SOURCE)

libgmp-source: $(DL_DIR)/$(GMP_SOURCE)

$(GMP_DIR)/.unpacked: $(DL_DIR)/$(GMP_SOURCE)
	$(GMP_CAT) $(DL_DIR)/$(GMP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GMP_DIR) package/gmp/ \*.patch
	$(CONFIG_UPDATE) $(GMP_DIR)
	touch $(GMP_DIR)/.unpacked

$(GMP_DIR)/.configured: $(GMP_DIR)/.unpacked
	(cd $(GMP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CC_FOR_BUILD="$(HOSTCC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_c_bigendian=$(GMP_BE) \
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
	touch $(GMP_DIR)/.configured

$(GMP_DIR)/.libs/$(GMP_BINARY): $(GMP_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GMP_DIR)

$(STAGING_DIR)/lib/$(GMP_BINARY): $(GMP_DIR)/.libs/$(GMP_BINARY)
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
	    -C $(GMP_DIR) install;

$(TARGET_DIR)/lib/libgmp.so.$(GMP_LIBVERSION): $(STAGING_DIR)/lib/$(GMP_BINARY)
	cp -a $(STAGING_DIR)/lib/libgmp.so* $(STAGING_DIR)/lib/libgmp.a \
		 $(TARGET_DIR)/lib/
ifeq ($(BR2_PACKAGE_LIBGMP_HEADERS),y)
	test -d $(TARGET_DIR)/usr/include || mkdir -p $(TARGET_DIR)/usr/include
	cp -a $(STAGING_DIR)/include/gmp.h $(TARGET_DIR)/usr/include/
endif
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgmp.so* \
		$(TARGET_DIR)/lib/libgmp.a

libgmp: uclibc $(TARGET_DIR)/lib/libgmp.so.$(GMP_LIBVERSION)
libgmp-stage: uclibc $(STAGING_DIR)/lib/$(GMP_BINARY)

libgmp-clean:
	rm -f $(TARGET_DIR)/lib/$(GMP_BINARY)
	-$(MAKE) -C $(GMP_DIR) clean

libgmp-dirclean:
	rm -rf $(GMP_DIR)

GMP_HOST_DIR:=$(TOOL_BUILD_DIR)/gmp-$(GMP_VERSION)
$(GMP_HOST_DIR)/.configured: $(GMP_DIR)/.unpacked
	[ -d $(GMP_HOST_DIR) ] || mkdir $(GMP_HOST_DIR)
	(cd $(GMP_HOST_DIR); \
		CC_FOR_BUILD="$(HOSTCC)" \
		CC="$(HOSTCC)" \
		CFLAGS="$(HOST_CFLAGS)" \
		$(GMP_DIR)/configure \
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
		--enable-static \
		$(DISABLE_NLS) \
	) && \
	touch $(GMP_HOST_DIR)/.configured

$(GMP_HOST_DIR)/.libs/$(GMP_BINARY): $(GMP_HOST_DIR)/.configured
	$(MAKE) -C $(GMP_HOST_DIR)

libgmp-host: $(GMP_HOST_DIR)/.libs/$(GMP_BINARY)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGMP)),y)
TARGETS+=libgmp
endif
