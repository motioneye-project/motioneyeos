################################################################################
#
# brotli
#
################################################################################

BROTLI_VERSION = 1.0.7
BROTLI_SOURCE = v$(BROTLI_VERSION).tar.gz
BROTLI_SITE = https://github.com/google/brotli/archive
BROTLI_LICENSE = MIT
BROTLI_LICENSE_FILES = LICENSE
BROTLI_INSTALL_STAGING = YES
BROTLI_CONF_OPTS = \
	-DBROTLI_DISABLE_TESTS=ON \
	-DBROTLI_BUNDLED_MODE=OFF

$(eval $(cmake-package))
