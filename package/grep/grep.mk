################################################################################
#
# grep
#
################################################################################

GREP_VERSION = 3.3
GREP_SITE = $(BR2_GNU_MIRROR)/grep
GREP_SOURCE = grep-$(GREP_VERSION).tar.xz
GREP_LICENSE = GPL-3.0+
GREP_LICENSE_FILES = COPYING
GREP_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
# install into /bin like busybox grep
GREP_CONF_OPTS = --exec-prefix=/

ifeq ($(BR2_SYSTEM_BIN_SH_NONE),y)

define GREP_REMOVE_ALIAS
	$(RM) $(TARGET_DIR)/bin/[fe]grep
endef
GREP_POST_INSTALL_TARGET_HOOKS += GREP_REMOVE_ALIAS

else

# ensure egrep/fgrep shell wrappers use #!/bin/sh
define GREP_FIXUP_SHEBANG
	$(SED) 's/bash$$/sh/' $(TARGET_DIR)/bin/[fe]grep
endef
GREP_POST_INSTALL_TARGET_HOOKS += GREP_FIXUP_SHEBANG

endif

# link with iconv if enabled
ifeq ($(BR2_PACKAGE_LIBICONV),y)
GREP_CONF_ENV += LIBS=-liconv
GREP_DEPENDENCIES += libiconv
endif

# link with pcre if enabled
ifeq ($(BR2_PACKAGE_PCRE),y)
GREP_CONF_OPTS += --enable-perl-regexp
GREP_DEPENDENCIES += pcre
else
GREP_CONF_OPTS += --disable-perl-regexp
endif

$(eval $(autotools-package))
