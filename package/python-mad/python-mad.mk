################################################################################
#
# python-mad
#
################################################################################

PYTHON_MAD_VERSION = 0.6
PYTHON_MAD_SOURCE = pymad-$(PYTHON_MAD_VERSION).tar.gz
PYTHON_MAD_SITE = http://spacepants.org/src/pymad/download
PYTHON_MAD_SETUP_TYPE = distutils
PYTHON_MAD_LICENSE = GPLv2+
PYTHON_MAD_LICENSE_FILES = COPYING

PYTHON_MAD_DEPENDENCIES = libmad

ifeq ($(BR2_ENDIAN),"LITTLE")
PYTHON_MAD_ENDIAN=little
else
PYTHON_MAD_ENDIAN=big
endif

define PYTHON_MAD_CONFIGURE_CMDS
	echo "endian = $(PYTHON_MAD_ENDIAN)" > $(@D)/Setup
	echo "mad_libs = mad" >> $(@D)/Setup
	echo "mad_lib_dir = $(STAGING_DIR)/usr/lib" >> $(@D)/Setup
	echo "mad_include_dir = $(STAGING_DIR)/usr/include" >> $(@D)/Setup
endef

$(eval $(python-package))
