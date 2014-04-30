################################################################################
#
# vala
#
################################################################################

VALA_VERSION_MAJOR = 0.18
VALA_VERSION = $(VALA_VERSION_MAJOR).1
VALA_SITE = http://download.gnome.org/sources/vala/$(VALA_VERSION_MAJOR)
VALA_SOURCE = vala-$(VALA_VERSION).tar.xz
VALA_LICENSE = LGPLv2.1+
VALA_LICENSE_FILES = COPYING

HOST_VALA_DEPENDENCIES = host-flex host-libglib2
# Yes, the autoconf script understands ':' as "xsltproc is not
# available".
HOST_VALA_CONF_ENV = ac_cv_path_XSLTPROC=:

$(eval $(host-autotools-package))
