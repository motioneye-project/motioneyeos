################################################################################
#
# vala
#
################################################################################

VALA_VERSION_MAJOR = 0.18
VALA_VERSION_MINOR = 1
VALA_VERSION = $(VALA_VERSION_MAJOR).$(VALA_VERSION_MINOR)
VALA_SITE = http://download.gnome.org/sources/vala/$(VALA_VERSION_MAJOR)
VALA_SOURCE = vala-$(VALA_VERSION).tar.xz
VALA_LICENSE = LGPLv2.1+
VALA_LICENSE_FILES = COPYING

VALA_DEPENDENCIES = host-flex host-bison libglib2 \
		$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

# Force Vala to not use the host xsltproc even if available, because it may or
# may not work with Vala documentation (some versions of xsltproc segfault)
VALA_CONF_ENV = ac_cv_path_XSLTPROC=:

HOST_VALA_DEPENDENCIES = host-flex host-libglib2
# Yes, the autoconf script understands ':' as "xsltproc is not
# available".
HOST_VALA_CONF_ENV = ac_cv_path_XSLTPROC=:

$(eval $(autotools-package))
$(eval $(host-autotools-package))
