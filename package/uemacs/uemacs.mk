#############################################################
#
# uemacs
#
#############################################################
UEMACS_VER:=4.0.15-lt
UEMACS_SOURCE:=em-$(UEMACS_VER).tar.bz2
UEMACS_SITE:=ftp://ftp.kernel.org/pub/software/editors/uemacs/
UEMACS_DIR:=$(BUILD_DIR)/em-$(UEMACS_VER)
UEMACS_BINARY:=em
UEMACS_TARGET_BINARY:=usr/bin/emacs

$(DL_DIR)/$(UEMACS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(UEMACS_SITE)/$(UEMACS_SOURCE)

uemacs-source: $(DL_DIR)/$(UEMACS_SOURCE)

$(UEMACS_DIR)/.unpacked: $(DL_DIR)/$(UEMACS_SOURCE)
	bzcat $(DL_DIR)/$(UEMACS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UEMACS_DIR) package/uemacs/ uemacs\*.patch
	touch $(UEMACS_DIR)/.unpacked

$(UEMACS_DIR)/$(UEMACS_BINARY): $(UEMACS_DIR)/.unpacked
	$(MAKE) -C $(UEMACS_DIR) \
	CC="$(TARGET_CC)" DEFINES="-DAUTOCONF -DPOSIX -DUSG" CFLAGS+="$(TARGET_CFLAGS) -march=$(ARCH)" LIBS=-lcurses
	$(STRIP) $(UEMACS_DIR)/$(UEMACS_BINARY)

$(TARGET_DIR)/$(UEMACS_TARGET_BINARY): $(UEMACS_DIR)/$(UEMACS_BINARY)
	$(INSTALL) -m 0755 -D $(UEMACS_DIR)/$(UEMACS_BINARY) $(TARGET_DIR)/$(UEMACS_TARGET_BINARY)

uemacs: uclibc $(TARGET_DIR)/$(UEMACS_TARGET_BINARY)

uemacs-clean:
	rm -f $(TARGET_DIR)/$(UEMACS_TARGET_BINARY)
	-$(MAKE) -C $(UEMACS_DIR) clean

uemacs-dirclean:
	rm -rf $(UEMACS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_UEMACS)),y)
TARGETS+=uemacs
endif
