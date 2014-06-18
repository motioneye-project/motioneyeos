################################################################################
#
# kbd
#
################################################################################

KBD_VERSION = 1.15.5
KBD_SOURCE = kbd-$(KBD_VERSION).tar.xz
KBD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kbd
KBD_CONF_OPT = --disable-vlock
KBD_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
KBD_LICENSE = GPLv2+
KBD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
