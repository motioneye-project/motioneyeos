#############################################################
#
# fbdump
#
#############################################################
FBDUMP_VERSION:=0.4.2
FBDUMP_SOURCE:=fbdump-$(FBDUMP_VERSION).tar.gz
FBDUMP_SITE:=http://www.rcdrummond.net/fbdump
FBDUMP_AUTORECONF = NO
FBDUMP_CONF_ENV = ac_cv_func_malloc_0_nonnull=yes
FBDUMP_INSTALL_TARGET = YES
FBDUMP_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-strip

$(eval $(call AUTOTARGETS,package,fbdump))

