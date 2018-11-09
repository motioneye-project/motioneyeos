################################################################################
#
# toolchain-external-synopsys-arc
#
################################################################################

TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_VERSION = 2017.09
TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_SITE = https://github.com/foss-for-synopsys-dwc-arc-processors/toolchain/releases/download/arc-$(TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_VERSION)-release

ifeq ($(BR2_arc750d)$(BR2_arc770d),y)
TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_CORE = arc700
else
TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_CORE = archs
endif

ifeq ($(BR2_arcle),y)
TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_ENDIANESS = le
else
TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_ENDIANESS = be
endif

TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_SOURCE = arc_gnu_$(TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_VERSION)_prebuilt_uclibc_$(TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_ENDIANESS)_$(TOOLCHAIN_EXTERNAL_SYNOPSYS_ARC_CORE)_linux_install.tar.gz

$(eval $(toolchain-external-package))
