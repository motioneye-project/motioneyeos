#############################################################
#
# mpg123
#
#############################################################
MPG123_VERSION = 0.66
MPG123_SOURCE = mpg123-$(MPG123_VERSION).tar.bz2
MPG123_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mpg123

MPG123_CONF_OPT = --program-prefix='' --with-cpu=generic_nofpu

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
MPG123_CONF_OPT += --with-audio=alsa
MPG123_DEPENDENCIES += alsa-lib
endif

$(eval $(call AUTOTARGETS,package/multimedia,mpg123))
