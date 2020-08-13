################################################################################
#
# spdlog
#
################################################################################

SPDLOG_VERSION = 1.5.0
SPDLOG_SITE = $(call github,gabime,spdlog,v$(SPDLOG_VERSION))
SPDLOG_LICENSE = MIT
SPDLOG_LICENSE_FILES = LICENSE
SPDLOG_DEPENDENCIES = fmt
SPDLOG_CONF_OPTS += \
	-DSPDLOG_BUILD_TESTS=OFF \
	-DSPDLOG_BUILD_EXAMPLE=OFF \
	-DSPDLOG_BUILD_BENCH=OFF \
	-DSPDLOG_FMT_EXTERNAL=ON

# Header-only library
SPDLOG_INSTALL_STAGING = YES
SPDLOG_INSTALL_TARGET = NO

$(eval $(cmake-package))
