################################################################################
#
# setools
#
################################################################################

SETOOLS_VERSION = 3.3.8
SETOOLS_SOURCE = setools-$(SETOOLS_VERSION).tar.bz2
SETOOLS_SITE = https://raw.githubusercontent.com/wiki/TresysTechnology/setools3/files/dists/setools-$(SETOOLS_VERSION)
SETOOLS_DEPENDENCIES = libselinux libsepol sqlite libxml2 bzip2 host-bison host-flex
SETOOLS_INSTALL_STAGING = YES
SETOOLS_LICENSE = GPLv2+, LGPLv2.1+
SETOOLS_LICENSE_FILES = COPYING COPYING.GPL COPYING.LGPL

# configure.ac is patched by the cross compile patch,
# so autoreconf is necessary
SETOOLS_AUTORECONF = YES

# Notes: Need "disable-selinux-check" so the configure does not check to see
#        if host has selinux enabled.
#        No python support as only the libraries and commandline tools are
#        installed on target
SETOOLS_CONF_OPTS = \
	--disable-debug \
	--disable-gui \
	--disable-bwidget-check \
	--disable-selinux-check \
	--disable-swig-java \
	--disable-swig-python \
	--disable-swig-tcl \
	--with-sepol-devel="$(STAGING_DIR)/usr" \
	--with-selinux-devel="$(STAGING_DIR)/usr"

ifeq ($(BR2_sparc64):$(BR2_STATIC_LIBS),y:)
SETOOLS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -fPIC"
endif

HOST_SETOOLS_DEPENDENCIES = host-libselinux host-libsepol host-sqlite \
	host-libxml2 host-bzip2 host-bison

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_SETOOLS_PYTHON_VERSION=$(PYTHON3_VERSION_MAJOR)
HOST_SETOOLS_DEPENDENCIES += host-python3
HOST_SETOOLS_CONF_ENV += am_cv_python_version=$(PYTHON3_VERSION)
else
HOST_SETOOLS_PYTHON_VERSION=$(PYTHON_VERSION_MAJOR)
HOST_SETOOLS_DEPENDENCIES += host-python
HOST_SETOOLS_CONF_ENV += am_cv_python_version=$(PYTHON_VERSION)
endif

HOST_SETOOLS_PYTHON_SITE_PACKAGES = $(HOST_DIR)/usr/lib/python$(HOST_SETOOLS_PYTHON_VERSION)/site-packages
HOST_SETOOLS_PYTHON_INCLUDES = $(HOST_DIR)/usr/include/python$(HOST_SETOOLS_PYTHON_VERSION)
HOST_SETOOLS_PYTHON_LIB = -lpython$(HOST_SETOOLS_PYTHON_VERSION)

# Notes: Need "disable-selinux-check" so the configure does not check to see
#        if host has selinux enabled.
#        Host builds with python support to enable tools for offline target
#        policy analysis
HOST_SETOOLS_CONF_OPTS = \
	--disable-debug \
	--disable-gui \
	--disable-bwidget-check \
	--disable-selinux-check \
	--disable-swig-java \
	--disable-swig-python \
	--disable-swig-tcl \
	--with-sepol-devel="$(HOST_DIR)/usr" \
	--with-selinux-devel="$(HOST_DIR)/usr" \
	PYTHON_LDFLAGS="-L$(HOST_DIR)/usr/lib/" \
	PYTHON_CPPFLAGS="-I$(HOST_SETOOLS_PYTHON_INCLUDES)" \
	PYTHON_SITE_PKG="$(HOST_SETOOLS_PYTHON_SITE_PACKAGES)" \
	PYTHON_EXTRA_LIBS="-lpthread -ldl -lutil $(HOST_SETOOLS_PYTHON_LIB)"

HOST_SETOOLS_CONF_ENV += \
	am_cv_pathless_PYTHON=python \
	ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python \
	am_cv_python_platform=linux2 \
	am_cv_python_version=$(HOST_SETOOLS_PYTHON_VERSION) \
	am_cv_python_pythondir=$(HOST_SETOOLS_PYTHON_SITE_PACKAGES) \
	am_cv_python_pyexecdir=$(HOST_SETOOLS_PYTHON_SITE_PACKAGES) \
	am_cv_python_includes=-I$(HOST_SETOOLS_PYTHON_INCLUDES)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
