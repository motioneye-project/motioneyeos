#############################################################
#
# qemu
#
#############################################################

QEMU_VERSION = 1.2.0
QEMU_SOURCE = qemu-$(QEMU_VERSION).tar.bz2
QEMU_SITE = http://wiki.qemu.org/download

QEMU_DEPENDENCIES = host-pkgconf zlib libglib2

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

QEMU_ARCH = $(ARCH)
ifeq ($(QEMU_ARCH),i486)
    QEMU_ARCH = i386
endif
ifeq ($(QEMU_ARCH),i586)
    QEMU_ARCH = i386
endif
ifeq ($(QEMU_ARCH),i686)
    QEMU_ARCH = i386
endif
ifeq ($(QEMU_ARCH),powerpc)
    QEMU_ARCH = ppc
endif
HOST_QEMU_TARGETS=$(QEMU_ARCH)-linux-user

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

define HOST_QEMU_BUILD_CMDS
	$(MAKE) -C $(@D) all
endef

define HOST_QEMU_INSTALL_CMDS
	$(MAKE) -C $(@D) install
endef

define HOST_QEMU_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(host-generic-package))

# variable used by other packages
QEMU_USER = $(HOST_DIR)/usr/bin/qemu-$(QEMU_ARCH)
