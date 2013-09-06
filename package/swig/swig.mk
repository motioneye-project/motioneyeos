################################################################################
#
# swig
#
################################################################################

SWIG_VERSION = 2.0.10
SWIG_SITE = http://downloads.sourceforge.net/project/swig/swig/swig-$(SWIG_VERSION)
SWIG_DEPENDENCIES = host-bison
HOST_SWIG_CONF_OPT = --without-pcre --disable-ccache
SWIG_LICENSE = GPLv3+ BSD-2c BSD-3c
SWIG_LICENSE_FILES = LICENSE LICENSE-GPL LICENSE-UNIVERSITIES

$(eval $(host-autotools-package))
