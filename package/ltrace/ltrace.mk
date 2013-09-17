################################################################################
#
# ltrace
#
################################################################################

LTRACE_VERSION = 0.7.3
LTRACE_SITE = http://alioth.debian.org/frs/download.php/file/3947
LTRACE_SOURCE = ltrace-$(LTRACE_VERSION).tar.bz2
LTRACE_DEPENDENCIES = libelf
LTRACE_CONF_OPT = --disable-werror
LTRACE_LICENSE = GPLv2
LTRACE_LICENSE_FILES = COPYING

# ltrace can use libunwind only if libc has backtrace() support
# We don't normally do so for uClibc and we can't know if it's external
ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),)
LTRACE_CONF_OPT += --with-libunwind=yes
LTRACE_DEPENDENCIES += libunwind
else
LTRACE_CONF_OPT += --with-libunwind=no
endif
endif

$(eval $(autotools-package))
