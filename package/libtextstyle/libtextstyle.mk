################################################################################
#
# libtextstyle
#
################################################################################

# Please keep in sync with package/gettext-gnu/gettext-gnu.mk
LIBTEXTSTYLE_VERSION = 0.20.1
LIBTEXTSTYLE_SITE = $(BR2_GNU_MIRROR)/gettext
LIBTEXTSTYLE_SOURCE = gettext-$(LIBTEXTSTYLE_VERSION).tar.xz
LIBTEXTSTYLE_INSTALL_STAGING = YES
LIBTEXTSTYLE_LICENSE = GPL-3.0+
LIBTEXTSTYLE_LICENSE_FILES = COPYING
HOST_LIBTEXTSTYLE_DL_SUBDIR = gettext-gnu
HOST_LIBTEXTSTYLE_SUBDIR = libtextstyle

# gettext-tools require libtextstyle.m4
define HOST_LIBTEXTSTYLE_INSTALL_M4
	$(INSTALL) -D -m 0755 $(@D)/libtextstyle/m4/libtextstyle.m4 \
		$(ACLOCAL_HOST_DIR)/libtextstyle.m4
endef
HOST_LIBTEXTSTYLE_POST_INSTALL_HOOKS += HOST_LIBTEXTSTYLE_INSTALL_M4

$(eval $(host-autotools-package))
