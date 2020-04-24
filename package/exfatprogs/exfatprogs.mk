################################################################################
#
# exfatprogs
#
################################################################################

EXFATPROGS_VERSION = 1.0.2
EXFATPROGS_SITE = $(call github,exfatprogs,exfatprogs,$(EXFATPROGS_VERSION))
EXFATPROGS_LICENSE = GPL-2.0+
EXFATPROGS_LICENSE_FILES = COPYING
EXFATPROGS_AUTORECONF = YES
EXFATPROGS_DEPENDENCIES = host-pkgconf
HOST_EXFATPROGS_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
