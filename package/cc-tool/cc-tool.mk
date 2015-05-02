################################################################################
#
# cc-tool
#
################################################################################

CC_TOOL_VERSION = 0.26
CC_TOOL_SITE = http://downloads.sourceforge.net/project/cctool
CC_TOOL_SOURCE = cc-tool-$(CC_TOOL_VERSION)-src.tgz
CC_TOOL_LICENSE = GPLv2
CC_TOOL_LICENSE_FILES = COPYING
CC_TOOL_DEPENDENCIES = boost libusb

# Configure script "discovers" boost in /usr/local if not given explicitly
CC_TOOL_CONF_OPTS = --with-boost=$(STAGING_DIR)/usr

$(eval $(autotools-package))
