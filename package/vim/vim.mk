################################################################################
#
# vim
#
################################################################################

VIM_VERSION = v8.0.0329
VIM_SITE = $(call github,vim,vim,$(VIM_VERSION))
# Win over busybox vi since vim is more feature-rich
VIM_DEPENDENCIES = \
	ncurses $(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_BUSYBOX),busybox)
VIM_SUBDIR = src
VIM_CONF_ENV = \
	vim_cv_toupper_broken=no \
	vim_cv_terminfo=yes \
	vim_cv_tty_group=world \
	vim_cv_tty_mode=0620 \
	vim_cv_getcwd_broken=no \
	vim_cv_stat_ignores_slash=yes \
	vim_cv_memmove_handles_overlap=yes \
	ac_cv_sizeof_int=4 \
	ac_cv_small_wchar_t=no
# GUI/X11 headers leak from the host so forcibly disable them
VIM_CONF_OPTS = --with-tlib=ncurses --enable-gui=no --without-x
VIM_LICENSE = Charityware
VIM_LICENSE_FILES = README.txt

ifeq ($(BR2_PACKAGE_ACL),y)
VIM_CONF_OPTS += --enable-acl
VIM_DEPENDENCIES += acl
else
VIM_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_GPM),y)
VIM_CONF_OPTS += --enable-gpm
VIM_DEPENDENCIES += gpm
else
VIM_CONF_OPTS += --disable-gpm
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
VIM_CONF_OPTS += --enable-selinux
VIM_DEPENDENCIES += libselinux
else
VIM_CONF_OPTS += --disable-selinux
endif

define VIM_INSTALL_TARGET_CMDS
	cd $(@D)/src; \
		$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) installvimbin; \
		$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) installtools; \
		$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) installlinks
endef

define VIM_INSTALL_RUNTIME_CMDS
	cd $(@D)/src; \
		$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) installrtbase; \
		$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) installmacros
endef

define VIM_REMOVE_DOCS
	$(RM) -rf $(TARGET_DIR)/usr/share/vim/vim*/doc/
endef

# Avoid oopses with vipw/vigr, lack of $EDITOR and 'vi' command expectation
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
define VIM_INSTALL_VI_SYMLINK
	ln -sf vim $(TARGET_DIR)/usr/bin/vi
endef
else
define VIM_INSTALL_VI_SYMLINK
	ln -sf ../usr/bin/vim $(TARGET_DIR)/bin/vi
endef
endif
VIM_POST_INSTALL_TARGET_HOOKS += VIM_INSTALL_VI_SYMLINK

ifeq ($(BR2_PACKAGE_VIM_RUNTIME),y)
VIM_POST_INSTALL_TARGET_HOOKS += VIM_INSTALL_RUNTIME_CMDS
VIM_POST_INSTALL_TARGET_HOOKS += VIM_REMOVE_DOCS
endif

HOST_VIM_DEPENDENCIES = host-ncurses

$(eval $(autotools-package))
$(eval $(host-autotools-package))
