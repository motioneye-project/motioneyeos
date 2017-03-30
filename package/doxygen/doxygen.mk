################################################################################
#
# doxygen
#
################################################################################

DOXYGEN_VERSION = 1.8.9.1
DOXYGEN_SOURCE = doxygen-$(DOXYGEN_VERSION).src.tar.gz
DOXYGEN_SITE = http://ftp.stack.nl/pub/users/dimitri
DOXYGEN_LICENSE = GPL-2.0
DOXYGEN_LICENSE_FILES = LICENSE
HOST_DOXYGEN_DEPENDENCIES = host-flex host-bison

define HOST_DOXYGEN_CONFIGURE_CMDS
	(cd $(@D); $(HOST_MAKE_ENV) ./configure --shared --prefix=$(HOST_DIR)/usr)
endef

define HOST_DOXYGEN_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_DOXYGEN_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

# Doxygen's configure is a handwritten script, not an autotools-generated one.
# It doesn't accept host-autotools-package default arguments, so we have to
# call host-generic-package here.
$(eval $(host-generic-package))
