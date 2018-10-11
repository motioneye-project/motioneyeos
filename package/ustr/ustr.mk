################################################################################
#
# ustr
#
################################################################################

# When bumping the version to a new upstream release, be sure to remove
# the ldconfig hack, below.
USTR_VERSION = 1.0.4
USTR_SOURCE = ustr-$(USTR_VERSION).tar.bz2
USTR_SITE = http://www.and.org/ustr/$(USTR_VERSION)
USTR_LICENSE = BSD-2-Clause, MIT, LGPL-2.0+
USTR_LICENSE_FILES = LICENSE LICENSE_BSD LICENSE_LGPL LICENSE_MIT
USTR_AUTORECONF = YES
USTR_PATCH = \
	http://snapshot.debian.org/archive/debian/20180131T223129Z/pool/main/u/ustr/ustr_$(USTR_VERSION)-6.debian.tar.xz

USTR_INSTALL_STAGING = YES

# ustr only builds the static library by default, but the default
# install rule will install both the static and the shared libraries,
# which means the shared one is build during the install step. :-(
#
# We can however instruct ustr to build both at build time, by adding
# 'all-shared' to the default 'all' rule.
USTR_MAKE_OPTS = all all-shared

USTR_CONF_OPTS += LDCONFIG=/bin/true
HOST_USTR_CONF_OPTS += LDCONFIG=/bin/true

# for some reason, ustr finds it useful to install its source code in
# /usr/share, which is totally useless on the target
define USTR_REMOVE_SOURCE_CODE
	$(RM) -rf $(TARGET_DIR)/usr/share/ustr-$(USTR_VERSION)
endef
USTR_POST_INSTALL_TARGET_HOOKS += USTR_REMOVE_SOURCE_CODE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
