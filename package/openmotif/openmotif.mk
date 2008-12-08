#############################################################
#
# openmotif
#
#############################################################

OPENMOTIF_VERSION = 2.3.0
OPENMOTIF_SOURCE = openmotif-$(OPENMOTIF_VERSION).tar.gz
OPENMOTIF_SITE = ftp://ftp.ics.com/openmotif/2.3/2.3.0
OPENMOTIF_CAT:=$(ZCAT)
OPENMOTIF_DIR:=$(BUILD_DIR)/openmotif-$(OPENMOTIF_VERSION)
OPENMOTIF_HOST_DIR:=$(BUILD_DIR)/openmotif-$(OPENMOTIF_VERSION)-host

$(DL_DIR)/$(OPENMOTIF_SOURCE):
	 $(WGET) -P $(DL_DIR) $(OPENMOTIF_SITE)/$(OPENMOTIF_SOURCE)

openmotif-source: $(DL_DIR)/$(OPENMOTIF_SOURCE)

$(OPENMOTIF_DIR)/.unpacked: $(DL_DIR)/$(OPENMOTIF_SOURCE)
	$(OPENMOTIF_CAT) $(DL_DIR)/$(OPENMOTIF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(OPENMOTIF_DIR)
	cp -a $(OPENMOTIF_DIR) $(OPENMOTIF_DIR)-host
	toolchain/patch-kernel.sh $(OPENMOTIF_DIR) package/openmotif/ \*.patch
	touch $(OPENMOTIF_DIR)/.unpacked

$(OPENMOTIF_HOST_DIR)/.configured: $(OPENMOTIF_DIR)/.unpacked
	(if [ ! -e "/usr/include/X11/extensions/Print.h" ]; then \
		echo "Please install libXp-devel and re-run make."; \
		exit 1; fi )
	(if [ ! -e "/usr/include/X11/bitmaps" ]; then \
		echo "Please install xorg-x11-xbitmaps and re-run make."; \
		exit 1; fi )
	(cd $(OPENMOTIF_HOST_DIR); rm -rf config.cache; \
		aclocal; automake --foreign --add-missing; autoconf; \
		./configure \
		--prefix=/usr -C;);
	touch $(OPENMOTIF_HOST_DIR)/.configured

$(OPENMOTIF_DIR)/.configured: $(OPENMOTIF_HOST_DIR)/.configured
	(cd $(OPENMOTIF_DIR); rm -rf config.cache; \
		aclocal; automake --foreign --add-missing; autoconf; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_file__usr_X_include_X11_X_h=yes \
		ac_cv_func_setpgrp_void=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--includedir=/usr/include \
		--with-x --program-prefix="" \
	);
	touch $(OPENMOTIF_DIR)/.configured

$(OPENMOTIF_HOST_DIR)/.done: $(OPENMOTIF_DIR)/.configured
	$(MAKE) -C $(OPENMOTIF_HOST_DIR)
	ln -s -f $(OPENMOTIF_HOST_DIR)/config/util/makestrs $(OPENMOTIF_DIR)/config/util/makestrs-host
	ln -s -f $(OPENMOTIF_HOST_DIR)/tools/wml/wmluiltok $(OPENMOTIF_DIR)/tools/wml/wmluiltok-host
	ln -s -f $(OPENMOTIF_HOST_DIR)/tools/wml/wml $(OPENMOTIF_DIR)/tools/wml/wml-host
	ln -s -f $(OPENMOTIF_HOST_DIR)/tools/wml/wmldbcreate $(OPENMOTIF_DIR)/tools/wml/wmldbcreate-host
	mkdir -p $(OPENMOTIF_DIR)/tools/wml/.libs
	ln -s -f $(OPENMOTIF_HOST_DIR)/tools/wml/.libs/lt-wmldbcreate $(OPENMOTIF_DIR)/tools/wml/.libs/lt-wmldbcreate-host
	mkdir -p $(OPENMOTIF_DIR)/demos/lib/Exm/wml/.libs
	ln -s -f $(OPENMOTIF_HOST_DIR)/demos/lib/Exm/wml/.libs/lt-wmldbcreate $(OPENMOTIF_DIR)/demos/lib/Exm/wml/.libs/lt-wmldbcreate-host
	mkdir -p $(OPENMOTIF_DIR)/clients/uil/.libs
	ln -s -f $(OPENMOTIF_HOST_DIR)/clients/uil/.libs/lt-uil $(OPENMOTIF_DIR)/clients/uil/.libs/lt-uil-host
	touch $(OPENMOTIF_HOST_DIR)/.done

$(OPENMOTIF_DIR)/.done: $(OPENMOTIF_HOST_DIR)/.done
	$(MAKE) -C $(OPENMOTIF_DIR)
	$(MAKE) -C $(OPENMOTIF_DIR) install DESTDIR=$(STAGING_DIR)
	$(MAKE) -C $(OPENMOTIF_DIR) install DESTDIR=$(TARGET_DIR)
	touch $(OPENMOTIF_DIR)/.done

openmotif: uclibc $(OPENMOTIF_DIR)/.done

openmotif-clean:
	rm -f $(TARGET_DIR)/bin/openmotif
	-$(MAKE) -C $(OPENMOTIF_DIR) clean

openmotif-dirclean:
	rm -rf $(OPENMOTIF_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_OPENMOTIF),y)
TARGETS+=openmotif
endif
