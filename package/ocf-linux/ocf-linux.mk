################################################################################
#
# ocf-linux
#
################################################################################

OCF_LINUX_VERSION = 20120127
OCF_LINUX_SITE = http://downloads.sourceforge.net/project/ocf-linux/ocf-linux/$(OCF_LINUX_VERSION)
OCF_LINUX_INSTALL_STAGING = YES

OCF_LINUX_MODULE_SUBDIRS = ocf
OCF_LINUX_MODULE_MAKE_OPTS = \
	CONFIG_OCF_OCF=m \
	CONFIG_OCF_CRYPTOSOFT=m \
	CONFIG_OCF_BENCH=m \
	CONFIG_OCF_OCFNULL=m

define OCF_LINUX_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/ocf/cryptodev.h \
		$(STAGING_DIR)/usr/include/crypto/cryptodev.h
endef

$(eval $(kernel-module))
$(eval $(generic-package))
