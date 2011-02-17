#############################################################
#
# tcpreplay
#
#############################################################

TCPREPLAY_VERSION = 3.4.3
TCPREPLAY_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/tcpreplay
TCPREPLAY_CONF_ENV = tr_cv_libpcap_version=">= 0.7.0"
TCPREPLAY_CONF_OPT = --program-prefix="" --with-libpcap=$(STAGING_DIR)/usr

TCPREPLAY_DEPENDENCIES = uclibc libpcap

$(eval $(call AUTOTARGETS,package,tcpreplay))

