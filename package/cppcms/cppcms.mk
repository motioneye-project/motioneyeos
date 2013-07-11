################################################################################
#
# cppcms
#
################################################################################

CPPCMS_VERSION = 1.0.3
CPPCMS_SOURCE = cppcms-$(CPPCMS_VERSION).tar.bz2
CPPCMS_LICENSE = LGPLv3
CPPCMS_LICENSE_FILE = COPYING.TXT
CPPCMS_SITE = http://downloads.sourceforge.net/project/cppcms/cppcms/$(CPPCMS_VERSION)
CPPCMS_INSTALL_STAGING = YES

CPPCMS_DEPENDENCIES = zlib pcre libgcrypt

ifeq ($(BR2_PACKAGE_CPPCMS_ICU),y)
CPPCMS_CONF_OPT += -DDISABLE_ICONV=ON
CPPCMS_DEPENDENCIES += icu
endif

# We copy cppcms_tmpl_cc from staging to host because this file can be
# needed for compiling packages using cppcms. And it is not worth
# creating a host package just for a python script.
define CPPCMS_INSTALL_HOST_TOOLS
	cp $(STAGING_DIR)/usr/bin/cppcms_tmpl_cc $(HOST_DIR)/usr/bin/cppcms_tmpl_cc
endef
CPPCMS_POST_INSTALL_STAGING_HOOKS += CPPCMS_INSTALL_HOST_TOOLS

$(eval $(cmake-package))
