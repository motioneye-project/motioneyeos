################################################################################
#
# filemq
#
################################################################################

FILEMQ_VERSION = c398c096a427d341e9323d7673e6e0ca5e43902a
FILEMQ_SITE = git://github.com/zeromq/filemq.git

FILEMQ_AUTORECONF = YES
FILEMQ_CONF_ENV = fmq_have_asciidoc=no
FILEMQ_INSTALL_STAGING = YES
FILEMQ_DEPENDENCIES = czmq openssl zeromq
FILEMQ_LICENSE = LGPLv3+ with exceptions
FILEMQ_LICENSE_FILES = COPYING COPYING.LESSER

define FILEMQ_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

FILEMQ_POST_PATCH_HOOKS += FILEMQ_CREATE_CONFIG_DIR

$(eval $(autotools-package))
