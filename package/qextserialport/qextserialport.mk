################################################################################
#
# qextserialport
#
################################################################################

QEXTSERIALPORT_VERSION = ada321a9ee463f628e7b781b8ed00ff219152158
QEXTSERIALPORT_SITE = $(call github,qextserialport,qextserialport,$(QEXTSERIALPORT_VERSION))
QEXTSERIALPORT_LICENSE = MIT
QEXTSERIALPORT_LICENSE_FILES = LICENSE.md
QEXTSERIALPORT_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
QEXTSERIALPORT_CONF_OPTS += CONFIG+=qesp_static
endif

$(eval $(qmake-package))
