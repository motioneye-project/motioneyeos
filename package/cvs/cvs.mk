#############################################################
#
# cvs
#
#############################################################
CVS_VER:=1.12.12
CVS_SOURCE:=cvs-$(CVS_VER).tar.bz2
CVS_SITE:=http://ccvs.cvshome.org/files/documents/19/872/$(CVS_SOURCE)
CVS_DIR:=$(BUILD_DIR)/cvs-$(CVS_VER)
CVS_CAT:=$(BZCAT)
CVS_BINARY:=src/cvs
CVS_TARGET_BINARY:=usr/bin/cvs

$(DL_DIR)/$(CVS_SOURCE):
	$(WGET) -P $(DL_DIR) $(CVS_SITE)/$(CVS_SOURCE)

cvs-source: $(DL_DIR)/$(CVS_SOURCE)

$(CVS_DIR)/.unpacked: $(DL_DIR)/$(CVS_SOURCE)
	$(CVS_CAT) $(DL_DIR)/$(CVS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(CVS_DIR)/.unpacked

$(CVS_DIR)/.configured: $(CVS_DIR)/.unpacked
	(cd $(CVS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		cvs_cv_func_printf_ptr=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
	);
	touch $(CVS_DIR)/.configured

$(CVS_DIR)/$(CVS_BINARY): $(CVS_DIR)/.configured
	$(MAKE) -C $(CVS_DIR)

$(TARGET_DIR)/$(CVS_TARGET_BINARY): $(CVS_DIR)/$(CVS_BINARY)
	install -D $(CVS_DIR)/$(CVS_BINARY) $(TARGET_DIR)/$(CVS_TARGET_BINARY)
	$(STRIP) $(TARGET_DIR)/$(CVS_TARGET_BINARY)

cvs: uclibc ncurses $(TARGET_DIR)/$(CVS_TARGET_BINARY)

cvs-clean:
	rm -f $(TARGET_DIR)/$(CVS_TARGET_BINARY)
	-$(MAKE) -C $(CVS_DIR) clean

cvs-dirclean:
	rm -rf $(CVS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CVS)),y)
TARGETS+=cvs
endif
