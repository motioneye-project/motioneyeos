KBD_VERSION = 1.15.2
KBD_SOURCE = kbd-$(KBD_VERSION).tar.gz
KBD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kbd

KBD_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

$(eval $(autotools-package))
