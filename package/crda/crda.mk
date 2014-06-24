################################################################################
#
# crda
#
################################################################################

CRDA_VERSION = 3.13
CRDA_SOURCE = crda-$(CRDA_VERSION).tar.xz
CRDA_SITE = $(BR2_KERNEL_MIRROR)/software/network/crda
CRDA_DEPENDENCIES = host-pkgconf host-python-m2crypto \
	libnl libgcrypt host-python
CRDA_LICENSE = ISC
CRDA_LICENSE_FILES = LICENSE

# libnl-3 needs -lm (for rint) and -lpthread if linking statically.
# And library order matters hence stick -lnl-3 first since it's appended
# in the crda Makefiles as in NLLIBS+=-lnl-3 ... thus failing.
#
# libgcrypt needs -lgpg-error if linking statically, which is correctly
# set by the libgcrypt-config script (and in the right order).
ifeq ($(BR2_PREFER_STATIC_LIB),y)
CRDA_NLLIBS += -lnl-3 -lm -lpthread
CRDA_LDLIBS += `$(STAGING_DIR)/usr/bin/libgcrypt-config --libs`
endif

# * key2pub.py currently is not python3 compliant (though python2/python3
#   compliance could rather easily be achieved.
# * key2pub.py uses M2Crypto python module, which is only available for
#   python2, so we have to make sure this script is run using the python2
#   interpreter, hence the host-python dependency and the PYTHON variable.
define CRDA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		LDLIBS="$(CRDA_LDLIBS)" \
		NLLIBS="$(CRDA_NLLIBS)" \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(MAKE) all_noverify -C $(@D)
endef

define CRDA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D) DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
