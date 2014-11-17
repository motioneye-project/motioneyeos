################################################################################
#
# qemu
#
################################################################################

QEMU_VERSION = 2.1.2
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
#       sh2a            not supported
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
HOST_QEMU_TARGETS = $(HOST_QEMU_ARCH)-linux-user

define HOST_QEMU_CONFIGURE_CMDS
	cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure    \
		--target-list="$(HOST_QEMU_TARGETS)"    \
		--prefix="$(HOST_DIR)/usr"              \
		--interp-prefix=$(STAGING_DIR)          \
		--cc="$(HOSTCC)"                        \
		--host-cc="$(HOSTCC)"                   \
		--extra-cflags="$(HOST_CFLAGS)"         \
		--extra-ldflags="$(HOST_LDFLAGS)"
endef

define HOST_QEMU_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_QEMU_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(host-generic-package))

# variable used by other packages
QEMU_USER = $(HOST_DIR)/usr/bin/qemu-$(HOST_QEMU_ARCH)

#-------------------------------------------------------------
# Target-qemu

QEMU_DEPENDENCIES = host-pkgconf host-python libglib2 zlib pixman

# Need the LIBS variable because librt and libm are
# not automatically pulled. :-(
QEMU_LIBS = -lrt -lm

QEMU_OPTS =

QEMU_VARS = \
	LIBTOOL=$(HOST_DIR)/usr/bin/libtool \
	PYTHON=$(HOST_DIR)/usr/bin/python2 \
	PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages

# If we want to specify only a subset of targets, we must still enable all
# of them, so that QEMU properly builds its list of default targets, from
# which it then checks if the specified sub-set is valid. That's what we
# do in the first part of the if-clause.
# Otherwise, if we do not want to pass a sub-set of targets, we then need
# to either enable or disable -user and/or -system emulation appropriately.
# That's what we do in the else-clause.
ifneq ($(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS)),)
QEMU_OPTS += --enable-system --enable-linux-user
QEMU_OPTS += --target-list="$(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS))"
else

ifeq ($(BR2_PACKAGE_QEMU_SYSTEM),y)
QEMU_OPTS += --enable-system
else
QEMU_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_QEMU_LINUX_USER),y)
QEMU_OPTS += --enable-linux-user
else
QEMU_OPTS += --disable-linux-user
endif

endif

ifeq ($(BR2_PACKAGE_QEMU_SDL),y)
QEMU_OPTS += --enable-sdl
QEMU_DEPENDENCIES += sdl
QEMU_VARS += SDL_CONFIG=$(BR2_STAGING_DIR)/usr/bin/sdl-config
else
QEMU_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_QEMU_FDT),y)
QEMU_OPTS += --enable-fdt
QEMU_DEPENDENCIES += dtc
else
QEMU_OPTS += --disable-fdt
endif

define QEMU_CONFIGURE_CMDS
	( cd $(@D);                                     \
		LIBS='$(QEMU_LIBS)'                     \
		$(TARGET_CONFIGURE_OPTS)                \
		$(TARGET_CONFIGURE_ARGS)                \
		$(QEMU_VARS)                            \
		./configure                             \
			--prefix=/usr                   \
			--cross-prefix=$(TARGET_CROSS)  \
			--with-system-pixman            \
			--audio-drv-list=               \
			--enable-kvm                    \
			--enable-attr                   \
			--enable-vhost-net              \
			--disable-bsd-user              \
			--disable-xen                   \
			--disable-slirp                 \
			--disable-vnc                   \
			--disable-virtfs                \
			--disable-brlapi                \
			--disable-curses                \
			--disable-curl                  \
			--disable-bluez                 \
			--disable-guest-base            \
			--disable-uuid                  \
			--disable-vde                   \
			--disable-linux-aio             \
			--disable-cap-ng                \
			--disable-docs                  \
			--disable-spice                 \
			--disable-rbd                   \
			--disable-libiscsi              \
			--disable-usb-redir             \
			--disable-smartcard-nss         \
			--disable-strip                 \
			--disable-seccomp               \
			--disable-sparse                \
			--disable-tools                 \
			$(QEMU_OPTS)                    \
	)
endef

define QEMU_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(QEMU_MAKE_ENV) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
