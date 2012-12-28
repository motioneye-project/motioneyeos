#############################################################
#
# dvb-apps
#
#############################################################

DVB_APPS_VERSION        = 3fc7dfa68484
DVB_APPS_SOURCE         = dvb-apps-$(DVB_APPS_VERSION).tar.bz2
DVB_APPS_SITE           = http://linuxtv.org/hg/dvb-apps/archive/

# We just install the transponders data. As this is not a 'work' as per
# traditional copyright, but just a collection of 'facts', there's probably
# no license to apply to these data files.
# To be noted however, is that the dvb-apps package bundles a copy of the
# GPLv2 and a copy of the LGPLv2.1, and that some of the source files refer
# to either the GPLv2+ or the LGPLv2.1+.
# But since we do not use any of those source files, their license do not
# apply to us.
DVB_APPS_LICENSE        = unknown (probably public domain)

define DVB_APPS_INSTALL_TARGET_CMDS
	for i in atsc dvb-c dvb-s dvb-t; do \
		mkdir -p $(TARGET_DIR)/usr/share/dvb-apps/scan/$$i; \
		$(INSTALL) $(@D)/util/scan/$$i/* $(TARGET_DIR)/usr/share/dvb-apps/scan/$$i; \
	done
endef

$(eval $(generic-package))
