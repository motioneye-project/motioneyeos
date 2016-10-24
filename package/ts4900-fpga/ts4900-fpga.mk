################################################################################
#
# ts4900-fpga
#
################################################################################

TS4900_FPGA_VERSION = 20150930
TS4900_FPGA_SOURCE = ts4900-fpga-$(TS4900_FPGA_VERSION).bin
TS4900_FPGA_SITE = ftp://ftp.embeddedarm.com/ts-socket-macrocontrollers/ts-4900-linux/fpga
# No license file provided, Yocto recipe from the vendor claims MIT.
# https://github.com/embeddedarm/meta-ts/blob/f31860f1204b64f765a5380d3b93a2cf18234f90/recipes-extras/ts4900-fpga/ts4900-fpga.bb#L6

define TS4900_FPGA_EXTRACT_CMDS
	cp $(DL_DIR)/$(TS4900_FPGA_SOURCE) $(@D)
endef

define TS4900_FPGA_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/$(TS4900_FPGA_SOURCE) $(TARGET_DIR)/boot/ts4900-fpga.bin
endef

$(eval $(generic-package))
