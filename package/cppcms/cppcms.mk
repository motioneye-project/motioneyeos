################################################################################
#
# cppcms
#
################################################################################

CPPCMS_VERSION = 1.2.1
CPPCMS_SOURCE = cppcms-$(CPPCMS_VERSION).tar.bz2
CPPCMS_LICENSE = MIT, BSL-1.0 (boost), Public Domain (json2.js), Zlib (md5)
CPPCMS_LICENSE_FILES = COPYING.TXT MIT.TXT THIRD_PARTY_SOFTWARE.TXT
CPPCMS_SITE = http://downloads.sourceforge.net/project/cppcms/cppcms/$(CPPCMS_VERSION)
CPPCMS_INSTALL_STAGING = YES
CPPCMS_CXXFLAGS = $(TARGET_CXXFLAGS)

# disable rpath to avoid getting /usr/lib added to the link search
# path
CPPCMS_CONF_OPTS = \
	-DCMAKE_SKIP_RPATH=ON \
	-DCMAKE_CXX_FLAGS="$(CPPCMS_CXXFLAGS)"

CPPCMS_DEPENDENCIES = zlib pcre libgcrypt

ifeq ($(BR2_PACKAGE_CPPCMS_ICU),y)
CPPCMS_CONF_OPTS += -DDISABLE_ICU_LOCALE=OFF
CPPCMS_DEPENDENCIES += icu
CPPCMS_CXXFLAGS += "`$(STAGING_DIR)/usr/bin/icu-config --cxxflags`"
else
CPPCMS_CONF_OPTS += -DDISABLE_ICU_LOCALE=ON
endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# posix backend needs monetary.h which isn't available on uClibc
CPPCMS_CONF_OPTS += -DDISABLE_POSIX_LOCALE=on
endif

# We copy cppcms_tmpl_cc from staging to host because this file can be
# needed for compiling packages using cppcms. And it is not worth
# creating a host package just for a python script.
define CPPCMS_INSTALL_HOST_TOOLS
	cp $(STAGING_DIR)/usr/bin/cppcms_tmpl_cc $(HOST_DIR)/bin/cppcms_tmpl_cc
endef
CPPCMS_POST_INSTALL_STAGING_HOOKS += CPPCMS_INSTALL_HOST_TOOLS

$(eval $(cmake-package))
