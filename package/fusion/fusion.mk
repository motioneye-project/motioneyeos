#############################################################
#
# linux-fusion
#
#############################################################
LINUX_FUSION_VERSION:=3.2.3
LINUX_FUSION_SOURCE:=linux-fusion-$(LINUX_FUSION_VERSION).tar.gz
LINUX_FUSION_SITE:=http://www.directfb.org/downloads/Core
LINUX_FUSION_CAT:=$(ZCAT)
LINUX_FUSION_DIR:=$(TARGET_DIR)/etc/udev/rules.d
LINUX_FUSION:=40-fusion.rules
LINUX_FUSION_HEADER=$(STAGING_DIR)/usr/include/linux/fusion.h

#############################################################
#
# build linux-fusion
#
#############################################################

$(LINUX_FUSION_HEADER):
	cp -dpf package/fusion/fusion.h $(LINUX_FUSION_HEADER)

$(LINUX_FUSION_DIR)/$(LINUX_FUSION):
	mkdir	-p $(LINUX_FUSION_DIR)
	cp -dpf package/fusion/40-fusion.rules $(LINUX_FUSION_DIR)
	touch -c $@

linux-fusion: $(LINUX_FUSION_DIR)/$(LINUX_FUSION) $(LINUX_FUSION_HEADER)

linux-fusion-clean:
	rm -f $(LINUX_FUSION_DIR)/$(LINUX_FUSION))

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LINUX_FUSION)),y)
TARGETS+=linux-fusion
endif

