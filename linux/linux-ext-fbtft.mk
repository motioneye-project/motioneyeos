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
		dest=drivers/video/fbdev ; \
	else \
		dest=drivers/video ; \
	fi ; \
	mkdir -p $(LINUX_DIR)/$${dest}/fbtft; \
	cp -dpfr $(FBTFT_DIR)/* $(LINUX_DIR)/$${dest}/fbtft/ ; \
	echo "source \"$${dest}/fbtft/Kconfig\"" \
		>> $(LINUX_DIR)/$${dest}/Kconfig ; \
	echo 'obj-y += fbtft/' >> $(LINUX_DIR)/$${dest}/Makefile
endef
