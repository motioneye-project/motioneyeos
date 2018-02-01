################################################################################
#
# imx-alsa-plugins
#
################################################################################

IMX_ALSA_PLUGINS_VERSION = rel_imx_4.9.x_1.0.0_ga
IMX_ALSA_PLUGINS_SITE = https://source.codeaurora.org/external/imx/imx-alsa-plugins
IMX_ALSA_PLUGINS_SITE_METHOD = git
IMX_ALSA_PLUGINS_LICENSE = GPL-2.0+
IMX_ALSA_PLUGINS_LICENSE_FILES = COPYING.GPL
IMX_ALSA_PLUGINS_DEPENDENCIES = host-pkgconf alsa-lib

# git, no configure
IMX_ALSA_PLUGINS_AUTORECONF = YES

# needs access to imx-specific kernel headers
IMX_ALSA_PLUGINS_DEPENDENCIES += linux
IMX_ALSA_PLUGINS_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -idirafter $(LINUX_DIR)/include/uapi"

$(eval $(autotools-package))
