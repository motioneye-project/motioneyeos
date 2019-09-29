################################################################################
#
# acpica
#
################################################################################

ACPICA_VERSION = 20170531
ACPICA_SOURCE = acpica-unix2-$(ACPICA_VERSION).tar.gz
ACPICA_SITE = https://acpica.org/sites/acpica/files
ACPICA_LICENSE = BSD-3-Clause or GPL-2.0
ACPICA_LICENSE_FILES = source/include/acpi.h
ACPICA_DEPENDENCIES = host-bison host-flex
HOST_ACPICA_DEPENDENCIES = host-bison host-flex

define ACPICA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		HARDWARE_NAME=$(BR2_ARCH) HOST=_LINUX CC="$(TARGET_CC)" \
		all
endef

define HOST_ACPICA_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		all
endef

define ACPICA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		HARDWARE_NAME=$(BR2_ARCH) DESTDIR="$(TARGET_DIR)" \
		INSTALLFLAGS=-m755 install
endef

define HOST_ACPICA_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX="$(HOST_DIR)" \
		INSTALLFLAGS=-m755 install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
