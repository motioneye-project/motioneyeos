################################################################################
#
# gnuchess
#
################################################################################

GNUCHESS_VERSION = 6.2.1
GNUCHESS_SITE = $(BR2_GNU_MIRROR)/chess
GNUCHESS_LICENSE = GPLv2+
GNUCHESS_LICENSE_FILES = COPYING

GNUCHESS_DEPENDENCIES = host-flex flex
GNUCHESS_DEPENDENCIES += $(if $(BR2_PACKAGE_READLINE),readline) \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

$(eval $(autotools-package))
