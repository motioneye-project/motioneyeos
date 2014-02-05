################################################################################
#
# logsurfer
#
################################################################################

LOGSURFER_VERSION = 1.8
LOGSURFER_SITE = http://downloads.sourceforge.net/project/logsurfer/logsurfer/logsurfer-$(LOGSURFER_VERSION)

define LOGSURFER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/logsurfer \
		$(TARGET_DIR)/usr/bin/logsurfer
endef

$(eval $(autotools-package))
