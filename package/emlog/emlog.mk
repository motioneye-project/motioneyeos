################################################################################
#
# emlog
#
################################################################################

EMLOG_VERSION = 0.70
EMLOG_SITE = $(call github,nicupavel,emlog,emlog-$(EMLOG_VERSION))
EMLOG_LICENSE = GPL-2.0
EMLOG_LICENSE_FILES = COPYING

# CVE-2019-16868 and CVE-2019-17073 are misclassified (by our CVE tracker) as
# affecting emlog, while in fact it affects http://www.emlog.net.
EMLOG_IGNORE_CVES += CVE-2019-16868 CVE-2019-17073

define EMLOG_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) nbcat
endef

# make install tries to strip, so install manually.
define EMLOG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/nbcat $(TARGET_DIR)/usr/bin/nbcat
endef

$(eval $(kernel-module))
$(eval $(generic-package))
