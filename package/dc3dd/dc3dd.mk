################################################################################
#
# dc3dd
#
################################################################################

DC3DD_VERSION_MAJOR = 7.2
DC3DD_VERSION = $(DC3DD_VERSION_MAJOR).641
DC3DD_SOURCE = dc3dd-$(DC3DD_VERSION).tar.xz
DC3DD_SITE = https://downloads.sourceforge.net/project/dc3dd/dc3dd/$(DC3DD_VERSION_MAJOR)
DC3DD_LICENSE = GPL-3.0+
DC3DD_LICENSE_FILES = COPYING
# We are patching the Makefile.am
DC3DD_AUTORECONF = YES

$(eval $(autotools-package))
