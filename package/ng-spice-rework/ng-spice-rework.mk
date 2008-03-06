#############################################################
#
# ng-spice-rework
#
#############################################################
NG_SPICE_REWORK_VERSION = 17
NG_SPICE_REWORK_SOURCE = ng-spice-rework-$(NG_SPICE_REWORK_VERSION).tar.gz
NG_SPICE_REWORK_SITE = http://superb-west.dl.sourceforge.net/sourceforge/ngspice
NG_SPICE_REWORK_AUTORECONF = NO
NG_SPICE_REWORK_INSTALL_STAGING = NO
NG_SPICE_REWORK_INSTALL_TARGET = YES
NG_SPICE_REWORK_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

NG-SPICE-REWORK_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,ng-spice-rework))

