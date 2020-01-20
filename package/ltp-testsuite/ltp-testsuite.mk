################################################################################
#
# ltp-testsuite
#
################################################################################

LTP_TESTSUITE_VERSION = 20200120
LTP_TESTSUITE_SOURCE = ltp-full-$(LTP_TESTSUITE_VERSION).tar.xz
LTP_TESTSUITE_SITE = https://github.com/linux-test-project/ltp/releases/download/$(LTP_TESTSUITE_VERSION)
LTP_TESTSUITE_LICENSE = GPL-2.0, GPL-2.0+
LTP_TESTSUITE_LICENSE_FILES = COPYING

LTP_TESTSUITE_CONF_OPTS += \
	--with-realtime-testsuite --with-open-posix-testsuite

ifeq ($(BR2_LINUX_KERNEL),y)
LTP_TESTSUITE_DEPENDENCIES += linux
LTP_TESTSUITE_MAKE_ENV += $(LINUX_MAKE_FLAGS)
LTP_TESTSUITE_CONF_OPTS += --with-linux-dir=$(LINUX_DIR)
else
LTP_TESTSUITE_CONF_OPTS += --without-modules
endif

# We change the prefix to a custom one, otherwise we get scripts and
# directories directly in /usr, such as /usr/runalltests.sh
LTP_TESTSUITE_CONF_OPTS += --prefix=/usr/lib/ltp-testsuite

# Needs libcap with file attrs which needs attr, so both required
ifeq ($(BR2_PACKAGE_LIBCAP)$(BR2_PACKAGE_ATTR),yy)
LTP_TESTSUITE_DEPENDENCIES += libcap
else
LTP_TESTSUITE_CONF_ENV += ac_cv_lib_cap_cap_compare=no
endif

# No explicit enable/disable options
ifeq ($(BR2_PACKAGE_NUMACTL),y)
LTP_TESTSUITE_DEPENDENCIES += numactl
else
LTP_TESTSUITE_CONF_ENV += have_numa_headers=no
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

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
LTP_TESTSUITE_DEPENDENCIES += musl-fts
LTP_TESTSUITE_LIBS += -lfts
endif

LTP_TESTSUITE_CONF_ENV += \
	CFLAGS="$(LTP_TESTSUITE_CFLAGS)" \
	CPPFLAGS="$(LTP_TESTSUITE_CPPFLAGS)" \
	LIBS="$(LTP_TESTSUITE_LIBS)" \
	SYSROOT="$(STAGING_DIR)"

# uclibc: bessel support normally not enabled
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
LTP_TESTSUITE_UNSUPPORTED_TEST_CASES = \
	testcases/misc/math/float/bessel/ \
	testcases/misc/math/float/float_bessel.c
else ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LTP_TESTSUITE_UNSUPPORTED_TEST_CASES = \
	testcases/kernel/pty/pty01.c \
	testcases/kernel/pty/pty02.c \
	testcases/kernel/pty/ptem01.c \
	testcases/kernel/sched/process_stress/process.c \
	testcases/kernel/syscalls/accept4/accept4_01.c \
	testcases/kernel/syscalls/confstr/confstr01.c \
	testcases/kernel/syscalls/fmtmsg/fmtmsg01.c \
	testcases/kernel/syscalls/getcontext/getcontext01.c \
	testcases/kernel/syscalls/getdents/getdents01.c \
	testcases/kernel/syscalls/getdents/getdents02.c \
	testcases/kernel/syscalls/ioctl/ioctl01.c \
	testcases/kernel/syscalls/ioctl/ioctl02.c \
	testcases/kernel/syscalls/rt_tgsigqueueinfo/rt_tgsigqueueinfo01.c \
	testcases/kernel/syscalls/sched_getaffinity/sched_getaffinity01.c \
	testcases/kernel/syscalls/timer_create/timer_create01.c \
	testcases/kernel/syscalls/timer_create/timer_create03.c \
	testcases/misc/crash/crash01.c \
	utils/benchmark/ebizzy-0.3
endif

define LTP_TESTSUITE_REMOVE_UNSUPPORTED_TESTCASES
	$(foreach f,$(LTP_TESTSUITE_UNSUPPORTED_TEST_CASES),
		rm -rf $(@D)/$(f)
	)
endef

LTP_TESTSUITE_POST_PATCH_HOOKS += LTP_TESTSUITE_REMOVE_UNSUPPORTED_TESTCASES

# ldd command build system tries to build a shared library unconditionally.
ifeq ($(BR2_STATIC_LIBS),y)
define LTP_TESTSUITE_REMOVE_LDD
	rm -rf $(@D)/testcases/commands/ldd
endef
LTP_TESTSUITE_POST_PATCH_HOOKS += LTP_TESTSUITE_REMOVE_LDD
endif

$(eval $(autotools-package))
