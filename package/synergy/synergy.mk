#############################################################
#
# synergy
#
#############################################################

SYNERGY_VERSION = 1.3.1
SYNERGY_SOURCE = synergy-$(SYNERGY_VERSION).tar.gz
SYNERGY_SITE = http://internap.dl.sourceforge.net/sourceforge/synergy2/
SYNERGY_AUTORECONF = NO
SYNERGY_INSTALL_STAGING = NO
SYNERGY_INSTALL_TARGET = YES

SYNERGY_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr --sysconfdir=/etc

SYNERGY_DEPENDENCIES = uclibc $(XSERVER)

$(eval $(call AUTOTARGETS,package,synergy))
