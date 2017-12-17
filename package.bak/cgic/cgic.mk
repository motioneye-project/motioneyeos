################################################################################
#
# cgic
#
################################################################################

CGIC_VERSION = 2.06
CGIC_SOURCE = cgic206.tar.gz
CGIC_SITE = http://boutell.com/cgic
CGIC_LICENSE = Custom
CGIC_LICENSE_FILES = license.txt

# Installs only a static library and a header file
CGIC_INSTALL_STAGING = YES
CGIC_INSTALL_TARGET = NO

define CGIC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) libcgic.a
endef

define CGIC_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) PREFIX=$(STAGING_DIR) -C $(@D) install
endef

$(eval $(generic-package))
