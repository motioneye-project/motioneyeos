CROSSTOOL_NG_VERSION           = 1.12.1
CROSSTOOL_NG_SOURCE            = crosstool-ng-$(CROSSTOOL_NG_VERSION).tar.bz2
CROSSTOOL_NG_SITE              = http://crosstool-ng.org/download/crosstool-ng/
CROSSTOOL_NG_INSTALL_STAGING   = NO
CROSSTOOL_NG_INSTALL_TARGET    = NO
CROSSTOOL_NG_MAKE              = $(MAKE1)
HOST_CROSSTOOL_NG_DEPENDENCIES = host-gawk host-automake $(if $(BR2_CCACHE),host-ccache)

$(eval $(call AUTOTARGETS,package,crosstool-ng,host))
