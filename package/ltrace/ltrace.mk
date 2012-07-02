#############################################################
#
# ltrace
#
#############################################################
LTRACE_VERSION      = 0.6.0
LTRACE_SITE         = git://anonscm.debian.org/collab-maint/ltrace.git
LTRACE_DEPENDENCIES = libelf
LTRACE_AUTORECONF   = YES
LTRACE_CONF_OPT     += --disable-werror

$(eval $(autotools-package))
