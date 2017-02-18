################################################################################
# Linux ev3dev extensions
#
# Patch the linux kernel with ev3dev extension
################################################################################

LINUX_EXTENSIONS += ev3dev-linux-drivers

define EV3DEV_LINUX_DRIVERS_PREPARE_KERNEL
	mkdir -p $(LINUX_DIR)/drivers/lego
	cp -dpfr $(EV3DEV_LINUX_DRIVERS_DIR)/* $(LINUX_DIR)/drivers/lego/
endef
