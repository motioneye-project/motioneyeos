################################################################################
# Linux fbtft extensions
#
# Patch the linux kernel with fbtft extension
################################################################################

LINUX_EXTENSIONS += fbtft

# for linux >= 3.15 install to drivers/video/fbdev/fbtft
# for linux < 3.15 install to drivers/video/fbtft
define FBTFT_PREPARE_KERNEL
	if [ -e $(LINUX_DIR)/drivers/video/fbdev ]; then \
		dest=$(LINUX_DIR)/drivers/video/fbdev ; \
	else \
		dest=$(LINUX_DIR)/drivers/video/ ; \
	fi ; \
	mkdir -p $${dest}/fbtft; \
	cp -dpfr $(FBTFT_DIR)/* $${dest}/fbtft/ ; \
	echo 'source "drivers/video/fbdev/fbtft/Kconfig"' \
		>> $${dest}/Kconfig ; \
	echo 'obj-y += fbtft/' >> $${dest}/Makefile
endef
