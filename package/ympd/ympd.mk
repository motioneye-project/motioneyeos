################################################################################
#
# ympd
#
################################################################################

YMPD_VERSION = a98d760dddff4b0dd595d977c9077f34beff05c5
YMPD_SITE = $(call github,notandy,ympd,$(YMPD_VERSION))
YMPD_LICENSE = GPLv2
YMPD_LICENSE_FILE = LICENSE
YMPD_DEPENDENCIES = libmpdclient

define YMPD_MAKE_HOST_TOOL
	$(HOSTCC) $(HOST_CFLAGS) $(@D)/htdocs/mkdata.c -o $(@D)/mkdata
endef

YMPD_PRE_BUILD_HOOKS += YMPD_MAKE_HOST_TOOL

YMPD_CONF_OPTS += -DMKDATA_EXE=$(@D)/mkdata

$(eval $(cmake-package))
