LIBURCU_VERSION = 0.6.7
LIBURCU_SITE    = http://lttng.org/files/bundles/20111214/
LIBURCU_SOURCE  = userspace-rcu-$(LIBURCU_VERSION).tar.bz2

LIBURCU_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
