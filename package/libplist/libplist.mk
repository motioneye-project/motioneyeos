################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 1.6
LIBPLIST_SITE = http://cgit.sukimashita.com/libplist.git/snapshot
LIBPLIST_DEPENDENCIES = libxml2
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_MAKE = $(MAKE1)
LIBPLIST_LICENSE = LGPLv2.1+
LIBPLIST_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
LIBPLIST_DEPENDENCIES += \
	python$(if $(BR2_PACKAGE_PYTHON3),3) \
	host-swig
LIBPLIST_CONF_OPTS += \
	-DENABLE_PYTHON=ON \
	-DSWIG_EXECUTABLE=$(SWIG)
else
LIBPLIST_CONF_OPTS += \
	-DENABLE_PYTHON=OFF \
	-DSWIG_EXECUTABLE=SWIG_EXECUTABLE-NOTFOUND
endif

$(eval $(cmake-package))
