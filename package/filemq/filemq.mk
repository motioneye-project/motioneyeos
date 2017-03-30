################################################################################
#
# filemq
#
################################################################################

FILEMQ_VERSION = 3dc89932903b0320853d87833aabc6f7e7781c49
FILEMQ_SITE = $(call github,zeromq,filemq,$(FILEMQ_VERSION))

FILEMQ_AUTORECONF = YES
FILEMQ_CONF_ENV = filemq_have_asciidoc=no
FILEMQ_INSTALL_STAGING = YES
FILEMQ_DEPENDENCIES = czmq openssl zeromq
FILEMQ_LICENSE = MPL-2.0
FILEMQ_LICENSE_FILES = LICENSE

define FILEMQ_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

FILEMQ_POST_PATCH_HOOKS += FILEMQ_CREATE_CONFIG_DIR

$(eval $(autotools-package))
