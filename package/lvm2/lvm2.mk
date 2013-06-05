################################################################################
#
# lvm2
#
################################################################################

LVM2_VERSION = 2.02.79
LVM2_SOURCE = LVM2.$(LVM2_VERSION).tgz
LVM2_SITE = ftp://sources.redhat.com/pub/lvm2/releases
LVM2_INSTALL_STAGING = YES

LVM2_BINS = \
	dmsetup fsadm lvm lvmconf lvmdump vgimportclone \
	lvchange lvconvert lvcreate lvdisplay lvextend 	\
	lvmchange lvmdiskscan lvmsadc lvmsar lvreduce  	\
	lvremove lvrename lvresize lvs lvscan pvchange 	\
	pvck pvcreate pvdisplay pvmove pvremove 	\
	pvresize pvs pvscan vgcfgbackup vgcfgrestore 	\
	vgchange vgck vgconvert vgcreate vgdisplay 	\
	vgexport vgextend vgimport vgmerge vgmknodes 	\
	vgreduce vgremove vgrename vgs vgscan vgsplit

# Make sure that binaries and libraries are installed with write
# permissions for the owner.
LVM2_CONF_OPT += --enable-write_install --enable-pkgconfig

# LVM2 uses autoconf, but not automake, and the build system does not
# take into account the CC passed at configure time.
LVM2_MAKE_ENV = CC="$(TARGET_CC)"

ifeq ($(BR2_PACKAGE_READLINE),y)
LVM2_DEPENDENCIES += readline
else
# v2.02.44: disable readline usage, or binaries are linked against provider
# of "tgetent" (=> ncurses) even if it's not used..
LVM2_CONF_OPT += --disable-readline
endif

ifeq ($(BR2_PACKAGE_LVM2_DMSETUP_ONLY),y)
LVM2_MAKE_OPT = device-mapper
LVM2_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install_device-mapper
LVM2_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install_device-mapper
endif

ifeq ($(BR2_PACKAGE_LVM2_APP_LIBRARY),y)
LVM2_CONF_OPT += --enable-applib
else
LVM2_CONF_OPT += --disable-applib
endif

define LVM2_UNINSTALL_STAGING_CMDS
	rm -f $(addprefix $(STAGING_DIR)/usr/sbin/,$(LVM2_BINS))
	rm -f $(addprefix $(STAGING_DIR)/usr/lib/,libdevmapper.so*)
endef

define LVM2_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,$(LVM2_BINS))
	rm -f $(addprefix $(TARGET_DIR)/usr/lib/,libdevmapper.so*)
endef

$(eval $(autotools-package))
