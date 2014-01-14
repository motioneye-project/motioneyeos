################################################################################
#
# rings
#
################################################################################

RINGS_VERSION_MAJOR = 1.3.0
RINGS_VERSION = $(RINGS_VERSION_MAJOR)-1
RINGS_SUBDIR  = rings-v_1_3_0
RINGS_LICENSE = MIT

$(eval $(luarocks-package))
