################################################################################
#
# crda
#
################################################################################

CRDA_VERSION = 3.18
CRDA_SOURCE = crda-$(CRDA_VERSION).tar.xz
CRDA_SITE = $(BR2_KERNEL_MIRROR)/software/network/crda
CRDA_DEPENDENCIES = host-pkgconf host-python-m2crypto \
	libnl libgcrypt host-python
CRDA_LICENSE = ISC
CRDA_LICENSE_FILES = LICENSE

# * key2pub.py currently is not python3 compliant (though python2/python3
#   compliance could rather easily be achieved.
# * key2pub.py uses M2Crypto python module, which is only available for
#   python2, so we have to make sure this script is run using the python2
#   interpreter, hence the host-python dependency and the PYTHON variable.
define CRDA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(MAKE) all_noverify -C $(@D)
endef

define CRDA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D) DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
