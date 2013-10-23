################################################################################
#
# perf
#
################################################################################

# Source taken from the Linux kernel tree
PERF_SOURCE =
PERF_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

PERF_DEPENDENCIES = linux host-flex host-bison

PERF_MAKE_FLAGS = \
	$(LINUX_MAKE_FLAGS) \
	NO_LIBAUDIT=1 \
	NO_NEWT=1 \
	NO_GTK2=1 \
	NO_LIBPERL=1 \
	NO_LIBPYTHON=1 \
	DESTDIR=$(TARGET_DIR) \
	prefix=/usr \
	WERROR=0 \
	ASCIIDOC=

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
	PERF_DEPENDENCIES += elfutils
else
	PERF_MAKE_FLAGS += NO_LIBELF=1 NO_DWARF=1
endif

define PERF_BUILD_CMDS
	$(Q)if test ! -f $(LINUX_DIR)/tools/perf/Makefile ; then \
		echo "Your kernel version is too old and does not have the perf tool." ; \
		echo "At least kernel 2.6.31 must be used." ; \
		exit 1 ; \
	fi
	$(Q)if test "$(BR2_PACKAGE_ELFUTILS)" = "" ; then \
		if ! grep -q NO_LIBELF $(LINUX_DIR)/tools/perf/Makefile ; then \
			echo "The perf tool in your kernel cannot be built without libelf." ; \
			echo "Either upgrade your kernel to >= 3.7, or enable the elfutils package." ; \
			exit 1 ; \
		fi \
	fi
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools/perf \
		$(PERF_MAKE_FLAGS) O=$(@D)
endef

# After installation, we remove the Perl and Python scripts from the
# target.
define PERF_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools/perf \
		$(PERF_MAKE_FLAGS) O=$(@D) install
	$(RM) -rf $(TARGET_DIR)/usr/libexec/perf-core/scripts/
endef

$(eval $(generic-package))
