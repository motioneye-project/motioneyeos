#############################################################
#
# bison
#
#############################################################

BISON_VERSION = 2.5
BISON_SITE = $(BR2_GNU_MIRROR)/bison

BISON_CONF_ENV += ac_cv_path_M4=/usr/bin/m4
BISON_DEPENDENCIES += m4

define BISON_DISABLE_EXAMPLES
	echo 'all install:' > $(@D)/examples/Makefile
endef

BISON_POST_CONFIGURE_HOOKS += BISON_DISABLE_EXAMPLES

HOST_BISON_DEPENDENCIES += host-m4

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
