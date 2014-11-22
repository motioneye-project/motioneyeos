################################################################################
#
# libllcp
#
################################################################################

LIBLLCP_VERSION = cf0c4b3c9df98851c6092c130192130c3f5a46bd
LIBLLCP_SITE = https://libllcp.googlecode.com/git
LIBLLCP_SITE_METHOD = git
LIBLLCP_DEPENDENCIES = host-pkgconf libnfc
# There's no ./configure in the repository, so we need to autoreconf
LIBLLCP_AUTORECONF = YES
LIBLLCP_INSTALL_STAGING = YES
LIBLLCP_LICENSE = GPLv3+
LIBLLCP_LICENSE_FILES = COPYING
# ensure graphviz isn't used
LIBLLCP_CONF_ENV = ac_cv_path_DOT=

$(eval $(autotools-package))
