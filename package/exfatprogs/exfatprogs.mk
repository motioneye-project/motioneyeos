################################################################################
#
# exfatprogs
#
################################################################################

EXFATPROGS_VERSION = 1.0.3
EXFATPROGS_SITE = https://github.com/exfatprogs/exfatprogs/releases/download/$(EXFATPROGS_VERSION)
EXFATPROGS_LICENSE = GPL-2.0+
EXFATPROGS_LICENSE_FILES = COPYING
EXFATPROGS_DEPENDENCIES = host-pkgconf
HOST_EXFATPROGS_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
