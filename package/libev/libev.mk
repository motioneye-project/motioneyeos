################################################################################
#
# libev
#
################################################################################

LIBEV_VERSION = 4.27
LIBEV_SITE = http://dist.schmorp.de/libev/Attic
LIBEV_INSTALL_STAGING = YES
LIBEV_LICENSE = BSD-2-Clause or GPL-2.0+
LIBEV_LICENSE_FILES = LICENSE

# The 'compatibility' event.h header conflicts with libevent
# It's completely unnecessary for BR packages so remove it
define LIBEV_DISABLE_EVENT_H_INSTALL
	$(SED) 's/ event.h//' $(@D)/Makefile.in
endef
LIBEV_POST_PATCH_HOOKS += LIBEV_DISABLE_EVENT_H_INSTALL

$(eval $(autotools-package))
$(eval $(host-autotools-package))
