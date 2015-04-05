################################################################################
#
# drbd-utils
#
################################################################################

DRBD_UTILS_VERSION = 8.9.1
DRBD_UTILS_SITE = http://oss.linbit.com/drbd/
DRBD_UTILS_LICENSE = GPLv2+
DRBD_UTILS_LICENSE_FILES = COPYING
DRBD_UTILS_DEPENDENCIES = host-flex

DRBD_UTILS_CONF_OPTS = --with-distro=generic

ifeq ($(BR2_INIT_SYSTEMD),y)
DRBD_UTILS_CONF_OPTS += --with-initscripttype=systemd
DRDB_UTILS_DEPENDENCIES += systemd
else
DRBD_UTILS_CONF_OPTS += --with-initscripttype=sysv
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
DRBD_UTILS_CONF_OPTS += --with-udev=yes
DRDB_UTILS_DEPENDENCIES += udev
else
DRBD_UTILS_CONF_OPTS += --with-udev=no
endif

# Do not build the documentation because it requires docbook
define DRBD_UTILS_DISABLE_DOCS
	$(SED) 's/user scripts documentation/user scripts/' $(@D)/Makefile.in
endef
DRBD_UTILS_POST_PATCH_HOOKS += DRBD_UTILS_DISABLE_DOCS

$(eval $(autotools-package))
