################################################################################
#
# jq
#
################################################################################

JQ_VERSION = a17dd3248a666d01be75f6b16be37e80e20b0954
JQ_SITE = $(call github,stedolan,jq,$(JQ_VERSION))
JQ_LICENSE = MIT (code), ICU (decNumber), CC-BY-3.0 (documentation)
JQ_LICENSE_FILES = COPYING
JQ_INSTALL_STAGING = YES

# currently using git version directly
JQ_AUTORECONF = YES

# uses c99 specific features
# _GNU_SOURCE added to fix gcc6+ host compilation
# (https://github.com/stedolan/jq/issues/1598)
JQ_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99 -D_GNU_SOURCE"
HOST_JQ_CONF_ENV += CFLAGS="$(HOST_CFLAGS) -std=c99 -D_GNU_SOURCE"

# jq explicitly enables maintainer mode, which we don't need/want
JQ_CONF_OPTS += --disable-maintainer-mode
HOST_JQ_CONF_OPTS += --disable-maintainer-mode --without-oniguruma

ifeq ($(BR2_PACKAGE_ONIGURUMA),y)
JQ_DEPENDENCIES += oniguruma
JQ_CONF_OPTS += --with-oniguruma
else
JQ_CONF_OPTS += --without-oniguruma
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
