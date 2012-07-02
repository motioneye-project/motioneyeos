#############################################################
#
# python-mad
#
#############################################################

PYTHON_MAD_VERSION = 0.6
PYTHON_MAD_SOURCE  = pymad-$(PYTHON_MAD_VERSION).tar.gz
PYTHON_MAD_SITE    = http://spacepants.org/src/pymad/download/

PYTHON_MAD_DEPENDENCIES = python libmad

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

define PYTHON_MAD_BUILD_CMDS
	(cd $(@D); \
		CC="$(TARGET_CC)"		\
		CFLAGS="$(TARGET_CFLAGS)" 	\
		LDSHARED="$(TARGET_CC) -shared" \
		LDFLAGS="$(TARGET_LDFLAGS)" 	\
	$(HOST_DIR)/usr/bin/python setup.py build_ext \
	--include-dirs=$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR))
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_MAD_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
