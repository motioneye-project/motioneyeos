################################################################################
#
# easydbus
#
################################################################################

EASYDBUS_VERSION = b86721147b265dfefc9a857669408cb6eb3d6560
EASYDBUS_SITE = $(call github,mniestroj,easydbus,$(EASYDBUS_VERSION))
EASYDBUS_DEPENDENCIES = luainterpreter libglib2
EASYDBUS_LICENSE = MIT
EASYDBUS_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
