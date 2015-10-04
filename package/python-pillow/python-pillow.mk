################################################################################
#
# python-pillow
#
################################################################################

PYTHON_PILLOW_VERSION = 2.4.0
PYTHON_PILLOW_SOURCE = Pillow-$(PYTHON_PILLOW_VERSION).zip
PYTHON_PILLOW_SITE = https://pypi.python.org/packages/source/P/Pillow/
PYTHON_PILLOW_DEPENDENCIES = python zlib freetype jpeg host-python-setuptools
PYTHON_PILLOW_SETUP_TYPE = setuptools

define PYTHON_PILLOW_EXTRACT_CMDS
	(unzip -o $(DL_DIR)/$(PYTHON_PILLOW_SOURCE) -d $(BUILD_DIR); \
	mv $(BUILD_DIR)/Pillow-$(PYTHON_PILLOW_VERSION)/* $(@D))
#	echo "[build_ext]" >> $(@D)/setup.cfg
#	echo "disable-webp = " >> $(@D)/setup.cfg
#	echo "disable-lcms = " >> $(@D)/setup.cfg
#	echo "disable-freetype = " >> $(@D)/setup.cfg
#	echo "disable-jpeg2000 = " >> $(@D)/setup.cfg
#	echo "disable-tcl = " >> $(@D)/setup.cfg
#	echo "disable-webpmux = " >> $(@D)/setup.cfg
#	echo "disable-tiff = " >> $(@D)/setup.cfg
endef

define PYTHON_PILLOW_BUILD_CMDS__
	(cd $(@D); \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
	$(HOST_DIR)/usr/bin/python setup.py build build_ext --disable-lcms --disable-webp)
endef

define PYTHON_PILLOW_INSTALL_TARGET_CMDS____
	(cd $(@D); \
	PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install \
	--single-version-externally-managed --root=/ --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(python-package))
