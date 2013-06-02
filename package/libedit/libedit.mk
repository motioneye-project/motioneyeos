#############################################################
#
# libedit
#
#############################################################

# Note: libedit does not have a regular homepage, and it seems
# there is no place where to download a tarball from. That's
# why we use the Debian way-back machine.
LIBEDIT_VERSION_MAJOR   = 2
LIBEDIT_VERSION_MINOR   = 11
LIBEDIT_VERSION_EXTRA   = -20080614
LIBEDIT_VERSION         = $(LIBEDIT_VERSION_MAJOR).$(LIBEDIT_VERSION_MINOR)
LIBEDIT_SOURCE          = libedit_$(LIBEDIT_VERSION)$(LIBEDIT_VERSION_EXTRA).orig.tar.bz2
LIBEDIT_SITE            = http://snapshot.debian.org/archive/debian/20120601T033558Z/pool/main/libe/libedit
LIBEDIT_SUBDIR          = libedit
LIBEDIT_PATCH           = libedit_2.11-20080614-5.debian.tar.bz2
LIBEDIT_INSTALL_STAGING = YES
LIBEDIT_DEPENDENCIES    = host-pmake libbsd ncurses

define LIBEDIT_POST_PATCH_PERMISSIONS
	chmod +x $(@D)/libedit/makelist
endef

LIBEDIT_POST_PATCH_HOOKS += LIBEDIT_POST_PATCH_PERMISSIONS

define LIBEDIT_FIX_VIS_H_INCLUDE
	$(SED) 's,^#include <vis\.h>$$,#include <bsd/vis\.h>,;' \
	       $(@D)/libedit/filecomplete.c                     \
	       $(@D)/libedit/history.c                          \
	       $(@D)/libedit/readline.c
endef
LIBEDIT_POST_PATCH_HOOKS += LIBEDIT_FIX_VIS_H_INCLUDE

LIBEDIT_PMAKE_OPTS = MKPROFILE=no MKCATPAGES=no MLINKS= MANPAGES= NOGCCERROR=1         \
                      SHLIB_SHFLAGS="-Wl,-soname,libedit.so.${LIBEDIT_VERSION_MAJOR}"  \

define LIBEDIT_BUILD_CMDS
	cd $(@D)/$(LIBEDIT_SUBDIR); \
	$(TARGET_CONFIGURE_OPTS) LDADD="-lbsd -lcurses" pmake $(LIBEDIT_PMAKE_OPTS)
endef

LIBEDIT_MAN_LINKS = el_init el_end el_reset el_gets el_getc el_push el_parse   \
                     el_set el_get el_source el_resize el_line el_insertstr     \
                     el_deletestr history_init history_end history

# $1: DESTDIR to install into
# Can't use pmake to install, it wants to be root. sigh... :-(
# We need to create the .so links, otherwise we can't link; and waiting for
# ldconfig is too late as it's done just before building the images.
define LIBEDIT_INSTALL_CMDS
	$(INSTALL) -D -m 0644 package/libedit/libedit.pc $(1)/usr/lib/pkgconfig/libedit.pc
	$(INSTALL) -D -m 0644 $(@D)/libedit/libedit.a $(1)/usr/lib/libedit.a
	$(INSTALL) -D -m 0644 $(@D)/libedit/libedit_pic.a $(1)/usr/lib/libedit_pic.a
	$(INSTALL) -D -m 0644 $(@D)/libedit/libedit.so.2.11 $(1)/usr/lib/libedit.so.2.11
	$(INSTALL) -D -m 0644 $(@D)/libedit/histedit.h $(1)/usr/include/histedit.h
	ln -sf libedit.so.$(LIBEDIT_VERSION) $(1)/usr/lib/libedit.so.$(LIBEDIT_VERSION_MAJOR)
	ln -sf libedit.so.$(LIBEDIT_VERSION_MAJOR) $(1)/usr/lib/libedit.so
	$(INSTALL) -D -m 0644 $(@D)/libedit/readline/readline.h $(1)/usr/include/editline/readline.h
	$(INSTALL) -v -D -m 0644 $(@D)/libedit/editline.3 $(1)/usr/share/man/man3/editline.3el
	$(INSTALL) -v -D -m 0644 $(@D)/libedit/editrc.5 $(1)/usr/share/man/man5/editrc.5el
	for lnk in $(LIBEDIT_MAN_LINKS); do                            \
	    ln -sfv editline.3el $(1)/usr/share/man/man3/$${lnk}.3el;   \
	done
endef

define LIBEDIT_INSTALL_STAGING_CMDS
	$(call LIBEDIT_INSTALL_CMDS,$(STAGING_DIR))
endef

define LIBEDIT_INSTALL_TARGET_CMDS
	$(call LIBEDIT_INSTALL_CMDS,$(TARGET_DIR))
endef

$(eval $(generic-package))
