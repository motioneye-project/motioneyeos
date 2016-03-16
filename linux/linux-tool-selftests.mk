################################################################################
#
# selftests
#
################################################################################

LINUX_TOOLS += selftests

ifeq ($(KERNEL_ARCH),x86_64)
SELFTESTS_ARCH=x86
else
ifeq ($(KERNEL_ARCH),i386)
SELFTESTS_ARCH=x86
else
SELFTESTS_ARCH=$(KERNEL_ARCH)
endif
endif

SELFTESTS_DEPENDENCIES = libcap-ng popt

SELFTESTS_MAKE_FLAGS = \
	$(LINUX_MAKE_FLAGS) \
	ARCH=$(SELFTESTS_ARCH)

# O must be redefined here to overwrite the one used by Buildroot for
# out of tree build. We build the selftests in $(@D)/tools/selftests and
# not just $(@D) so that it isn't built in the root directory of the kernel
# sources.
#
# The headers_install step here is important as some kernel selftests use a
# hardcoded CFLAGS to find kernel headers e.g:
# CFLAGS += -I../../../../usr/include/
# The headers_install target will install the kernel headers locally inside
# the Linux build dir
define SELFTESTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(SELFTESTS_MAKE_FLAGS) \
		headers_install
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)/tools/testing/selftests \
		$(SELFTESTS_MAKE_FLAGS) O=$(@D)/tools/testing/selftests
endef

define SELFTESTS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)/tools/testing/selftests \
		$(SELFTESTS_MAKE_FLAGS) O=$(@D)/tools/testing/selftests \
		INSTALL_PATH=$(TARGET_DIR)/usr/lib/kselftests install
endef
