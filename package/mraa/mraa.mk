################################################################################
#
# mraa
#
################################################################################

MRAA_VERSION = v0.9.1
MRAA_SITE = $(call github,intel-iot-devkit,mraa,$(MRAA_VERSION))
MRAA_LICENSE = MIT
MRAA_LICENSE_FILES = COPYING
MRAA_INSTALL_STAGING = YES

# USBPLAT only makes sense with FTDI4222, which requires the ftd2xx library,
# which doesn't exist in buildroot

MRAA_CONF_OPTS += \
	-DBUILDSWIG=OFF \
	-DUSBPLAT=OFF \
	-DFTDI4222=OFF \
	-DIPK=OFF \
	-DRPM=OFF \
	-DENABLEEXAMPLES=OFF \
	-DBUILDTESTS=OFF

$(eval $(cmake-package))
