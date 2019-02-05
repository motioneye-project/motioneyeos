################################################################################
#
# cog
#
################################################################################

COG_VERSION = v0.2.0
COG_SITE = $(call github,Igalia,cog,$(COG_VERSION))
COG_DEPENDENCIES = dbus wpewebkit wpebackend-fdo
COG_LICENSE = MIT
COG_LICENSE_FILES = COPYING
COG_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_PLATFORM_FDO=ON \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_PROGRAMS_HOME_URI))'

$(eval $(cmake-package))
