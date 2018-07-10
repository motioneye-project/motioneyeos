################################################################################
#
# ncurses
#
################################################################################

NCURSES_VERSION = 6.0
NCURSES_SITE = $(BR2_GNU_MIRROR)/ncurses
NCURSES_INSTALL_STAGING = YES
NCURSES_DEPENDENCIES = host-ncurses
NCURSES_LICENSE = MIT with advertising clause
NCURSES_LICENSE_FILES = README
NCURSES_CONFIG_SCRIPTS = ncurses$(NCURSES_LIB_SUFFIX)6-config

NCURSES_CONF_OPTS = \
	--without-cxx \
	--without-cxx-binding \
	--without-ada \
	--without-tests \
	--disable-big-core \
	--without-profile \
	--disable-rpath \
	--disable-rpath-hack \
	--enable-echo \
	--enable-const \
	--enable-overwrite \
	--enable-pc-files \
	--with-pkg-config-libdir="/usr/lib/pkgconfig" \
	$(if $(BR2_PACKAGE_NCURSES_TARGET_PROGS),,--without-progs) \
	--without-manpages

ifeq ($(BR2_STATIC_LIBS),y)
NCURSES_CONF_OPTS += --without-shared --with-normal
else ifeq ($(BR2_SHARED_LIBS),y)
NCURSES_CONF_OPTS += --with-shared --without-normal
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
NCURSES_CONF_OPTS += --with-shared --with-normal
endif

# configure can't find the soname for libgpm when cross compiling
ifeq ($(BR2_PACKAGE_GPM),y)
NCURSES_CONF_OPTS += --with-gpm=libgpm.so.2
NCURSES_DEPENDENCIES += gpm
else
NCURSES_CONF_OPTS += --without-gpm
endif

NCURSES_TERMINFO_FILES = \
	a/ansi \
	d/dumb \
	l/linux \
	p/putty \
	p/putty-256color \
	p/putty-vt100 \
	s/screen \
	s/screen-256color \
	v/vt100 \
	v/vt100-putty \
	v/vt102 \
	v/vt200 \
	v/vt220 \
	x/xterm \
	x/xterm+256color \
	x/xterm-256color \
	x/xterm-color \
	x/xterm-xfree86

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
NCURSES_CONF_OPTS += --enable-widec
NCURSES_LIB_SUFFIX = w
NCURSES_LIBS = ncurses menu panel form

define NCURSES_LINK_LIBS_STATIC
	$(foreach lib,$(NCURSES_LIBS:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).a $(STAGING_DIR)/usr/lib/$(lib).a
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).a \
		$(STAGING_DIR)/usr/lib/libcurses.a
endef

define NCURSES_LINK_LIBS_SHARED
	$(foreach lib,$(NCURSES_LIBS:%=lib%), \
		ln -sf $(lib)$(NCURSES_LIB_SUFFIX).so $(STAGING_DIR)/usr/lib/$(lib).so
	)
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).so \
		$(STAGING_DIR)/usr/lib/libcurses.so
endef

define NCURSES_LINK_PC
	$(foreach pc,$(NCURSES_LIBS), \
		ln -sf $(pc)$(NCURSES_LIB_SUFFIX).pc \
			$(STAGING_DIR)/usr/lib/pkgconfig/$(pc).pc
	)
endef

NCURSES_LINK_STAGING_LIBS = \
	$(if $(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_STATIC);) \
	$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),$(call NCURSES_LINK_LIBS_SHARED))

NCURSES_LINK_STAGING_PC = $(call NCURSES_LINK_PC)

NCURSES_CONF_OPTS += --enable-ext-colors

NCURSES_POST_INSTALL_STAGING_HOOKS += NCURSES_LINK_STAGING_LIBS
NCURSES_POST_INSTALL_STAGING_HOOKS += NCURSES_LINK_STAGING_PC

endif # BR2_PACKAGE_NCURSES_WCHAR

ifneq ($(BR2_ENABLE_DEBUG),y)
NCURSES_CONF_OPTS += --without-debug
endif

# ncurses breaks with parallel build, but takes quite a while to
# build single threaded. Work around it similar to how Gentoo does
define NCURSES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) sources
	rm -rf $(@D)/misc/pc-files
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR)
endef

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_PROGS),y)
define NCURSES_TARGET_SYMLINK_RESET
	ln -sf tset $(TARGET_DIR)/usr/bin/reset
endef
NCURSES_POST_INSTALL_TARGET_HOOKS += NCURSES_TARGET_SYMLINK_RESET
endif

define NCURSES_TARGET_CLEANUP_TERMINFO
	$(RM) -rf $(TARGET_DIR)/usr/share/terminfo $(TARGET_DIR)/usr/share/tabset
	$(foreach t,$(NCURSES_TERMINFO_FILES), \
		$(INSTALL) -D -m 0644 $(STAGING_DIR)/usr/share/terminfo/$(t) \
			$(TARGET_DIR)/usr/share/terminfo/$(t)
	)
endef
NCURSES_POST_INSTALL_TARGET_HOOKS += NCURSES_TARGET_CLEANUP_TERMINFO

#
# On systems with an older version of tic, the installation of ncurses hangs
# forever. To resolve the problem, build a static version of tic on host
# ourselves, and use that during installation.
#
define HOST_NCURSES_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) sources
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/progs tic
endef

HOST_NCURSES_CONF_OPTS = \
	--with-shared \
	--without-gpm \
	--without-manpages \
	--without-cxx \
	--without-cxx-binding \
	--without-ada \
	--with-default-terminfo-dir=/usr/share/terminfo \
	--without-normal

$(eval $(autotools-package))
$(eval $(host-autotools-package))
