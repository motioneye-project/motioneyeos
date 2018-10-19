################################################################################
#
# mdadm
#
################################################################################

MDADM_VERSION = 4.0
MDADM_SOURCE = mdadm-$(MDADM_VERSION).tar.xz
MDADM_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/raid/mdadm
MDADM_LICENSE = GPL-2.0+
MDADM_LICENSE_FILES = COPYING

MDADM_BUILD_OPTS = $(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) -DNO_COROSYNC -DNO_DLM" \
	CPPFLAGS="$(TARGET_CPPFLAGS) -DBINDIR=\\\"/sbin\\\"" \
	CHECK_RUN_DIR=0

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
MDADM_BUILD_OPTS += USE_PTHREADS=
endif

define MDADM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MDADM_BUILD_OPTS) mdadm mdmon
endef

define MDADM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) \
		install-mdadm install-mdmon
endef

$(eval $(generic-package))
