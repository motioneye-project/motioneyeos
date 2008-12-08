#############################################################
#
# socat
#
#############################################################

SOCAT_VERSION=1.4.0.3

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

SOCAT_SOURCE=socat-$(SOCAT_VERSION).tar.bz2
SOCAT_CAT:=$(BZCAT)
SOCAT_SITE=http://www.dest-unreach.org/socat/download/
#SOCAT_DIR=$(BUILD_DIR)/${shell basename $(SOCAT_SOURCE) .tar.bz2}
SOCAT_DIR=$(BUILD_DIR)/socat-1.4
#SOCAT_WORKDIR=$(BUILD_DIR)/socat_workdir
SOCAT_WORKDIR=$(SOCAT_DIR)

$(DL_DIR)/$(SOCAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(SOCAT_SITE)/$(SOCAT_SOURCE)

$(SOCAT_DIR)/.unpacked: $(DL_DIR)/$(SOCAT_SOURCE)
	$(SOCAT_CAT) $(DL_DIR)/$(SOCAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(SOCAT_DIR)/.unpacked

$(SOCAT_WORKDIR)/Makefile: $(SOCAT_DIR)/.unpacked
	rm -f $(SOCAT_WORKDIR)/Makefile
	mkdir -p $(SOCAT_WORKDIR)
	(cd $(SOCAT_WORKDIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		$(SOCAT_DIR)/configure \
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
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-termios \
		$(DISABLE_NLS); \
	$(SED) 's/#define HAVE_TERMIOS_ISPEED 1/#undef HAVE_TERMIOS_ISPEED/g' config.h; \
	)

$(SOCAT_WORKDIR)/socat: $(SOCAT_WORKDIR)/Makefile
	rm -f $@
	$(MAKE) -C $(SOCAT_WORKDIR)

$(TARGET_DIR)/usr/bin/socat: $(SOCAT_WORKDIR)/socat
	mkdir -p $(TARGET_DIR)/usr/man/man1
	$(MAKE) -C $(SOCAT_WORKDIR) install prefix=$(TARGET_DIR)/usr DESTDIR=$(TARGET_DIR)
	touch $@

socat: uclibc $(TARGET_DIR)/usr/bin/socat

socat-source: $(DL_DIR)/$(SOCAT_SOURCE)

socat-clean:
	-$(MAKE) -C $(SOCAT_WORKDIR) clean
	rm -f $(TARGET_DIR)/usr/bin/{socat,filan,procan}

socat-dirclean:
	rm -rf $(SOCAT_DIR) $(SOCAT_WORKDIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_SOCAT),y)
TARGETS+=socat
endif
