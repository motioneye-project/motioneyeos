#############################################################
#
# ace_of_penguins
#
#############################################################

ACE_OF_PENGUINS_VERSION = 1.2
ACE_OF_PENGUINS_SOURCE = ace-$(ACE_OF_PENGUINS_VERSION).tar.gz
ACE_OF_PENGUINS_SITE = http://www.delorie.com/store/ace/
ACE_OF_PENGUINS_AUTORECONF = YES
ACE_OF_PENGUINS_STAGING = NO
ACE_OF_PENGUINS_TARGET = YES

ACE_OF_PENGUINS_DEPENDENCIES = uclibc libpng $(XSERVER)

$(eval $(call AUTOTARGETS,package,ace_of_penguins))