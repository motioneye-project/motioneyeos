################################################################################
#
# directfb-examples
#
################################################################################

DIRECTFB_EXAMPLES_VERSION = 1.7.0
DIRECTFB_EXAMPLES_SITE = http://www.directfb.org/downloads/Extras
DIRECTFB_EXAMPLES_SOURCE = DirectFB-examples-$(DIRECTFB_EXAMPLES_VERSION).tar.gz
DIRECTFB_EXAMPLES_LICENSE = MIT
DIRECTFB_EXAMPLES_LICENSE_FILES = COPYING
DIRECTFB_EXAMPLES_DEPENDENCIES = directfb

ifeq ($(BR2_STATIC_LIBS),y)
        DIRECTFB_EXAMPLES_CONF_OPTS += LIBS=-lstdc++
endif

$(eval $(autotools-package))
