################################################################################
#
# patch
#
################################################################################

PATCH_VERSION = 2.7.6
PATCH_SOURCE = patch-$(PATCH_VERSION).tar.xz
PATCH_SITE = $(BR2_GNU_MIRROR)/patch
PATCH_LICENSE = GPL-3.0+
PATCH_LICENSE_FILES = COPYING

# 0001-Fix-segfault-with-mangled-rename-patch.patch
PATCH_IGNORE_CVES += CVE-2018-6951

# 0003-Fix-arbitrary-command-execution-in-ed-style-patches-.patch
PATCH_IGNORE_CVES += CVE-2018-1000156

ifeq ($(BR2_PACKAGE_ATTR),y)
PATCH_CONF_OPTS += --enable-xattr
PATCH_DEPENDENCIES += attr
else
PATCH_CONF_OPTS += --disable-xattr
endif

$(eval $(autotools-package))
