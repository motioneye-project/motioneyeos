################################################################################
#
# ncurses
#
################################################################################

NCURSES_VERSION = 5.9
NCURSES_SITE = $(BR2_GNU_MIRROR)/ncurses
NCURSES_INSTALL_STAGING = YES
NCURSES_DEPENDENCIES = host-ncurses
HOST_NCURSES_DEPENDENCIES =
NCURSES_PROGS = clear infocmp tabs tic toe tput tset
NCURSES_LICENSE = MIT with advertising clause
NCURSES_LICENSE_FILES = README
NCURSES_CONFIG_SCRIPTS = ncurses$(NCURSES_LIB_SUFFIX)5-config

NCURSES_CONF_OPTS = \
	$(if $(BR2_PREFER_STATIC_LIB),--without-shared,--with-shared) \
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
	$(if $(BR2_PACKAGE_NCURSES_TARGET_PROGS),,--without-progs) \
	--without-manpages

# Install after busybox for the full-blown versions
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	NCURSES_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
NCURSES_CONF_OPTS += --enable-widec
NCURSES_LIB_SUFFIX = w

ifeq ($(BR2_PREFER_STATIC_LIB),y)
define NCURSES_LINK_LIBS
	for lib in $(NCURSES_LIBS-y); do \
		ln -sf $${lib}$(NCURSES_LIB_SUFFIX).a \
			$(1)/usr/lib/$${lib}.a; \
	done
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).a \
		$(1)/usr/lib/libcurses.a
endef
else
define NCURSES_LINK_LIBS
	for lib in $(NCURSES_LIBS-y); do \
		ln -sf $${lib}$(NCURSES_LIB_SUFFIX).a \
			$(1)/usr/lib/$${lib}.a; \
		ln -sf $${lib}$(NCURSES_LIB_SUFFIX).so \
			$(1)/usr/lib/$${lib}.so; \
	done
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).a \
		$(1)/usr/lib/libcurses.a
	ln -sf libncurses$(NCURSES_LIB_SUFFIX).so \
		$(1)/usr/lib/libcurses.so
endef
endif

NCURSES_LINK_TARGET_LIBS = $(call NCURSES_LINK_LIBS, $(TARGET_DIR))
NCURSES_LINK_STAGING_LIBS = $(call NCURSES_LINK_LIBS, $(STAGING_DIR))

NCURSES_POST_INSTALL_STAGING_HOOKS += NCURSES_LINK_STAGING_LIBS

endif

NCURSES_LIBS-y = libncurses
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_MENU) += libmenu
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_PANEL) += libpanel
NCURSES_LIBS-$(BR2_PACKAGE_NCURSES_TARGET_FORM) += libform

ifneq ($(BR2_ENABLE_DEBUG),y)
NCURSES_CONF_OPTS += --without-debug
endif

# ncurses breaks with parallel build, but takes quite a while to
# build single threaded. Work around it similar to how Gentoo does
define NCURSES_BUILD_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) sources
	rm -rf $(@D)/misc/pc-files
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR)
endef

ifneq ($(BR2_PREFER_STATIC_LIB),y)
define NCURSES_INSTALL_TARGET_LIBS
	for lib in $(NCURSES_LIBS-y); do \
		cp -dpf $(NCURSES_DIR)/lib/$${lib}$(NCURSES_LIB_SUFFIX).so* \
			$(TARGET_DIR)/usr/lib/; \
	done
endef
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_PROGS),y)
define NCURSES_INSTALL_TARGET_PROGS
	for x in $(NCURSES_PROGS); do \
		$(INSTALL) -m 0755 $(NCURSES_DIR)/progs/$$x \
			$(TARGET_DIR)/usr/bin/$$x; \
	done
	ln -sf tset $(TARGET_DIR)/usr/bin/reset
endef
endif

define NCURSES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	$(NCURSES_INSTALL_TARGET_LIBS)
	$(NCURSES_LINK_TARGET_LIBS)
	$(NCURSES_INSTALL_TARGET_PROGS)
	ln -snf /usr/share/terminfo $(TARGET_DIR)/usr/lib/terminfo
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-color $(TARGET_DIR)/usr/share/terminfo/x
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/x/xterm-xfree86 $(TARGET_DIR)/usr/share/terminfo/x
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt100 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt102 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt200 $(TARGET_DIR)/usr/share/terminfo/v
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/v/vt220 $(TARGET_DIR)/usr/share/terminfo/v
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/a
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/a/ansi $(TARGET_DIR)/usr/share/terminfo/a
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/l
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/l/linux $(TARGET_DIR)/usr/share/terminfo/l
	mkdir -p $(TARGET_DIR)/usr/share/terminfo/s
	cp -dpf $(STAGING_DIR)/usr/share/terminfo/s/screen $(TARGET_DIR)/usr/share/terminfo/s
endef # NCURSES_INSTALL_TARGET_CMDS

#
# On systems with an older version of tic, the installation of ncurses hangs
# forever. To resolve the problem, build a static version of tic on host
# ourselves, and use that during installation.
#
define HOST_NCURSES_BUILD_CMDS
	$(MAKE1) -C $(@D) sources
	$(MAKE) -C $(@D)/progs tic
endef

HOST_NCURSES_CONF_OPTS = \
	--with-shared --without-gpm \
	--without-manpages \
	--without-cxx \
	--without-cxx-binding \
	--without-ada

$(eval $(autotools-package))
$(eval $(host-autotools-package))
