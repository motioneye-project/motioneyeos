################################################################################
#
# iio
#
################################################################################

LINUX_TOOLS += iio

IIO_MAKE_OPTS = $(LINUX_MAKE_FLAGS)

define IIO_BUILD_CMDS
	$(Q)if ! grep install $(LINUX_DIR)/tools/iio/Makefile >/dev/null 2>&1 ; then \
		echo "Your kernel version is too old and does not have install section in the iio tools." ; \
		echo "At least kernel 4.7 must be used." ; \
		exit 1 ; \
	fi

	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools/iio \
		$(IIO_MAKE_OPTS)
endef

define IIO_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR)/tools/iio \
		$(IIO_MAKE_OPTS) \
		INSTALL_ROOT=$(TARGET_DIR) \
		install
endef
