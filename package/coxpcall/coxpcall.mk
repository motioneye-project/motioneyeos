################################################################################
#
# coxpcall
#
################################################################################

COXPCALL_VERSION = 1.17.0-1
COXPCALL_SUBDIR = coxpcall
COXPCALL_LICENSE = MIT
COXPCALL_LICENSE_FILES = $(COXPCALL_SUBDIR)/doc/license.html

$(eval $(luarocks-package))
