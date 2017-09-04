################################################################################
#
# copas
#
################################################################################

COPAS_VERSION = 2.0.2-1
COPAS_SUBDIR = copas-2_0_2
COPAS_LICENSE = MIT
COPAS_LICENSE_FILES = $(COPAS_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
