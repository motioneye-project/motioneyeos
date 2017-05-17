################################################################################
#
# cppcms
#
################################################################################

CPPCMS_VERSION = 1.0.5
CPPCMS_SOURCE = cppcms-$(CPPCMS_VERSION).tar.bz2
CPPCMS_LICENSE = LGPL-3.0
CPPCMS_LICENSE_FILES = COPYING.TXT
CPPCMS_SITE = http://downloads.sourceforge.net/project/cppcms/cppcms/$(CPPCMS_VERSION)
CPPCMS_INSTALL_STAGING = YES

# disable rpath to avoid getting /usr/lib added to the link search
# path
CPPCMS_CONF_OPTS = -DCMAKE_SKIP_RPATH=ON

CPPCMS_DEPENDENCIES = zlib pcre libgcrypt

ifeq ($(BR2_PACKAGE_CPPCMS_ICU),y)
CPPCMS_CONF_OPTS += -DDISABLE_ICONV=ON
CPPCMS_DEPENDENCIES += icu
endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# posix backend needs monetary.h which isn't available on uClibc
CPPCMS_CONF_OPTS += -DDISABLE_POSIX_LOCALE=on
endif

# We copy cppcms_tmpl_cc from staging to host because this file can be
# needed for compiling packages using cppcms. And it is not worth
# creating a host package just for a python script.
define CPPCMS_INSTALL_HOST_TOOLS
	cp $(STAGING_DIR)/usr/bin/cppcms_tmpl_cc $(HOST_DIR)/usr/bin/cppcms_tmpl_cc
endef
CPPCMS_POST_INSTALL_STAGING_HOOKS += CPPCMS_INSTALL_HOST_TOOLS

$(eval $(cmake-package))
