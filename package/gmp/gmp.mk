#############################################################
#
# gmp
#
#############################################################
GMP_VERSION:=4.2.2
GMP_SOURCE:=gmp-$(GMP_VERSION).tar.bz2
GMP_SITE:=http://ftp.sunet.se/pub/gnu/gmp/
GMP_CAT:=$(BZCAT)
GMP_DIR:=$(TOOL_BUILD_DIR)/gmp-$(GMP_VERSION)
GMP_TARGET_DIR:=$(BUILD_DIR)/gmp-$(GMP_VERSION)
GMP_BINARY:=libgmp$(LIBTGTEXT)
GMP_HOST_BINARY:=libgmp$(HOST_SHREXT)
GMP_LIBVERSION:=3.4.1

# this is a workaround for a bug in GMP, please see
# http://gmplib.org/list-archives/gmp-devel/2006-April/000618.html
ifeq ($(HOST_EXEEXT),.exe)
GMP_CPP_FLAGS:=CPPFLAGS=-DDLL_EXPORT
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
		$(TARGET_CONFIGURE_ARGS) \
		$(GMP_CPP_FLAGS) \
		$(GMP_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(PREFERRED_LIB_FLAGS) \
		$(DISABLE_NLS) \
	)
	touch $@

$(GMP_TARGET_DIR)/.libs/$(GMP_BINARY): $(GMP_TARGET_DIR)/.configured
	#$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(GMP_TARGET_DIR)
	$(MAKE) -C $(GMP_TARGET_DIR)

$(STAGING_DIR)/usr/lib/$(GMP_BINARY): $(GMP_TARGET_DIR)/.libs/$(GMP_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(GMP_TARGET_DIR) install
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(STAGING_DIR)/usr/lib/libgmp$(LIBTGTEXT)*

$(TARGET_DIR)/usr/lib/libgmp.so $(TARGET_DIR)/usr/lib/libgmp.so.$(GMP_LIBVERSION) $(TARGET_DIR)/usr/lib/libgmp.a: $(STAGING_DIR)/usr/lib/$(GMP_BINARY)
	cp -dpf $(STAGING_DIR)/usr/lib/libgmp$(LIBTGTEXT)* $(TARGET_DIR)/usr/lib/
ifeq ($(BR2_PACKAGE_LIBGMP_HEADERS),y)
	test -d $(TARGET_DIR)/usr/include || mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(STAGING_DIR)/usr/include/gmp.h $(TARGET_DIR)/usr/include/
endif

libgmp: uclibc $(TARGET_DIR)/usr/lib/libgmp$(LIBTGTEXT)
stage-libgmp: uclibc $(STAGING_DIR)/usr/lib/$(GMP_BINARY)

libgmp-clean:
	rm -f $(TARGET_DIR)/usr/lib/libgmp.* $(TARGET_DIR)/usr/include/gmp.h \
		$(STAGING_DIR)/usr/lib/libgmp* $(STAGING_DIR)/usr/include/gmp.h
	-$(MAKE) -C $(GMP_TARGET_DIR) clean

libgmp-dirclean:
	rm -rf $(GMP_TARGET_DIR) $(GMP_DIR)

GMP_DIR2:=$(TOOL_BUILD_DIR)/gmp-$(GMP_VERSION)-host
GMP_HOST_DIR:=$(TOOL_BUILD_DIR)/gmp
$(GMP_DIR2)/.configured: $(GMP_DIR)/.unpacked
	mkdir -p $(GMP_DIR2)
	(cd $(GMP_DIR2); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		$(GMP_CPP_FLAGS) \
		$(GMP_DIR)/configure \
		--prefix="$(GMP_HOST_DIR)" \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--enable-shared \
		--enable-static \
		$(DISABLE_NLS) \
	)
	touch $@

$(GMP_HOST_DIR)/lib/libgmp$(HOST_LIBEXT) $(GMP_HOST_DIR)/lib/libgmp$(HOST_SHREXT) $(GMP_HOST_DIR)/lib/libgmp$(HOST_SHREXT).(GMP_LIBVERSION): $(GMP_DIR2)/.configured
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
