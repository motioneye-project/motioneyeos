################################################################################
#
# swig
#
################################################################################

SWIG_VERSION_MAJOR = 2.0
SWIG_VERSION = $(SWIG_VERSION_MAJOR).12
SWIG_SITE = http://downloads.sourceforge.net/project/swig/swig/swig-$(SWIG_VERSION)
SWIG_DEPENDENCIES = host-bison
HOST_SWIG_CONF_OPTS = \
	--without-pcre \
	--disable-ccache \
	--without-octave
SWIG_LICENSE = GPLv3+ BSD-2c BSD-3c
SWIG_LICENSE_FILES = LICENSE LICENSE-GPL LICENSE-UNIVERSITIES

# CMake looks first at swig2.0 and then swig. However, when doing the
# search, it will look into the PATH for swig2.0 first, and then for
# swig. While the PATH contains first our $(HOST_DIR)/usr/bin, it also
# contains /usr/bin and other system directories. Therefore, if there
# is an installed swig2.0 on the system, it will get the preference
# over the swig installed in $(HOST_DIR)/usr/bin, which isn't nice. To
# prevent this from happening we create a symbolic link swig2.0 ->
# swig, so that our swig always gets used.

define HOST_SWIG_INSTALL_SYMLINK
	ln -fs $(HOST_DIR)/usr/bin/swig $(HOST_DIR)/usr/bin/swig$(SWIG_VERSION_MAJOR)
endef

HOST_SWIG_POST_INSTALL_HOOKS += HOST_SWIG_INSTALL_SYMLINK

$(eval $(host-autotools-package))

SWIG = $(HOST_DIR)/usr/bin/swig$(SWIG_VERSION_MAJOR)
