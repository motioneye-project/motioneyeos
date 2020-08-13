################################################################################
#
# autofs
#
################################################################################

AUTOFS_VERSION = 5.1.6
AUTOFS_SOURCE = autofs-$(AUTOFS_VERSION).tar.xz
AUTOFS_SITE = $(BR2_KERNEL_MIRROR)/linux/daemons/autofs/v5
AUTOFS_LICENSE = GPL-2.0+
AUTOFS_LICENSE_FILES = COPYING COPYRIGHT
AUTOFS_DEPENDENCIES = host-flex host-bison host-pkgconf host-nfs-utils

# autofs looks on the build machine for the path of modprobe, mount,
# umount and fsck programs so tell it explicitly where they will be
# located on the target.
AUTOFS_CONF_ENV = \
	ac_cv_path_E2FSCK=/sbin/fsck \
	ac_cv_path_E3FSCK=no \
	ac_cv_path_E4FSCK=no \
	ac_cv_path_KRB5_CONFIG=no \
	ac_cv_path_MODPROBE=/sbin/modprobe \
	ac_cv_path_MOUNT=/bin/mount \
	ac_cv_path_MOUNT_NFS=/usr/sbin/mount.nfs \
	ac_cv_path_UMOUNT=/bin/umount \
	ac_cv_linux_procfs=yes

# instead of looking in the PATH like any reasonable package, autofs
# configure looks only in an hardcoded search path for host tools,
# which we have to override with --with-path.
AUTOFS_CONF_OPTS = \
	--disable-mount-locking \
	--enable-ignore-busy \
	--without-openldap \
	--without-sasl \
	--with-path="$(BR_PATH)" \
	--with-hesiod=no

AUTOFS_MAKE_ENV = DONTSTRIP=1

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
AUTOFS_CONF_OPTS += --with-libtirpc
AUTOFS_DEPENDENCIES += libtirpc
else
AUTOFS_CONF_OPTS += --without-libtirpc
endif

$(eval $(autotools-package))
