#############################################################
#
# gnuchess
#
#############################################################
GNUCHESS_VERSION = 5.07
GNUCHESS_SOURCE = gnuchess-$(GNUCHESS_VERSION).tar.gz
GNUCHESS_SITE = $(BR2_GNU_MIRROR)/chess
GNUCHESS_INSTALL_STAGING = NO
GNUCHESS_INSTALL_TARGET = YES

GNUCHESS_CONF_ENV = ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes

GNUCHESS_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package/games,gnuchess))

