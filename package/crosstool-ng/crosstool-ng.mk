################################################################################
#
# crosstool-ng
#
################################################################################

CROSSTOOL_NG_VERSION           = 1.18.0
CROSSTOOL_NG_SOURCE            = crosstool-ng-$(CROSSTOOL_NG_VERSION).tar.bz2
CROSSTOOL_NG_SITE              = http://crosstool-ng.org/download/crosstool-ng/
CROSSTOOL_NG_INSTALL_TARGET    = NO
CROSSTOOL_NG_MAKE              = $(MAKE1)

HOST_CROSSTOOL_NG_DEPENDENCIES = \
	$(if $(BR2_CCACHE),host-ccache) host-gawk \
	host-automake host-gperf host-bison host-flex \
	host-texinfo

$(eval $(host-autotools-package))
