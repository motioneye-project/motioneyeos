################################################################################
#
# gdb
#
################################################################################

GDB_VERSION = $(call qstrip,$(BR2_GDB_VERSION))
GDB_SITE = $(BR2_GNU_MIRROR)/gdb
GDB_SOURCE = gdb-$(GDB_VERSION).tar.xz

ifeq ($(BR2_arc),y)
GDB_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,binutils-gdb,$(GDB_VERSION))
GDB_SOURCE = gdb-$(GDB_VERSION).tar.gz
GDB_FROM_GIT = y
endif

ifeq ($(BR2_microblaze),y)
GDB_SITE = $(call github,Xilinx,gdb,$(GDB_VERSION))
GDB_SOURCE = gdb-$(GDB_VERSION).tar.gz
GDB_FROM_GIT = y
endif

GDB_LICENSE = GPL-2.0+, LGPL-2.0+, GPL-3.0+, LGPL-3.0+
GDB_LICENSE_FILES = COPYING COPYING.LIB COPYING3 COPYING3.LIB

# We only want gdbserver and not the entire debugger.
ifeq ($(BR2_PACKAGE_GDB_DEBUGGER),)
GDB_SUBDIR = gdb/gdbserver
HOST_GDB_SUBDIR = .
else
GDB_DEPENDENCIES = ncurses \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
endif

# For the host variant, we really want to build with XML support,
# which is needed to read XML descriptions of target architectures. We
# also need ncurses.
HOST_GDB_DEPENDENCIES = host-expat host-ncurses

# Disable building documentation
GDB_MAKE_OPTS += MAKEINFO=true
GDB_INSTALL_TARGET_OPTS += MAKEINFO=true DESTDIR=$(TARGET_DIR) install
HOST_GDB_MAKE_OPTS += MAKEINFO=true
HOST_GDB_INSTALL_OPTS += MAKEINFO=true install

# Apply the Xtensa specific patches
ifneq ($(ARCH_XTENSA_OVERLAY_FILE),)
define GDB_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),gdb)
endef
GDB_POST_EXTRACT_HOOKS += GDB_XTENSA_OVERLAY_EXTRACT
GDB_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
HOST_GDB_POST_EXTRACT_HOOKS += GDB_XTENSA_OVERLAY_EXTRACT
HOST_GDB_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
endif

ifeq ($(GDB_FROM_GIT),y)
GDB_DEPENDENCIES += host-flex host-bison
HOST_GDB_DEPENDENCIES += host-flex host-bison
endif

# When gdb sources are fetched from the binutils-gdb repository, they
# also contain the binutils sources, but binutils shouldn't be built,
# so we disable it.
GDB_DISABLE_BINUTILS_CONF_OPTS = \
	--disable-binutils \
	--disable-ld \
	--disable-gas

GDB_CONF_ENV = \
	ac_cv_type_uintptr_t=yes \
	gt_cv_func_gettext_libintl=yes \
	ac_cv_func_dcgettext=yes \
	gdb_cv_func_sigsetjmp=yes \
	bash_cv_func_strcoll_broken=no \
	bash_cv_must_reinstall_sighandlers=no \
	bash_cv_func_sigsetjmp=present \
	bash_cv_have_mbstate_t=yes \
	gdb_cv_func_sigsetjmp=yes

# Starting with gdb 7.11, the bundled gnulib tries to use
# rpl_gettimeofday (gettimeofday replacement) due to the code being
# unable to determine if the replacement function should be used or
# not when cross-compiling with uClibc or musl as C libraries. So use
# gl_cv_func_gettimeofday_clobber=no to not use rpl_gettimeofday,
# assuming musl and uClibc have a properly working gettimeofday
# implementation. It needs to be passed to GDB_CONF_ENV to build
# gdbserver only but also to GDB_MAKE_ENV, because otherwise it does
# not get passed to the configure script of nested packages while
# building gdbserver with full debugger.
GDB_CONF_ENV += gl_cv_func_gettimeofday_clobber=no
GDB_MAKE_ENV += gl_cv_func_gettimeofday_clobber=no

# Starting with glibc 2.25, the proc_service.h header has been copied
# from gdb to glibc so other tools can use it. However, that makes it
# necessary to make sure that declaration of prfpregset_t declaration
# is consistent between gdb and glibc. In gdb, however, there is a
# workaround for a broken prfpregset_t declaration in glibc 2.3 which
# uses AC_TRY_RUN to detect if it's needed, which doesn't work in
# cross-compilation. So pass the cache option to configure.
# It needs to be passed to GDB_CONF_ENV to build gdbserver only but
# also to GDB_MAKE_ENV, because otherwise it does not get passed to the
# configure script of nested packages while building gdbserver with full
# debugger.
GDB_CONF_ENV += gdb_cv_prfpregset_t_broken=no
GDB_MAKE_ENV += gdb_cv_prfpregset_t_broken=no

# The shared only build is not supported by gdb, so enable static build for
# build-in libraries with --enable-static.
GDB_CONF_OPTS = \
	--without-uiout \
	--disable-gdbtk \
	--without-x \
	--disable-sim \
	$(GDB_DISABLE_BINUTILS_CONF_OPTS) \
	$(if $(BR2_PACKAGE_GDB_SERVER),--enable-gdbserver) \
	--with-curses \
	--without-included-gettext \
	--disable-werror \
	--enable-static

# When gdb is built as C++ application for ARC it segfaults at runtime
# So we pass --disable-build-with-cxx config option to force gdb not to
# be built as C++ app.
ifeq ($(BR2_arc),y)
GDB_CONF_OPTS += --disable-build-with-cxx
endif

# gdb 7.12+ by default builds with a C++ compiler, which doesn't work
# when we don't have C++ support in the toolchain
ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
GDB_CONF_OPTS += --disable-build-with-cxx
endif

ifeq ($(BR2_PACKAGE_GDB_TUI),y)
GDB_CONF_OPTS += --enable-tui
else
GDB_CONF_OPTS += --disable-tui
endif

ifeq ($(BR2_PACKAGE_GDB_PYTHON),y)
GDB_CONF_OPTS += --with-python=$(TOPDIR)/package/gdb/gdb-python-config
GDB_DEPENDENCIES += python
else
GDB_CONF_OPTS += --without-python
endif

ifeq ($(BR2_PACKAGE_EXPAT),y)
GDB_CONF_OPTS += --with-expat
GDB_CONF_OPTS += --with-libexpat-prefix=$(STAGING_DIR)/usr
GDB_DEPENDENCIES += expat
else
GDB_CONF_OPTS += --without-expat
endif

ifeq ($(BR2_PACKAGE_XZ),y)
GDB_CONF_OPTS += --with-lzma
GDB_CONF_OPTS += --with-liblzma-prefix=$(STAGING_DIR)/usr
GDB_DEPENDENCIES += xz
else
GDB_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GDB_CONF_OPTS += --with-zlib
GDB_DEPENDENCIES += zlib
else
GDB_CONF_OPTS += --without-zlib
endif

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
		$(HOST_DIR)/$(GNU_TARGET_NAME)/debug-root/usr/bin/gdbserver
endef

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
GDB_POST_INSTALL_TARGET_HOOKS += GDB_SDK_INSTALL_GDBSERVER
endif

# A few notes:
#  * --target, because we're doing a cross build rather than a real
#    host build.
#  * --enable-static because gdb really wants to use libbfd.a
HOST_GDB_CONF_OPTS = \
	--target=$(GNU_TARGET_NAME) \
	--enable-static \
	--without-uiout \
	--disable-gdbtk \
	--without-x \
	--enable-threads \
	--disable-werror \
	--without-included-gettext \
	$(GDB_DISABLE_BINUTILS_CONF_OPTS)

ifeq ($(BR2_PACKAGE_HOST_GDB_TUI),y)
HOST_GDB_CONF_OPTS += --enable-tui
else
HOST_GDB_CONF_OPTS += --disable-tui
endif

ifeq ($(BR2_PACKAGE_HOST_GDB_PYTHON),y)
HOST_GDB_CONF_OPTS += --with-python=$(HOST_DIR)/bin/python2
HOST_GDB_DEPENDENCIES += host-python
else
HOST_GDB_CONF_OPTS += --without-python
endif

# workaround a bug if in-tree build is used for bfin sim
define HOST_GDB_BFIN_SIM_WORKAROUND
	$(RM) $(@D)/sim/common/tconfig.h
endef

ifeq ($(BR2_PACKAGE_HOST_GDB_SIM),y)
HOST_GDB_CONF_OPTS += --enable-sim
ifeq ($(BR2_bfin),y)
HOST_GDB_PRE_CONFIGURE_HOOKS += HOST_GDB_BFIN_SIM_WORKAROUND
endif
else
HOST_GDB_CONF_OPTS += --disable-sim
endif

# legacy $arch-linux-gdb symlink
define HOST_GDB_ADD_SYMLINK
	cd $(HOST_DIR)/bin && \
		ln -snf $(GNU_TARGET_NAME)-gdb $(ARCH)-linux-gdb
endef

HOST_GDB_POST_INSTALL_HOOKS += HOST_GDB_ADD_SYMLINK

HOST_GDB_POST_INSTALL_HOOKS += gen_gdbinit_file

$(eval $(autotools-package))
$(eval $(host-autotools-package))
