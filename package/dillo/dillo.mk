#############################################################
#
# dillo
#
#############################################################

DILLO_VERSION=0.8.6
DILLO_SOURCE=dillo-$(DILLO_VERSION).tar.bz2
DILLO_SITE=http://www.dillo.org/download/
DILLO_DIR=$(BUILD_DIR)/dillo-$(DILLO_VERSION)
DILLO_CAT:=$(BZCAT)

$(DL_DIR)/$(DILLO_SOURCE):
	$(WGET) -P $(DL_DIR) $(DILLO_SITE)/$(DILLO_SOURCE)

$(DILLO_DIR)/.unpacked: $(DL_DIR)/$(DILLO_SOURCE)
	$(DILLO_CAT) $(DL_DIR)/$(DILLO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(DILLO_DIR)/.unpacked

$(DILLO_DIR)/.configured: $(DILLO_DIR)/.unpacked
	(cd $(DILLO_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--program-transform-name='' \
		--disable-dlgui \
	);
	touch $(DILLO_DIR)/.configured

$(DILLO_DIR)/src/dillo: $(DILLO_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(DILLO_DIR)

$(DILLO_DIR)/.installed: $(DILLO_DIR)/src/dillo
	$(MAKE) -C $(DILLO_DIR) DESTDIR=$(TARGET_DIR) install
	touch $(DILLO_DIR)/.installed

dillo: uclibc $(XSERVER) libglib12 libgtk12 jpeg libpng $(DILLO_DIR)/.installed

dillo-source: $(DL_DIR)/$(DILLO_SOURCE)

dillo-clean:
	@if [ -d $(DILLO_DIR)/Makefile ] ; then \
		$(MAKE) -C $(DILLO_DIR) clean ; \
	fi;

dillo-dirclean:
	rm -rf $(DILLO_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DILLO)),y)
TARGETS+=dillo
endif
