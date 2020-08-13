################################################################################
#
# argparse
#
################################################################################

ARGPARSE_VERSION = 0.7.0-1
ARGPARSE_LICENSE = MIT
ARGPARSE_LICENSE_FILES = $(ARGPARSE_SUBDIR)/LICENSE

$(eval $(luarocks-package))
