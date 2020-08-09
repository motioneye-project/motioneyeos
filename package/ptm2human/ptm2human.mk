################################################################################
#
# ptm2human
#
################################################################################

PTM2HUMAN_VERSION = d0b8b6be9897ea5b04fd6460038a4773cec078bc
PTM2HUMAN_SITE = $(call github,hwangcc23,ptm2human,$(PTM2HUMAN_VERSION))
PTM2HUMAN_LICENSE = GPL-2.0
PTM2HUMAN_LICENSE_FILES = LICENSE

# Straight out from an non-autoconfigured git tree:
PTM2HUMAN_AUTORECONF = YES

$(eval $(autotools-package))
