#############################################################
#
# socat
#
#############################################################

SOCAT_VERSION=1.3.0.1

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

SOCAT_SOURCE=socat-$(SOCAT_VERSION).tar.bz2
SOCAT_SITE=http://www.dest-unreach.org/socat/download/
#SOCAT_DIR=$(BUILD_DIR)/${shell basename $(SOCAT_SOURCE) .tar.bz2}
SOCAT_DIR=$(BUILD_DIR)/socat-1.3
#SOCAT_WORKDIR=$(BUILD_DIR)/socat_workdir
SOCAT_WORKDIR=$(SOCAT_DIR)

$(DL_DIR)/$(SOCAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(SOCAT_SITE)/$(SOCAT_SOURCE)

$(SOCAT_DIR)/.unpacked:	$(DL_DIR)/$(SOCAT_SOURCE)
	bzip2 -d -c $(DL_DIR)/$(SOCAT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(SOCAT_DIR)/.unpacked

$(SOCAT_WORKDIR)/Makefile: $(SOCAT_DIR)/.unpacked
	rm -f $(SOCAT_WORKDIR)/Makefile
	mkdir -p $(SOCAT_WORKDIR)
	(cd $(SOCAT_WORKDIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) CC=$(TARGET_CC) \
		$(SOCAT_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
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
		--disable-nls \
	);
        
$(SOCAT_WORKDIR)/socat:	$(SOCAT_WORKDIR)/Makefile
	rm -f $@
	$(MAKE) -C $(SOCAT_WORKDIR)

$(SOCAT_WORKDIR)/.installed: $(SOCAT_WORKDIR)/socat
	mkdir -p $(TARGET_DIR)/usr/man/man1
	$(MAKE) -C $(SOCAT_WORKDIR) install prefix=$(TARGET_DIR)/usr

socat:	uclibc $(SOCAT_WORKDIR)/.installed

socat-clean:
	@if [ -d $(SOCAT_WORKDIR)/Makefile ] ; then \
		$(MAKE) -C $(SOCAT_WORKDIR) clean ; \
	fi;

socat-dirclean:
	rm -rf $(SOCAT_DIR) $(SOCAT_WORKDIR)

