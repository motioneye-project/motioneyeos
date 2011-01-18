#############################################################
#
# mpg123
#
#############################################################

MPG123_VERSION = 1.13.1
MPG123_SOURCE = mpg123-$(MPG123_VERSION).tar.bz2
MPG123_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mpg123
MPG123_CONF_OPT = --with-optimization=0 --disable-lfs-alias
MPG123_INSTALL_STAGING = YES
MPG123_CPU = $(if $(BR2_SOFT_FLOAT),generic_nofpu,generic_fpu)

ifeq ($(BR2_arm),y)
MPG123_CPU = arm_nofpu
endif

ifeq ($(BR2_i386),y)
MPG123_CPU = x86
endif

ifeq ($(BR2_powerpc),y)
ifneq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),)
MPG123_CPU = altivec
endif
ifeq ($(BR2_SOFT_FLOAT),y)
MPG123_CPU = ppc_nofpu
endif
endif

ifeq ($(BR2_x86_64),y)
MPG123_CPU = x86-64
endif

MPG123_CONF_OPT += --program-prefix='' --with-cpu=$(MPG123_CPU)

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
MPG123_CONF_OPT += --with-audio=alsa
MPG123_DEPENDENCIES += alsa-lib
endif

$(eval $(call AUTOTARGETS,package/multimedia,mpg123))
