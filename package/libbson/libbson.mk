################################################################################
#
# libbson
#
################################################################################

LIBBSON_VERSION = 1.6.2
LIBBSON_SITE = https://github.com/mongodb/libbson/releases/download/$(LIBBSON_VERSION)
LIBBSON_LICENSE = Apache-2.0, MIT (jsonl), ISC (b64), Zlib (md5)
LIBBSON_LICENSE_FILES = COPYING THIRD_PARTY_NOTICES
LIBBSON_CONF_OPTS = \
	--disable-tests \
	--disable-examples \
	--disable-man-pages \
	--disable-html-docs

LIBBSON_INSTALL_STAGING = YES

# Also has CMake support, but that forces shared+static libs and static
# lib has a different name.
$(eval $(autotools-package))
