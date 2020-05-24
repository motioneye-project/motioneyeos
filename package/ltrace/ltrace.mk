################################################################################
#
# ltrace
#
################################################################################

LTRACE_VERSION = c22d359433b333937ee3d803450dc41998115685
#LTRACE_SITE = git://anonscm.debian.org/collab-maint/ltrace.git

# Upstream is dead: the git reporistory for ltrace did not follow during the
# migration from alioth to gitlab, and there is no longer any official
# upstream repository with the expected sha1, except for the tarball cached on
# s.b.o., so we go fetch it there.
LTRACE_SITE = http://sources.buildroot.org/ltrace

LTRACE_DEPENDENCIES = elfutils
LTRACE_CONF_OPTS = --disable-werror
LTRACE_LICENSE = GPL-2.0
LTRACE_LICENSE_FILES = COPYING
LTRACE_AUTORECONF = YES

# ltrace can use libunwind only if libc has backtrace() support
# We don't normally do so for uClibc and we can't know if it's external
# Also ltrace with libunwind support is broken for MIPS so we disable it
ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC)$(BR2_mips)$(BR2_mipsel),)
# --with-elfutils only selects unwinding support backend. elfutils is a
# mandatory dependency regardless.
LTRACE_CONF_OPTS += --with-libunwind=yes --with-elfutils=no
LTRACE_DEPENDENCIES += libunwind
else
LTRACE_CONF_OPTS += --with-libunwind=no
endif
endif

$(eval $(autotools-package))
