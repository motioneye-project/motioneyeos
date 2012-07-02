#############################################################
#
# vala
#
#############################################################

VALA_VERSION_MAJOR = 0.15
VALA_VERSION_MINOR = 2
VALA_VERSION = $(VALA_VERSION_MAJOR).$(VALA_VERSION_MINOR)
VALA_SITE = http://download.gnome.org/sources/vala/$(VALA_VERSION_MAJOR)
VALA_SOURCE = vala-$(VALA_VERSION).tar.xz
VALA_DEPENDENCIES = host-flex libglib2 \
		$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)
HOST_VALA_DEPENDENCIES = host-flex host-libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
