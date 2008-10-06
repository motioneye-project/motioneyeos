#############################################################
#
# vsftpd
#
#############################################################
VSFTPD_VERSION:=2.0.7
VSFTPD_SOURCE:=vsftpd-$(VSFTPD_VERSION).tar.gz
VSFTPD_SITE:=ftp://vsftpd.beasts.org/users/cevans
VSFTPD_DIR:=$(BUILD_DIR)/vsftpd-$(VSFTPD_VERSION)
VSFTPD_CAT:=$(ZCAT)
VSFTPD_BINARY:=vsftpd
VSFTPD_TARGET_BINARY:=usr/sbin/vsftpd

ifeq ($(BR2_PACKAGE_OPENSSL),y)
VSFTPD_LIBS:=-lcrypt -lssl
else
VSFTPD_LIBS:=-lcrypt
endif

$(DL_DIR)/$(VSFTPD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(VSFTPD_SITE)/$(VSFTPD_SOURCE)

vsftpd-source: $(DL_DIR)/$(VSFTPD_SOURCE)

$(VSFTPD_DIR)/.unpacked: $(DL_DIR)/$(VSFTPD_SOURCE)
	$(VSFTPD_CAT) $(DL_DIR)/$(VSFTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(VSFTPD_DIR) package/vsftpd/ vsftpd\*.patch
	touch $@

$(VSFTPD_DIR)/.configured: $(VSFTPD_DIR)/.unpacked
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	$(SED) 's,#undef[[:space:]]*VSF_BUILD_SSL.*,#define VSF_BUILD_SSL,g' $(VSFTPD_DIR)/builddefs.h
else
	$(SED) 's,#define[[:space:]]*VSF_BUILD_SSL.*,#undef VSF_BUILD_SSL,g' $(VSFTPD_DIR)/builddefs.h
endif
ifneq ($(findstring uclibc,$(BR2_GNU_TARGET_SUFFIX)),)
	$(SED) 's,#define[[:space:]]*VSF_BUILDDEFS_H.*,#define VSF_BUILDDEFS_H\n#define __UCLIBC__,g' $(VSFTPD_DIR)/builddefs.h
	$(SED) 's,.*__UCLIBC_HAS_LFS__.*,,g' $(VSFTPD_DIR)/builddefs.h
ifeq ($(BR2_LARGEFILE),y)
	$(SED) 's,#define[[:space:]]*VSF_BUILDDEFS_H.*,#define VSF_BUILDDEFS_H\n#define __UCLIBC_HAS_LFS__,g' $(VSFTPD_DIR)/builddefs.h
endif
else # not uclibc
	$(SED) 's,.*__UCLIBC_.*,,g' $(VSFTPD_DIR)/builddefs.h
endif


$(VSFTPD_DIR)/$(VSFTPD_BINARY): $(VSFTPD_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" LIBS="$(VSFTPD_LIBS)" -C $(VSFTPD_DIR)

$(TARGET_DIR)/$(VSFTPD_TARGET_BINARY): $(VSFTPD_DIR)/$(VSFTPD_BINARY)
	cp -dpf $< $@
	$(INSTALL) -D -m 0755 package/vsftpd/vsftpd-init $(TARGET_DIR)/etc/init.d/S70vsftpd

ifeq ($(BR2_PACKAGE_OPENSSL),y)
vsftpd: uclibc openssl $(TARGET_DIR)/$(VSFTPD_TARGET_BINARY)
else
vsftpd: uclibc $(TARGET_DIR)/$(VSFTPD_TARGET_BINARY)
endif

vsftpd-clean:
	-$(MAKE) -C $(VSFTPD_DIR) clean
	rm -f $(TARGET_DIR)/$(VSFTPD_TARGET_BINARY)

vsftpd-dirclean:
	rm -rf $(VSFTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_VSFTPD)),y)
TARGETS+=vsftpd
endif
