################################################################################
#
# e2tools
#
################################################################################

E2TOOLS_VERSION = 3158ef18a903ca4a98b8fa220c9fc5c133d8bdf6
E2TOOLS_SITE = $(call github,ndim,e2tools,$(E2TOOLS_VERSION))

# Source coming from github, no configure included.
E2TOOLS_AUTORECONF = YES
E2TOOLS_LICENSE = GPLv2
E2TOOLS_LICENSE_FILES = COPYING
E2TOOLS_DEPENDENCIES = e2fsprogs
E2TOOLS_CONF_ENV = LIBS="-lpthread"
HOST_E2TOOLS_CONF_ENV = LIBS="-lpthread"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
