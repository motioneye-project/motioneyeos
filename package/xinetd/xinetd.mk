################################################################################
#
# xinetd
#
################################################################################

XINETD_VERSION = xinetd-2-3-15
XINETD_SITE = $(call github,xinetd-org,xinetd,$(XINETD_VERSION))
XINETD_LICENSE = xinetd license
XINETD_LICENSE_FILES = COPYRIGHT

XINETD_CFLAGS = $(TARGET_CFLAGS)

# Three cases here:
#  1. We have libtirpc, use it by passing special flags
#  2. We have native RPC support, use it, no need to pass special
#     flags (so this case 2 is implicit and not visible below)
#  3. We don't have RPC support, pass -DNO_RPC to disable it
ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
XINETD_DEPENDENCIES += libtirpc
XINETD_CFLAGS += -I$(STAGING_DIR)/usr/include/tirpc/
XINETD_LIBS += -ltirpc
else ifeq ($(BR2_TOOLCHAIN_HAS_NATIVE_RPC),)
XINETD_CFLAGS += -DNO_RPC
endif

XINETD_CONF_ENV += \
	CFLAGS="$(XINETD_CFLAGS)" \
	LIBS="$(XINETD_LIBS)"

XINETD_MAKE_OPTS = AR="$(TARGET_AR)"

$(eval $(autotools-package))
