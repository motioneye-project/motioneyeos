################################################################################
#
# lunit
#
################################################################################

LUNIT_VERSION = 0.5-2
LUNIT_LICENSE = MIT
LUNIT_LICENSE_FILES = $(LUNIT_SUBDIR)/LICENSE

$(eval $(luarocks-package))
