################################################################################
#
# rcw
#
################################################################################

RCW_VERSION = LSDK-18.12
RCW_SITE = https://source.codeaurora.org/external/qoriq/qoriq-components/rcw
RCW_SITE_METHOD = git
RCW_LICENSE = BSD-3-Clause
RCW_LICENSE_FILES = LICENSE

# Copy source files and script into $(HOST_DIR)/share/rcw/ so a developer
# could use a post image or SDK to build/install PBL files.
define HOST_RCW_INSTALL_CMDS
	mkdir -p  $(HOST_DIR)/share/rcw
	cp -a $(@D)/* $(HOST_DIR)/share/rcw
endef

$(eval $(host-generic-package))
