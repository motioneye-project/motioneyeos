################################################################################
#
# ljlinenoise
#
################################################################################

LJLINENOISE_VERSION = 0.1.3-1
LJLINENOISE_LICENSE = MIT
LJLINENOISE_LICENSE_FILES = $(LJLINENOISE_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
