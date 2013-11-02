################################################################################
#
# czmq
#
################################################################################

CZMQ_VERSION = cb9839cf90e4ac69acb7c6ff2b4e2d42d704cf6e
CZMQ_SITE = git://github.com/zeromq/czmq.git

# Autoreconf required as we use the git tree
CZMQ_AUTORECONF = YES
CZMQ_INSTALL_STAGING = YES
CZMQ_DEPENDENCIES = zeromq
CZMQ_LICENSE = LGPLv3+ with exceptions
CZMQ_LICENSE_FILES = COPYING COPYING.LESSER

# asciidoc is a python script that imports unicodedata, which is not in
# host-python, so disable asciidoc entirely.
CZMQ_CONF_ENV = ac_cv_prog_czmq_have_asciidoc=no

define CZMQ_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

CZMQ_POST_PATCH_HOOKS += CZMQ_CREATE_CONFIG_DIR

$(eval $(autotools-package))
