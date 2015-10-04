################################################################################
#
# read-edid
#
################################################################################

READ_EDID_VERSION = 1.4.2
READ_EDID_SITE = http://www.polypux.org/projects/read-edid
READ_EDID_LICENSE = GPLv2
READ_EDID_LICENSE_FILES = COPYING

define READ_EDID_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

$(eval $(autotools-package))
