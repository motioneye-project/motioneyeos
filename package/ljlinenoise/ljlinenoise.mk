################################################################################
#
# ljlinenoise
#
################################################################################

LJLINENOISE_VERSION_UPSTREAM = 0.1.1
LJLINENOISE_VERSION = $(LJLINENOISE_VERSION_UPSTREAM)-1
LJLINENOISE_SUBDIR = ljlinenoise-$(LJLINENOISE_VERSION_UPSTREAM)
LJLINENOISE_LICENSE = MIT
LJLINENOISE_LICENSE_FILES = $(LJLINENOISE_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
