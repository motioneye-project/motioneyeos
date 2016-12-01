################################################################################
#
# uclibc-ng-test
#
################################################################################

UCLIBC_NG_TEST_VERSION = 4ad1c23ae2eb30888cda520c739cc26150512487
UCLIBC_NG_TEST_SITE = git://uclibc-ng.org/git/uclibc-ng-test
UCLIBC_NG_TEST_LICENSE = LGPLv2.1+
UCLIBC_NG_TEST_LICENSE_FILES = COPYING.LIB

ifeq ($(BR2_USE_WCHAR),)
UCLIBC_NG_TEST_MAKE_ENV += NO_WCHAR=1
endif
ifeq ($(BR2_ENABLE_LOCALE),)
UCLIBC_NG_TEST_MAKE_ENV += NO_LOCALE=1
endif
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
UCLIBC_NG_TEST_MAKE_ENV += NO_TLS=1 NO_THREADS=1
endif
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS_NPTL),)
UCLIBC_NG_TEST_MAKE_ENV += NO_TLS=1 NO_NPTL=1
endif
# most NPTL/TLS tests use dlopen
ifeq ($(BR2_STATIC_LIBS),y)
UCLIBC_NG_TEST_MAKE_ENV += NO_TLS=1 NO_NPTL=1 NO_DL=1
endif

# to execute tests in a deterministic order, call test_gen separately
define UCLIBC_NG_TEST_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(UCLIBC_NG_TEST_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		UCLIBC_EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		test_compile
	$(TARGET_MAKE_ENV) $(UCLIBC_NG_TEST_MAKE_ENV) $(MAKE1) -C $(@D) \
		CC="$(TARGET_CC)" \
		UCLIBC_EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		test_gen
endef

define UCLIBC_NG_TEST_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
