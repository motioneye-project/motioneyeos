################################################################################
#
# util-linux
#
################################################################################

UTIL_LINUX_VERSION_MAJOR = 2.34
UTIL_LINUX_VERSION = $(UTIL_LINUX_VERSION_MAJOR)
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.xz
UTIL_LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_VERSION_MAJOR)

UTIL_LINUX_EXTRACT_CMDS =
HOST_UTIL_LINUX_EXTRACT_CMDS =

# util-linux-libs installs on STAGING_DIR only, for build time,
# util-linux-programs installs on TARGET_DIR only, for run time.
# We may need both.
UTIL_LINUX_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBS),util-linux-libs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PROGRAMS),util-linux-programs)

# In the host version we need either host-util-linux-programs or
# host-util-linux-libs, only.
HOST_UTIL_LINUX_DEPENDENCIES = \
	host-util-linux-$(if $(BR2_PACKAGE_HOST_UTIL_LINUX),programs,libs)

$(eval $(generic-package))
$(eval $(host-generic-package))

include package/util-linux/util-linux-libs/util-linux-libs.mk
include package/util-linux/util-linux-programs/util-linux-programs.mk
