#############################################################
#
# findutils
#
#############################################################
FINDUTILS_VERSION:=4.2.31
FINDUTILS_SOURCE:=findutils-$(FINDUTILS_VERSION).tar.gz
#FINDUTILS_SITE:=ftp://alpha.gnu.org/gnu/findutils
FINDUTILS_SITE:=http://ftp.gnu.org/pub/gnu/findutils/
FINDUTILS_CAT:=$(ZCAT)
FINDUTILS_DIR:=$(BUILD_DIR)/findutils-$(FINDUTILS_VERSION)
FINDUTILS_BINARY:=find/find
FINDUTILS_TARGET_BINARY:=usr/bin/find

$(DL_DIR)/$(FINDUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FINDUTILS_SITE)/$(FINDUTILS_SOURCE)

findutils-source: $(DL_DIR)/$(FINDUTILS_SOURCE)

$(FINDUTILS_DIR)/.unpacked: $(DL_DIR)/$(FINDUTILS_SOURCE)
	$(FINDUTILS_CAT) $(DL_DIR)/$(FINDUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(FINDUTILS_DIR)
	touch $@

$(FINDUTILS_DIR)/.configured: $(FINDUTILS_DIR)/.unpacked
	(cd $(FINDUTILS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_func_setvbuf_reversed=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib/locate \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var/lib \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(FINDUTILS_DIR)/$(FINDUTILS_BINARY): $(FINDUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(FINDUTILS_DIR)

# This stuff is needed to work around GNU make deficiencies
findutils-target_binary: $(FINDUTILS_DIR)/$(FINDUTILS_BINARY)
	@if [ -L $(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY) ]; then \
		rm -f $(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY); \
	fi
	@if [ ! -f $(FINDUTILS_DIR)/$(FINDUTILS_BINARY) \
		-o $(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY) \
		-ot $(FINDUTILS_DIR)/$(FINDUTILS_BINARY) ]; then \
		set -x; \
		$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FINDUTILS_DIR) install; \
		$(STRIPCMD) $(TARGET_DIR)/usr/lib/locate/* > /dev/null 2>&1; \
	fi
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc

findutils: uclibc findutils-target_binary

findutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FINDUTILS_DIR) uninstall
	-$(MAKE) -C $(FINDUTILS_DIR) clean

findutils-dirclean:
	rm -rf $(FINDUTILS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FINDUTILS)),y)
TARGETS+=findutils
endif
