################################################################################
#
# time
#
################################################################################

TIME_VERSION = 1.7
TIME_SITE = $(BR2_GNU_MIRROR)/time
TIME_CONF_ENV = ac_cv_func_wait3=yes
TIME_LICENSE = GPL-2.0+
TIME_LICENSE_FILES = COPYING

# time uses an old version of automake that does not support
# installing in DESTDIR.
define TIME_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755  $(@D)/time $(TARGET_DIR)/usr/bin/time
endef

$(eval $(autotools-package))
