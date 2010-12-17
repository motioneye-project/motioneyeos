#############################################################
#
# bison
#
#############################################################

BISON_VERSION = 2.4.3
BISON_SITE = $(BR2_GNU_MIRROR)/bison

define BISON_DISABLE_EXAMPLES
	echo 'all install:' > $(@D)/examples/Makefile
endef

BISON_POST_CONFIGURE_HOOKS += BISON_DISABLE_EXAMPLES

$(eval $(call AUTOTARGETS,package,bison))
