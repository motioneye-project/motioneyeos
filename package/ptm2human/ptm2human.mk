################################################################################
#
# ptm2human
#
################################################################################

PTM2HUMAN_VERSION = d7dd68ea6495daef50e00ef2d65c99810e0a594f
PTM2HUMAN_SITE = $(call github,hwangcc23,ptm2human,$(PTM2HUMAN_VERSION))
PTM2HUMAN_LICENSE = GPL-2.0
PTM2HUMAN_LICENSE_FILES = LICENSE

# Straight out from an non-autoconfigured git tree, plus a patch:
# 0001-configure.ac-remove-unneeded-check-for-c-compiler.patch
PTM2HUMAN_AUTORECONF = YES

$(eval $(autotools-package))
