#############################################################
#
# vim
#
#############################################################

# svn r1889 == 7.2 release + patchlevel 446
VIM_SITE = https://vim.svn.sourceforge.net/svnroot/vim/branches/vim7.2
VIM_SITE_METHOD = svn
VIM_VERSION = 1889
VIM_DEPENDENCIES = ncurses
VIM_SUBDIR = src
VIM_CONF_ENV = vim_cv_toupper_broken=no \
		vim_cv_terminfo=yes \
		vim_cv_tty_group=world \
		vim_cv_tty_mode=0620 \
		vim_cv_getcwd_broken=no \
		vim_cv_stat_ignores_slash=yes \
		vim_cv_memmove_handles_overlap=yes \
		ac_cv_sizeof_int=4 \
		ac_cv_small_wchar_t=no

VIM_CONF_OPT = --with-tlib=ncurses

define VIM_INSTALL_TARGET_CMDS
	cd $(@D)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installvimbin; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installlinks
endef

define VIM_INSTALL_RUNTIME_CMDS
	cd $(@D)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installrtbase; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installmacros
endef

ifeq ($(BR2_PACKAGE_VIM_RUNTIME),y)
VIM_POST_INSTALL_TARGET_HOOKS += VIM_INSTALL_RUNTIME_CMDS
endif

$(eval $(call AUTOTARGETS,package,vim))
