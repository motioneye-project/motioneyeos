################################################################################
#
# barebox
#
################################################################################

define BAREBOX_HELP_CMDS
	@echo '  barebox-menuconfig     - Run barebox menuconfig'
	@echo '  barebox-savedefconfig  - Run barebox savedefconfig'
endef

# Instantiate the barebox package
$(eval $(barebox-package))
