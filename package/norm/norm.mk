################################################################################
#
# norm
#
################################################################################

NORM_VERSION = 1.5.8
NORM_SITE = https://github.com/USNavalResearchLaboratory/norm/releases/download/v$(NORM_VERSION)
NORM_SOURCE = src-norm-with-protolib-$(NORM_VERSION).tgz
NORM_INSTALL_STAGING = YES
NORM_LICENSE = NRL License
NORM_LICENSE_FILES = LICENSE.TXT

ifeq ($(BR2_PACKAGE_LIBNETFILTER_QUEUE),y)
NORM_DEPENDENCIES += libnetfilter_queue
endif

# install target doesn't install headers unfortunately...
define NORM_INSTALL_HEADERS
	cp -f $(@D)/include/norm* $(STAGING_DIR)/usr/include
endef
NORM_POST_INSTALL_STAGING_HOOKS += NORM_INSTALL_HEADERS

$(eval $(waf-package))
