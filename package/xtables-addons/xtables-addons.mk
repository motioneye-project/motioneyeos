################################################################################
#
# xtables-addons
#
################################################################################

XTABLES_ADDONS_VERSION = 3.7
XTABLES_ADDONS_SOURCE = xtables-addons-$(XTABLES_ADDONS_VERSION).tar.xz
XTABLES_ADDONS_SITE = http://downloads.sourceforge.net/project/xtables-addons/Xtables-addons
XTABLES_ADDONS_DEPENDENCIES = iptables linux host-pkgconf
XTABLES_ADDONS_LICENSE = GPL-2.0+
XTABLES_ADDONS_LICENSE_FILES = LICENSE

XTABLES_ADDONS_CONF_OPTS = \
	--with-kbuild="$(LINUX_DIR)" \
	--with-xtables="$(STAGING_DIR)/usr" \
	--with-xtlibdir="/usr/lib/xtables"

# geoip helpers need perl with modules and unzip so disable
define XTABLES_DISABLE_GEOIP_HELPERS
	$(SED) 's/ geoip//' $(@D)/Makefile.in
endef
XTABLES_ADDONS_POST_PATCH_HOOKS += XTABLES_DISABLE_GEOIP_HELPERS

define XTABLES_ADDONS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS)
endef

define XTABLES_ADDONS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(autotools-package))
