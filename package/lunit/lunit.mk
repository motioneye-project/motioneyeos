################################################################################
#
# lunit
#
################################################################################

LUNIT_VERSION_UPSTREAM = 0.5
LUNIT_VERSION = $(LUNIT_VERSION_UPSTREAM)-2
LUNIT_SUBDIR  = lunit-$(LUNIT_VERSION_UPSTREAM)
LUNIT_LICENSE = MIT
LUNIT_LICENSE_FILES = $(LUNIT_SUBDIR)/LICENSE

$(eval $(luarocks-package))
