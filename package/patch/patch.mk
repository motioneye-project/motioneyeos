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

# 0004-Invoke-ed-directly-instead-of-using-the-shell.patch
PATCH_IGNORE_CVES += CVE-2018-20969 CVE-2019-13638

# 0005-Don-t-follow-symlinks-unless--follow-symlinks-is-given.patch
PATCH_IGNORE_CVES += CVE-2019-13636

ifeq ($(BR2_PACKAGE_ATTR),y)
PATCH_CONF_OPTS += --enable-xattr
PATCH_DEPENDENCIES += attr
else
PATCH_CONF_OPTS += --disable-xattr
endif

$(eval $(autotools-package))
