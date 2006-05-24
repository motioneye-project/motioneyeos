#############################################################
#
# gettext
#
#############################################################
GETTEXT_SOURCE:=gettext-0.11.5.tar.gz
GETTEXT_SITE:=ftp://ftp.gnu.org/gnu/gettext
GETTEXT_DIR:=$(BUILD_DIR)/gettext-0.11.5
GETTEXT_CAT:=zcat
GETTEXT_BINARY:=src/gettext
GETTEXT_TARGET_BINARY:=usr/bin/gettext

$(DL_DIR)/$(GETTEXT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GETTEXT_SITE)/$(GETTEXT_SOURCE)

gettext-source: $(DL_DIR)/$(GETTEXT_SOURCE)

$(GETTEXT_DIR)/.unpacked: $(DL_DIR)/$(GETTEXT_SOURCE)
	$(GETTEXT_CAT) $(DL_DIR)/$(GETTEXT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GETTEXT_DIR) package/gettext/ gettext\*.patch
	touch $(GETTEXT_DIR)/.unpacked

$(GETTEXT_DIR)/.configured: $(GETTEXT_DIR)/.unpacked
	(cd $(GETTEXT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
	);
	touch $(GETTEXT_DIR)/.configured

$(GETTEXT_DIR)/$(GETTEXT_BINARY): $(GETTEXT_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GETTEXT_DIR)

$(STAGING_DIR)/$(GETTEXT_TARGET_BINARY): $(GETTEXT_DIR)/$(GETTEXT_BINARY)
	$(MAKE) prefix=$(STAGING_DIR)/usr \
		exec_prefix=$(STAGING_DIR)/usr \
		bindir=$(STAGING_DIR)/usr/bin \
		sbindir=$(STAGING_DIR)/usr/sbin \
		libexecdir=$(STAGING_DIR)/usr/lib \
		datadir=$(STAGING_DIR)/usr/share \
		sysconfdir=$(STAGING_DIR)/etc \
		localstatedir=$(STAGING_DIR)/var \
		libdir=$(STAGING_DIR)/usr/lib \
		infodir=$(STAGING_DIR)/info \
		mandir=$(STAGING_DIR)/man \
		includedir=$(STAGING_DIR)/include \
		-C $(GETTEXT_DIR) install;

gettext: uclibc $(STAGING_DIR)/$(GETTEXT_TARGET_BINARY)

gettext-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GETTEXT_DIR) uninstall
	-$(MAKE) -C $(GETTEXT_DIR) clean

gettext-dirclean:
	rm -rf $(GETTEXT_DIR)

#############################################################
#
# gettext on the target
#
#############################################################
   
gettext-target: $(GETTEXT_DIR)/$(GETTEXT_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GETTEXT_DIR) install
	chmod +x $(TARGET_DIR)/usr/lib/libintl.so.2.2.0 # identify as needing to be stipped
	rm -rf  $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc \
		$(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/aclocal \
		$(TARGET_DIR)/usr/include/libintl.h
	-rmdir $(TARGET_DIR)/usr/include
   
libintl: $(TARGET_DIR)/usr/lib/libintl.so

$(TARGET_DIR)/usr/lib/libintl.so: $(STAGING_DIR)/$(GETTEXT_TARGET_BINARY)
	cp -a $(STAGING_DIR)/usr/lib/libintl.so* $(TARGET_DIR)/usr/lib
	touch $@
    
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBINTL)),y)
TARGETS+=libintl
endif
ifeq ($(strip $(BR2_PACKAGE_GETTEXT)),y)
TARGETS+=gettext-target
endif
