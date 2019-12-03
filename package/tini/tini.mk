################################################################################
#
# tini
#
################################################################################

TINI_VERSION = 0.18.0
TINI_SITE = $(call github,krallin,tini,v$(TINI_VERSION))
TINI_LICENSE = MIT
TINI_LICENSE_FILES = LICENSE

TINI_CFLAGS = $(TARGET_CFLAGS) \
	-static \
	-DTINI_VERSION=\"$(TINI_VERSION)\" \
	-DTINI_GIT=\"\"

ifeq ($(BR2_PACKAGE_TINI_MINIMAL),y)
TINI_CFLAGS += -DTINI_MINIMAL
endif

define TINI_CONFIGURE_CMDS
	printf "#pragma once\n" > $(@D)/src/tiniConfig.h
endef

define TINI_BUILD_CMDS
	mkdir -p $(@D)/bin
	$(TARGET_CC) $(TINI_CFLAGS) \
		-o $(@D)/bin/tini $(@D)/src/tini.c
endef

define TINI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/tini $(TARGET_DIR)/usr/bin/tini
endef

# Tini's CMakeLists.txt is not suitable for Buildroot.
$(eval $(generic-package))
