################################################################################
#
# sunxi-mali-prop
#
################################################################################

SUNXI_MALI_PROP_VERSION = e4ced47
SUNXI_MALI_PROP_SITE = http://github.com/linux-sunxi/sunxi-mali-proprietary/tarball/$(SUNXI_MALI_PROP_VERSION)

$(eval $(generic-package))
