#############################################################
#
# sane-backends
#
#############################################################
SANE_BACKENDS_VERSION = 1.0.22
SANE_BACKENDS_SOURCE = sane-backends-$(SANE_BACKENDS_VERSION).tar.gz
SANE_BACKENDS_SITE = ftp://ftp2.sane-project.org/pub/sane/sane-backends-$(SANE_BACKENDS_VERSION)

SANE_BACKENDS_DEPENDENCIES += libusb
SANE_BACKENDS_CONF_OPT += --enable-libusb_1_0

$(eval $(call AUTOTARGETS))
