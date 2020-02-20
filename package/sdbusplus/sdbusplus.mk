################################################################################
#
# sdbusplus
#
################################################################################

SDBUSPLUS_VERSION = 4212292bcf136d04b38ba5116aa568b0fa312798
SDBUSPLUS_SITE = $(call github,openbmc,sdbusplus,$(SDBUSPLUS_VERSION))
SDBUSPLUS_DEPENDENCIES = host-autoconf-archive host-pkgconf systemd
HOST_SDBUSPLUS_DEPENDENCIES = \
	host-autoconf-archive \
	host-pkgconf \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python) \
	host-python-inflection \
	host-python-mako \
	host-python-pyyaml
SDBUSPLUS_CONF_OPTS = --disable-sdbuspp
HOST_SDBUSPLUS_CONF_OPTS = --disable-libsdbusplus
SDBUSPLUS_AUTORECONF = YES
SDBUSPLUS_AUTORECONF_OPTS = --include=$(HOST_DIR)/share/autoconf-archive
SDBUSPLUS_INSTALL_STAGING = YES
SDBUSPLUS_LICENSE = Apache-2.0
SDBUSPLUS_LICENSE_FILES = LICENSE

# Autoreconf is missing the m4/ directory, which might actually be missing
# iff it was the first argument, but unfortunately we are overriding the
# first include directory above. Thus we need that hook here.
define SDBUSPLUS_CREATE_M4
	mkdir -p $(@D)/m4
endef
SDBUSPLUS_POST_PATCH_HOOKS += SDBUSPLUS_CREATE_M4
HOST_SDBUSPLUS_POST_PATCH_HOOKS += SDBUSPLUS_CREATE_M4

$(eval $(autotools-package))
$(eval $(host-autotools-package))
