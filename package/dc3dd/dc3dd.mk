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
# We are patching Makefile.am, so we need to autoreconf. We also need to
# enable gettextize as dc3dd comes with an old gettext infra.
DC3DD_AUTORECONF = YES
DC3DD_GETTEXTIZE = YES

$(eval $(autotools-package))
