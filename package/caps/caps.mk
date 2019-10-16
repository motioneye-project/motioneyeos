################################################################################
#
# caps
#
################################################################################

CAPS_VERSION = 0.9.26
CAPS_SOURCE = caps_$(CAPS_VERSION).tar.bz2
CAPS_SITE = http://quitte.de/dsp
CAPS_LICENSE = GPL-3.0+
CAPS_LICENSE_FILES = COPYING

# Need to pass TARGET_CONFIGURE_OPTS in the environment to not
# override the LDFLAGS definition of the Makefile.
CAPS_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CXXFLAGS)"

# caps Makefile uses CC and CFLAGS, but for C++
CAPS_MAKE_OPTS = \
	CC="$(TARGET_CXX)" \
	STRIP=/bin/true

define CAPS_BUILD_CMDS
	$(CAPS_MAKE_ENV) $(MAKE) $(CAPS_MAKE_OPTS) all -C $(@D)
endef

define CAPS_INSTALL_TARGET_CMDS
	$(CAPS_MAKE_ENV) $(MAKE) $(CAPS_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) install -C $(@D)
endef

$(eval $(generic-package))
