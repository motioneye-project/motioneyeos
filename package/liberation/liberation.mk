#############################################################
#
# liberation
#
#############################################################
LIBERATION_VERSION = 1.04
LIBERATION_SITE = http://www.fedorahosted.org/releases/l/i/liberation-fonts
LIBERATION_SOURCE = liberation-fonts-$(LIBERATION_VERSION).tar.gz
LIBERATION_DIR = $(BUILD_DIR)/liberation-fonts-$(LIBERATION_VERSION)
LIBERATION_CAT:=$(ZCAT)
LIBERATION_TARGET_DIR:=$(TARGET_DIR)/usr/share/fonts/liberation

$(DL_DIR)/$(LIBERATION_SOURCE):
	$(call DOWNLOAD,$(LIBERATION_SITE),$(LIBERATION_SOURCE))

liberation-source: $(DL_DIR)/$(LIBERATION_SOURCE)

$(LIBERATION_DIR)/.unpacked: $(DL_DIR)/$(LIBERATION_SOURCE)
	$(LIBERATION_CAT) $(DL_DIR)/$(LIBERATION_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LIBERATION_TARGET_DIR)/LiberationMono-Bold.ttf: $(LIBERATION_DIR)/.unpacked
	mkdir -p $(LIBERATION_TARGET_DIR)
	$(INSTALL) -m0644 $(LIBERATION_DIR)/*.ttf $(LIBERATION_TARGET_DIR)
	touch -c $@

liberation: uclibc $(LIBERATION_TARGET_DIR)/LiberationMono-Bold.ttf

liberation-clean:
	rm -rf $(LIBERATION_TARGET_DIR)

liberation-dirclean:
	rm -rf $(LIBERATION_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBERATION),y)
TARGETS+=liberation
endif
