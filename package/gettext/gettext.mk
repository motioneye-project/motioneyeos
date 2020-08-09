################################################################################
#
# gettext
#
################################################################################

GETTEXTIZE = $(HOST_CONFIGURE_OPTS) AUTOM4TE=$(HOST_DIR)/bin/autom4te $(HOST_DIR)/bin/gettextize -f

$(eval $(virtual-package))
$(eval $(host-virtual-package))
