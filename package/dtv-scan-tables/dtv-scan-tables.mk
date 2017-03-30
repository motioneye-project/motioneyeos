################################################################################
#
# dtv-scan-tables
#
################################################################################

DTV_SCAN_TABLES_VERSION = ceb11833b35f05813b1f0397a60e0f3b99430aab
DTV_SCAN_TABLES_SITE = http://git.linuxtv.org/cgit.cgi/dtv-scan-tables.git
DTV_SCAN_TABLES_SITE_METHOD = git

# This package only contains the transponders data. This is not a 'work'
# as per traditional copyright, but just a collection of 'facts', so there's
# probably no license to apply to these data files.
# However, the package prominently contains the COPYING and COPYING.LIB
# license files (respectively for the GPLv2 and the LGPLv2.1), so we use
# that as the licensing information.
DTV_SCAN_TABLES_LICENSE = GPL-2.0, LGPL-2.1
DTV_SCAN_TABLES_LICENSE_FILES = COPYING COPYING.LGPL

# In order to avoid issues with file name encodings, we rename the
# only dtv-scan-tables file that has non-ASCII characters to have a
# name using only ASCII characters (pl-Krosno_Sucha_Gora)
define DTV_SCAN_TABLES_FIX_NONASCII_FILENAMES
	mv $(@D)/dvb-t/pl-Krosno_Sucha* $(@D)/dvb-t/pl-Krosno_Sucha_Gora
endef

DTV_SCAN_TABLES_POST_PATCH_HOOKS += DTV_SCAN_TABLES_FIX_NONASCII_FILENAMES

define DTV_SCAN_TABLES_INSTALL_TARGET_CMDS
	for f in atsc dvb-c dvb-s dvb-t; do \
		$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/dvb/$$f; \
		$(INSTALL) $(@D)/$$f/* $(TARGET_DIR)/usr/share/dvb/$$f; \
	done
endef

$(eval $(generic-package))
