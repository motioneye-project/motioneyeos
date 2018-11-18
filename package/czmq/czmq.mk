################################################################################
#
# czmq
#
################################################################################

CZMQ_VERSION = 4.1.1
CZMQ_SITE = https://github.com/zeromq/czmq/releases/download/v$(CZMQ_VERSION)

# 0001-configure.ac-remove-Werror.patch touches configure.ac
CZMQ_AUTORECONF = YES
CZMQ_INSTALL_STAGING = YES
CZMQ_DEPENDENCIES = zeromq host-pkgconf
CZMQ_LICENSE = MPL-2.0
CZMQ_LICENSE_FILES = LICENSE

# asciidoc is a python script that imports unicodedata, which is not in
# host-python, so disable asciidoc entirely.
CZMQ_CONF_ENV = ac_cv_prog_czmq_have_asciidoc=no

$(eval $(autotools-package))
