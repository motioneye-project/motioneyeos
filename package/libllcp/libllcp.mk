################################################################################
#
# libllcp
#
################################################################################

LIBLLCP_VERSION = 05dfa8003433a7070bfd8ae02efdb0203bbf34aa
LIBLLCP_SITE = $(call github,nfc-tools,libllcp,$(LIBLLCP_VERSION))
LIBLLCP_DEPENDENCIES = host-pkgconf libnfc
# There's no ./configure in the repository, so we need to autoreconf
LIBLLCP_AUTORECONF = YES
LIBLLCP_INSTALL_STAGING = YES
LIBLLCP_LICENSE = GPL-3.0+
LIBLLCP_LICENSE_FILES = COPYING
# ensure graphviz isn't used
LIBLLCP_CONF_ENV = ac_cv_path_DOT=

$(eval $(autotools-package))
