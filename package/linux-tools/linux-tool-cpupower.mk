################################################################################
#
# cpupower
#
################################################################################

LINUX_TOOLS += cpupower

CPUPOWER_DEPENDENCIES = pciutils $(if $(BR2_NEEDS_GETTEXT),gettext)

CPUPOWER_MAKE_OPTS = CROSS=$(TARGET_CROSS) \
	CPUFREQ_BENCH=false \
	NLS=false \
	$(if $(BR2_NEEDS_GETTEXT),LDFLAGS=-lintl) \
	DEBUG=false

define CPUPOWER_BUILD_CMDS
	$(Q)if test ! -f $(LINUX_DIR)/tools/power/cpupower/Makefile ; then \
		echo "Your kernel version is too old and does not have the cpupower tool." ; \
		echo "At least kernel 3.4 must be used." ; \
		exit 1 ; \
	fi

	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools \
		$(CPUPOWER_MAKE_OPTS) \
		cpupower
endef

define CPUPOWER_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools \
		$(CPUPOWER_MAKE_OPTS) \
		DESTDIR=$(STAGING_DIR) \
		cpupower_install
endef

define CPUPOWER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools \
		$(CPUPOWER_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		cpupower_install
endef
