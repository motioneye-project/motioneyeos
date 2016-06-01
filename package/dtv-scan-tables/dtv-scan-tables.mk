################################################################################
#
# dtv-scan-tables
#
################################################################################

DTV_SCAN_TABLES_VERSION = 0c92e5e5d3590da60acb4bcc92c19f041dc7e481
DTV_SCAN_TABLES_SITE = http://git.linuxtv.org/cgit.cgi/dtv-scan-tables.git
DTV_SCAN_TABLES_SITE_METHOD = git

# This package only contains the transponders data. This is not a 'work'
# as per traditional copyright, but just a collection of 'facts', so there's
# probably no license to apply to these data files.
# However, the package prominently contains the COPYING and COPYING.LIB
# license files (respectively for the GPLv2 and the LGPLv2.1), so we use
# that as the licensing information.
DTV_SCAN_TABLES_LICENSE = GPLv2, LGPLv2.1
DTV_SCAN_TABLES_LICENSE_FILES = COPYING COPYING.LGPL

define DTV_SCAN_TABLES_INSTALL_TARGET_CMDS
	for f in atsc dvb-c dvb-s dvb-t; do \
		$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/dvb/$$f; \
		$(INSTALL) $(@D)/$$f/* $(TARGET_DIR)/usr/share/dvb/$$f; \
	done
endef

$(eval $(generic-package))
