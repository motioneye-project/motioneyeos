################################################################################
#
# filemq
#
################################################################################

FILEMQ_VERSION = 8940f34e0f1c8f25c1c693ed8db069f58fbc5ad0
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
