################################################################################
#
# qemu
#
################################################################################

QEMU_VERSION = 1.3.1
QEMU_SOURCE = qemu-$(QEMU_VERSION).tar.bz2
QEMU_SITE = http://wiki.qemu.org/download
QEMU_LICENSE = GPLv2 LGPLv2.1 MIT BSD-3c BSD-2c Others/BSD-1c
QEMU_LICENSE_FILES = COPYING COPYING.LIB
# NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.

#-------------------------------------------------------------
# Host-qemu

HOST_QEMU_DEPENDENCIES = host-pkgconf host-zlib host-libglib2 host-pixman

#       BR ARCH         qemu
#       -------         ----
#       arm             arm
#       armeb           armeb
#       avr32           not supported
#       bfin            not supported
#       i386            i386
#       i486            i386
#       i586            i386
#       i686            i386
#       x86_64          x86_64
#       m68k            m68k
#       microblaze      microblaze
#       mips            mips
#       mipsel          mipsel
#       mips64          ?
#       mips64el        ?
#       powerpc         ppc
#       sh2             not supported
#       sh2a            not supported
#       sh3             not supported
#       sh3eb           not supported
#       sh4             sh4
#       sh4eb           sh4eb
#       sh4a            ?
#       sh4aeb          ?
#       sh64            not supported
#       sparc           sparc

HOST_QEMU_ARCH = $(ARCH)
ifeq ($(HOST_QEMU_ARCH),i486)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i586)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i686)
    HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),powerpc)
    HOST_QEMU_ARCH = ppc
endif
HOST_QEMU_TARGETS=$(HOST_QEMU_ARCH)-linux-user

# Note: although QEMU has a ./configure script, it is not a real autotools
# package, and ./configure chokes on options such as --host or --target.
# So, provide out own _CONFIGURE_CMDS to override the defaults.
define HOST_QEMU_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure   \
		--target-list="$(HOST_QEMU_TARGETS)"    \
		--prefix="$(HOST_DIR)/usr"              \
		--interp-prefix=$(STAGING_DIR)          \
		--cc="$(HOSTCC)"                        \
		--host-cc="$(HOSTCC)"                   \
		--extra-cflags="$(HOST_CFLAGS)"         \
		--extra-ldflags="$(HOST_LDFLAGS)"       \
	)
endef

$(eval $(host-autotools-package))

# variable used by other packages
QEMU_USER = $(HOST_DIR)/usr/bin/qemu-$(HOST_QEMU_ARCH)
