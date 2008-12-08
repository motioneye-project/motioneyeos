#############################################################
#
# distcc
#
#############################################################
DISTCC_VERSION:=2.18.3
DISTCC_SOURCE:=distcc-$(DISTCC_VERSION).tar.bz2
DISTCC_CAT:=$(BZCAT)
DISTCC_SITE:=http://distcc.samba.org/ftp/distcc/
DISTCC_BUILDDIR:=$(BUILD_DIR)/distcc-$(DISTCC_VERSION)
DISTCC_BINARY:=distcc
DISTCC_TARGET_BINARY:=usr/bin/distcc

$(DL_DIR)/$(DISTCC_SOURCE):
	$(WGET) -P $(DL_DIR) $(DISTCC_SITE)/$(DISTCC_SOURCE)

distcc-source: $(DL_DIR)/$(CVS_SOURCE)

$(DISTCC_BUILDDIR)/.unpacked: $(DL_DIR)/$(DISTCC_SOURCE)
	$(DISTCC_CAT) $(DL_DIR)/$(DISTCC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(DISTCC_BUILDDIR)
	touch $(DISTCC_BUILDDIR)/.unpacked

$(DISTCC_BUILDDIR)/.configured: $(DISTCC_BUILDDIR)/.unpacked
	(cd $(DISTCC_BUILDDIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-included-popt \
		--without-gtk \
		--without-gnome \
	)
	touch $(DISTCC_BUILDDIR)/.configured

$(DISTCC_BUILDDIR)/$(DISTCC_BINARY): $(DISTCC_BUILDDIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(DISTCC_BUILDDIR)

$(TARGET_DIR)/$(DISTCC_TARGET_BINARY): $(DISTCC_BUILDDIR)/$(DISTCC_BINARY)
	install -D $(DISTCC_BUILDDIR)/$(DISTCC_BINARY)d $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)d
	install -D $(DISTCC_BUILDDIR)/$(DISTCC_BINARY) $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)

distcc: uclibc $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)

distcc-clean:
	rm -f $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)
	rm -f $(TARGET_DIR)/$(DISTCC_TARGET_BINARY)d
	-$(MAKE) -C $(DISTCC_BUILDDIR) clean

distcc-dirclean:
	rm -rf $(DISTCC_BUILDDIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_DISTCC),y)
TARGETS+=distcc
endif
