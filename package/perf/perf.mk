#############################################################
#
# perf
#
#############################################################

# Source taken from the Linux kernel tree
PERF_SOURCE =
PERF_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

PERF_DEPENDENCIES = linux

PERF_MAKE_FLAGS = \
	$(LINUX_MAKE_FLAGS) \
	NO_LIBELF=1 \
	NO_DWARF=1 \
	NO_LIBAUDIT=1 \
	NO_NEWT=1 \
	NO_GTK2=1 \
	NO_LIBPERL=1 \
	NO_LIBPYTHON=1 \
	DESTDIR=$(TARGET_DIR) \
	prefix=/usr \
	WERROR=0

define PERF_BUILD_CMDS
	$(MAKE) -C $(LINUX_DIR)/tools/perf \
		$(PERF_MAKE_FLAGS) O=$(@D)
endef

# After installation, we remove the Perl and Python scripts from the
# target.
define PERF_INSTALL_TARGET_CMDS
	$(MAKE) -C $(LINUX_DIR)/tools/perf \
		$(PERF_MAKE_FLAGS) O=$(@D) install
	$(RM) -rf $(TARGET_DIR)/usr/libexec/perf-core/scripts/
endef

$(eval $(generic-package))
