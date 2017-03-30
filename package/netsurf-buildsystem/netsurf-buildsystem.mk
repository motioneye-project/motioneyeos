################################################################################
#
# netsurf-buildsystem
#
################################################################################

NETSURF_BUILDSYSTEM_VERSION = 7574b41345968b5f7e9ca5875faccb1478ce0555
NETSURF_BUILDSYSTEM_SITE = http://git.netsurf-browser.org/buildsystem.git
NETSURF_BUILDSYSTEM_SITE_METHOD = git
NETSURF_BUILDSYSTEM_LICENSE = MIT, BSD-3-Clause (for llvm/* files)
NETSURF_BUILDSYSTEM_LICENSE_FILES = llvm/LICENSE.TXT

NETSURF_BUILDSYSTEM_INSTALL_DIR = $(HOST_DIR)/usr/share/netsurf-buildsystem

define HOST_NETSURF_BUILDSYSTEM_INSTALL_CMDS
	mkdir -p $(NETSURF_BUILDSYSTEM_INSTALL_DIR)
	cp -dpfr $(@D)/* $(NETSURF_BUILDSYSTEM_INSTALL_DIR)
endef

$(eval $(host-generic-package))
