################################################################################
#
# openrc
#
################################################################################

OPENRC_VERSION = 0.41.2
OPENRC_SITE = $(call github,OpenRC,openrc,$(OPENRC_VERSION))
OPENRC_LICENSE = BSD-2-Clause
OPENRC_LICENSE_FILES = LICENSE

OPENRC_DEPENDENCIES = ncurses

# set LIBNAME so openrc puts files in proper directories and sets proper
# paths in installed files. Since in buildroot /lib64 and /lib32 always
# points to /lib, it's safe to hardcode it to "lib"
OPENRC_MAKE_OPTS = \
	LIBNAME=lib \
	LIBEXECDIR=/usr/libexec/rc \
	MKPKGCONFIG=no \
	MKSELINUX=no \
	MKSYSVINIT=yes \
	BRANDING="Buildroot $(BR2_VERSION_FULL)" \
	CC=$(TARGET_CC)

ifeq ($(BR2_SHARED_LIBS),y)
OPENRC_MAKE_OPTS += MKSTATICLIBS=no
else
OPENRC_MAKE_OPTS += MKSTATICLIBS=yes
endif

define OPENRC_BUILD_CMDS
	$(MAKE) $(OPENRC_MAKE_OPTS) -C $(@D)
endef

define OPENRC_INSTALL_TARGET_CMDS
	$(MAKE) $(OPENRC_MAKE_OPTS) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define OPENRC_REMOVE_UNNEEDED
	$(RM) -r $(TARGET_DIR)/usr/share/openrc
endef
OPENRC_TARGET_FINALIZE_HOOKS += OPENRC_REMOVE_UNNEEDED

$(eval $(generic-package))
