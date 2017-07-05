################################################################################
#
# vala
#
################################################################################

VALA_VERSION_MAJOR = 0.34
VALA_VERSION = $(VALA_VERSION_MAJOR).7
VALA_SITE = http://download.gnome.org/sources/vala/$(VALA_VERSION_MAJOR)
VALA_SOURCE = vala-$(VALA_VERSION).tar.xz
VALA_LICENSE = LGPL-2.1+
VALA_LICENSE_FILES = COPYING

HOST_VALA_DEPENDENCIES = host-bison host-flex host-libglib2
# Yes, the autoconf script understands ':' as "xsltproc is not
# available".
HOST_VALA_CONF_ENV = ac_cv_path_XSLTPROC=:

# We wrap vala & valac to point to the proper gir and vapi data dirs
# Otherwise we'll get host directory data which isn't enough
define HOST_VALA_INSTALL_WRAPPER
	$(INSTALL) -D -m 0755 package/vala/vala-wrapper \
		$(HOST_DIR)/bin/vala
	$(INSTALL) -D -m 0755 package/vala/vala-wrapper \
		$(HOST_DIR)/bin/valac
	$(SED) 's,@VALA_VERSION@,$(VALA_VERSION_MAJOR),' \
		$(HOST_DIR)/bin/vala \
		$(HOST_DIR)/bin/valac
endef
HOST_VALA_POST_INSTALL_HOOKS += HOST_VALA_INSTALL_WRAPPER

$(eval $(host-autotools-package))
