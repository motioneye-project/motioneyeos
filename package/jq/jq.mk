################################################################################
#
# jq
#
################################################################################

JQ_VERSION = 1.6
JQ_SITE = https://github.com/stedolan/jq/releases/download/jq-$(JQ_VERSION)
JQ_LICENSE = MIT (code), CC-BY-3.0 (documentation)
JQ_LICENSE_FILES = COPYING
JQ_INSTALL_STAGING = YES

# uses c99 specific features
# _GNU_SOURCE added to fix gcc6+ host compilation
# (https://github.com/stedolan/jq/issues/1598)
JQ_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99 -D_GNU_SOURCE"
HOST_JQ_CONF_ENV += CFLAGS="$(HOST_CFLAGS) -std=c99 -D_GNU_SOURCE"

# jq explicitly enables maintainer mode, which we don't need/want
JQ_CONF_OPTS += --disable-maintainer-mode --without-oniguruma
HOST_JQ_CONF_OPTS += --disable-maintainer-mode --without-oniguruma

$(eval $(autotools-package))
$(eval $(host-autotools-package))
