################################################################################
#
# flex
#
################################################################################

FLEX_VERSION = 2.6.4
FLEX_SITE = https://github.com/westes/flex/files/981163
FLEX_INSTALL_STAGING = YES
FLEX_LICENSE = FLEX
FLEX_LICENSE_FILES = COPYING
FLEX_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) host-m4
HOST_FLEX_DEPENDENCIES = host-m4

# 0001-build-AC_USE_SYSTEM_EXTENSIONS-in-configure.ac.patch
# 0002-build-make-it-possible-to-disable-the-build-of-the-f.patch
# 0003-build-make-it-possible-to-disable-the-build-of-the-d.patch
FLEX_AUTORECONF = YES
FLEX_GETTEXTIZE = YES
FLEX_CONF_ENV = ac_cv_path_M4=/usr/bin/m4 \
	ac_cv_func_reallocarray=no

# Don't enable programs, they are not needed on the target, and
# require MMU support.
# Don't enable the doc, it's not needed on the target and requires
# special tools (help2man) to build.
FLEX_CONF_OPTS += --disable-program --disable-doc
HOST_FLEX_CONF_OPTS = --disable-doc

$(eval $(autotools-package))
$(eval $(host-autotools-package))
