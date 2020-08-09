################################################################################
#
# python-pillow
#
################################################################################

PYTHON_PILLOW_VERSION = 7.0.0
PYTHON_PILLOW_SITE = https://files.pythonhosted.org/packages/39/47/f28067b187dd664d205f75b07dcc6e0e95703e134008a14814827eebcaab
PYTHON_PILLOW_SOURCE = Pillow-$(PYTHON_PILLOW_VERSION).tar.gz
PYTHON_PILLOW_LICENSE = PIL Software License
PYTHON_PILLOW_LICENSE_FILES = LICENSE
PYTHON_PILLOW_SETUP_TYPE = setuptools
PYTHON_PILLOW_BUILD_OPTS = --disable-platform-guessing

ifeq ($(BR2_PACKAGE_FREETYPE),y)
PYTHON_PILLOW_DEPENDENCIES += freetype
PYTHON_PILLOW_BUILD_OPTS += --enable-freetype
else
PYTHON_PILLOW_BUILD_OPTS += --disable-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
PYTHON_PILLOW_DEPENDENCIES += jpeg
PYTHON_PILLOW_BUILD_OPTS += --enable-jpeg
else
PYTHON_PILLOW_BUILD_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
PYTHON_PILLOW_DEPENDENCIES += openjpeg
PYTHON_PILLOW_BUILD_OPTS += --enable-jpeg2000
else
PYTHON_PILLOW_BUILD_OPTS += --disable-jpeg2000
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
PYTHON_PILLOW_DEPENDENCIES += tiff
PYTHON_PILLOW_BUILD_OPTS += --enable-tiff
else
PYTHON_PILLOW_BUILD_OPTS += --disable-tiff
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
PYTHON_PILLOW_DEPENDENCIES += webp
PYTHON_PILLOW_BUILD_OPTS += --enable-webp
else
PYTHON_PILLOW_BUILD_OPTS += --disable-webp
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
PYTHON_PILLOW_DEPENDENCIES += zlib
PYTHON_PILLOW_BUILD_OPTS += --enable-zlib
else
PYTHON_PILLOW_BUILD_OPTS += --disable-zlib
endif

define PYTHON_PILLOW_BUILD_CMDS
	cd $(PYTHON_PILLOW_BUILDDIR); \
		$(PYTHON_PILLOW_BASE_ENV) $(PYTHON_PILLOW_ENV) \
		$(PYTHON_PILLOW_PYTHON_INTERPRETER) setup.py build_ext \
		$(PYTHON_PILLOW_BASE_BUILD_OPTS) $(PYTHON_PILLOW_BUILD_OPTS)
endef

define PYTHON_PILLOW_INSTALL_TARGET_CMDS
	cd $(PYTHON_PILLOW_BUILDDIR); \
		$(PYTHON_PILLOW_BASE_ENV) $(PYTHON_PILLOW_ENV) \
		$(PYTHON_PILLOW_PYTHON_INTERPRETER) setup.py build_ext \
		$(PYTHON_PILLOW_BUILD_OPTS) install \
		$(PYTHON_PILLOW_BASE_INSTALL_TARGET_OPTS) \
		$(PYTHON_PILLOW_INSTALL_TARGET_OPTS)
endef

$(eval $(python-package))
