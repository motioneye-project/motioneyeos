#############################################################
#
# which
#
#############################################################
WHICH_VERSION:=2.20
WHICH_SOURCE:=which-$(WHICH_VERSION).tar.gz
WHICH_SITE:=http://www.xs4all.nl/~carlo17/which/
WHICH_AUTORECONF:=NO
WHICH_INSTALL_STAGING:=NO
WHICH_INSTALL_TARGET:=YES

$(eval $(call AUTOTARGETS,package,which))
