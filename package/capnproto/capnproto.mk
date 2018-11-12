################################################################################
#
# capnproto
#
################################################################################

CAPNPROTO_VERSION = v0.6.1
CAPNPROTO_SITE = $(call github,capnproto,capnproto,$(CAPNPROTO_VERSION))
CAPNPROTO_LICENSE = MIT
CAPNPROTO_LICENSE_FILES = LICENSE
CAPNPROTO_INSTALL_STAGING = YES
# Fetched from Github with no configure script
CAPNPROTO_AUTORECONF = YES
CAPNPROTO_CONF_OPTS = --with-external-capnp
# Needs the capnproto compiler on the host to generate C++ code from message
# definitions
CAPNPROTO_DEPENDENCIES = host-autoconf host-capnproto
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
CAPNPROTO_CONF_ENV += LIBS=-latomic
endif
# The actual source to be compiled is within a 'c++' subdirectory
CAPNPROTO_SUBDIR = c++

$(eval $(autotools-package))
$(eval $(host-autotools-package))
