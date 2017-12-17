################################################################################
#
# lpty
#
################################################################################

LPTY_VERSION_UPSTREAM = 1.0.1
LPTY_VERSION = $(LPTY_VERSION_UPSTREAM)-1
LPTY_SUBDIR = lpty-$(LPTY_VERSION)
LPTY_LICENSE = MIT
LPTY_LICENSE_FILES = $(LPTY_SUBDIR)/doc/LICENSE

$(eval $(luarocks-package))
