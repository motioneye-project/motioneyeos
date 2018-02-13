################################################################################
#
# toolchain
#
################################################################################

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
TOOLCHAIN_DEPENDENCIES += toolchain-buildroot
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
TOOLCHAIN_DEPENDENCIES += toolchain-external
endif

TOOLCHAIN_ADD_TOOLCHAIN_DEPENDENCY = NO

# Apply a hack that Rick Felker suggested[1] to avoid conflicts between libc
# headers and kernel headers. This is needed for kernel headers older than
# 4.15. Kernel headers 4.15 and newer don't require __GLIBC__ to be defined.
#
# Augment the original suggestion with __USE_MISC since recent kernels
# (older than 4.15) require this glibc internal macro. Also, as musl defines
# IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, add another macro to suppress
# them in the kernel header, and avoid macro/enum conflict.
#
# Kernel version 3.12 introduced the libc-compat.h header.
#
# [1] http://www.openwall.com/lists/musl/2015/10/08/2
ifeq ($(BR2_TOOLCHAIN_USES_MUSL)$(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_12):$(BR2_TOOLCHAIN_HEADERS_AT_LEAST_4_15),yy:)
define TOOLCHAIN_MUSL_KERNEL_HEADERS_COMPATIBILITY_HACK
	$(SED) 's/^#if defined(__GLIBC__)$$/#if 1/' \
		$(STAGING_DIR)/usr/include/linux/libc-compat.h
	$(SED) '1s/^/#define __USE_MISC\n/' \
		$(STAGING_DIR)/usr/include/linux/libc-compat.h
	$(SED) '1s/^/#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 0\n/' \
		$(STAGING_DIR)/usr/include/linux/libc-compat.h
endef
TOOLCHAIN_POST_INSTALL_STAGING_HOOKS += TOOLCHAIN_MUSL_KERNEL_HEADERS_COMPATIBILITY_HACK
TOOLCHAIN_INSTALL_STAGING = YES
endif

$(eval $(virtual-package))

toolchain: $(HOST_DIR)/share/buildroot/toolchainfile.cmake
toolchain: $(HOST_DIR)/share/buildroot/Platform/Buildroot.cmake
