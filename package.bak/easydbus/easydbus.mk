################################################################################
#
# easydbus
#
################################################################################

EASYDBUS_VERSION = 59c340f2cd2c92ded82f9d4436866847f295faab
EASYDBUS_SITE = $(call github,mniestroj,easydbus,$(EASYDBUS_VERSION))
EASYDBUS_DEPENDENCIES = luainterpreter libglib2
EASYDBUS_LICENSE = MIT
EASYDBUS_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
