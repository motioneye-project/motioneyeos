################################################################################
#
# cjson
#
################################################################################

CJSON_VERSION = v1.1.0
CJSON_SITE = $(call github,DaveGamble,cjson,$(CJSON_VERSION))
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE = MIT
CJSON_LICENSE_FILES = LICENSE

# This patch fixes -Werror=strict-overflow compile errors on sh4a and powerpc
# toolchains:
# http://autobuild.buildroot.net/results/3d899790acdc5c21733ff6f7f5a1b500e862ea0a
CJSON_PATCH = \
	https://github.com/DaveGamble/cjson/commit/fcc89c4bb264d665929b00eeebc479a643a90896.patch

$(eval $(cmake-package))
