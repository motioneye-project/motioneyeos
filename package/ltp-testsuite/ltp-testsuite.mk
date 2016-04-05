################################################################################
#
# ltp-testsuite
#
################################################################################

LTP_TESTSUITE_VERSION = 20160126
LTP_TESTSUITE_SOURCE = ltp-full-$(LTP_TESTSUITE_VERSION).tar.xz
LTP_TESTSUITE_SITE = https://github.com/linux-test-project/ltp/releases/download/$(LTP_TESTSUITE_VERSION)
LTP_TESTSUITE_LICENSE = GPLv2, GPLv2+
LTP_TESTSUITE_LICENSE_FILES = COPYING
LTP_TESTSUITE_CONF_OPTS += \
	--with-power-management-testsuite \
	--with-realtime-testsuite

ifeq ($(BR2_LINUX_KERNEL),y)
LTP_TESTSUITE_DEPENDENCIES += linux
LTP_TESTSUITE_MAKE_ENV += $(LINUX_MAKE_FLAGS)
LTP_TESTSUITE_CONF_OPTS += --with-linux-dir=$(LINUX_DIR)
else
LTP_TESTSUITE_CONF_OPTS += --without-modules
endif

# Needs libcap with file attrs which needs attr, so both required
ifeq ($(BR2_PACKAGE_LIBCAP)$(BR2_PACKAGE_ATTR),yy)
LTP_TESTSUITE_DEPENDENCIES += libcap
else
LTP_TESTSUITE_CONF_ENV += ac_cv_lib_cap_cap_compare=no
endif

# ltp-testsuite uses <fts.h>, which isn't compatible with largefile
# support.
LTP_TESTSUITE_CFLAGS = $(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))
LTP_TESTSUITE_CPPFLAGS = $(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))
LTP_TESTSUITE_LIBS =

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
LTP_TESTSUITE_DEPENDENCIES += libtirpc host-pkgconf
LTP_TESTSUITE_CFLAGS += "`$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`"
LTP_TESTSUITE_LIBS += "`$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`"
endif

LTP_TESTSUITE_CONF_ENV += \
	CFLAGS="$(LTP_TESTSUITE_CFLAGS)" \
	CPPFLAGS="$(LTP_TESTSUITE_CPPFLAGS)" \
	LIBS="$(LTP_TESTSUITE_LIBS)" \
	SYSROOT="$(STAGING_DIR)"

# Requires uClibc fts and bessel support, normally not enabled
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
define LTP_TESTSUITE_REMOVE_UNSUPPORTED
	rm -rf $(@D)/testcases/kernel/controllers/cpuset/
	rm -rf $(@D)/testcases/misc/math/float/bessel/
	rm -f $(@D)/testcases/misc/math/float/float_bessel.c
endef
LTP_TESTSUITE_POST_PATCH_HOOKS += LTP_TESTSUITE_REMOVE_UNSUPPORTED
endif


$(eval $(autotools-package))
