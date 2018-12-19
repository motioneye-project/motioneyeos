################################################################################
#
# argparse
#
################################################################################

ARGPARSE_VERSION = 0.6.0-1
ARGPARSE_SUBDIR = argparse
ARGPARSE_LICENSE = MIT
ARGPARSE_LICENSE_FILES = $(ARGPARSE_SUBDIR)/LICENSE

$(eval $(luarocks-package))
