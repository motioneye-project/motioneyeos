################################################################################
#
# cmocka
#
################################################################################

CMOCKA_VERSION = 1.1.5
CMOCKA_SOURCE = cmocka-$(CMOCKA_VERSION).tar.xz
CMOCKA_SITE = https://cmocka.org/files/1.1
CMOCKA_LICENSE = Apache-2.0
CMOCKA_LICENSE_FILES = COPYING
CMOCKA_INSTALL_STAGING = YES
CMOCKA_CONF_OPTS = -DWITH_EXAMPLES=OFF

# cmocka only supports out of source builds
CMOCKA_SUPPORTS_IN_SOURCE_BUILD = NO

# cmocka always builds a shared library, but you can optionally build a static
# library as well
ifeq ($(BR2_SHARED_STATIC_LIBS),y)
CMOCKA_CONF_OPTS += -DWITH_STATIC_LIB=ON
endif

$(eval $(cmake-package))
