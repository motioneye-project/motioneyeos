################################################################################
#
# valgrind
#
################################################################################

VALGRIND_VERSION = 3.15.0
VALGRIND_SITE = ftp://sourceware.org/pub/valgrind
VALGRIND_SOURCE = valgrind-$(VALGRIND_VERSION).tar.bz2
VALGRIND_LICENSE = GPL-2.0, GFDL-1.2
VALGRIND_LICENSE_FILES = COPYING COPYING.DOCS
VALGRIND_CONF_OPTS = \
	--disable-ubsan \
	--without-mpicc
VALGRIND_INSTALL_STAGING = YES

# Valgrind must be compiled with no stack protection, so forcefully
# pass -fno-stack-protector to override what Buildroot may have in
# TARGET_CFLAGS if BR2_SSP_* support is enabled.
VALGRIND_CFLAGS = \
	$(TARGET_CFLAGS) \
	-fno-stack-protector

# When Valgrind detects a 32-bit MIPS architecture, it forcibly adds
# -march=mips32 to CFLAGS; when it detects a 64-bit MIPS architecture,
# it forcibly adds -march=mips64. This causes Valgrind to be built
# always for the first ISA revision level (R1), even when the user has
# configured Buildroot for the second ISA revision level (R2).
#
# Override the CFLAGS variable (which Valgrind appends to its CFLAGS)
# and pass the right -march option, so they take precedence over
# Valgrind's wrongfully detected value.
ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
VALGRIND_CFLAGS += -march="$(GCC_TARGET_ARCH)"
endif

VALGRIND_CONF_ENV = CFLAGS="$(VALGRIND_CFLAGS)"

# fix uclibc configure c99 support detection
VALGRIND_CONF_ENV += ac_cv_prog_cc_c99='-std=gnu99'

# On ARM, Valgrind only supports ARMv7, and uses the arch part of the
# host tuple to determine whether it's being built for ARMv7 or
# not. Therefore, we adjust the host tuple to specify we're on
# ARMv7. The valgrind package is guaranteed, through Config.in, to
# only be selected on ARMv7-A platforms.
ifeq ($(BR2_ARM_CPU_ARMV7A),y)
VALGRIND_CONF_OPTS += \
	--host=$(patsubst arm-%,armv7-%,$(GNU_TARGET_NAME))
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
VALGRIND_CONF_OPTS += --enable-lto
else
VALGRIND_CONF_OPTS += --disable-lto
endif

define VALGRIND_INSTALL_UCLIBC_SUPP
	$(INSTALL) -D -m 0644 package/valgrind/uclibc.supp $(TARGET_DIR)/usr/lib/valgrind/uclibc.supp
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_INSTALL_UCLIBC_SUPP

ifeq ($(BR2_PACKAGE_VALGRIND_MEMCHECK),)
define VALGRIND_REMOVE_MEMCHECK
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*memcheck*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_MEMCHECK
endif

ifeq ($(BR2_PACKAGE_VALGRIND_CACHEGRIND),)
define VALGRIND_REMOVE_CACHEGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*cachegrind*
	for i in cg_annotate cg_diff cg_merge; do \
		rm -f $(TARGET_DIR)/usr/bin/$$i ; \
	done
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_CACHEGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_CALLGRIND),)
define VALGRIND_REMOVE_CALLGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*callgrind*
	for i in callgrind_annotate callgrind_control ; do \
		rm -f $(TARGET_DIR)/usr/bin/$$i ; \
	done
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_CALLGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_HELGRIND),)
define VALGRIND_REMOVE_HELGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*helgrind*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_HELGRIND
endif

ifeq ($(BR2_PACKAGE_VALGRIND_DRD),)
define VALGRIND_REMOVE_DRD
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*drd*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_DRD
endif

ifeq ($(BR2_PACKAGE_VALGRIND_MASSIF),)
define VALGRIND_REMOVE_MASSIF
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*massif*
	rm -f $(TARGET_DIR)/usr/bin/ms_script
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_MASSIF
endif

ifeq ($(BR2_PACKAGE_VALGRIND_DHAT),)
define VALGRIND_REMOVE_DHAT
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*dhat*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_DHAT
endif

ifeq ($(BR2_PACKAGE_VALGRIND_SGCHECK),)
define VALGRIND_REMOVE_SGCHECK
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*sgcheck*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_SGCHECK
endif

ifeq ($(BR2_PACKAGE_VALGRIND_BBV),)
define VALGRIND_REMOVE_BBV
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*bbv*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_BBV
endif

ifeq ($(BR2_PACKAGE_VALGRIND_LACKEY),)
define VALGRIND_REMOVE_LACKEY
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*lackey*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_LACKEY
endif

ifeq ($(BR2_PACKAGE_VALGRIND_NULGRIND),)
define VALGRIND_REMOVE_NULGRIND
	rm -f $(TARGET_DIR)/usr/lib/valgrind/*none*
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_REMOVE_NULGRIND
endif

$(eval $(autotools-package))
