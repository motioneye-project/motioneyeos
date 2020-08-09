################################################################################
#
# e2tools
#
################################################################################

E2TOOLS_VERSION = 0.0.16.4
E2TOOLS_SITE = $(call github,ndim,e2tools,v$(E2TOOLS_VERSION))

# Source coming from GitHub, no configure included.
E2TOOLS_AUTORECONF = YES
E2TOOLS_LICENSE = GPL-2.0
E2TOOLS_LICENSE_FILES = COPYING
E2TOOLS_DEPENDENCIES = e2fsprogs
E2TOOLS_CONF_ENV = LIBS="-lpthread"
HOST_E2TOOLS_DEPENDENCIES = host-e2fsprogs
HOST_E2TOOLS_CONF_ENV = LIBS="-lpthread"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
