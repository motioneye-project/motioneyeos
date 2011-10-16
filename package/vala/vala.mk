#############################################################
#
# vala
#
#############################################################

VALA_VERSION = 0.14.0
VALA_SITE = http://download.gnome.org/sources/vala/0.14
VALA_SOURCE = vala-$(VALA_VERSION).tar.bz2
VALA_DEPENDENCIES = host-flex libglib2 \
		$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)
HOST_VALA_DEPENDENCIES = host-flex host-libglib2

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
