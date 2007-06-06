#############################################################
#
# gmp
#
#############################################################
GMP_VERSION:=4.2.1
GMP_SOURCE:=gmp-$(GMP_VERSION).tar.bz2
GMP_SITE:=http://ftp.sunet.se/pub/gnu/gmp/
GMP_CAT:=$(BZCAT)
GMP_DIR:=$(TOOL_BUILD_DIR)/gmp-$(GMP_VERSION)
GMP_TARGET_DIR:=$(BUILD_DIR)/gmp-$(GMP_VERSION)
GMP_BINARY:=libgmp$(LIBTGTEXT)
GMP_HOST_BINARY:=libgmp$(HOST_LIBEXT)
GMP_LIBVERSION:=3.4.1

ifeq ($(BR2_ENDIAN),"BIG")
GMP_BE:=yes
else
GMP_BE:=no
endif

# this is a workaround for a bug in GMP, please see 
# http://gmplib.org/list-archives/gmp-devel/2006-April/000618.html
ifeq ($(HOST_EXEEXT),.exe)
GMP_CPP_FLAGS:=-DDLL_EXPORT
else
GMP_CPP_FLAGS:=
endif

$(DL_DIR)/$(GMP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GMP_SITE)/$(GMP_SOURCE)

libgmp-source: $(DL_DIR)/$(GMP_SOURCE)

$(GMP_DIR)/.unpacked: $(DL_DIR)/$(GMP_SOURCE)
	$(GMP_CAT) $(DL_DIR)/$(GMP_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GMP_DIR) package/gmp/ \*.patch
	$(CONFIG_UPDATE) $(GMP_DIR)
	touch $@

$(GMP_TARGET_DIR)/.configured: $(GMP_DIR)/.unpacked
	mkdir -p $(GMP_TARGET_DIR)
	(cd $(GMP_TARGET_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		CPPFLAGS="$(GMP_CPP_FLAGS)" \
		ac_cv_c_bigendian=$(GMP_BE) \
		$(GMP_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(PREFERRED_LIB_FLAGS) \
		$(DISABLE_NLS) \
	);
	touch $@

$(GMP_TARGET_DIR)/.libs/$(GMP_BINARY): $(GMP_TARGET_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GMP_TARGET_DIR)

$(STAGING_DIR)/lib/$(GMP_BINARY): $(GMP_TARGET_DIR)/.libs/$(GMP_BINARY)
	$(MAKE) prefix=$(STAGING_DIR) \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/bin \
	    datadir=$(STAGING_DIR)/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    sharedstatedir=$(STAGING_DIR)/com \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    includedir=$(STAGING_DIR)/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
            -C $(GMP_TARGET_DIR) install
	$(STRIP) --strip-unneeded $(STAGING_DIR)/lib/libgmp$(LIBTGTEXT)*

$(TARGET_DIR)/lib/libgmp.so $(TARGET_DIR)/lib/libgmp.so.$(GMP_LIBVERSION) $(TARGET_DIR)/lib/libgmp.a: $(STAGING_DIR)/lib/$(GMP_BINARY)
	cp -dpf $(STAGING_DIR)/lib/libgmp$(LIBTGTEXT) $(TARGET_DIR)/lib/
ifeq ($(BR2_PACKAGE_LIBGMP_HEADERS),y)
	test -d $(TARGET_DIR)/usr/include || mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(STAGING_DIR)/include/gmp.h $(TARGET_DIR)/usr/include/
endif

libgmp: uclibc $(TARGET_DIR)/lib/libgmp$(LIBTGTEXT)
stage-libgmp: uclibc $(STAGING_DIR)/lib/$(GMP_BINARY)

libgmp-clean:
	rm -f $(TARGET_DIR)/lib/libgmp.* $(TARGET_DIR)/usr/include/gmp.h
	-$(MAKE) -C $(GMP_TARGET_DIR) clean

libgmp-dirclean:
	rm -rf $(GMP_TARGET_DIR) $(GMP_DIR)

GMP_DIR2:=$(TOOL_BUILD_DIR)/gmp-$(GMP_VERSION)-host
GMP_HOST_DIR:=$(TOOL_BUILD_DIR)/gmp
$(GMP_DIR2)/.configured: $(GMP_DIR)/.unpacked
	mkdir -p $(GMP_DIR2)
	(cd $(GMP_DIR2); \
		CC_FOR_BUILD="$(HOSTCC)" \
		CC="$(HOSTCC)" \
		CFLAGS="$(HOST_CFLAGS)" \
		CPPFLAGS="$(GMP_CPP_FLAGS)" \
		$(GMP_DIR)/configure \
		--prefix="$(GMP_HOST_DIR)" \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		$(PREFERRED_LIB_FLAGS) \
		$(DISABLE_NLS) \
	);
	touch $@

$(GMP_HOST_DIR)/lib/$(GMP_HOST_BINARY): $(GMP_DIR2)/.configured
	$(MAKE) -C $(GMP_DIR2) install

host-libgmp: $(GMP_HOST_DIR)/lib/$(GMP_HOST_BINARY)
host-libgmp-clean:
	rm -rf $(GMP_HOST_DIR)
	-$(MAKE) -C $(GMP_DIR2) clean
host-libgmp-dirclean:
	rm -rf $(GMP_HOST_DIR) $(GMP_DIR2)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGMP)),y)
TARGETS+=libgmp
endif
