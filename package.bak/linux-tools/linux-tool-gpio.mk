################################################################################
#
# gpio
#
################################################################################

LINUX_TOOLS += gpio

GPIO_MAKE_OPTS = $(LINUX_MAKE_FLAGS)

define GPIO_BUILD_CMDS
	$(Q)if ! grep install $(LINUX_DIR)/tools/gpio/Makefile >/dev/null 2>&1 ; then \
		echo "Your kernel version is too old and does not have the gpio tools." ; \
		echo "At least kernel 4.8 must be used." ; \
		exit 1 ; \
	fi

	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools \
		$(GPIO_MAKE_OPTS) \
		gpio
endef

define GPIO_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools \
		$(GPIO_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		gpio_install
endef
