################################################################################
#
# dieharder
#
################################################################################

DIEHARDER_VERSION = 3.31.1
DIEHARDER_SITE = http://www.phy.duke.edu/~rgb/General/dieharder
DIEHARDER_SOURCE = dieharder-$(DIEHARDER_VERSION).tgz
DIEHARDER_STRIP_COMPONENTS = 2
DIEHARDER_LICENSE = GPL-2.0 with beverage clause
DIEHARDER_LICENSE_FILES = COPYING
DIEHARDER_DEPENDENCIES = gsl

# The original configure does not use variables provided in the
# environment so _CONF_ENV does not work. (_CONF_OPTS does).
#
# In addition, the m4/*.m4 files are symlinks to /usr/share, which
# clearly doesn't work, so doing an autoreconf replaces them.
#
# Finally, we patch configure.ac and some Makefile.am so we need to
# autoreconf anyway
DIEHARDER_AUTORECONF = YES

# fix endianness detection
ifeq ($(BR2_ENDIAN),"BIG")
DIEHARDER_CONF_ENV = ac_cv_c_endian=big
else
DIEHARDER_CONF_ENV = ac_cv_c_endian=little
endif

# parallel build fail, disable it
DIEHARDER_MAKE = $(MAKE1)

$(eval $(autotools-package))
