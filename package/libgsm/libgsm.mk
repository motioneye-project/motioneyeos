################################################################################
#
# libgsm
#
################################################################################

LIBGSM_VERSION = 1.0.18
LIBGSM_SOURCE = gsm-$(LIBGSM_VERSION).tar.gz
LIBGSM_SITE = http://www.quut.com/gsm
LIBGSM_LICENSE = gsm
LIBGSM_LICENSE_FILES = COPYRIGHT
LIBGSM_INSTALL_STAGING = YES

define LIBGSM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D)
endef

# Install targets are not safe for parallel jobs. However, since there's
# just only a bunch of files to install, just do it manually. Note that,
# even though the package version is '1.0.16', the solib is generated as
# '1.0.13' and its SONAME is just '1'.
#
# For staging, we install all the .so symlinks, and the header.
define LIBGSM_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/inc/gsm.h $(STAGING_DIR)/usr/include/gsm.h
	$(INSTALL) -D -m 0644 $(@D)/lib/libgsm.so.1.0.13 $(STAGING_DIR)/usr/lib/libgsm.so.1.0.13
	ln -sf libgsm.so.1.0.13 $(STAGING_DIR)/usr/lib/libgsm.so.1
	ln -sf libgsm.so.1.0.13 $(STAGING_DIR)/usr/lib/libgsm.so
endef

# Install targets are not safe for parallel jobs. However, since there's
# just only a bunch of files to install, just do it manually. Note that,
# even though the package version is '1.0.16', the solib is versioned as
# '1.0.13' and its SONAME is just versioned with '1'.
#
# For target, we just need the library to be installed as its SONAME, and
# the programs.
define LIBGSM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/lib/libgsm.so.1.0.13 $(TARGET_DIR)/usr/lib/libgsm.so.1
	$(INSTALL) -D -m 0755 $(@D)/bin/toast $(TARGET_DIR)/usr/bin/toast
	$(INSTALL) -D -m 0755 $(@D)/bin/tcat $(TARGET_DIR)/usr/bin/tcat
	$(INSTALL) -D -m 0755 $(@D)/bin/untoast $(TARGET_DIR)/usr/bin/untoast
endef

$(eval $(generic-package))
