################################################################################
#
# logsurfer
#
################################################################################

LOGSURFER_VERSION = 1.8
LOGSURFER_SOURCE = logsurfer-$(LOGSURFER_VERSION).tar.gz
LOGSURFER_SITE = http://downloads.sourceforge.net/project/logsurfer/logsurfer/logsurfer-$(LOGSURFER_VERSION)

define LOGSURFER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/logsurfer \
		$(TARGET_DIR)/usr/bin/logsurfer
endef

ifeq ($(BR2_HAVE_DOCUMENTATION),y)

define LOGSURFER_INSTALL_TARGET_MAN
	$(INSTALL) -D -m 0644 $(@D)/man/logsurfer.1 \
		$(TARGET_DIR)/usr/man/man1/logsurfer.1
	$(INSTALL) -D -m 0644 $(@D)/man/logsurfer.conf.4 \
		$(TARGET_DIR)/usr/man/man4/logsurfer.conf.4
endef

LOGSURFER_POST_INSTALL_TARGET_HOOKS += LOGSURFER_INSTALL_TARGET_MAN

endif

$(eval $(autotools-package))
