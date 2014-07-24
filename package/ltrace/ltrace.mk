################################################################################
#
# ltrace
#
################################################################################

LTRACE_VERSION = 0896ce554f80afdcba81d9754f6104f863dea803
LTRACE_SITE = git://anonscm.debian.org/collab-maint/ltrace.git
LTRACE_DEPENDENCIES = libelf elfutils
LTRACE_CONF_OPT = --disable-werror
LTRACE_LICENSE = GPLv2
LTRACE_LICENSE_FILES = COPYING
LTRACE_AUTORECONF = YES

define LTRACE_CREATE_CONFIG_M4
	mkdir -p $(@D)/config/m4
endef
LTRACE_POST_PATCH_HOOKS += LTRACE_CREATE_CONFIG_M4

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
