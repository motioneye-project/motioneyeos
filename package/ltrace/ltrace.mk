################################################################################
#
# ltrace
#
################################################################################

LTRACE_VERSION = 0.7.2
LTRACE_SITE = http://alioth.debian.org/frs/download.php/file/3848
LTRACE_SOURCE = ltrace-$(LTRACE_VERSION).tar.bz2
LTRACE_DEPENDENCIES = libelf
LTRACE_AUTORECONF = YES
LTRACE_CONF_OPT = --disable-werror
LTRACE_LICENSE = GPLv2
LTRACE_LICENSE_FILES = COPYING

$(eval $(autotools-package))
