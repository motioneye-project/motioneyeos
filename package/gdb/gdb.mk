################################################################################
#
# gdb
#
################################################################################

GDB_VERSION = $(call qstrip,$(BR2_GDB_VERSION))
GDB_SITE    = $(BR2_GNU_MIRROR)/gdb

ifeq ($(BR2_arc),y)
GDB_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,gdb,$(GDB_VERSION))
GDB_SOURCE = gdb-$(GDB_VERSION).tar.gz
GDB_FROM_GIT = y
endif

ifeq ($(BR2_microblaze),y)
GDB_SITE = $(call github,Xilinx,gdb,$(GDB_VERSION))
GDB_SOURCE = gdb-$(GDB_VERSION).tar.gz
GDB_FROM_GIT = y
endif

ifeq ($(GDB_VERSION),6.7.1-avr32-2.1.5)
GDB_SITE = ftp://www.at91.com/pub/buildroot/
endif

GDB_SOURCE ?= gdb-$(GDB_VERSION).tar.bz2
GDB_LICENSE = GPLv2+ LGPLv2+ GPLv3+ LGPLv3+
GDB_LICENSE_FILES = COPYING COPYING.LIB COPYING3 COPYING3.LIB

# We only want gdbserver and not the entire debugger.
ifeq ($(BR2_PACKAGE_GDB_DEBUGGER),)
GDB_SUBDIR = gdb/gdbserver
HOST_GDB_SUBDIR = .
else
GDB_DEPENDENCIES = ncurses
endif

# For the host variant, we really want to build with XML support,
# which is needed to read XML descriptions of target architectures.
HOST_GDB_DEPENDENCIES = host-expat

# Apply the Xtensa specific patches
XTENSA_CORE_NAME = $(call qstrip, $(BR2_XTENSA_CORE_NAME))
ifneq ($(XTENSA_CORE_NAME),)
define GDB_XTENSA_PRE_PATCH
	tar xf $(BR2_XTENSA_OVERLAY_DIR)/xtensa_$(XTENSA_CORE_NAME).tar \
		-C $(@D) --strip-components=1 gdb
endef
GDB_PRE_PATCH_HOOKS += GDB_XTENSA_PRE_PATCH
HOST_GDB_PRE_PATCH_HOOKS += GDB_XTENSA_PRE_PATCH
endif

GDB_CONF_ENV = \
	ac_cv_prog_MAKEINFO=missing \
	ac_cv_type_uintptr_t=yes \
	gt_cv_func_gettext_libintl=yes \
	ac_cv_func_dcgettext=yes \
	gdb_cv_func_sigsetjmp=yes \
	bash_cv_func_strcoll_broken=no \
	bash_cv_must_reinstall_sighandlers=no \
	bash_cv_func_sigsetjmp=present \
	bash_cv_have_mbstate_t=yes \
	gdb_cv_func_sigsetjmp=yes

GDB_CONF_OPT = \
	--without-uiout \
	--disable-tui \
	--disable-gdbtk \
	--without-x \
	--disable-sim \
	$(if $(BR2_PACKAGE_GDB_SERVER),--enable-gdbserver) \
	--with-curses \
	--without-included-gettext \
	--disable-werror

# This removes some unneeded Python scripts and XML target description
# files that are not useful for a normal usage of the debugger.
define GDB_REMOVE_UNNEEDED_FILES
	$(RM) -rf $(TARGET_DIR)/usr/share/gdb
endef

GDB_POST_INSTALL_TARGET_HOOKS += GDB_REMOVE_UNNEEDED_FILES

# This installs the gdbserver somewhere into the $(HOST_DIR) so that
# it becomes an integral part of the SDK, if the toolchain generated
# by Buildroot is later used as an external toolchain. We install it
# in debug-root/usr/bin/gdbserver so that it matches what Crosstool-NG
# does.
define GDB_SDK_INSTALL_GDBSERVER
	$(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/bin/gdbserver \
		$(HOST_DIR)/usr/$(GNU_TARGET_NAME)/debug-root/usr/bin/gdbserver
endef

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
GDB_POST_INSTALL_TARGET_HOOKS += GDB_SDK_INSTALL_GDBSERVER
endif

# A few notes:
#  * --target, because we're doing a cross build rather than a real
#    host build.
#  * --enable-static because gdb really wants to use libbfd.a
#  * --disable-shared, otherwise the old 6.7 version specific to AVR32
#    doesn't build because it wants to link a shared libbfd.so against
#    non-PIC liberty.a.
HOST_GDB_CONF_OPT = \
	--target=$(GNU_TARGET_NAME) \
	--enable-static --disable-shared \
	--without-uiout \
	--disable-tui \
	--disable-gdbtk \
	--without-x \
	--enable-threads \
	--disable-werror \
	--without-included-gettext \
	--disable-sim

ifeq ($(GDB_FROM_GIT),y)
HOST_GDB_DEPENDENCIES += host-texinfo
endif

# legacy $arch-linux-gdb symlink
define HOST_GDB_ADD_SYMLINK
	cd $(HOST_DIR)/usr/bin && \
		ln -snf $(GNU_TARGET_NAME)-gdb $(ARCH)-linux-gdb
endef

HOST_GDB_POST_INSTALL_HOOKS += HOST_GDB_ADD_SYMLINK

$(eval $(autotools-package))
$(eval $(host-autotools-package))
