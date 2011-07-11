#############################################################
#
# valgrind
#
#############################################################

VALGRIND_VERSION = 3.6.1
VALGRIND_SITE    = http://valgrind.org/downloads/
VALGRIND_SOURCE  = valgrind-$(VALGRIND_VERSION).tar.bz2

VALGRIND_CONF_OPT = --disable-tls

# On ARM, Valgrind only supports ARMv7, and uses the arch part of the
# host tuple to determine whether it's being built for ARMv7 or
# not. Therefore, we adjust the host tuple to specify we're on
# ARMv7. The valgrind package is guaranteed, through Config.in, to
# only be selected on Cortex A8 and Cortex A9 platforms.
ifeq ($(BR2_cortex_a8)$(BR2_cortex_a9),y)
VALGRIND_CONF_OPT += \
	--host=$(patsubst arm-%,armv7-unknown-%,$(GNU_TARGET_NAME))
endif

define VALGRIND_INSTALL_UCLIBC_SUPP
	install -D -m 0644 package/valgrind/uclibc.supp $(TARGET_DIR)/usr/lib/valgrind/uclibc.supp
endef

VALGRIND_POST_INSTALL_TARGET_HOOKS += VALGRIND_INSTALL_UCLIBC_SUPP

$(eval $(call AUTOTARGETS,package,valgrind))
