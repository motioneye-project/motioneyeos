#############################################################
#
# PCRE
#
#############################################################
PCRE_VERSION = 7.6
PCRE_SOURCE = pcre-$(PCRE_VERSION).tar.bz2
PCRE_SITE = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
PCRE_INSTALL_STAGING = YES
PCRE_INSTALL_TARGET = YES

PCRE_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
        --build=$(GNU_HOST_NAME) --prefix=/usr \
        --includedir=/usr/include

PCRE_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,pcre))
